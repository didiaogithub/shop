//
//  SCMineViewController.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCMineViewController.h"
#import "SCOrderListViewController.h"
#import "YSCollectionViewController.h"
#import "YSMemberPointViewController.h"
#import "ChangeMyAddressViewController.h"
#import "WebDetailViewController.h"
#import "CleanCache.h"
#import "SCMineInfoViewController.h"
#import "SetUpViewController.h"
#import "SCMineTableViewCell.h"
#import "SCUserInfoModel.h"
#import "FFWarnAlertView.h"


@interface SCMineViewController ()<UITableViewDelegate, UITableViewDataSource, SCUserInfoSignUpDelegate, SCMineOrderCellDelegate>

@property (nonatomic, strong) UITableView *mineTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SCUserInfoModel *userInfoM;

@end

@implementation SCMineViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self getMeInfo];
    
    //请求我的优惠券列表
    [[SCCouponTools shareInstance] resquestMyCouponsData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createUIView];
    
    [CKCNotificationCenter addObserver:self selector:@selector(defaultTableViewFrame) name:@"HasNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(changeTableViewFrame) name:@"NoNetNotification" object:nil];
}

- (void)createUIView {
    _mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-49-NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStyleGrouped];
    _mineTableView.rowHeight = UITableViewAutomaticDimension;
    _mineTableView.estimatedRowHeight = 0;
    _mineTableView.estimatedSectionFooterHeight = 0;
    _mineTableView.estimatedSectionHeaderHeight = 0;
    _mineTableView.delegate  = self;
    _mineTableView.dataSource = self;
    _mineTableView.separatorColor = [UIColor tt_grayBgColor];
    _mineTableView.backgroundColor = [UIColor tt_grayBgColor];
    [self.view addSubview:_mineTableView];
    
    [self bindMineData];
    
}

-(void)getMeInfo {
    
    NSDictionary *params = @{@"openid":USER_OPENID};
    NSString *signUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetMeInfoUrl];
    
    [HttpTool getWithUrl:signUrl params:params success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] intValue] != 200) {
            [self.loadingView showNoticeView:dict[@"msg"]];
            return ;
        }
        
        self.userInfoM = [[SCUserInfoModel alloc] init];
        [self.userInfoM setValuesForKeysWithDictionary:dict];
        
        NSString *smallname = [NSString stringWithFormat:@"%@", dict[@"smallname"]];
        NSString *mobile = [NSString stringWithFormat:@"%@", dict[@"mobile"]];
        NSString *headPath = [NSString stringWithFormat:@"%@", dict[@"head"]];
        if (!IsNilOrNull(smallname)) {
            [KUserdefaults setObject:smallname forKey:@"YDSC_USER_SMALLNAME"];
        }
        if (!IsNilOrNull(headPath)) {
            [KUserdefaults setObject:headPath forKey:@"YDSC_USER_HEAD"];
        }
        if (!IsNilOrNull(mobile)) {
            [KUserdefaults setObject:mobile forKey:@"YDSC_USER_MOBILE"];
        }
        [self bindMineData];
    } failure:^(NSError *error) {
        [self bindMineData];
    }];
    
}

