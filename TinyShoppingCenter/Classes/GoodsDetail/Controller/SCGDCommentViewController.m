//
//  SCGDCommentViewController.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCGDCommentViewController.h"
#import "SCGoodsDetailBottomView.h"
#import "SCCommentListCell.h"
#import "SCCommentListHeaderView.h"
#import "SCCommentModel.h"
#import "SCConfirmOrderVC.h"
#import "SCBannerActiveGDVC.h"
#import "XWAlterVeiw.h"
#import "SCDownloadCKAPPWebVC.h"

@interface SCGDCommentViewController ()<SCGoodsDetailBottomViewDelegate, UITableViewDataSource, UITableViewDelegate, XWAlterVeiwDelegate>

@property (nonatomic, strong) UITableView *commentTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) SCGoodsDetailBottomView *detailBottomView;

@end

@implementation SCGDCommentViewController

-(NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价";
    
    [self createTableView];
    
    [self requestCommentData];
    [self refreshData];
}

-(void)requestCommentData {
    
#warning startindex 从1开始
    NSString *startindex = [NSString stringWithFormat:@"%ld", self.dataArr.count];
    
    if (self.dataArr.count != 0 && self.dataArr.count < 20) {
        [self.commentTableView.mj_header endRefreshing];
        [self.commentTableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    NSString *endindex = [NSString stringWithFormat:@"%ld", self.dataArr.count + 20];
    NSDictionary *pramaDic = @{@"itemid": self.goodsId, @"startindex":startindex, @"endindex":endindex};
    
    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, CommentListUrl];
    [HttpTool getWithUrl:loveItemUrl params:pramaDic success:^(id json) {
        [self.commentTableView.mj_footer endRefreshing];
        NSDictionary *dic = json;
        NSString * status = [dic valueForKey:@"code"];
        if ([status intValue] != 200) {
            [self showNoticeView:[dic valueForKey:@"msg"]];
            return ;
        }
        
        NSArray *commentlist = dic[@"commentlist"];
        if (commentlist.count == 0) {
            [self.commentTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        for (NSDictionary *dict in commentlist) {
            SCCommentModel *commentM = [[SCCommentModel alloc] init];
            [commentM setValuesForKeysWithDictionary:dict];
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *pathDic in dict[@"pathlist"]) {
                SCCommentImgModel *commentImgM = [[SCCommentImgModel alloc] init];
                [commentImgM setValuesForKeysWithDictionary:pathDic];
                [tempArr addObject:commentImgM];
            }
            commentM.imgPathArray = tempArr;
            [self.dataArr addObject:commentM];
        }
        
        NSString *synthesispf = [NSString stringWithFormat:@"%@", dic[@"synthesispf"]];
        if (IsNilOrNull(synthesispf)) {
            synthesispf = @"5.0";
        }
        
        SCCommentListHeaderView *headerView = [[SCCommentListHeaderView alloc] initWithFrame:CGRectMake(5,69, SCREEN_WIDTH-10,90)];
        CGFloat score = [synthesispf floatValue];
        NSString *commentScore = [NSString stringWithFormat:@"%.1f", score];
        
        [headerView realoadView:commentScore];
        
        headerView.backgroundColor = [UIColor whiteColor];
        _commentTableView.tableHeaderView = headerView;
        
        [self.commentTableView reloadData];
    } failure:^(NSError *error) {
        [self.commentTableView.mj_footer endRefreshing];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}
/**创建tableView*/
-(void)createTableView{
    if (@available(iOS 11.0, *)) {
       _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-50-64-NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStyleGrouped];
    }else{
       _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50) style:UITableViewStyleGrouped];
    }
    
    _commentTableView.rowHeight = UITableViewAutomaticDimension;
    _commentTableView.estimatedRowHeight = 44;
    _commentTableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    _commentTableView.estimatedSectionHeaderHeight = 44;
    _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    _commentTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_commentTableView];

    //创建底部 加入购物车  立即购买
    _detailBottomView = [[SCGoodsDetailBottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50-BOTTOM_BAR_HEIGHT, SCREEN_WIDTH, 50)];
    
    if ([_limit isEqualToString:@"0"]) {
        if ([_libcnt integerValue] > 0) {
            [_detailBottomView showBottomType:@"Sell"];//可以购买
        }else{
            [_detailBottomView showBottomType:@"Sellout"];//已售罄
        }
    }else if([_limit isEqualToString:@"1"]){
        [_detailBottomView showBottomType:@"WaitSell"];//待出售
    }else if([_limit isEqualToString:@"2"]){
        [_detailBottomView showBottomType:@"Sellout"];//已售罄
    }
    
    _detailBottomView.delegate = self;
    [self.view addSubview:_detailBottomView];
    
}

#pragma mark - tableViewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SCCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"SCCommentListCell%ld", indexPath.row]];
    if (cell == nil) {
        cell = [[SCCommentListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"SCCommentListCell%ld", indexPath.row]];
    }
    cell.backgroundColor = [UIColor tt_grayBgColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell refreshCellWithModel:self.dataArr[indexPath.row] index:indexPath.row];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - 消息40 店铺41 加入购物车42 立即购买43
-(void)pushToOtherVCWithButtonTag:(NSInteger)buttonTag{
    
    if (buttonTag == 40) {
        [[SCEnterRCloudOrToothManager manager] enterRCloudOrTooth];
    }else if (buttonTag == 41){
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else if (buttonTag == 42){
        
        NSString *isdlbitem = [NSString stringWithFormat:@"%@", self.goodsDM.isdlbitem];
        if ([isdlbitem isEqualToString:@"true"] || [isdlbitem isEqualToString:@"1"]) {
            //跳转到下载下载创客app页面
            XWAlterVeiw *alert = [[XWAlterVeiw alloc] init];
            alert.delegate = self;
            alert.titleLable.text = @"您购买的商品暂不能在商城下单，请点击【确定】下载创客APP进行购买";
            [alert show];
        }else{
            NSLog(@"加入购物车");
            NSDictionary *pramaDic = @{@"itemids": self.goodsId, @"openid": USER_OPENID};
            NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, AddToShoppingCarUrl];
            [self.view addSubview:self.loadingView];
            [self.loadingView stopAnimation];
            [HttpTool postWithUrl:loveItemUrl params:pramaDic success:^(id json) {
                [self.loadingView startAnimation];
                
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
    }else{
        NSString *isdlbitem = [NSString stringWithFormat:@"%@", self.goodsDM.isdlbitem];
        if ([isdlbitem isEqualToString:@"true"] || [isdlbitem isEqualToString:@"1"]) {
            //跳转到下载下载创客app页面
            XWAlterVeiw *alert = [[XWAlterVeiw alloc] init];
            alert.delegate = self;
            alert.titleLable.text = @"您购买的商品暂不能在商城下单，请点击【确定】下载创客APP进行购买";
            [alert show];
        }else{
            NSLog(@"立即购买");
            SCConfirmOrderVC *confirmOrder = [[SCConfirmOrderVC alloc] init];
            NSDictionary *goodsDict = [self.goodsDM mj_keyValues];
            confirmOrder.goodsDict = goodsDict;
            [self.navigationController pushViewController:confirmOrder animated:YES];
        }
    }
}

-(void)subuttonClicked {
    SCDownloadCKAPPWebVC *downVC = [[SCDownloadCKAPPWebVC alloc] init];
    [self.navigationController pushViewController:downVC animated:YES];
}

-(void)refreshData {
    __typeof (self) __weak weakSelf = self;
    
    self.commentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [weakSelf requestCommentData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
