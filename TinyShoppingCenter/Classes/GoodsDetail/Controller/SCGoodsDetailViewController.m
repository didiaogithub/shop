//
//  SCGoodsDetailViewController.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/22.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCGoodsDetailViewController.h"
#import "SCGoodsDetailModel.h"
#import "SDCycleScrollView.h"
#import "SCShoppingCarViewController.h"
#import "SCGDCommentViewController.h"
#import "SCGoodsDetailBottomView.h"
#import "SCConfirmOrderVC.h"
#import "CKShareManager.h"
#import "SCGoodsDetailCell.h"
#import "XLImageViewer.h"
#import "SCDownloadCKAPPWebVC.h"
#import "XWAlterVeiw.h"
#import "SCFirstPageModel.h"

@interface SCGoodsDetailViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, SCGoodsDetailBottomViewDelegate, SDCycleScrollViewDelegate, UIWebViewDelegate, SCCollectionGoodsDelegate, SCgoodsDetailImageBannerDelegate, XWAlterVeiwDelegate>

@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic, strong) SCGoodsDetailBottomView *detailBottomView;
@property (nonatomic, strong) SCGoodsDetailModel *goodsDM;
@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) UIButton *shoppingCarBtn;
@property (nonatomic, copy)   NSString *libcnt;
@property (nonatomic, copy)   NSString *limit;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImageView *noData;
@property (nonatomic, strong) UIWebView *detailWebView;
@property (nonatomic, strong) UILabel *headLab;

@end

@implementation SCGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self refreshUI];
}

-(void)refreshUI {
    RequestReachabilityStatus status = [RequestManager reachabilityStatus];
    switch (status) {
        case RequestReachabilityStatusReachableViaWiFi:
        case RequestReachabilityStatusReachableViaWWAN: {
            [self createTableView];
            
            [self rightShareItem];
            
            [self requestGoodsDetailData];
        }
            break;
        default: {
            if (_noData == nil) {
                _noData = [[UIImageView alloc] initWithFrame:self.view.bounds];
                [self.view addSubview:_noData];
                _noData.userInteractionEnabled = YES;
                _noData.image = [UIImage imageNamed:@"NoNetHold"];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshUI)];
                [_noData addGestureRecognizer:tap];
            }
        }
            break;
    }
}

#pragma mark-创建控件
-(void)createTableView{
    
    if (@available(iOS 11.0, *)) {
        _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50-NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStyleGrouped];
    }else{
        _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) style:UITableViewStyleGrouped];
    }
    _detailTableView.delegate = self;
    _detailTableView.dataSource = self;
    _detailTableView.showsVerticalScrollIndicator = NO;
    _detailTableView.estimatedSectionHeaderHeight = 0;
    _detailTableView.estimatedSectionFooterHeight = 0;
    _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_detailTableView];
    
    self.shoppingCarBtn = [[UIButton alloc] init];
    self.shoppingCarBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 64 + 20+NaviAddHeight, 40, 40);
    [self.shoppingCarBtn setImage:[UIImage imageNamed:@"gdShoppingCar"] forState:UIControlStateNormal];
    [self.shoppingCarBtn addTarget:self action:@selector(pushToShoppingCar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shoppingCarBtn];
}

#pragma mark - 请求详情页数据
-(void)requestGoodsDetailData {
    
    if (IsNilOrNull(self.goodsId)) {
        self.goodsId = @"";
    }
    
    NSDictionary *pramaDic= @{@"itemid": self.goodsId, @"openid": USER_OPENID};
    //请求数据
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GoodsDetailUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
        
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] !=  200) {
            [self.loadingView stopAnimation];
            if ([dic[@"msg"] containsString:@"该商品不存在"]) {
                [self showNoticeView:dic[@"msg"]];
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self showNoticeView:dic[@"msg"]];
            return ;
        }
        
        if (_detailBottomView == nil) {
            //创建底部 加入购物车  立即购买
            _detailBottomView = [[SCGoodsDetailBottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50-BOTTOM_BAR_HEIGHT, SCREEN_WIDTH, 50)];
            _detailBottomView.delegate = self;
            [self.view addSubview:_detailBottomView];
        }
        
        [self bindData:dic];
        [self.loadingView stopAnimation];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
    }];
}

