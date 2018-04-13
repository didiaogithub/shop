//
//  SCBannerActiveGDVC.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/9/6.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCBannerActiveGDVC.h"
#import "SCConfirmOrderVC.h"
#import "SCGoodsDetailModel.h"

@interface SCBannerActiveGDVC ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *nowBuyButton;
@property (nonatomic, strong) SCGoodsDetailModel *goodsDM;
@property (nonatomic, strong) UIImageView *noData;

@end

@implementation SCBannerActiveGDVC

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
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
    
    _webView = [[UIWebView alloc] init];
    [self.view addSubview:_webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.link]];
    [_webView loadRequest:request];
    if ([self.showBuyBottom isEqualToString:@"YES"]) {
        if(IPHONE_X){
            _webView.frame = CGRectMake(0, -44, SCREEN_WIDTH, SCREEN_HEIGHT - 44-BOTTOM_BAR_HEIGHT+44);
        }else{
            _webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
        }
        //立即购买
        _nowBuyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_nowBuyButton];
        _nowBuyButton.backgroundColor = CKYS_Color(203, 24, 45);
        [_nowBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [_nowBuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nowBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
            make.height.mas_equalTo(44);
        }];
        [self requestGoodsDetailData];
    }else{
        if(IPHONE_X){
            _webView.frame = CGRectMake(0, -44, SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_BAR_HEIGHT+44);
        }else{
            _webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }
    }
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 30, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(clickActiveBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

-(void)clickActiveBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求详情页数据
-(void)requestGoodsDetailData {
    
    if (IsNilOrNull(self.goodsId)) {
        self.goodsId = @"";
    }
    
    NSDictionary *pramaDic= @{@"itemid": self.goodsId, @"openid": USER_OPENID};
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GoodsDetailUrl];
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        
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
        
        
        NSString *limit = [NSString stringWithFormat:@"%@", dic[@"islimit"]];
        NSString *libcnt = [NSString stringWithFormat:@"%@", dic[@"libcnt"]];
        
        
        
        if ([limit isEqualToString:@"0"]) {
            if ([libcnt integerValue] > 0) {//可以购买
                _nowBuyButton.backgroundColor = CKYS_Color(203, 24, 45);
                [_nowBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
                [_nowBuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_nowBuyButton addTarget:self action:@selector(buyGoodsNow) forControlEvents:UIControlEventTouchUpInside];
            }else{//已售罄
                _nowBuyButton.backgroundColor = [UIColor colorWithHexString:@"#999999"];
                [_nowBuyButton setTitle:@"已售罄" forState:UIControlStateNormal];
                [_nowBuyButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
            }
        }else if([limit isEqualToString:@"1"]){//待出售
            _nowBuyButton.backgroundColor = [UIColor colorWithHexString:@"#999999"];
            [_nowBuyButton setTitle:@"待出售" forState:UIControlStateNormal];
            [_nowBuyButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        }else if([limit isEqualToString:@"2"]){//已售罄
            _nowBuyButton.backgroundColor = [UIColor colorWithHexString:@"#999999"];
            [_nowBuyButton setTitle:@"已售罄" forState:UIControlStateNormal];
            [_nowBuyButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        }
    } failure:^(NSError *error) {
    }];
    
}


-(void)buyGoodsNow {
    
    SCConfirmOrderVC *confirmOrder = [[SCConfirmOrderVC alloc] init];
    NSDictionary *goodsDict = [self.goodsDM mj_keyValues];
    confirmOrder.goodsDict = goodsDict;
    confirmOrder.activeId = self.activeID;
    confirmOrder.limitnum = self.limitnum;
    [self.navigationController pushViewController:confirmOrder animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
