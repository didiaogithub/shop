//
//  SCWaitReleaseCommentViewController.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/9/9.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCWaitReleaseCommentViewController.h"
#import "SCCanCommentCell.h"
#import "SCCommentOrderViewController.h"
#import "SCOrderDetailModel.h"

@interface SCWaitReleaseCommentViewController ()<UITableViewDataSource, UITableViewDelegate, ReleaseOrderCommentDelegate>

@property (nonatomic, strong) UITableView *commentTableView;
@property (nonatomic, strong) SCOrderDetailGoodsModel *goodsM;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation SCWaitReleaseCommentViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSString *releasedId = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"ReleasedGoodsId"]];
    if (!IsNilOrNull(releasedId)) {
        [KUserdefaults removeObjectForKey:@"ReleasedGoodsId"];
        
        NSInteger index = -1;

        for (NSInteger i = 0; i < self.dataArray.count; i++) {
            SCOrderDetailGoodsModel *goodsM = self.dataArray[i];
            if ([goodsM.itemid isEqualToString:releasedId]) {
                index = i;
            }
        }
        if (index != -1) {
            [self.dataArray removeObjectAtIndex:index];
            if (self.dataArray.count > 0) {
                [self.commentTableView reloadData];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"待评价商品";
    
    [self initComponents];
    
    [self createCheckOrderDetailData];
}

#pragma mark-请求订单详情数据
-(void)createCheckOrderDetailData{
    [self.dataArray removeAllObjects];
    NSString *orderDetailUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,OrderDetailUrl];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    NSDictionary *pramaDic = @{@"orderid": self.orderid};
    
    [HttpTool getWithUrl:orderDetailUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"msg"]];
            return ;
        }
        
        
        _dataArray = [NSMutableArray array];
        for (NSDictionary *goodsDic in dict[@"itemlist"]) {
            
            NSString *iscomment = [NSString stringWithFormat:@"%@", goodsDic[@"iscomment"]];
            if ([iscomment isEqualToString:@"0"] || [iscomment isEqualToString:@"false"]) {
                SCOrderDetailGoodsModel *goodsM = [[SCOrderDetailGoodsModel alloc] init];
                [goodsM setValuesForKeysWithDictionary:goodsDic];
                [self.dataArray addObject:goodsM];
            }
            
        }
        [self.commentTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}

-(void)initComponents {
    if (@available(iOS 11.0, *)) {
       _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64-NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
    }else{
        _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    }
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_commentTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *rid = [NSString stringWithFormat:@"SCReleaseCommentCell%ld", indexPath.row];
    SCCanCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[SCCanCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    }
    
    cell.delegate = self;
    _goodsM = self.dataArray[indexPath.row];
    cell.rightBtn.tag = indexPath.row + 333;
    [cell refreshWithDetailModel:_goodsM];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145;
}

-(void)gotoReleaseOrderComment:(NSInteger)tag {

    SCCommentOrderViewController *releaseComment = [[SCCommentOrderViewController alloc] init];
    releaseComment.goodsM = self.dataArray[tag];
    releaseComment.orderid = self.orderid;
    releaseComment.fromVC = @"SCWaitReleaseCommentViewController";
    [self.navigationController pushViewController:releaseComment animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
