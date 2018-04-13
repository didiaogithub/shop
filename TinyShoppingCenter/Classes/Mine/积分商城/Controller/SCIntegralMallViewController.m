//
//  SCIntegralMallViewController.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/13.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCIntegralMallViewController.h"
#import "SCIntegralGoodsDetailVC.h"
#import "UIViewController+BackButtonHandler.h"
#import "SCConfirmOrderVC.h"
#import "SCGoodsDetailModel.h"
#import "SCMyPrizeConfirmOrderViewController.h"
#import "SCMyPrizeModel.h"

@interface SCIntegralMallViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *mallWeb;
@property (nonatomic, strong) SCGoodsDetailModel *goodsDM;
@property (nonatomic, strong) SCMyPrizeModel *prizeModel;
@property (nonatomic, strong) UIImageView *noData;

@end

@implementation SCIntegralMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"积分商城";
    
    [self refreshUI];

    
}

-(void)refreshUI {
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
        _mallWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-65-NaviAddHeight-BOTTOM_BAR_HEIGHT)];
    }else{
        _mallWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, SCREEN_HEIGHT-1)];
    }
    
    _mallWeb.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mallWeb];
    NSString *uk = [KUserdefaults objectForKey:@"YDSC_uk"];
    NSString *urlStr = [NSString stringWithFormat:@"%@front/appmall/html/integralmall.html?ckys_openid=%@&uk=%@", WebServiceAPI, USER_OPENID, uk];

//    NSString *urlStr = [NSString stringWithFormat:@"%@front/appmall/html/integralmall.html?ckys_openid=%@", WebServiceAPI, USER_OPENID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    _mallWeb.delegate = self;
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [_mallWeb loadRequest:request];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    if (!webView.isLoading) {
        [self.loadingView stopAnimation];
    }
}

-(void)reloadWebView {
    NSString *uk = [KUserdefaults objectForKey:@"YDSC_uk"];
    NSString *urlStr = [NSString stringWithFormat:@"%@front/appmall/html/integralmall.html?ckys_openid=%@&uk=%@", WebServiceAPI, USER_OPENID, uk];

//    NSString *urlStr = [NSString stringWithFormat:@"%@front/appmall/html/integralmall.html?ckys_openid=%@", WebServiceAPI, USER_OPENID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [_mallWeb loadRequest:request];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *str = request.URL.absoluteString;
    NSString *paramStr = [str componentsSeparatedByString:@"://"].lastObject;
    NSString *paramStr1 = [paramStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *JSONData = [paramStr1 dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@", paramDic);
    if ([str containsString:@"buyNow://"]) {
        [self buyNow:paramDic];
    }else if ([str containsString:@"gotoDetail://"]) {
        [self gotoDetail:paramDic];
    }
    return YES;
}

-(void)buyNow:(NSDictionary*)paramer {
    
    NSLog(@"立即购买");
    NSString *itemid = [NSString stringWithFormat:@"%@", paramer[@"items"]];
    NSString *type = [NSString stringWithFormat:@"%@", paramer[@"type"]];
    if ([type isEqualToString:@"3"]) {
        [self requestMyPrizeData:itemid];
        
    }else if([type isEqualToString:@"4"]){
        //type:3奖品，4积分商品
        [self requestGoodsDetailData:itemid];
    }
}

-(void)gotoDetail:(NSDictionary*)paramer {
    NSLog(@"进入详情");
    SCIntegralGoodsDetailVC *gdvc = [[SCIntegralGoodsDetailVC alloc] init];
    gdvc.itemid = [NSString stringWithFormat:@"%@", paramer[@"itemid"]];
    [self.navigationController pushViewController:gdvc animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.loadingView stopAnimation];
}

-(BOOL)navigationShouldPopOnBackButton {
    
    if([_mallWeb canGoBack]){
        [_mallWeb goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    return NO;
}

#pragma mark - 请求详情页数据
-(void)requestGoodsDetailData:(NSString*)itemid {
    
    if (IsNilOrNull(itemid)) {
        itemid = @"";
    }
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    NSDictionary *pramaDic= @{@"itemid": itemid, @"openid": USER_OPENID};
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GoodsDetailUrl];
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] !=  200) {
            
            if ([dic[@"msg"] containsString:@"该商品不存在"]) {
                [self showNoticeView:dic[@"msg"]];
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self showNoticeView:dic[@"msg"]];
            return ;
        }
        self.goodsDM = [[SCGoodsDetailModel alloc] init];
        [self.goodsDM setValuesForKeysWithDictionary:dic];
        
        SCConfirmOrderVC *confirmOrder = [[SCConfirmOrderVC alloc] init];
        NSDictionary *goodsDict = [self.goodsDM mj_keyValues];
        confirmOrder.goodsDict = goodsDict;
        [self.navigationController pushViewController:confirmOrder animated:YES];
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
    }];
    
}

#pragma mark - 请求选中的奖品商品数据
-(void)requestMyPrizeData:(NSString*)itemid {
    
    if (IsNilOrNull(itemid)) {
        itemid = @"";
    }
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    NSDictionary *pramaDic= @{@"items": itemid, @"openid": USER_OPENID};
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetMyPrizeGoodsList];
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] ==  200) {
            
            NSArray *prizelist = dic[@"prizelist"];
            NSMutableArray *selectedArray = [NSMutableArray array];
            for (NSDictionary *prizeDict in prizelist) {
                self.prizeModel = [[SCMyPrizeModel alloc] init];
                [self.prizeModel setValuesForKeysWithDictionary:prizeDict];
                [selectedArray addObject:self.prizeModel];
            }
            
            SCMyPrizeConfirmOrderViewController *confirmOrder = [[SCMyPrizeConfirmOrderViewController alloc]init];
            confirmOrder.prizeModel = self.prizeModel;
            confirmOrder.allMoneyString = @"合计:¥0.00";
            confirmOrder.dataArray = selectedArray;
            confirmOrder.itemid = itemid;
            [self.navigationController pushViewController:confirmOrder animated:YES];
        }
        
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