-(void)bindMineData{
    self.dataArray = [NSMutableArray array];
    CellModel *userInfoM = [self createCellModel:[SCUserInfoCell class] userInfo:self.userInfoM height:180];
    userInfoM.delegate = self;
    SectionModel *section0 = [self createSectionModel:@[userInfoM] headerHeight:0.1 footerHeight:0.1];
    [self.dataArray addObject:section0];
    
    CellModel *orderCellM = [self createCellModel:[SCMineOrderCell class] userInfo:nil height:115];
    orderCellM.delegate = self;
    SectionModel *section1 = [self createSectionModel:@[orderCellM] headerHeight:0.1 footerHeight:10];
    [self.dataArray addObject:section1];

    NSMutableArray *titleArray = [NSMutableArray array];
    NSMutableArray *imageArray = [NSMutableArray array];
    NSString *mallintegralshow = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:MallintegralShowOrNot]];
    if ([mallintegralshow isEqualToString:@"ture"] || [mallintegralshow isEqualToString:@"1"]) {
        [titleArray addObjectsFromArray:@[@"我的收藏", @"我的积分", @"推荐有奖", @"积分商城", @"我的地址", @"问题帮助", @"关于我们", @"设置"]];
        [imageArray addObjectsFromArray:@[@"collected", @"score", @"recommondReward", @"minemall", @"addressred",  @"minehelp", @"ckysred", @"minesetup"]];
    }else{
        [titleArray addObjectsFromArray:@[@"我的收藏", @"我的积分", @"推荐有奖", @"我的地址", @"问题帮助", @"关于我们", @"设置"]];
        [imageArray addObjectsFromArray:@[@"collected", @"score", @"recommondReward", @"addressred",  @"minehelp", @"ckysred", @"minesetup"]];
        
    }
    //控制消息中心显示不显示  0:不显示，1：显示
    NSString *msgshow = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_msgShow"]];
    if ([msgshow isEqualToString:@"ture"] || [msgshow isEqualToString:@"1"]) {
        [titleArray insertObject:@"消息中心" atIndex:1];
        [imageArray insertObject:@"messageCenter" atIndex:1];
    }
    
    for (NSInteger i = 0; i < titleArray.count; i++) {
        CellModel *functionM = [self createCellModel:[SCMineFunctionCell class] userInfo:@{@"title":titleArray[i], @"image": imageArray[i]} height:55];
        SectionModel *section2 = [self createSectionModel:@[functionM] headerHeight:0.1 footerHeight:0.1];
        [self.dataArray addObject:section2];
    }
    
    [self.mineTableView reloadData];
}

-(CellModel*)createCellModel:(Class)cls userInfo:(id)userInfo height:(CGFloat)height {
    CellModel *model = [[CellModel alloc] init];
    model.selectionStyle = UITableViewCellSelectionStyleNone;
    model.userInfo = userInfo;
    model.height = height;
    model.className = NSStringFromClass(cls);
    return model;
}

