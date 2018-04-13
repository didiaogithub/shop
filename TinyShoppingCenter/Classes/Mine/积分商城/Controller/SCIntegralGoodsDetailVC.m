//
//  SCIntegralGoodsDetailVC.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/13.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCIntegralGoodsDetailVC.h"
#import "SCGoodsDetailBottomView.h"
#import "SCConfirmOrderVC.h"
#import "SCGoodsDetailModel.h"
#import "SCIntegralGDBottomView.h"

@interface SCIntegralGoodsDetailVC ()<UIWebViewDelegate, SCIntegralGDBottomViewDelegate>

@property (nonatomic, strong) UIWebView *mallWeb;
@property (nonatomic, strong) SCIntegralGDBottomView *detailBottomView;
@property (nonatomic, strong) SCGoodsDetailModel *goodsDM;

@end

@implementation SCIntegralGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商品详情";
    if (@available(iOS 11.0, *)) {
        _mallWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-65-NaviAddHeight-BOTTOM_BAR_HEIGHT-50)];
    }else{
        _mallWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, SCREEN_HEIGHT-1-50)];
    }
    _mallWeb.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mallWeb];
    NSString *uk = [KUserdefaults objectForKey:@"YDSC_uk"];
    NSString *urlStr = [NSString stringWithFormat:@"%@front/appmall/html/detail.html?ckys_openid=%@&itemid=%@&uk=%@", WebServiceAPI, USER_OPENID, self.itemid, uk];
//    NSString *urlStr = [NSString stringWithFormat:@"%@front/appmall/html/detail.html?ckys_openid=%@&itemid=%@", WebServiceAPI, USER_OPENID, self.itemid];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    _mallWeb.delegate = self;
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [_mallWeb loadRequest:request];
    
    [self requestGoodsDetailData];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    if (!webView.isLoading) {
        [self.loadingView stopAnimation];
    }
}

#pragma mark - 请求详情页数据
-(void)requestGoodsDetailData {
    
    if (IsNilOrNull(self.itemid)) {
        self.itemid = @"";
    }
    
    NSDictionary *pramaDic= @{@"itemid": self.itemid, @"openid": USER_OPENID};
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GoodsDetailUrl];
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            
            if ([dic[@"msg"] containsString:@"该商品不存在"]) {
                [self showNoticeView:dic[@"msg"]];
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self showNoticeView:dic[@"msg"]];
            return ;
        }
        self.goodsDM = [[SCGoodsDetailModel alloc] init];
        [self.goodsDM setValuesForKeysWithDictionary:dic];
        
        //创建底部 加入购物车  立即购买
        _detailBottomView = [[SCIntegralGDBottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50-BOTTOM_BAR_HEIGHT, SCREEN_WIDTH, 50)];
        _detailBottomView.delegate = self;
        [self.view addSubview:_detailBottomView];
        
        NSString *limit = [NSString stringWithFormat:@"%@", dic[@"islimit"]];
        NSString *libcnt = [NSString stringWithFormat:@"%@", dic[@"libcnt"]];
        
        if ([limit isEqualToString:@"0"]) {
            if ([libcnt integerValue] > 0) {
                [_detailBottomView showBottomType:@"Sell"];//可以购买
            }else{
                [_detailBottomView showBottomType:@"Sellout"];//已售罄
            }
        }else if([limit isEqualToString:@"1"]){
            [_detailBottomView showBottomType:@"WaitSell"];//待出售
        }else if([limit isEqualToString:@"2"]){
            [_detailBottomView showBottomType:@"Sellout"];//已售罄
        }
        
        
    } failure:^(NSError *error) {
    }];
    
}

#pragma mark - 消息1024 店铺1025 立即购买1026
-(void)jumpWithTag:(NSInteger)buttonTag {
    if (buttonTag == 1024) {
        
        [[SCEnterRCloudOrToothManager manager] enterRCloudOrTooth];
        
    }else if (buttonTag == 1025){
        NSLog(@"点击店铺");
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        SCConfirmOrderVC *confirmOrder = [[SCConfirmOrderVC alloc] init];
        NSDictionary *goodsDict = [self.goodsDM mj_keyValues];
        confirmOrder.goodsDict = goodsDict;
        [self.navigationController pushViewController:confirmOrder animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.loadingView stopAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
