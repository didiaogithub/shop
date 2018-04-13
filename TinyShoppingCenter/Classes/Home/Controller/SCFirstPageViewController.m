//
//  SCFirstPageViewController.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/16.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCFirstPageViewController.h"
#import "SCFirstPageModel.h"
#import "SCFirstPageCell.h"
#import <RongIMKit/RongIMKit.h>
#import "CKShareManager.h"
#import "SCGoodsDetailViewController.h"
#import "FFPopTool.h"
#import "CKVersionCheckManager.h"
#import "SCBannerActiveGDVC.h"
#import "RCloudManager.h"
#import "XLImageViewer.h"
#import "InvitationAlterVeiw.h"
#import "SCGoodsSearchViewController.h"

@interface SCFirstPageViewController ()<UITableViewDelegate, UITableViewDataSource, SCShopInfoDelegate, InvitationAlterVeiwDelegate>

@property (nonatomic, strong) UITableView *firstPageTableView;
@property (nonatomic, strong) NSMutableArray<SectionModel*> *dataArray;
@property (nonatomic, strong) UIView *contentView; //广告弹窗页面
/** 活动页数据*/
@property (nonatomic, copy) NSString *activeId;
@property (nonatomic, copy) NSString *itemid;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *limitnum;
@property (nonatomic, strong) NSDictionary *memoDic;
/** 刷新时间间隔*/
@property (nonatomic, assign) NSTimeInterval startInterval;
@property (nonatomic, assign) NSTimeInterval endInterval;
@property (nonatomic, strong) InvitationAlterVeiw *invitationView;

@end

@implementation SCFirstPageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.firstPageTableView.mj_header endRefreshing];
    /**2017.10.12首页数据接口返回店铺信息和融云所需参数，所以以下两个方法不在调用
     //请求时官方店还是创客店铺
     [self requestShopOwner];
     //请求个人信息用来设置融云和智齿
     [self getMeInfo];
     */
    
    //请求我的优惠券列表
    [[SCCouponTools shareInstance] resquestMyCouponsData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"创客云商";
    self.view.backgroundColor = [UIColor tt_grayBgColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSString *adClick = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_CLICKED_AD"]];
    if ([adClick isEqualToString:@"YES"]) {
        [KUserdefaults removeObjectForKey:@"YDSC_CLICKED_AD"];
        [self enterAdDetailVc];
    }
    
    [CKCNotificationCenter addObserver:self selector:@selector(defaultTableViewFrame) name:@"HasNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(changeTableViewFrame) name:@"NoNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(requestDataWithoutCache) name:@"RequestHomePageData" object:nil];
    
    [self createTableView];

    [self bindFirstPageData];
    
    RLMResults *result = [self getFirstPageData];
    if (result.count > 0) {
        [self loadHomeData:NO];
    }else{
        [self loadHomeData:YES];
    }
    
    [self refreshData];
    //请求活动
    [self requestFirstPageAD];
    //进店提醒
    [self enterShopNotice];
    //请求支付方式与域名
    [self requestPayMethod];
}

#pragma mark - 分享
-(void)createShareButton {
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareGoods)];
    right.tintColor = [UIColor blackColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.rightBarButtonItem = right;
    }else{
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -10;
        self.navigationItem.rightBarButtonItems = @[spaceItem, right];
    }
    
}

-(void)shareGoods {
    NSLog(@"首页分享分享");
    RLMResults *result = [self getFirstPageData];
    SCFirstPageModel *firstPageM = result.firstObject;
    
    NSString *title = [NSString stringWithFormat:@"%@", firstPageM.ckInfoM.name];
    NSString *shareApi = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_mallshareurl"]];
    if (IsNilOrNull(shareApi)) {
        shareApi = [NSString stringWithFormat:@"%@Wapmall/WeChat/share", WebServiceAPI];
    }
    
//    NSString *ckid = [NSString stringWithFormat:@"%@", firstPageM.ckInfoM.ckid];
//    if (IsNilOrNull(ckid)) {
//        ckid = @"0";
//    }
    NSString *shareUrl = [NSString stringWithFormat:@"%@?type=index&openid=%@", shareApi, USER_OPENID];
//    NSString *shareUrl = [NSString stringWithFormat:@"%@?type=index&ckid=%@", shareApi, ckid];

    
    NSString *logoUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, ShareLogoUrl];
    [CKShareManager shareToFriendWithName:title andHeadImages:logoUrl andUrl:[NSURL URLWithString:shareUrl] andTitle:@"创客云商"];
}

