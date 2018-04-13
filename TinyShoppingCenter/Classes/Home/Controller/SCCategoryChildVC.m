//
//  SCCategoryChildVC.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/22.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCCategoryChildVC.h"
#import "ZJScrollPageViewDelegate.h"
#import "SCCategoryTableCell.h"
#import "SCCategoryGoodsModel.h"
#import "SCGoodsDetailViewController.h"
#import "SCDownloadCKAPPWebVC.h"
#import "XWAlterVeiw.h"

@interface SCCategoryChildVC ()<ZJScrollPageViewChildVcDelegate, UITableViewDelegate, UITableViewDataSource, CatogoryAddToShoppingCarDelete, XWAlterVeiwDelegate>

@property (nonatomic, strong) NSMutableArray *idArr;
@property (nonatomic, strong) UITableView *cateTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy)   NSString *categoryId;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NodataLableView *nodataLableView;
@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, assign) NSTimeInterval startInterval;
@property (nonatomic, assign) NSTimeInterval endInterval;

@end

@implementation SCCategoryChildVC

-(NodataLableView *)nodataLableView {
    if(_nodataLableView == nil) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT - 64-49-50)];
        _nodataLableView.nodataLabel.text = @"暂无商品";
    }
    return _nodataLableView;
}

-(void)passSortIdArray:(id)data {
    self.idArr = data;
}

-(void)passSelectIndex:(id)data {
    _selectIndex = [data integerValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initComponents];
    [self refreshData];
}

-(void)zj_viewDidAppearForIndex:(NSInteger)index {
    
    if (index == 0) {
        self.categoryId = @"0";
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [self requestData];
            }
                break;
            default: {
                [self.cateTableView.mj_header endRefreshing];
                [self.cateTableView.mj_footer endRefreshing];
                if (self.dataArr.count == 0) {
                    _nodataLableView.hidden = NO;
                    [self.cateTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArr.count];
                }
            }
                break;
        }
    }
}

-(void)zj_viewDidLoadForIndex:(NSInteger)index {
    
    if (index == 0) {
        return;
    }
    self.categoryId = [NSString stringWithFormat:@"%@", self.idArr[index]];
    RequestReachabilityStatus status = [RequestManager reachabilityStatus];
    switch (status) {
        case RequestReachabilityStatusReachableViaWiFi:
        case RequestReachabilityStatusReachableViaWWAN: {
            [self requestData];
        }
            break;
        default: {
            [self.cateTableView.mj_header endRefreshing];
            [self.cateTableView.mj_footer endRefreshing];
            if (self.dataArr.count == 0) {
                _nodataLableView.hidden = NO;
                [self.cateTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArr.count];
            }
        }
            break;
    }
}

-(void)requestData {
    
    _nodataLableView.hidden = YES;
    
    NSDictionary *pramaDic= @{@"openid":USER_OPENID, @"categoryId":self.categoryId, @"sorttype":@"2", @"startindex":@"1", @"endindex":@"20"};
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, CategoryUrl];
    
    NSLog(@"请求参数：%@", pramaDic);
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];

        NSDictionary *dic = json;
        [self.cateTableView.mj_header endRefreshing];
        [self.cateTableView.mj_footer endRefreshing];

        if ([dic[@"code"] integerValue] !=  200) {
            [self showNoticeView:dic[@"msg"]];
            return ;
        }
        
        NSLog(@"%@", dic);
        NSArray *goodslist = dic[@"goodslist"];
        if (goodslist.count == 0) {
            
            _nodataLableView.hidden = NO;
            [self.dataArr removeAllObjects];
            
            [self.cateTableView reloadData];
            
            [self.cateTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArr.count];
            [self.cateTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            self.dataArr = [NSMutableArray array];
            for (NSDictionary *listDic in goodslist){
                SCCategoryGoodsModel *cateM = [[SCCategoryGoodsModel alloc] init];
                [cateM setValuesForKeysWithDictionary:listDic];
                cateM.isvip = [NSString stringWithFormat:@"%@", listDic[@"isvip"]];
                cateM.keyName = [NSString stringWithFormat:@"%@_%@", cateM.itemtype, cateM.itemid];
                [self.dataArr addObject:cateM];
            }
            
            [self.cateTableView reloadData];
        }
        

    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];

        [self.cateTableView.mj_header endRefreshing];
        [self.cateTableView.mj_footer endRefreshing];
        if (self.dataArr.count == 0) {
            _nodataLableView.hidden = NO;
            [self.cateTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArr.count];
        }
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        
        if(self.dataArr.count == 0){
            _nodataLableView.hidden = NO;
            [self.cateTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArr.count];
        }
    }];
}

-(void)initComponents {
    _cateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40-NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_cateTableView];
    
    self.cateTableView.estimatedSectionHeaderHeight = 0;
    self.cateTableView.estimatedSectionFooterHeight = 0;
    self.cateTableView.delegate = self;
    self.cateTableView.dataSource = self;
    _cateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseID = [NSString stringWithFormat:@"SCCategoryTableCell%ld", indexPath.row];
    SCCategoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[SCCategoryTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count > 0) {
        [cell refreshCellWithModel:self.dataArr[indexPath.row]];
    }else{
        [self.cateTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArr.count];
    }
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AdaptedWidth(100);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.0001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SCGoodsDetailViewController *detailVC = [[SCGoodsDetailViewController alloc] init];
    SCCategoryGoodsModel *goodsM = [[SCCategoryGoodsModel alloc] init];
    if (self.dataArr.count > 0) {
        goodsM = self.dataArr[indexPath.row];
    }
    
    detailVC.goodsId = [NSString stringWithFormat:@"%@", goodsM.itemid];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 添加到购物车