-(SectionModel*)createSectionModel:(NSArray<CellModel*>*)items headerHeight:(CGFloat)headerHeight footerHeight:(CGFloat)footerHeight {
    SectionModel *model = [SectionModel sectionModelWithTitle:nil cells:items];
    model.headerhHeight = headerHeight;
    model.footerHeight = footerHeight;
    return model;
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_dataArray){
        return _dataArray.count;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SectionModel *s = _dataArray[section];
    if(s.cells) {
        return s.cells.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionModel *s = _dataArray[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    
    SCMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:item.reuseIdentifier];
    if(!cell) {
        cell = [[NSClassFromString(item.className) alloc] initWithStyle:item.style reuseIdentifier:item.reuseIdentifier];
    }
    cell.selectionStyle = item.selectionStyle;
    cell.accessoryType = item.accessoryType;
    cell.delegate = item.delegate;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionModel *s = _dataArray[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    
    if(item.title) {
        cell.textLabel.text = item.title;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor colorWithRed:0.294 green:0.298 blue:0.302 alpha:1.00];
    }
    if(item.subTitle) {
        cell.detailTextLabel.text = item.subTitle;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.294 green:0.298 blue:0.302 alpha:1.00];
    }
    
    SEL selector = NSSelectorFromString(@"fillData:");
    if([cell respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
        [cell performSelector:selector withObject:item.userInfo];
#pragma clang diagnostic pop
    }
}

#pragma mark - tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionModel *s = _dataArray[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    return item.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SectionModel *s = _dataArray[section];
    return s.headerhHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    SectionModel *s = _dataArray[section];
    return s.footerHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *vcNameArray =
        [NSMutableArray arrayWithArray:@[@"YSCollectionViewController",
                                         @"YSMemberPointViewController",
                                         @"SCRecommendRewardVC",
                                         @"ChangeMyAddressViewController",
                                         @"WebDetailViewController",
                                         @"WebDetailViewController",
                                         @"SetUpViewController"]];
    
    
    NSString *mallintegralshow = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:MallintegralShowOrNot]];
    if ([mallintegralshow isEqualToString:@"ture"] || [mallintegralshow isEqualToString:@"1"]) {
        [vcNameArray insertObject:@"SCIntegralMallViewController" atIndex:3];
    }
    
    NSString *msgshow = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_msgShow"]];
    if ([msgshow isEqualToString:@"ture"] || [msgshow isEqualToString:@"1"]) {
        [vcNameArray insertObject:@"SCMessageListViewController" atIndex:1];
    }

    if (indexPath.section > 1) {
        if(indexPath.section == vcNameArray.count-1){//问题帮助
            WebDetailViewController *detailVC = [[WebDetailViewController alloc] init];
            detailVC.type = @"help";
            detailVC.detailUrl = [NSString stringWithFormat:@"%@front/help/html/helplist.html", WebServiceAPI];
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if(indexPath.section == vcNameArray.count){//关于我们
            WebDetailViewController *detailVC = [[WebDetailViewController alloc] init];
            detailVC.type = @"our";
            NSString *uk = [KUserdefaults objectForKey:@"YDSC_uk"];
            detailVC.detailUrl = [NSString stringWithFormat:@"%@front/appmall/html/aboutus.html?ckys_openid=%@&uk=%@", WebServiceAPI, USER_OPENID, uk];
            [self.navigationController pushViewController:detailVC animated:YES];
        }else{
            NSString *className = vcNameArray[indexPath.section - 2];
            Class cls = NSClassFromString(className);
            
            NSString *couponbgurl = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_couponbgurl"]];
            if (IsNilOrNull(couponbgurl)) {
                if ([className isEqualToString:@"SCRecommendRewardVC"]) {
                    [self.loadingView showNoticeView:@"功能暂未开放，敬请期待！"];
                    return;
                }
            }
            
            UIViewController *viewController = [[cls alloc]init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

#pragma - mark cellDelegate
-(void)signUp {
    
    NSDictionary *params = @{@"openid":USER_OPENID};
    NSString *signUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, SignUrl];
    
    [HttpTool getWithUrl:signUrl params:params success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] intValue] != 200) {
            [self.loadingView showNoticeView:dict[@"msg"]];
            return ;
        }
        
        NSString *integralnum = [NSString stringWithFormat:@"%@", dict[@"integralnum"]];
        if ([integralnum isEqualToString:@"0"] || IsNilOrNull(integralnum)) {
            [self.loadingView showNoticeView:@"已签到"];
        }else{
            NSString *msg = [NSString stringWithFormat:@"%@ 获得积分%@", dict[@"msg"], dict[@"integralnum"]];
            
            [self.loadingView showNoticeView:msg];
            
            [self getMeInfo];
        }
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self.loadingView showNoticeView:NetWorkNotReachable];
        }else{
            [self.loadingView showNoticeView:NetWorkTimeout];
        }
    }];
}

-(void)enterToDetailUserInfo {
    SCMineInfoViewController *info = [[SCMineInfoViewController alloc] init];
    info.userInfoM = self.userInfoM;
    [self.navigationController pushViewController:info animated:YES];
}

#pragma mark-查看我的订单跳转
-(void)enterOrderListWithType:(NSInteger)buttonTag{
    NSInteger tag = buttonTag - 20;
    NSString *status;
    if(tag == 0){
        status = @"1";
    }else if (tag == 1){
        status = @"2,7";
    }else if (tag == 2){
        status = @"3,4,5,6";
    }else if (tag == 3){
        status = @"4,5";
    }else{
        status = @"99";
    }
    
    SCOrderListViewController *myorder = [[SCOrderListViewController alloc] init];
    myorder.statusString = status;
    [self.navigationController pushViewController:myorder animated:YES];
}

-(void)defaultTableViewFrame {
    self.mineTableView.frame = CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-49-NaviAddHeight-BOTTOM_BAR_HEIGHT);
}

-(void)changeTableViewFrame {
    self.mineTableView.frame = CGRectMake(0, 64+44+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-44-49-NaviAddHeight-BOTTOM_BAR_HEIGHT);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