-(void)enterShopNotice {
    NSDictionary *pramaDic = @{@"openid": USER_OPENID};
    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, ShopNoticeUrl];
    [HttpTool getWithUrl:loveItemUrl params:pramaDic success:^(id json) {

    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 请求首页数据
-(void)loadHomeData:(BOOL)showLoading {
    
    NSDictionary *pramaDic= @{@"openid":USER_OPENID};
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,Home_Url];
    
    if (showLoading) {
        [self.view addSubview:self.loadingView];
        [self.loadingView startAnimation];
    }
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        [self.firstPageTableView.mj_header endRefreshing];
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.loadingView showNoticeView:dic[@"msg"]];
            return ;
        }
        
        NSString *meid = [NSString stringWithFormat:@"%@", dic[@"meid"]];
        if (!IsNilOrNull(meid)) {
            // 设置标签，别名
            NSSet *setTags = [NSSet setWithObject:@"appmall"];
            [JPUSHService setTags:setTags alias:[NSString stringWithFormat:@"m%@", meid] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                NSLog(@"\n[用户登录成功后设置别名]---[%@]",iAlias);
            }];
            
            //查看registId
            [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
                NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
            }];
        }
        
        [self analysisDatas:dic];
        [self bindFirstPageData];
        //创建分享按钮2017.10.12
        [self createShareButton];
        //连接融云或者智齿
        [self connectRCloudOrTooth];
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self.loadingView showNoticeView:NetWorkNotReachable];
        }else{
            [self.loadingView showNoticeView:NetWorkTimeout];
        }
        [self.firstPageTableView.mj_header endRefreshing];
    }];
}

-(void)analysisDatas:(NSDictionary *)dic {
    
    RLMResults *result = [SCFirstPageModel allObjects];
    RLMRealm *realm = [RLMRealm defaultRealm];
    if (result.count>0) {
        [realm beginWriteTransaction];
        [realm deleteObjects:result];
        [realm commitWriteTransaction];
    }
    
    NSArray *bannerArr = dic[@"bannerlist"];
    NSArray *topiclistArr = dic[@"topiclist"];
    NSArray *categorylistArr = dic[@"categorylist"];
    NSArray *goodslistArr = dic[@"goodslist"];
    NSDictionary *ckInfo = dic[@"ckInfo"];
    
    CkInfoModel *ckInfoM = [[CkInfoModel alloc] init];
    NSString *cerpath = [NSString stringWithFormat:@"%@", ckInfo[@"cerpath"]];
    NSString *cershow = [NSString stringWithFormat:@"%@", ckInfo[@"cershow"]];
    NSString *wxshow = [NSString stringWithFormat:@"%@", ckInfo[@"wxshow"]];
    NSString *mobile = [NSString stringWithFormat:@"%@", ckInfo[@"mobile"]];
    NSString *logopath = [NSString stringWithFormat:@"%@", ckInfo[@"logopath"]];
    NSString *smallname = [NSString stringWithFormat:@"%@", ckInfo[@"smallname"]];
    NSString *mobileshow = [NSString stringWithFormat:@"%@", ckInfo[@"mobileshow"]];
    NSString *wxaccount = [NSString stringWithFormat:@"%@", ckInfo[@"wxaccount"]];
    NSString *name = [NSString stringWithFormat:@"%@", ckInfo[@"name"]];
    NSString *ckid = [NSString stringWithFormat:@"%@", ckInfo[@"ckid"]];
    
    ckInfoM.cerpath = cerpath;
    ckInfoM.cershow = cershow;
    ckInfoM.wxshow = wxshow;
    ckInfoM.mobile = mobile;
    ckInfoM.logopath = logopath;
    ckInfoM.smallname = smallname;
    ckInfoM.mobileshow = mobileshow;
    ckInfoM.wxaccount = wxaccount;
    ckInfoM.name = name;
    ckInfoM.ckid = ckid;
    
    SCFirstPageModel *firstM = [[SCFirstPageModel alloc] init];
    [firstM setValuesForKeysWithDictionary:dic];
    firstM.ckInfoM = ckInfoM;
    firstM.firstPageKey = @"1";
    if (bannerArr.count > 0) {
        for (NSDictionary *dict in bannerArr) {
            Bannerlist *bannerM = [[Bannerlist alloc] init];
            [bannerM setValuesForKeysWithDictionary:dict];
            NSString *limitnum = [NSString stringWithFormat:@"%@", dict[@"limitnum"]];
            bannerM.limitnum = limitnum;
            bannerM.primaryKey = [NSString stringWithFormat:@"%@_%@", bannerM.bannerId, bannerM.path];
            [firstM.bannerlistArray addObject:bannerM];
        }
    }
    if (topiclistArr.count > 0) {
        for (NSDictionary *dict in topiclistArr) {
            Topiclist *topiclistM = [[Topiclist alloc] init];
            [topiclistM setValuesForKeysWithDictionary:dict];
            topiclistM.primaryKey = [NSString stringWithFormat:@"%@_%@", topiclistM.topId, topiclistM.path];
            [firstM.topiclistArray addObject:topiclistM];
        }
    }
    if (categorylistArr.count > 0) {
        for (NSDictionary *dict in categorylistArr) {
            Categorylist *categoryM = [[Categorylist alloc] init];
            [categoryM setValuesForKeysWithDictionary:dict];
            [firstM.categorylistArray addObject:categoryM];
        }
    }
    if (goodslistArr.count > 0) {
        for (NSDictionary *bannerDic in goodslistArr) {
            Goodslist *goodsM = [[Goodslist alloc] init];
            [goodsM setValuesForKeysWithDictionary:bannerDic];
            goodsM.primaryKey = [NSString stringWithFormat:@"%@_%@", goodsM.goodsId, goodsM.imgpath];
            [firstM.goodslistArray addObject:goodsM];
        }
    }
    
    [realm beginWriteTransaction];
    [SCFirstPageModel createOrUpdateInRealm:realm withValue:firstM];
    [realm commitWriteTransaction];
}