-(void)addGoodsToShoppingCar:(SCCategoryGoodsModel *)cateM {

    NSString *isdlbitem = [NSString stringWithFormat:@"%@", cateM.isdlbitem];
    if ([isdlbitem isEqualToString:@"true"] || [isdlbitem isEqualToString:@"1"]) {
        //跳转到下载下载创客app页面
        XWAlterVeiw *alert = [[XWAlterVeiw alloc] init];
        alert.delegate = self;
        alert.titleLable.text = @"您购买的商品暂不能在商城下单，请点击【确定】下载创客APP进行购买";
        [alert show];
    }else{
        NSString *goodsId = [NSString stringWithFormat:@"%@", cateM.itemid];
        NSLog(@"加入购物车");
        NSDictionary *pramaDic = @{@"itemids": goodsId, @"openid": USER_OPENID};
        NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, AddToShoppingCarUrl];

        [self.view addSubview:self.loadingView];
        [self.loadingView startAnimation];

        [HttpTool postWithUrl:loveItemUrl params:pramaDic success:^(id json) {
            [self.loadingView stopAnimation];
            NSDictionary *dic = json;
            NSString * status = [dic valueForKey:@"code"];
            if ([status intValue] != 200) {
                [self showNoticeView:[dic valueForKey:@"msg"]];
                return ;
            }
            [[NSUserDefaults standardUserDefaults] setObject:@"AddToShoppingCarSuccess" forKey:@"SCChangedShopingCar"];
            [self showNoticeView:@"亲，在购物车等你哦"];
        } failure:^(NSError *error) {
            [self.loadingView stopAnimation];
            if (error.code == -1009) {
                [self showNoticeView:NetWorkNotReachable];
            }else{
                [self showNoticeView:NetWorkTimeout];
            }
        }];
    }
}

-(void)subuttonClicked {
    SCDownloadCKAPPWebVC *downVC = [[SCDownloadCKAPPWebVC alloc] init];
    [self.navigationController pushViewController:downVC animated:YES];
}

-(void)refreshData{
    
    __weak typeof(self) weakSelf = self;
    self.cateTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.cateTableView.mj_header beginRefreshing];
        [self.cateTableView.mj_footer endRefreshing];
        
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";
        strongSelf.endInterval = [nowDate timeIntervalSince1970];
        NSTimeInterval value = strongSelf.endInterval - strongSelf.startInterval;
        CGFloat second = [[NSString stringWithFormat:@"%.2f",value] floatValue];//秒
        NSLog(@"间隔------%f秒",second);
        strongSelf.startInterval = strongSelf.endInterval;
        
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                if (value >= Interval) {
                    [strongSelf requestData];
                }else{
                    [strongSelf.cateTableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [strongSelf showNoticeView:NetWorkNotReachable];
                [strongSelf.cateTableView.mj_header endRefreshing];
                [strongSelf.cateTableView.mj_footer endRefreshing];
                if (strongSelf.dataArr.count == 0) {
                    strongSelf.nodataLableView.hidden = NO;
                    [strongSelf.cateTableView tableViewDisplayView:strongSelf.nodataLableView ifNecessaryForRowCount:strongSelf.dataArr.count];
                }
            }
                break;
        }
    }];
    
    self.cateTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

-(void)loadMoreData {
    NSString *startindex = [NSString stringWithFormat:@"%ld", self.dataArr.count+1];
    NSString *endindex = [NSString stringWithFormat:@"%ld", [startindex integerValue]+20];
    NSDictionary *pramaDic= @{@"openid":USER_OPENID, @"categoryId":self.categoryId, @"sorttype":@"2", @"startindex":startindex, @"endindex":endindex};
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, CategoryUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        [self.cateTableView.mj_footer endRefreshing];

        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] !=  200) {
            [self showNoticeView:dic[@"msg"]];
            return ;
        }
        
        NSLog(@"%@", dic);
        NSArray *goodslist = dic[@"goodslist"];
        if (goodslist.count == 0) {
            [self.cateTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
        
        for (NSDictionary *listDic in goodslist){
            SCCategoryGoodsModel *cateM = [[SCCategoryGoodsModel alloc] init];
            [cateM setValuesForKeysWithDictionary:listDic];
            cateM.isvip = [NSString stringWithFormat:@"%@", listDic[@"isvip"]];
            cateM.keyName = [NSString stringWithFormat:@"%@_%@", cateM.itemtype, cateM.itemid];
            [self.dataArr addObject:cateM];
        }
        
        [self.cateTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        
        [self.cateTableView.mj_footer endRefreshing];
//        [self loadCacheData:[self getCacheData]];
        [self.cateTableView.mj_header endRefreshing];
        [self.cateTableView.mj_footer endRefreshing];
        if (self.dataArr.count == 0) {
            _nodataLableView.hidden = NO;
            [self.cateTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArr.count];
        }
        
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];

}

- (void)zj_viewWillDisappearForIndex:(NSInteger)index {
    [self.cateTableView.mj_header endRefreshing];
    [self.cateTableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
