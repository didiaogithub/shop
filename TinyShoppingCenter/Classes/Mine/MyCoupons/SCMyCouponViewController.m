//
//  SCMyCouponViewController.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/12/15.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCMyCouponViewController.h"
#import "FFAlertView.h"

@interface SCMyCouponViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *couponWeb;
@property (nonatomic, strong) UIImageView *noData;
@property (nonatomic, assign) NSInteger pageCount;

@end

@implementation SCMyCouponViewController

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.loadingView stopAnimation];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"我的奖励";
    self.navigationController.navigationBar.hidden = NO;
    //禁止滑动返回
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    //请求的未使用的优惠券用来更新缓存
    [[SCCouponTools shareInstance] resquestValidCouponsData];
    
    [self refreshUI];
    
    //里面不显示规则了
//    [self setUpRightItem];
}

#pragma mark - 使用说明
-(void)setUpRightItem {
    
    if (@available(iOS 11.0, *)) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"规则说明" style:UIBarButtonItemStylePlain target:self action:@selector(showCouponInstruction)];
        right.tintColor = [UIColor colorWithHexString:@"#333333"];
        self.navigationItem.rightBarButtonItem = right;
    }else{
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"规则说明 " style:UIBarButtonItemStylePlain target:self action:@selector(showCouponInstruction)];
        right.tintColor = [UIColor colorWithHexString:@"#333333"];
        self.navigationItem.rightBarButtonItem = right;
    }
}

-(void)showCouponInstruction {
    [[FFAlertView shareInstance] showAlert:@"规则说明" content:@"【优惠券获取方式】\n(1) 分享店铺商品链接，好友下单金额首次达到标准后获得优惠券；\n(2) 分享店铺商品链接，好友下单累计金额达到一定标准后获得优惠券；\n【优惠券使用规则】\n(1) 一笔订单只能使用一张优惠券；\n(2) 优惠券只能抵扣订单金额，优惠金额超出订单金额部分不能再次使用，不能兑换现金；\n(3) 并非所有商品均能使用优惠券，根据优惠券使用范围而定；\n(4) 超过有效期优惠券不能被使用；\n(5) 使用优惠券的订单发生退货，退货金额=退货商品价格—优惠券金额；\n(6) 使用优惠券订单退回后，则优惠券不能再次被使用；\n在法律范围内保留对优惠券使用细则的最终解释权。"];
}

-(void)refreshUI {
    self.pageCount = 0;
    RequestReachabilityStatus status = [RequestManager reachabilityStatus];
    switch (status) {
        case RequestReachabilityStatusReachableViaWiFi:
        case RequestReachabilityStatusReachableViaWWAN: {
            [self initViews];
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

-(void)initViews {
    if (@available(iOS 11.0, *)) {
        _couponWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-65-NaviAddHeight-BOTTOM_BAR_HEIGHT)];
    }else{
        _couponWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, SCREEN_HEIGHT-1)];
    }
    
    _couponWeb.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_couponWeb];
    NSString *uk = [KUserdefaults objectForKey:@"YDSC_uk"];
    NSString *urlStr = [NSString stringWithFormat:@"%@front/appmall/html/ticket.html?ckys_openid=%@&uk=%@", WebServiceAPI, USER_OPENID, uk];
//    NSString *urlStr = [NSString stringWithFormat:@"%@front/appmall/html/ticket.html?ckys_openid=%@", WebServiceAPI, USER_OPENID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    _couponWeb.delegate = self;
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [_couponWeb loadRequest:request];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    if (!webView.isLoading) {
        [self.loadingView stopAnimation];
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    self.pageCount ++;
    // 判断是否是二级页面
    if (self.pageCount == 2){
        self.navigationItem.title = @"奖励来源";
    }
    
    return YES;
}

-(BOOL)navigationShouldPopOnBackButton {
    
    if([_couponWeb canGoBack]){
        [_couponWeb goBack];
        self.pageCount = 0;
        self.navigationItem.title = @"我的奖励";
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