-(RLMResults*)getFirstPageData {
    NSString *firstPageKey = @"1";
    NSString *predicate = [NSString stringWithFormat:@"firstPageKey = '%@'", firstPageKey];
    RLMResults *result =  [[SCFirstPageModel class] objectsWhere:predicate];
    return result;
}

-(void)bindFirstPageData {
    RLMResults *result = [self getFirstPageData];
    _dataArray = [NSMutableArray array];
    SCFirstPageModel *firstPageM = result.firstObject;
    
    CellModel *shopInfoM = [self createCellModel:[SCShopInfoCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:firstPageM.ckInfoM ,@"data", firstPageM.headerPic, @"headerPic", nil] height:AdaptedWidth(63)];
    shopInfoM.delegate = self;
    SectionModel *section0 = [self createSectionModel:@[shopInfoM] headerHeight:0.1 footerHeight:10];
    [self.dataArray addObject:section0];
    
    CellModel *categoryM = [self createCellModel:[SCCategoryCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:firstPageM.categorylistArray ,@"data", nil] height:40*SCREEN_WIDTH/375.0f];
    SectionModel *section1 = [self createSectionModel:@[categoryM] headerHeight:0.1 footerHeight:0.1];
    [self.dataArray addObject:section1];
    
    CellModel *bannerM = [self createCellModel:[SCBannerCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:firstPageM.bannerlistArray ,@"data", nil] height:SCREEN_WIDTH/8*5];
    SectionModel *section2 = [self createSectionModel:@[bannerM] headerHeight:0.1 footerHeight:0.1];
    [self.dataArray addObject:section2];
    
    if (firstPageM.topiclistArray.count > 0) {
        for (Topiclist *topM in firstPageM.topiclistArray) {
            CellModel *TopicM = [self createCellModel:[SCTopiclistCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:topM ,@"data", nil] height:SCREEN_WIDTH*0.5];
            SectionModel *section3 = [self createSectionModel:@[TopicM] headerHeight:0.1 footerHeight:10];
            [self.dataArray addObject:section3];
        }
    }
    
    
    CellModel *titleM = [self createCellModel:[SCTitleCell class] userInfo:nil height:44*SCREEN_WIDTH/375.0f];
    SectionModel *section31 = [self createSectionModel:@[titleM] headerHeight:0.1 footerHeight:0.1];
    [self.dataArray addObject:section31];
    
    for (Goodslist *goodsModel in firstPageM.goodslistArray) {
        CellModel *goodsM = [self createCellModel:[SCGoodListCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:goodsModel ,@"data", nil] height:SCREEN_WIDTH*0.5];
        
        SectionModel *section3 = [self createSectionModel:@[goodsM] headerHeight:0.00001 footerHeight:0.00001];
        [self.dataArray addObject:section3];
    }
    
    [self.firstPageTableView.mj_header endRefreshing];
    [self.firstPageTableView reloadData];

}