-(void)bindData:(NSDictionary*)dic {
    
    _dataArray = [NSMutableArray array];
    
    SCGDCommentModel *commentM = [[SCGDCommentModel alloc] init];
    NSDictionary *commentDic = dic[@"ordercomment"];
    if (commentDic != nil) {
        [commentM setValuesForKeysWithDictionary:commentDic];
    }
    self.goodsDM = [[SCGoodsDetailModel alloc] init];
    [self.goodsDM setValuesForKeysWithDictionary:dic];
    self.goodsDM.commentM = commentM;
    
    _limit = [NSString stringWithFormat:@"%@", dic[@"islimit"]];
    _libcnt = [NSString stringWithFormat:@"%@", dic[@"libcnt"]];
    
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
    self.pictureArray = [NSMutableArray array];
    
    
    NSString *path = [NSString stringWithFormat:@"%@", dic[@"path"]];
    if (!IsNilOrNull(path)) {
        [self.pictureArray addObject:path];
    }
    NSString *path1 = [NSString stringWithFormat:@"%@", dic[@"path1"]];
    if (!IsNilOrNull(path1)) {
        [self.pictureArray addObject:path1];
    }NSString *path2 = [NSString stringWithFormat:@"%@", dic[@"path2"]];
    if (!IsNilOrNull(path2)) {
        [self.pictureArray addObject:path2];
    }

    CellModel *imageCellM = [self createCellModel:[SCgoodsDetailImageCell class] userInfo:self.pictureArray height:SCREEN_WIDTH];
    imageCellM.delegate = self;
    SectionModel *section0 = [self createSectionModel:@[imageCellM] headerHeight:0.1 footerHeight:0.1];
    [self.dataArray addObject:section0];
    
    CellModel *goodsInfoM = [self createCellModel:[SCGoodsDetailInfoCell class] userInfo:self.goodsDM height:[SCGoodsDetailInfoCell computeHeight:self.goodsDM]];
    goodsInfoM.delegate = self;
    SectionModel *section1 = [self createSectionModel:@[goodsInfoM] headerHeight:0.1 footerHeight:10];
    [self.dataArray addObject:section1];
    
    CellModel *commentCellM = [self createCellModel:[SCGoodsDetailCommentCell class] userInfo:self.goodsDM height:150];
    SectionModel *section2 = [self createSectionModel:@[commentCellM] headerHeight:0.1 footerHeight:10];
    [self.dataArray addObject:section2];
    
    CellModel *tipCellM = [self createCellModel:[SCGoodsDetailTipCell class] userInfo:nil height:30];
    SectionModel *section3 = [self createSectionModel:@[tipCellM] headerHeight:0.1 footerHeight:0.1];
    [self.dataArray addObject:section3];
    
    [self.detailTableView reloadData];

    if (_detailWebView == nil) {
        _detailWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.view.frame.size.height -50)];
        _detailWebView.delegate = self;
        _detailWebView.scrollView.delegate = self;
        _detailWebView.scalesPageToFit = YES;
        [self.view addSubview:self.detailWebView];
    }
    
    NSString *htmlnameios = [NSString stringWithFormat:@"%@", self.goodsDM.htmlnameios];
    NSString *uk = [KUserdefaults objectForKey:@"YDSC_uk"];
    if (IsNilOrNull(htmlnameios)) {
        htmlnameios = [NSString stringWithFormat:@"%@front/appmall/html/detail-ios.html?itemid=%@&ckys_openid=%@&uk=%@", WebServiceAPI, self.goodsId, USER_OPENID, uk];
//        htmlnameios = [NSString stringWithFormat:@"%@front/appmall/html/detail-ios.html?itemid=%@&ckys_openid=%@", WebServiceAPI, self.goodsId, USER_OPENID];
    }else{
        htmlnameios = [NSString stringWithFormat:@"%@front/appmall/html/%@?itemid=%@&ckys_openid=%@&uk=%@", WebServiceAPI, htmlnameios, self.goodsId, USER_OPENID, uk];
//        htmlnameios = [NSString stringWithFormat:@"%@front/appmall/html/%@?itemid=%@&ckys_openid=%@", WebServiceAPI, htmlnameios, self.goodsId, USER_OPENID];
    }
    
    NSURL *url = [NSURL URLWithString:htmlnameios];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_detailWebView loadRequest:request];
    [self.view addSubview:_detailWebView];
    
    _headLab = [[UILabel alloc] init];
    _headLab.text = @"上拉，返回详情";
    _headLab.textAlignment = NSTextAlignmentCenter;
    _headLab.font = [UIFont systemFontOfSize:15.0];
    _headLab.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40.f);
    _headLab.alpha = 0.f;
    _headLab.textColor = [UIColor blackColor];
    [_detailWebView addSubview:_headLab];
}

