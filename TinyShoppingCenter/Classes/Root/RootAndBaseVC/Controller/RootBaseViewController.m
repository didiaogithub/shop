//
//  RootBaseViewController.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/15.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "RootBaseViewController.h"

@interface RootBaseViewController ()


@end

@implementation RootBaseViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self chekNetworking];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [CKCNotificationCenter addObserver:self selector:@selector(stopHud) name:@"hudstop" object:nil];
    
    [CKCNotificationCenter addObserver:self selector:@selector(networkStatusDidChange) name:RequestManagerReachabilityDidChangeNotification object:nil];
    
    [self createBaseUI];
    
}

-(void)stopHud{
    [self.loadingView stopAnimation];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.loadingView stopAnimation];
    [self.view sendSubviewToBack:_netTip];
}

-(void)createBaseUI{

    self.view.backgroundColor = [UIColor tt_grayBgColor];
    // loadView
    self.loadingView = [[LoadingAndMsgTipView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    //有无网络提示
    _netTip = [[UIView alloc] init];
    if (IPHONE_X) {
        _netTip.frame = CGRectMake(0, 88, SCREEN_WIDTH, 44);
    }else{
        _netTip.frame = CGRectMake(0, 64, SCREEN_WIDTH, 44);
    }
    _netTip.backgroundColor = [UIColor colorWithHexString:@"#fffbe0"];
    [self.view addSubview:_netTip];
    [self.view sendSubviewToBack:_netTip];
    
    UIImageView *warnImgV = [UIImageView new];
    [_netTip addSubview:warnImgV];
    warnImgV.image = [UIImage imageNamed:@"netWarn"];
    [warnImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_netTip.mas_centerY);
        make.left.mas_equalTo(10);
        make.width.height.mas_equalTo(13);
    }];
    
    UILabel *warnMsg = [UILabel new];
    warnMsg.text = NetWorkNotReachable;
    warnMsg.textColor = [UIColor colorWithHexString:@"#db291d"];
    warnMsg.font = [UIFont systemFontOfSize:13.0f];
    [_netTip addSubview:warnMsg];
    [warnMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(warnImgV.mas_centerY);
        make.left.equalTo(warnImgV.mas_right).offset(10);
    }];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.childViewControllers.count==1) {
        return NO;
    }
    return YES;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    UIViewController *vc = self.presentingViewController;
    NSString *class = NSStringFromClass([vc class]);
    
    // 模态之前先判断是否存在之情的视图
    if ([class isEqualToString:NSStringFromClass([viewControllerToPresent class])]) {
        
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self dismissViewControllerAnimated:YES completion:completion];
        
    } else {
        [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}


-(void)chekNetworking {
    
    RequestReachabilityStatus status = [RequestManager reachabilityStatus];
    switch (status) {
        case RequestReachabilityStatusReachableViaWiFi:
        case RequestReachabilityStatusReachableViaWWAN: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HasNetNotification" object:nil];
            [self.view sendSubviewToBack:_netTip];
        }
            break;
            
        default: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoNetNotification" object:nil];
            [self.view bringSubviewToFront:_netTip];

        }
            break;
    }
}


-(void)networkStatusDidChange {
    
    RootTabBarController *rootVc = (RootTabBarController *)APPKeyWindow.rootViewController;
    
    RequestReachabilityStatus status = [RequestManager reachabilityStatus];
    switch (status) {
        case RequestReachabilityStatusReachableViaWiFi:
        case RequestReachabilityStatusReachableViaWWAN: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HasNetNotification" object:nil];
            [self.view sendSubviewToBack:_netTip];//将一个UIView层推送到背后
            [self requestRootData:rootVc.selectedIndex];
        }
            break;
        default: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoNetNotification" object:nil];
            [self.view bringSubviewToFront:_netTip]; //将一个UIView显示在最前面
        }
            break;
    }
}

-(void)requestRootData:(NSInteger)selectedIndex {
    
    if (selectedIndex == 0) {
        //请求数据
        [CKCNotificationCenter postNotificationName:@"RequestHomePageData" object:nil];
    }else if (selectedIndex == 1) {
        //请求数据
    }else if (selectedIndex == 2) {
        //请求数据
    }else if (selectedIndex == 3) {
        //请求数据
        [CKCNotificationCenter postNotificationName:@"RequestShoppingCarData" object:nil];
    }else if (selectedIndex == 4) {
        //请求数据
        [CKCNotificationCenter postNotificationName:@"RequestMineData" object:nil];
    }
}

-(void)dealloc{
    [CKCNotificationCenter removeObserver:self name:@"hudstop" object:nil];
    
    [CKCNotificationCenter removeObserver:self name:RequestManagerReachabilityDidChangeNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