-(void)createTableView{
    
    _firstPageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 113-NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:_firstPageTableView];
    _firstPageTableView.backgroundColor = [UIColor tt_grayBgColor];
    self.firstPageTableView.delegate = self;
    self.firstPageTableView.dataSource = self;
    self.firstPageTableView.estimatedSectionHeaderHeight = 0;
    self.firstPageTableView.estimatedSectionFooterHeight = 0;
    self.firstPageTableView.estimatedRowHeight = 0;

    _firstPageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    
    SCFirstPageCell *cell = [tableView dequeueReusableCellWithIdentifier:item.reuseIdentifier];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section > 2) {
        RLMResults *results = [self getFirstPageData];
        SCFirstPageModel *firstM = results.firstObject;
        if (firstM.topiclistArray.count > 0) {
            if (indexPath.section < (3 + firstM.topiclistArray.count)) {
                Topiclist *topicM = firstM.topiclistArray[indexPath.section-3];
                NSString *activeId = [NSString stringWithFormat:@"%@", topicM.activityid];
                if (!IsNilOrNull(activeId) && ![activeId isEqualToString:@"0"]) {
                    if(!IsNilOrNull(topicM.topId) && ![topicM.topId isEqualToString:@"0"]){
                        SCBannerActiveGDVC *detail = [[SCBannerActiveGDVC alloc] init];
                        if (IsNilOrNull(topicM.link)) {
                            return;
                        }
                        detail.link = topicM.link;
                        detail.goodsId = topicM.topId;
                        detail.activeID = topicM.activityid;
                        detail.showBuyBottom = @"YES";
                        [self.navigationController pushViewController:detail animated:YES];
                    }else{
                        SCBannerActiveGDVC *detail = [[SCBannerActiveGDVC alloc] init];
                        if (IsNilOrNull(topicM.link)) {
                            return;
                        }
                        detail.link = topicM.link;
                        detail.activeID = topicM.activityid;
                        detail.showBuyBottom = @"NO";
                        [self.navigationController pushViewController:detail animated:YES];
                    }
                }else{
                    if(!IsNilOrNull(topicM.topId) && ![topicM.topId isEqualToString:@"0"]){
                        SCGoodsDetailViewController *detail = [[SCGoodsDetailViewController alloc] init];
                        detail.goodsId = topicM.topId;
                        [self.navigationController pushViewController:detail animated:YES];
                    }else{
                        SCBannerActiveGDVC *detail = [[SCBannerActiveGDVC alloc] init];
                        if (IsNilOrNull(topicM.link)) {
                            return;
                        }
                        detail.link = topicM.link;
                        detail.showBuyBottom = @"NO";
                        [self.navigationController pushViewController:detail animated:YES];
                    }
                }
                
            }else if(indexPath.section == (3 + firstM.topiclistArray.count)){
            
            }else{
                Goodslist *goodsM = firstM.goodslistArray[indexPath.section - 4 -firstM.topiclistArray.count];
                NSString *activeId = [NSString stringWithFormat:@"%@", goodsM.activityid];
                if (!IsNilOrNull(activeId) && ![activeId isEqualToString:@"0"]) {
                    if(!IsNilOrNull(goodsM.goodsId) && ![goodsM.goodsId isEqualToString:@"0"]){
                        SCBannerActiveGDVC *detail = [[SCBannerActiveGDVC alloc] init];
                        if (IsNilOrNull(goodsM.path)) {
                            return;
                        }
                        detail.link = goodsM.path;
                        detail.goodsId = goodsM.goodsId;
                        detail.activeID = goodsM.activityid;
                        detail.showBuyBottom = @"YES";
                        [self.navigationController pushViewController:detail animated:YES];
                    }else{
                        SCBannerActiveGDVC *detail = [[SCBannerActiveGDVC alloc] init];
                        if (IsNilOrNull(goodsM.path)) {
                            return;
                        }
                        detail.link = goodsM.path;
                        detail.activeID = goodsM.activityid;
                        detail.showBuyBottom = @"NO";
                        [self.navigationController pushViewController:detail animated:YES];
                    }
                }else{
                    if(!IsNilOrNull(goodsM.goodsId) && ![goodsM.goodsId isEqualToString:@"0"]){
                        SCGoodsDetailViewController *detail = [[SCGoodsDetailViewController alloc] init];
                        detail.goodsId = goodsM.goodsId;
                        [self.navigationController pushViewController:detail animated:YES];
                    }else{
                        SCBannerActiveGDVC *detail = [[SCBannerActiveGDVC alloc] init];
                        if (IsNilOrNull(goodsM.path)) {
                            return;
                        }
                        detail.link = goodsM.path;
                        detail.showBuyBottom = @"NO";
                        [self.navigationController pushViewController:detail animated:YES];
                    }
                }
            }
        }else{
            if (indexPath.section == 3) {
                
            }else{
                Goodslist *goodsM = firstM.goodslistArray[indexPath.section - 4];
                NSString *activeId = [NSString stringWithFormat:@"%@", goodsM.activityid];
                if (!IsNilOrNull(activeId) && ![activeId isEqualToString:@"0"]) {
                    if(!IsNilOrNull(goodsM.goodsId) && ![goodsM.goodsId isEqualToString:@"0"]){
                        SCBannerActiveGDVC *detail = [[SCBannerActiveGDVC alloc] init];
                        if (IsNilOrNull(goodsM.path)) {
                            return;
                        }
                        detail.link = goodsM.path;
                        detail.goodsId = goodsM.goodsId;
                        detail.activeID = goodsM.activityid;
                        detail.showBuyBottom = @"YES";
                        [self.navigationController pushViewController:detail animated:YES];
                    }else{
                        SCBannerActiveGDVC *detail = [[SCBannerActiveGDVC alloc] init];
                        if (IsNilOrNull(goodsM.path)) {
                            return;
                        }
                        detail.link = goodsM.path;
                        detail.activeID = goodsM.activityid;
                        detail.showBuyBottom = @"NO";
                        [self.navigationController pushViewController:detail animated:YES];
                    }
                }else{
                    if(!IsNilOrNull(goodsM.goodsId) && ![goodsM.goodsId isEqualToString:@"0"]){
                        SCGoodsDetailViewController *detail = [[SCGoodsDetailViewController alloc] init];
                        detail.goodsId = goodsM.goodsId;
                        [self.navigationController pushViewController:detail animated:YES];
                    }else{
                        SCBannerActiveGDVC *detail = [[SCBannerActiveGDVC alloc] init];
                        if (IsNilOrNull(goodsM.path)) {
                            return;
                        }
                        detail.link = goodsM.path;
                        detail.showBuyBottom = @"NO";
                        [self.navigationController pushViewController:detail animated:YES];
                    }
                }
            }
        }
    }
}