#pragma mark - 分享
-(void)rightShareItem {

//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(shareGoods) image:[UIImage imageNamed:@"share"]];
    
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

-(void)shareGoods{
    NSString *title = [NSString stringWithFormat:@"%@", self.goodsDM.name];
    NSString *shareApi = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_mallshareurl"]];
    if (IsNilOrNull(shareApi)) {
        shareApi = [NSString stringWithFormat:@"%@Wapmall/WeChat/share", WebServiceAPI];
    }

//    NSString *firstPageKey = @"1";
//    NSString *predicate = [NSString stringWithFormat:@"firstPageKey = '%@'", firstPageKey];
//    RLMResults *result = [[SCFirstPageModel class] objectsWhere:predicate];
//    SCFirstPageModel *firstPageM = result.firstObject;
//    NSString *ckid = [NSString stringWithFormat:@"%@", firstPageM.ckInfoM.ckid];
//    if (IsNilOrNull(ckid)) {
//        ckid = @"0";
//    }
    NSString *shareUrl = [NSString stringWithFormat:@"%@?type=detail&openid=%@&itemid=%@", shareApi, USER_OPENID, self.goodsId];
    [CKShareManager shareToFriendWithName:@"点击查看详情" andHeadImages:self.goodsDM.path andUrl:[NSURL URLWithString:shareUrl] andTitle:title];
}

-(void)pushToShoppingCar {
    SCShoppingCarViewController *shoppingCar = [[SCShoppingCarViewController alloc] init];
    shoppingCar.enterType = @"Detail";
    [self.navigationController pushViewController:shoppingCar animated:YES];
}

#pragma mark - tableViewDelegate
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
    
    SCGoodsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:item.reuseIdentifier];
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
    if (indexPath.section == 2) {
        NSString *commentCount = [NSString stringWithFormat:@"%@", self.goodsDM.commentnum];
        if ([commentCount integerValue] == 0) {
            [self showNoticeView:@"该商品暂无评价"];
        }else{
            SCGDCommentViewController *comment = [[SCGDCommentViewController alloc] init];
            comment.goodsId = self.goodsId;
            comment.limit = self.limit;
            comment.libcnt = self.libcnt;
            comment.goodsDM = self.goodsDM;
            [self.navigationController pushViewController:comment animated:YES];
        }
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetY = scrollView.contentOffset.y;
    if([scrollView isKindOfClass:[UITableView class]]) { // tableView界面上的滚动
        if (offsetY > (_detailTableView.contentSize.height - _detailTableView.frame.size.height+10)) {
            _headLab.alpha = 0.0f;
            [self goToDetailAnimation]; // 进入图文详情的动画
        }
    }else {// webView页面上的滚动
        if(offsetY < 0 && -offsetY > 40) {
            [self backToFirstPageAnimation]; // 返回基本详情界面的动画
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if([scrollView isKindOfClass:[UITableView class]]) {
    }else {// webView页面上的滚动
        if (offsetY < -20 && offsetY > -40) {
            _headLab.textColor = [UIColor blackColor];
            _headLab.alpha = 1.0f;
            _headLab.text = @"上拉，返回详情";
        }else if(offsetY < -40){
            _headLab.textColor = [UIColor blackColor];
            _headLab.alpha = 1.0f;
            _headLab.text = @"松开，返回详情";
            NSLog(@"%f", offsetY);
        }else{
            _headLab.alpha = 0.0f;
        }
    }
}

// 进入详情的动画
-(void)goToDetailAnimation {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        _detailWebView.frame = CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, self.view.frame.size.height-64-50-NaviAddHeight-BOTTOM_BAR_HEIGHT);
        _detailTableView.frame = CGRectMake(0, -self.view.frame.size.height , SCREEN_WIDTH, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

// 返回第一个界面的动画
-(void)backToFirstPageAnimation {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        if (@available(iOS 11.0, *)) {
            _detailTableView.frame = CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50-NaviAddHeight-BOTTOM_BAR_HEIGHT);
        }else{
            _detailTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50);
        }
        _detailWebView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.view.frame.size.height - 50);
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 消息40 店铺41 加入购物车42 立即购买43
-(void)pushToOtherVCWithButtonTag:(NSInteger)buttonTag{
    if (buttonTag == 40) {
        
        [[SCEnterRCloudOrToothManager manager] enterRCloudOrTooth];
        
    }else if (buttonTag == 41){
        NSLog(@"点击店铺");
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else if (buttonTag == 42){
        
        NSString *isdlbitem = [NSString stringWithFormat:@"%@", self.goodsDM.isdlbitem];
        if ([isdlbitem isEqualToString:@"true"] || [isdlbitem isEqualToString:@"1"]) {
            
            NSString *isdlbsale = [NSString stringWithFormat:@"%@", self.goodsDM.isdlbsale];
            //如果大礼包商品可以购买，那么可以添加到购物车
            if ([isdlbsale isEqualToString:@"true"] || [isdlbsale isEqualToString:@"1"]) {
                
                [self addToShoppingCar];
            }else{
                //跳转到下载下载创客app页面
                XWAlterVeiw *alert = [[XWAlterVeiw alloc] init];
                alert.delegate = self;
                alert.titleLable.text = @"您购买的商品暂不能在商城下单，请点击【确定】下载创客APP进行购买";
                [alert show];
            }
            
        }else{
            [self addToShoppingCar];
        }
    }else{
        
        NSString *isdlbitem = [NSString stringWithFormat:@"%@", self.goodsDM.isdlbitem];
        if ([isdlbitem isEqualToString:@"true"] || [isdlbitem isEqualToString:@"1"]) {
            NSString *isdlbsale = [NSString stringWithFormat:@"%@", self.goodsDM.isdlbsale];
            //如果大礼包商品可以购买，那么可以提交订单
            if ([isdlbsale isEqualToString:@"true"] || [isdlbsale isEqualToString:@"1"]) {
                
                SCConfirmOrderVC *confirmOrder = [[SCConfirmOrderVC alloc] init];
                NSDictionary *goodsDict = [self.goodsDM mj_keyValues];
                confirmOrder.goodsDict = goodsDict;
                confirmOrder.isdlbitem = isdlbitem;
                [self.navigationController pushViewController:confirmOrder animated:YES];
            }else{
                //跳转到下载下载创客app页面
                XWAlterVeiw *alert = [[XWAlterVeiw alloc] init];
                alert.delegate = self;
                alert.titleLable.text = @"您购买的商品暂不能在商城下单，请点击【确定】下载创客APP进行购买";
                [alert show];
            }
        }else{
            SCConfirmOrderVC *confirmOrder = [[SCConfirmOrderVC alloc] init];
            NSDictionary *goodsDict = [self.goodsDM mj_keyValues];
            confirmOrder.goodsDict = goodsDict;
            [self.navigationController pushViewController:confirmOrder animated:YES];
        }
    }
}

-(void)addToShoppingCar {
    NSLog(@"加入购物车");
    NSDictionary *pramaDic = @{@"itemids": self.goodsId, @"openid": USER_OPENID};
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

-(void)subuttonClicked {
    SCDownloadCKAPPWebVC *downVC = [[SCDownloadCKAPPWebVC alloc] init];
    [self.navigationController pushViewController:downVC animated:YES];
}

#pragma mark - 显示大的轮播图片
-(void)showBigGoodsImage:(NSInteger)index {
    
    [[XLImageViewer shareInstanse] showNetImages:self.pictureArray index:index from:self.view];
}

#pragma mark - 收藏
-(void)goodsDetailCollection:(UIButton *)button {
    NSLog(@"点击收藏");
    if(!button.selected){ //收藏
        NSDictionary *pramaDic = @{@"itemid": self.goodsDM.itemid, @"openid": USER_OPENID};
        NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, AddCollectionUrl];
        [HttpTool postWithUrl:loveItemUrl params:pramaDic success:^(id json) {
            NSDictionary *dic = json;
            NSString * status = [dic valueForKey:@"code"];
            if ([status intValue] != 200) {
                [self showNoticeView:[dic valueForKey:@"msg"]];
                return ;
            }
            [button setImage:[UIImage imageNamed:@"collectedred"] forState:UIControlStateNormal];
            button.selected = YES;
            [self showNoticeView:@"收藏成功"];
            NSLog(@"收藏成功");
            //取消收藏成功刷新数据
        } failure:^(NSError *error) {
            if (error.code == -1009) {
                [self showNoticeView:NetWorkNotReachable];
            }else{
                [self showNoticeView:NetWorkTimeout];
            }
        }];
        
    }else{
        NSDictionary *pramaDic = @{@"itemids": self.goodsDM.itemid, @"openid": USER_OPENID};
        
        NSString *deloveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, CancelCollectionUrl];
        [HttpTool postWithUrl:deloveItemUrl params:pramaDic success:^(id json) {
            NSDictionary *dic = json;
            NSString * status = [dic valueForKey:@"code"];
            if ([status intValue] != 200) {
                [self showNoticeView:[dic valueForKey:@"msg"]];
                return ;
            }
            [button setImage:[UIImage imageNamed:@"collectedgray"] forState:UIControlStateNormal];
            NSLog(@"取消收藏成功");
            [self showNoticeView:@"已取消收藏"];
            button.selected = NO;
            
        } failure:^(NSError *error) {
            if (error.code == -1009) {
                [self showNoticeView:NetWorkNotReachable];
            }else{
                [self showNoticeView:NetWorkTimeout];
            }
        }];
    }
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

@end
