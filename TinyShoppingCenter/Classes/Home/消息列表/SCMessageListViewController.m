//
//  SCMessageListViewController.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2018/2/1.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "SCMessageListViewController.h"
#import "SCMessageModel.h"
#import "SCMessageTableViewCell.h"
#import "CKOfficialAlert.h"
#import "SCFirstPageModel.h"
#import "NodataLableView.h"

@interface SCMessageListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *messageTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NodataLableView *nodataLableView;
@property (nonatomic, assign) NSTimeInterval startInterval;
@property (nonatomic, assign) NSTimeInterval endInterval;

@end

@implementation SCMessageListViewController

-(NodataLableView *)nodataLableView {
    if (_nodataLableView == nil) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - 64 - 49)];
        _nodataLableView.nodataLabel.text = @"暂无消息";
    }
    return _nodataLableView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"消息中心";
    
    [self initComponent];
    
    [self refreshData];
    
    [self requestMsgListData];
}

#pragma mark - 设置刷新
-(void)refreshData{
    __typeof (self) __weak weakSelf = self;
    self.messageTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        [weakSelf.messageTableView.mj_header beginRefreshing];
        
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";
        weakSelf.endInterval = [nowDate timeIntervalSince1970];
        NSTimeInterval value = weakSelf.endInterval - weakSelf.startInterval;
        CGFloat second = [[NSString stringWithFormat:@"%.2f",value] floatValue];//秒
        NSLog(@"间隔------%f秒",second);
        weakSelf.startInterval = weakSelf.endInterval;
        
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                if (value >= Interval) {
                    [weakSelf requestMsgListData];
                }else{
                    [weakSelf.messageTableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView:NetWorkNotReachable];
                [weakSelf.messageTableView.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.messageTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [weakSelf requestMoreMsgData];
                [weakSelf.messageTableView.mj_footer endRefreshing];
            }
                break;
            default: {
                [self showNoticeView:NetWorkNotReachable];
                [weakSelf.messageTableView.mj_footer endRefreshing];
            }
                break;
        }
    }];
}

#pragma mark - UI
- (void)initComponent {
    //消息
    _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH,SCREEN_HEIGHT - 64 - BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        _messageTableView.frame = CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - BOTTOM_BAR_HEIGHT- NaviAddHeight);
    }else{
        _messageTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - BOTTOM_BAR_HEIGHT);
    }
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _messageTableView.backgroundColor = [UIColor tt_grayBgColor];
    [self.view addSubview:_messageTableView];
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
}

#pragma mark - 请求消息列表数据
- (void)requestMsgListData {
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Wxmall/User/getofficialMsgs"];
    
    RLMResults *result =  [SCFirstPageModel objectsWhere:@"firstPageKey = '1'"];
    SCFirstPageModel *firstPageM = result.firstObject;
    NSString *meid = [NSString stringWithFormat:@"%@", firstPageM.meid];
    
    NSDictionary *params = @{@"meid":meid, @"rownum":@"0", @"pagesize":@"20"};
    
    [HttpTool getWithUrl:requestUrl params:params success:^(id json) {
        NSDictionary *listDic = json;
        NSString *code = [NSString stringWithFormat:@"%@", listDic[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:listDic[@"codeinfo"]];
            [self.messageTableView.mj_header endRefreshing];
            [self.loadingView stopAnimation];
            return ;
        }
        
        NSArray *listArr = listDic[@"list"];
        if (listArr.count == 0) {
            if (self.dataArray.count == 0) {
                [self.messageTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArray.count];
            }
        }else{
            [self.dataArray removeAllObjects];
            for (NSDictionary *dict in listArr) {
                SCMessageModel *msgModel = [[SCMessageModel alloc] init];
                [msgModel setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:msgModel];
            }
            if (self.dataArray.count != 0) {
                if (_nodataLableView) {
                    [_nodataLableView removeFromSuperview];
                }
            }
            
            [self.messageTableView reloadData];
        }
        [self.messageTableView.mj_header endRefreshing];
        [self.loadingView stopAnimation];
    } failure:^(NSError *error) {
        if (self.dataArray.count == 0) {
            [self.messageTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArray.count];
        }
        
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        
        [self.messageTableView.mj_header endRefreshing];
        [self.loadingView stopAnimation];
    }];
}

- (void)requestMoreMsgData {
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Wxmall/User/getofficialMsgs"];
    
    RLMResults *result =  [SCFirstPageModel objectsWhere:@"firstPageKey = '1'"];
    SCFirstPageModel *firstPageM = result.firstObject;
    NSString *meid = [NSString stringWithFormat:@"%@", firstPageM.meid];
    NSString *rownum = [NSString stringWithFormat:@"%ld", self.dataArray.count];

    NSDictionary *params = @{@"meid":meid, @"rownum":rownum, @"pagesize":@"20"};

    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:requestUrl params:params success:^(id json) {
        
        
        NSDictionary *listDic = json;
        NSString *code = [NSString stringWithFormat:@"%@",listDic[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self.loadingView stopAnimation];
            [self showNoticeView:listDic[@"codeinfo"]];
            [self.messageTableView.mj_header endRefreshing];
            return ;
        }
        NSArray *listArr = listDic[@"list"];
        if (listArr.count == 0) {
            [self.loadingView stopAnimation];
            [self.messageTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        
        for (NSDictionary *dict in listArr) {
            SCMessageModel *msgModel = [[SCMessageModel alloc] init];
            [msgModel setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:msgModel];
        }
        [self.messageTableView reloadData];
        [self.messageTableView.mj_footer endRefreshing];
        [self.loadingView stopAnimation];
        
    } failure:^(NSError *error) {
        
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        [self.messageTableView.mj_footer endRefreshing];
        [self.loadingView stopAnimation];
    }];
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SCMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCMessageTableViewCell"];
    if (cell == nil) {
        cell = [[SCMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCMessageTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.dataArray count]) {
        SCMessageModel *messageM = self.dataArray[indexPath.row];
        [cell refreshWithModel:messageM iconName:indexPath.row];
    }
    return cell;
}

#pragma mark - TableViewDataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SCMessageModel *messageM = self.dataArray[indexPath.row];
    CKOfficialAlert *msgAlert = [CKOfficialAlert shareInstance];
    [msgAlert showAlert:messageM.title content:messageM.msg];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (SCREEN_HEIGHT <= 568) {
        return AdaptedHeight(165);
    }
    return AdaptedHeight(150);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