-(void)refreshData {
    
    __weak typeof(self) weakSelf = self;
    self.firstPageTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.firstPageTableView.mj_header beginRefreshing];
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
                    [strongSelf loadHomeData:YES];
                }else{
                    [strongSelf.firstPageTableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [strongSelf.loadingView showNoticeView:NetWorkNotReachable];
                [strongSelf.firstPageTableView.mj_header endRefreshing];
            }
                break;
        }
    }];
}

#pragma mark - 请求活动数据
- (void)requestFirstPageAD {
    //活动页@"typeCode":@"AD" 首页@"typeCode":@"AL"
    NSDictionary *paramters = @{@"openid":USER_OPENID, @"typeCode":@"AL"};
    NSString *adUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, ActivityUrl];
    
    [HttpTool getWithUrl:adUrl params:paramters success:^(id json) {
        
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] == 200) {
            NSArray *arr = dict[@"list"];
            
            if (arr.count == 0) {
                //检查更新
                [[CKVersionCheckManager shareInstance] checkVersion];
                return;
            }
            NSDictionary *goodsDic = arr.firstObject;
            
            _itemid = [NSString stringWithFormat:@"%@", goodsDic[@"itemid"]];
            _activeId = [NSString stringWithFormat:@"%@", goodsDic[@"id"]];
            _link = [NSString stringWithFormat:@"%@", goodsDic[@"link"]];
            _path = [NSString stringWithFormat:@"%@", goodsDic[@"path"]];
            _memo = [NSString stringWithFormat:@"%@", goodsDic[@"memo"]];
            _titleStr = [NSString stringWithFormat:@"%@", goodsDic[@"title"]];
            _limitnum = [NSString stringWithFormat:@"%@", goodsDic[@"limitnum"]];
            
            
            NSData *JSONData = [_memo dataUsingEncoding:NSUTF8StringEncoding];
            _memoDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
            
            [self popViewShow];
        }
        
    } failure:^(NSError *error) {
        //检查更新
        [[CKVersionCheckManager shareInstance] checkVersion];
    }];
}

