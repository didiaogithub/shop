//
//  SCCategoryViewController.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/22.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCCategoryViewController.h"
#import "ZJScrollPageViewDelegate.h"
#import "ZJScrollPageView.h"
#import "SCCategoryChildVC.h"
#import "CKShareManager.h"
#import "SCFirstPageModel.h"
#import "SCCategoryGoodsModel.h"

@interface SCCategoryViewController ()<ZJScrollPageViewDelegate, ZJScrollPageViewChildVcDelegate>

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;
@property (nonatomic, strong) ZJSegmentStyle *style;

@end

@implementation SCCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"分类";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initComponents];

    [self createShareButton];
}

//-(void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    RLMResults *classArr = [SCCategoryGoodsModel allObjects];
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    if (classArr.count > 0) {
//        for (SCCategoryGoodsModel *classM in classArr) {
//            [realm beginWriteTransaction];
//            [realm deleteObject:classM];
//            [realm commitWriteTransaction];
//        }
//    }
//    
//    [self.scrollPageView.contentView reload];
//}

-(void)initComponents{
    /**设置title样式*/
    _style = [[ZJSegmentStyle alloc] init];
    _style.normalTitleColor = TitleColor;
    _style.selectedTitleColor = [UIColor tt_redMoneyColor];
    _style.scrollLineColor = [UIColor tt_redMoneyColor];
    _style.scrollLineHeight = 1.5;
    
    //显示滚动条
    _style.showLine = YES;
    _style.titleFont = MAIN_TITLE_FONT;
    _style.autoAdjustTitlesWidth = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;

    // 初始化
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 65-NaviAddHeight-BOTTOM_BAR_HEIGHT) segmentStyle:_style titles:self.titleArr parentViewController:self delegate:self];
    [_scrollPageView setBackgroundColor:[UIColor tt_grayBgColor]];

    [_scrollPageView setSelectedIndex:self.selectedIndex animated:YES];

    [self.view addSubview:_scrollPageView];
}

- (NSInteger)numberOfChildViewControllers {
    return self.titleArr.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    

    if (!childVc) {
        childVc = (UIViewController<ZJScrollPageViewChildVcDelegate> *)[[SCCategoryChildVC alloc] init];
    }
    
    SEL selector = NSSelectorFromString(@"passSortIdArray:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
    [childVc performSelector:selector withObject:self.categoryIdArr];
#pragma clang diagnostic pop
    
    SEL selector1 = NSSelectorFromString(@"passSelectIndex:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
    [childVc performSelector:selector1 withObject:[NSString stringWithFormat:@"%ld", self.selectedIndex]];
    
#pragma clang diagnostic pop
    
    return childVc;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
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
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(shareGoods) image:[UIImage imageNamed:@"share"]];
}

-(void)shareGoods{
    NSLog(@"列表分享");
    
    NSString *firstPageKey = @"1";
    NSString *predicate = [NSString stringWithFormat:@"firstPageKey = '%@'", firstPageKey];
    RLMResults *result = [[SCFirstPageModel class] objectsWhere:predicate];
    
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
    NSString *shareUrl = [NSString stringWithFormat:@"%@?type=list&openid=%@", shareApi, USER_OPENID];
    
    NSString *logoUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, ShareLogoUrl];
    [CKShareManager shareToFriendWithName:title andHeadImages:logoUrl andUrl:[NSURL URLWithString:shareUrl] andTitle:@"创客云商"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