-(void)popViewShow {
    
    CGFloat w = SCREEN_WIDTH-60;
    CGFloat h = (SCREEN_WIDTH-60) /63 * 74;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    _contentView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
    [imageV sd_setImageWithURL:[NSURL URLWithString:_path]];
    imageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterActiveDetail)];
    [imageV addGestureRecognizer:tap];
    
    [_contentView addSubview:imageV];
    
    NSString *showJoin = [NSString stringWithFormat:@"%@", _memoDic[@"join"]];

    UIButton *join = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([showJoin isEqualToString:@"1"]) {
        join.frame = CGRectMake(20, CGRectGetMaxY(imageV.frame) - 56, w-40, 46);
        join.backgroundColor = [UIColor colorWithHexString:@"#f65253"];
        [join setTitle:@"立即参与" forState:UIControlStateNormal];
        join.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [join setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [join addTarget:self action:@selector(enterActiveDetail) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:join];
    }
    
    [FFPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [FFPopTool sharedInstance].closeButtonType = ButtonPositionTypeBottom;
    [[FFPopTool sharedInstance] showWithPresentView:_contentView animated:YES];

}

-(void)enterActiveDetail {
    
    [[FFPopTool sharedInstance] closeWithBlcok:^{
        
    }];

    if (!IsNilOrNull(_activeId) && ![_activeId isEqualToString:@"0"]) {
        if(!IsNilOrNull(_itemid) && ![_itemid isEqualToString:@"0"]){
            SCBannerActiveGDVC *detail = [[SCBannerActiveGDVC alloc] init];
            if (IsNilOrNull(_link)) {
                return;
            }
            detail.link = _link;
            detail.goodsId = _itemid;
            detail.activeID = _activeId;
            detail.showBuyBottom = @"YES";
            detail.limitnum = self.limitnum;
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            SCBannerActiveGDVC *detail = [[SCBannerActiveGDVC alloc] init];
            if (IsNilOrNull(_link)) {
                return;
            }
            detail.link = _link;
            detail.activeID = _activeId;
            detail.showBuyBottom = @"NO";
            [self.navigationController pushViewController:detail animated:YES];
        }
    }else{
        if(!IsNilOrNull(_itemid) && ![_itemid isEqualToString:@"0"]){
            SCGoodsDetailViewController *detail = [[SCGoodsDetailViewController alloc] init];
            detail.goodsId = _itemid;
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            SCBannerActiveGDVC *detail = [[SCBannerActiveGDVC alloc] init];
            if (IsNilOrNull(_link)) {
                return;
            }
            detail.link = _link;
            detail.showBuyBottom = @"NO";
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
}

#pragma mark - 判断连接融云或者智齿
-(void)connectRCloudOrTooth {
    RLMResults *result = [self getFirstPageData];
    SCFirstPageModel *firstPageM = result.firstObject;
    NSString *ckid = [NSString stringWithFormat:@"%@", firstPageM.ckInfoM.ckid];
    //如果ckid不为空并且ckid！=0则进入的是创客店铺，客服是用户，连接融云
    if (!IsNilOrNull(ckid) && ![ckid isEqualToString:@"0"]) {
        NSString *status = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"SC_ConnectRCloudStatus"]];
        if (![status isEqualToString:@"YES"]) {
            [[RCloudManager manager] connectRCloud];
        }
    }
}

-(void)defaultTableViewFrame {
    _firstPageTableView.frame = CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 113-NaviAddHeight-BOTTOM_BAR_HEIGHT);
}

-(void)changeTableViewFrame {
    _firstPageTableView.frame = CGRectMake(0, 64+44+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 113-NaviAddHeight-BOTTOM_BAR_HEIGHT);
}

-(void)requestDataWithoutCache {
    [self loadHomeData:YES];
}

#pragma mark - 进入商品详情页
-(void)enterAdDetailVc {
    
    NSString *activeId = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_AD_activityid"]];
    NSString *itemid = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_AD_itemid"]];
    NSString *link = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_AD_link"]];
    NSString *limitnum = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_AD_limitnum"]];

    
    if (!IsNilOrNull(activeId) && ![activeId isEqualToString:@"0"]) {
        if(!IsNilOrNull(itemid) && ![itemid isEqualToString:@"0"]){
            SCBannerActiveGDVC *detail = [[SCBannerActiveGDVC alloc] init];
            if (IsNilOrNull(link)) {
                return;
            }
            detail.link = link;
            detail.goodsId = itemid;
            detail.activeID = activeId;
            detail.limitnum = limitnum;
            detail.showBuyBottom = @"YES";
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            SCBannerActiveGDVC *detail = [[SCBannerActiveGDVC alloc] init];
            if (IsNilOrNull(link)) {
                return;
            }
            detail.link = link;
            detail.activeID = activeId;
            detail.showBuyBottom = @"NO";
            [self.navigationController pushViewController:detail animated:YES];
        }
    }else{
        if(!IsNilOrNull(itemid) && ![itemid isEqualToString:@"0"]){
            SCGoodsDetailViewController *detail = [[SCGoodsDetailViewController alloc] init];
            detail.goodsId = itemid;
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            SCBannerActiveGDVC *detail = [[SCBannerActiveGDVC alloc] init];
            if (IsNilOrNull(link)) {
                return;
            }
            detail.link = link;
            detail.showBuyBottom = @"NO";
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
}

-(void)requestPayMethod {
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, PayMethodUrl];
    [HttpTool getWithUrl:requestUrl params:nil success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if ([code isEqualToString:@"200"]) {
            
            NSString *coupontime = [NSString stringWithFormat:@"%@", dict[@"coupontime"]];
            if (IsNilOrNull(coupontime)) {
                coupontime = @"600";
            }
            [KUserdefaults setObject:coupontime forKey:@"YDSC_coupontime"];
            
            NSString *couponbgurl = [NSString stringWithFormat:@"%@", dict[@"couponbgurl"]];
            if (IsNilOrNull(couponbgurl)) {
                couponbgurl = @"";
            }
            [KUserdefaults setObject:couponbgurl forKey:@"YDSC_couponbgurl"];
            
            
            //是否显示消息中心
            NSString *appmallmsg = [dict objectForKey:@"appmallmsg"];
            if (!IsNilOrNull(appmallmsg)) {
                [KUserdefaults setObject:appmallmsg forKey:@"YDSC_msgShow"];
            }
            
            
            NSString *payalertmsg = [NSString stringWithFormat:@"%@", dict[@"payalertmsg"]];
            if (IsNilOrNull(payalertmsg)) {
                payalertmsg = @"";
            }
            [KUserdefaults setObject:payalertmsg forKey:@"payalertmsg"];
            
            NSString *appmallverinfo = [dict objectForKey:@"appmallverinfo"];
            if (!IsNilOrNull(appmallverinfo)) {
                [KUserdefaults setObject:appmallverinfo forKey:@"YDSC_updateInfo"];
            }
            
            //是否显示积分商城
            NSString *mallintegralshow = [dict objectForKey:@"mallintegralshow"];
            if (!IsNilOrNull(mallintegralshow)) {
                [KUserdefaults setObject:mallintegralshow forKey:MallintegralShowOrNot];
            }
            
            NSString *ckappdownloadmsg = [dict objectForKey:@"ckappdownloadmsg"];
            if (!IsNilOrNull(ckappdownloadmsg)) {
                [KUserdefaults setObject:ckappdownloadmsg forKey:@"BecomeCKMsg"];
            }
            
            NSString *mallshareurl = [NSString stringWithFormat:@"%@", dict[@"mallshareurl"]];
            if (!IsNilOrNull(mallshareurl)) {
                [KUserdefaults setObject:mallshareurl forKey:@"YDSC_mallshareurl"];
            }
            
            NSString *ckappiosver = [dict objectForKey:@"malliosversion"];
            if (!IsNilOrNull(ckappiosver)) {
                [KUserdefaults setObject:ckappiosver forKey:ServerVersion];
            }
            
            NSString *ckappiosforce = [dict objectForKey:@"malliosforce"];
            if (!IsNilOrNull(ckappiosforce)) {
                [KUserdefaults setObject:ckappiosforce forKey:Forceupdate];
            }
            
            NSString *downLoadUrl = [NSString stringWithFormat:@"%@",dict[@"malldownloadurl"]];
            if (IsNilOrNull(downLoadUrl)) {
                downLoadUrl = @"https://itunes.apple.com/cn/app/id1164737320";
            }
            [KUserdefaults setObject:downLoadUrl forKey:AppStoreUrl];
            
            
            
            NSString *ckappdownloadurl = [NSString stringWithFormat:@"%@",dict[@"ckappdownloadurl"]];
            if (IsNilOrNull(ckappdownloadurl)) {
                ckappdownloadurl = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.ckc.ckys.ckmanager";
            }
            [KUserdefaults setObject:ckappdownloadurl forKey:@"ckappdownloadurl"];
            [KUserdefaults synchronize];
            
            [self updatePayMethod:dict];
            
            [self updateDomain:dict];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)updatePayMethod:(NSDictionary*)dict {
    NSString *alipay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"alipay"]];
    if (!IsNilOrNull(alipay)) {
        [[DefaultValue shareInstance] paymentAvaliable:alipay forKey:@"alipay"];
    }
    NSString *wxpay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"wxpay"]];
    if (!IsNilOrNull(wxpay)) {
        [[DefaultValue shareInstance] paymentAvaliable:wxpay forKey:@"wxpay"];
    }
    NSString *unionpay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"unionpay"]];
    if (!IsNilOrNull(unionpay)) {
        [[DefaultValue shareInstance] paymentAvaliable:unionpay forKey:@"unionpay"];
    }
    NSString *applepay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"applepay"]];
    if (!IsNilOrNull(applepay)) {
        [[DefaultValue shareInstance] paymentAvaliable:applepay forKey:@"applepay"];
    }
    NSString *jdpay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"jdpay"]];
    if (!IsNilOrNull(jdpay)) {
        [[DefaultValue shareInstance] paymentAvaliable:jdpay forKey:@"jdpay"];
    }
}

#pragma mark - 更新域名
-(void)updateDomain:(NSDictionary*)dict {
    
    NSString *domainImgRegetUrl = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainImgRegetUrl"]];
    if (!IsNilOrNull(domainImgRegetUrl)) {
        if (![domainImgRegetUrl hasSuffix:@"/"]) {
            domainImgRegetUrl = [domainImgRegetUrl stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainImgRegetUrl forKey:@"domainImgRegetUrl"];
    }
    
    NSString *domainNameRes = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainNameRes"]];
    if (!IsNilOrNull(domainNameRes)) {
        if (![domainNameRes hasSuffix:@"/"]) {
            domainNameRes = [domainNameRes stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainNameRes forKey:@"domainNameRes"];
    }
    
    NSString *domainNamePay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainNamePay"]];
    if (!IsNilOrNull(domainNamePay)) {
        if (![domainNamePay hasSuffix:@"/"]) {
            domainNamePay = [domainNamePay stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainNamePay forKey:@"domainNamePay"];
    }
    
    NSString *domainSmsMessage = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainSmsMessage"]];
    if (!IsNilOrNull(domainSmsMessage)) {
        if (![domainSmsMessage hasSuffix:@"/"]) {
            domainSmsMessage = [domainSmsMessage stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainSmsMessage forKey:@"domainSmsMessage"];
    }
    
    NSString *domainNameUnionPay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainUnionPay"]];
    if (!IsNilOrNull(domainNameUnionPay)) {
        if (![domainNameUnionPay hasSuffix:@"/"]) {
            domainNameUnionPay = [domainNameUnionPay stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainNameUnionPay forKey:@"domainNameUnionPay"];
    }
}

#pragma mark -- cellDelegate
-(void)shopInfoClickWithTag:(NSInteger)tag {

    RLMResults *result = [self getFirstPageData];
    SCFirstPageModel *firstPageM = result.firstObject;
    if(tag == 0){
        
        NSString *cerPath = [NSString stringWithFormat:@"%@", firstPageM.ckInfoM.cerpath];

        int x = arc4random() % 100000;
        NSString *cerPathAddRandom = [NSString stringWithFormat:@"%@?%d", cerPath, x];
        
        [[XLImageViewer shareInstanse] showNetImages:@[cerPathAddRandom] index:0 from:self.view];

    }else if (tag == 1){
        self.invitationView = [[InvitationAlterVeiw alloc]init];
        self.invitationView.delegate = self;

        NSString *wxaccount = [NSString stringWithFormat:@"%@", firstPageM.ckInfoM.wxaccount];

        if (IsNilOrNull(wxaccount)) {
            wxaccount = @"";
            self.invitationView.titleLable.text = @"微信号为空";
        }else{
            self.invitationView.titleLable.text = wxaccount;
        }

        [self.invitationView show];

    }else if (tag == 2){
        
        NSString *phoneNO = [NSString stringWithFormat:@"%@", firstPageM.ckInfoM.mobile];

        NSString *number = [[NSString alloc]initWithFormat:@"telprompt://%@", phoneNO];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];

    }else if (tag == 3){
        SCGoodsSearchViewController *search = [[SCGoodsSearchViewController alloc] init];
        [self.navigationController pushViewController:search animated:YES];
    }
}

-(void)copyInvitationCode {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.invitationView.titleLable.text;
    if(pasteboard == nil){
        NSLog(@"复制失败");
    }else{
        NSLog(@"复制成功");
    }
}

@end
