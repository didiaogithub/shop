//
//  AppDelegate.m
//  MoveShoppingMall
//
//  Created by 庞宏侠 on 17/2/7.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "AppDelegate.h"
#import "DefaultValue.h"
#import "SCLoginViewController.h"
#import "CKShareManager.h"
#import "RootNavigationController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UPPaymentControl.h"
#import "BKGuidePageAppearToll.h"
#import "BKGuidePageController.h"
#import "SCAdGoodsViewController.h"
#import "CommonLoginViewController.h"
#import "SCProgressTimerView.h"
#import <RongIMKit/RongIMKit.h>
#import "RCloudManager.h"
#import "SCEverydayGuideVC.h"//每天第一次启动显示的引导页
#import "JDPAuthSDK.h"
#import "CKVersionCheckManager.h"
#import "CKJPushManager.h"

@interface AppDelegate ()<WXApiDelegate, ADTimerDelegate>

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) UIViewController *tempRootVC;
@property (nonatomic, copy)   NSString *statusStr;
@property (nonatomic, strong) SCProgressTimerView *waitTimer;
@property (nonatomic, strong) JGProgressHUD *viewNetError;

@end

@implementation AppDelegate
// 测试修改发送到发
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([[CKVersionCheckManager shareInstance] isFirstLoadCurrentVersion]) {
        [[DefaultValue shareInstance] cleanLoginStatusCacheData];
    }
//    NSURL*url=[RLMRealmConfiguration defaultConfiguration].fileURL;
    
    [[DefaultValue shareInstance] defaultValue];
    //审核测试账号
    [KUserdefaults setObject:@"123" forKey:@"18392630543"];
    [KUserdefaults setObject:OpenidForLogin forKey:@"user18392630543"];
    
    
    NSString *tip = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"BecomeCKMsg"]];
    if (IsNilOrNull(tip)) {
        [KUserdefaults setObject:@"恭喜您已获得成为创客的资格，请点击【确定】下载创客APP并完善资料吧。" forKey:@"BecomeCKMsg"];
    }
    
    [RequestManager manager];
    
    [self initKeyWindow];
    
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    _statusStr = @"2017";
    
    [CKCNotificationCenter addObserver:self selector:@selector(checkAppDoesOnCheck) name:RequestManagerReachabilityDidChangeNotification object:nil];
    
    [CacheData shareInstance];
    
    [self configKeyboard];
    //分享
    [CKShareManager manager];
    //微信授权处理
    [WXApi registerApp:kWXAPP_ID];
    //融云初始化与连接
    [RCloudManager manager];
    [[RCloudManager manager] connectRCloud];
    
    [[JDPAuthSDK sharedJDPay] registServiceWithAppID:JDAPPID merchantID:JDMerchantID];
    
    //极光推送
    [[CKJPushManager manager] registerJPushWithapplication:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

-(void)initKeyWindow {
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    _tempRootVC = [[UIViewController alloc] init];
    _tempRootVC.view.backgroundColor = [UIColor whiteColor];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_tempRootVC.view addSubview:iv];
    
    //启动时请求相关数据，下面为临时页面
    if (SCREEN_HEIGHT < 568) {
        iv.image = [UIImage imageNamed:@"iphone4.png"];
    }else if(SCREEN_HEIGHT == 568){
        iv.image = [UIImage imageNamed:@"iphone5.png"];
    }else if(SCREEN_HEIGHT == 667){
        iv.image = [UIImage imageNamed:@"iphone6.png"];
    }else if(SCREEN_HEIGHT == 736){
        iv.image = [UIImage imageNamed:@"iphone7p.png"];
    }else if(SCREEN_HEIGHT == 812){
        iv.image = [UIImage imageNamed:@"iphoneX.png"];
    }
    
    self.window.rootViewController = _tempRootVC;
    [self.window makeKeyAndVisible];
    
    self.viewNetError = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.viewNetError.indicatorView = nil;
    self.viewNetError.userInteractionEnabled = NO;
    self.viewNetError.position = JGProgressHUDPositionBottomCenter;
    self.viewNetError.marginInsets = (UIEdgeInsets)
    {
        .top = 0.0f,
        .bottom = 60.0f,
        .left = 0.0f,
        .right = 0.0f,
    };
    
}

-(void)checkAppDoesOnCheck {
    
    UIViewController *vc = [UIViewController currentVC];
    if (![vc isEqual:_tempRootVC]) {
        return;
    }
    
    RequestReachabilityStatus status = [RequestManager reachabilityStatus];
    if ([_statusStr integerValue] == status) {
        return;
    }else{
        _statusStr = [NSString stringWithFormat:@"%ld", status];
    }
    
    switch (status) {
        case RequestReachabilityStatusReachableViaWiFi:
        case RequestReachabilityStatusReachableViaWWAN: {
            
            _isFirst = YES;
            //如果请求审核接口成功并且返回code200，那么之后不再请求，除非卸载应用
            NSString *iOSCheckCode = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"IOS_CheckCode"]];
            if (IsNilOrNull(iOSCheckCode)) {
                //非200下次启动继续请求
                [self appLaunchType];
            }else if ([iOSCheckCode isEqualToString:@"200"]){
                BOOL appear = [BKGuidePageAppearToll AppearGuidePage];
                if (appear == YES) {
                    BKGuidePageController *guideVc = [[BKGuidePageController alloc]init];
                    self.window.rootViewController = guideVc;
                    [self.window makeKeyAndVisible];
                }else{
                    [self normalLaunchApp];
                }
            }
        }
            break;
        default: {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前无网络，请连接网络后再试" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alertVC addAction:action];
            [alertVC addAction:actionCancel];
            UIViewController *vc = [[UIApplication sharedApplication].keyWindow rootViewController];
            [vc presentViewController:alertVC animated:YES completion:nil];
        }
            break;
    }
}

-(void)appLaunchType {
    
    NSString *appCheckUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, IsIosCheck_Url];
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *params = @{@"ver": currentVersion};
    
    [HttpTool getWithUrl:appCheckUrl params:params success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] == 200) {//审核通过：200
            [KUserdefaults setObject:@"200" forKey:@"IOS_CheckCode"];
            BOOL appear = [BKGuidePageAppearToll AppearGuidePage];
            if (appear == YES) {
                BKGuidePageController *guideVc = [[BKGuidePageController alloc]init];
                self.window.rootViewController = guideVc;
                [self.window makeKeyAndVisible];
            }else{
                [self normalLaunchApp];
            }
        }else{//审核中：非200
            BOOL appear = [BKGuidePageAppearToll AppearGuidePage];
            if (appear == YES) {
                BKGuidePageController *guideVc = [[BKGuidePageController alloc]init];
                self.window.rootViewController = guideVc;
                [self.window makeKeyAndVisible];
            }else{
                [self showCheckLoginView];
            }
        }
    } failure:^(NSError *error) {
        
        if (_isFirst == YES) {
            _isFirst = NO;
            [self appLaunchType];
        }else{
            
            NSString *loginWithCheckPhone = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"loginWithCheckPhone"]];
            if (IsNilOrNull(loginWithCheckPhone)) {
                
                if ([USER_OPENID isEqualToString:OpenidForLogin] || [USER_OPENID isEqualToString:OpenidForRegist]) {
                    [self showCheckLoginView];
                }else{
                    [KUserdefaults setObject:@"200" forKey:@"IOS_CheckCode"];
                    BOOL appear = [BKGuidePageAppearToll AppearGuidePage];
                    if (appear == YES) {
                        BKGuidePageController *guideVc = [[BKGuidePageController alloc]init];
                        self.window.rootViewController = guideVc;
                        [self.window makeKeyAndVisible];
                    }else{
                        [self normalLaunchApp];
                    }
                }
            }else{
                [self enterFirstPage];
            }
        }
    }];
}

-(void)adTimerStop {
    
    NSLog(@"销毁定时器:%@", [NSDate date]);
    [_waitTimer stop];
    
    NSString *path = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_AD_path"]];
    if (!IsNilOrNull(path)) {
        [self loadAD];
    }else{
        NSString *str = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:KloginStatus]];
        if (IsNilOrNull(str)) {
            [self goWelcom];
        }else{
            [self enterFirstPage];
        }
    }
}

-(void)normalLaunchApp {
    
    NSDate *firstLaunchDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *launchDateStr = [dateformatter stringFromDate:firstLaunchDate];
    NSString *cacheLaunchDataStr = [KUserdefaults objectForKey:@"FirstLaunchAppEveryday"];
    
    if (![launchDateStr isEqualToString:cacheLaunchDataStr]) {
        
        //不显示欢迎页，显示新的轮播页面可控的
        NSLog(@"第一次启动");
        //活动页@"typeCode":@"AD" 首页@"typeCode":@"AL" 引导页：GD
        NSDictionary *paramters = @{@"typeCode":@"GD"};
        NSString *adUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, AdUrl];
        [HttpTool getWithUrl:adUrl params:paramters success:^(id json) {
            
            NSDictionary *dict = json;
            if ([dict[@"code"] integerValue] == 200) {
                NSArray *arr = dict[@"list"];
                if (arr.count > 0) {
                    NSMutableArray *temp = [NSMutableArray array];
                    for (NSDictionary *dict in arr) {
                        NSString *path = [NSString stringWithFormat:@"%@", dict[@"path"]];
                        [temp addObject:path];
                    }
                    SCEverydayGuideVC *gd = [[SCEverydayGuideVC alloc] init];
                    gd.imageArray = temp;
                    self.window.rootViewController = gd;
                    [self.window makeKeyAndVisible];
                }else{
                    NSString *str = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:KloginStatus]];
                    if (IsNilOrNull(str)) {
                        [self goWelcom];
                    }else{
                        [self enterFirstPage];
                    }
                }
            }else{
                NSString *str = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:KloginStatus]];
                if (IsNilOrNull(str)) {
                    [self goWelcom];
                }else{
                    [self enterFirstPage];
                }
            }
        } failure:^(NSError *error) {
            NSString *str = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:KloginStatus]];
            if (IsNilOrNull(str)) {
                [self goWelcom];
            }else{
                [self enterFirstPage];
            }
        }];
    }else{
        NSLog(@"不是第一次启动");
        if (IsNilOrNull(USER_OPENID)) {//没有openid不请求启动页广告
            NSString *str = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:KloginStatus]];
            if (IsNilOrNull(str)) {
                [self goWelcom];
            }else{
                [self enterFirstPage];
            }
        }else{
            _waitTimer = [[SCProgressTimerView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 25, 40, 40)];
            _waitTimer.count = 0;
            _waitTimer.delegate = self;
            [_waitTimer time];
            NSLog(@"启动定时器:%@", [NSDate date]);
            //活动页@"typeCode":@"AD" 首页@"typeCode":@"AL"
            NSDictionary *paramters = @{@"openid":USER_OPENID, @"typeCode":@"AD"};
            NSString *adUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, AdUrl];
            [HttpTool getWithUrl:adUrl params:paramters success:^(id json) {
                
                NSDictionary *dict = json;
                if ([dict[@"code"] integerValue] == 200) {
                    NSArray *arr = dict[@"list"];
                    //处理启动页广告返回数据
                    [self processADData:arr];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@", error);
                [_waitTimer.delegate adTimerStop];
            }];
        }
    }
    
    [KUserdefaults setValue:launchDateStr forKey:@"FirstLaunchAppEveryday"];
    [KUserdefaults synchronize];
    
}

-(void)processADData:(NSArray*)arr {
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imgPath = [documentsDirectoryPath stringByAppendingString:@"/MyImage.jpg"];
    if (!IsNilOrNull(imgPath)) {
        [[NSFileManager defaultManager] removeItemAtPath:imgPath error:nil];
    }
    
    NSDictionary *goodsDic = arr.firstObject;
    
    NSString *activityid = [NSString stringWithFormat:@"%@", goodsDic[@"activityid"]];
    NSString *itemid = [NSString stringWithFormat:@"%@", goodsDic[@"itemid"]];
    NSString *link = [NSString stringWithFormat:@"%@", goodsDic[@"link"]];
    NSString *path = [NSString stringWithFormat:@"%@", goodsDic[@"path"]];
    NSString *adId = [NSString stringWithFormat:@"%@", goodsDic[@"id"]];
    NSString *limitnum = [NSString stringWithFormat:@"%@", goodsDic[@"limitnum"]];
    
    if (!IsNilOrNull(activityid)) {
        [KUserdefaults setObject:activityid forKey:@"YDSC_AD_activityid"];
    }else{
        [KUserdefaults setObject:@"0" forKey:@"YDSC_AD_activityid"];
    }
    if (!IsNilOrNull(itemid)) {
        [KUserdefaults setObject:itemid forKey:@"YDSC_AD_itemid"];
    }else{
        [KUserdefaults setObject:@"0" forKey:@"YDSC_AD_itemid"];
    }
    if (!IsNilOrNull(link)) {
        [KUserdefaults setObject:link forKey:@"YDSC_AD_link"];
    }else{
        [KUserdefaults setObject:@"" forKey:@"YDSC_AD_link"];
    }
    if (!IsNilOrNull(path)) {
        [KUserdefaults setObject:path forKey:@"YDSC_AD_path"];
    }
    if (!IsNilOrNull(adId)) {
        [KUserdefaults setObject:adId forKey:@"YDSC_AD_adId"];
    }else{
        [KUserdefaults setObject:@"0" forKey:@"YDSC_AD_adId"];
    }
    if (!IsNilOrNull(limitnum)) {
        [KUserdefaults setObject:limitnum forKey:@"YDSC_AD_limitnum"];
    }
    
    NSLog(@"启动页广告保存路径:%@", documentsDirectoryPath);
    [self saveImage:[self getImageFromURL:path] withFileName:@"MyImage" ofType:@"jpg" inDirectory:documentsDirectoryPath];
}

#pragma mark - 加载广告
-(void)loadAD {
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imgPath = [documentsDirectoryPath stringByAppendingString:@"/MyImage.jpg"];
    NSData *data = [NSData dataWithContentsOfFile:imgPath];
    UIImage *img = [UIImage imageWithData:data];
    if (img != nil) {//有图片显示广告页面
        SCAdGoodsViewController *adVc = [[SCAdGoodsViewController alloc] init];
        self.window.rootViewController = adVc;
        [self.window makeKeyAndVisible];
    }else{//没有则进入欢迎页面
        NSString *str = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:KloginStatus]];
        if (IsNilOrNull(str)) {
            [self goWelcom];
        }else{
            [self enterFirstPage];
        }
    }
}

-(void)showCheckLoginView {
    NSString *loginWithCheckPhone = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"loginWithCheckPhone"]];
    if (IsNilOrNull(loginWithCheckPhone)) {
        NSLog(@"去注册登录吧");
        CommonLoginViewController *login = [[CommonLoginViewController alloc] init];
        RootNavigationController *loginNavi = [[RootNavigationController alloc] initWithRootViewController:login];
        self.window.rootViewController = loginNavi;
        [self.window makeKeyAndVisible];
    }else{
        [self enterFirstPage];
    }
}

-(void)goWelcom{
    SCLoginViewController *welcome =[[SCLoginViewController alloc] init];
    RootNavigationController *welcomeNav = [[RootNavigationController alloc] initWithRootViewController:welcome];
    self.window.rootViewController = welcomeNav;
    [self.window makeKeyAndVisible];
}

-(void)enterFirstPage {
    RootTabBarController *rootVC = [[RootTabBarController alloc]init];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
}

/* -------------- 键盘管理 -------------*/
-(void)configKeyboard{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES; // 控制整个功能是否启用。
    manager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    manager.toolbarManageBehaviour = IQAutoToolbarByTag; // 最新版的设置键盘的returnKey的关键字 ,可以点击键盘上的next键，自动跳转到下一个输入框，最后一个输入框点击完成，自动收起键盘。
}

+ (AppDelegate* )shareAppDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    //ckys://com.ckc8.shopt/?unionid=oIEshwaT7-LPhiE2ZaH5A-l4HLNM&openid=o4bo3t5K64gYPL1lsfDGfc-YWmu4
    
    //    ckys://com.ckc8.shopt/?unionid=omC8_wQX-63V0Q3agmwaxB9SRSfU&openid=oX5Lut6UwPSrakY3aDE-JLSLAi0Q
    NSString *urlStr = url.absoluteString;
    if ([url.scheme isEqualToString:@"ckysmall://"]) {
        
        return YES;
    }
    if ([urlStr containsString:@"oauth"]) {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    if (self.paymentType == 1) { //微信支付
        return [WXApi handleOpenURL:url delegate:self];
    }else if(self.paymentType == 2){
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                [CKCNotificationCenter postNotificationName:Alipay_CallBack object:self userInfo:resultDic];
            }];
            
            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                
                // 解析 auth code
                NSString *result = resultDic[@"result"];
                NSString *authCode = nil;
                if (result.length>0) {
                    NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                    for (NSString *subResult in resultArr) {
                        if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                            authCode = [subResult substringFromIndex:10];
                            break;
                        }
                    }
                }
                NSLog(@"授权结果 authCode = %@", authCode?:@"");
            }];
        }else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                [CKCNotificationCenter postNotificationName:Alipay_CallBack object:self userInfo:resultDic];
            }];
        }
        
        return YES;
    }else if(self.paymentType == 3){
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            
            [CKCNotificationCenter postNotificationName:UnionPay_CallBack object:code userInfo:data];
            
            if([code isEqualToString:@"success"]){
                NSLog(@"银联支付成功");
                //                [[UIViewController currentVC].navigationController popToRootViewControllerAnimated:YES];
            }else if([code isEqualToString:@"fail"]) { //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成
                NSLog(@"银联支付失败");
            }else if([code isEqualToString:@"cancel"]) {
                NSLog(@"银联取消支付");
            }
        }];
        return YES;
    }
    
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSString *urlStr = url.absoluteString;
    if ([urlStr containsString:@"oauth"]) {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    if (self.paymentType == 1) { //微信支付
        return [WXApi handleOpenURL:url delegate:self];
    }else if(self.paymentType == 2){
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                [CKCNotificationCenter postNotificationName:Alipay_CallBack object:self userInfo:resultDic];
            }];
            
            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                
                // 解析 auth code
                NSString *result = resultDic[@"result"];
                NSString *authCode = nil;
                if (result.length>0) {
                    NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                    for (NSString *subResult in resultArr) {
                        if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                            authCode = [subResult substringFromIndex:10];
                            break;
                        }
                    }
                }
                NSLog(@"授权结果 authCode = %@", authCode?:@"");
            }];
        }else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                [CKCNotificationCenter postNotificationName:Alipay_CallBack object:self userInfo:resultDic];
            }];
        }
        
        return YES;
    }else if(self.paymentType == 3){
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            
            [CKCNotificationCenter postNotificationName:UnionPay_CallBack object:code userInfo:data];
            
            if([code isEqualToString:@"success"]){
                NSLog(@"银联支付成功");
            }else if([code isEqualToString:@"fail"]) { //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成
                NSLog(@"银联支付失败");
            }else if([code isEqualToString:@"cancel"]) {
                NSLog(@"银联取消支付");
            }
        }];
        return YES;
    }
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[CKJPushManager manager] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    //请求我的优惠券列表
    [[SCCouponTools shareInstance] resquestMyCouponsData];
    
    [[CKJPushManager manager] applicationWillEnterForeground:application];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [[CKJPushManager manager] application:application didRegisterUserNotificationSettings:notificationSettings];
}

//收到推送消息 基于iOS 7 及以上的系统版本
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[CKJPushManager manager] application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [[RCloudManager manager] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    [[CKJPushManager manager] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[CKJPushManager manager] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//授权后回调 WXApiDelegate
//如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
-(void)onResp:(BaseResp *)resp {
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    //微信授权回调处理
    if ([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode == 0) {
            [CKCNotificationCenter postNotificationName:@"cancel" object:@(aresp.errCode)];
            [self getWeiCodefinishedWhth:resp];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }
    //    WXSuccess           = 0,    /**< 成功    */
    //    WXErrCodeCommon     = -1,   /**< 普通错误类型    */
    //    WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    //    WXErrCodeSentFail   = -3,   /**< 发送失败    */
    //    WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
    //    WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
    
    //微信支付回调 处理
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        [CKCNotificationCenter postNotificationName:WeiXinPay_CallBack object:@(response.errCode)];
    }
}

- (void)showNoticeView:(NSString*)title{
    if (self.viewNetError && !self.viewNetError.visible) {
        self.viewNetError.textLabel.text = title;
        [self.viewNetError showInView:[UIApplication sharedApplication].keyWindow];
        [self.viewNetError dismissAfterDelay:1.5f];
    }
}

#pragma mark-通过第一步code获取Accesontoken
-(void)getWeiCodefinishedWhth:(BaseResp *)req
{
    if (req.errCode==0) {
        NSLog(@"用户同意");
        //到绑定手机号
        SendAuthResp *aresp=(SendAuthResp *)req;
        NSLog(@"state=====%@",aresp.state);
        [self getAccessTokenWithCode:aresp.code andStateStr:aresp.state];
    }else if (req.errCode==-4){
        NSLog(@"用户拒绝");
        //[LCProgressHUD showInfoMsg:@"登录失败"];
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    }else if (req.errCode==-2){
        NSLog(@"用户取消");
        //[LCProgressHUD showInfoMsg:@"登录失败"];
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

-(void)getAccessTokenWithCode:(NSString *)code andStateStr:(NSString *)stateStr {
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAPP_ID,kWXAPP_SECRET,code];
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"微信的返回%@",dict);
                if ([dict objectForKey:@"errcode"]){
                    //获取token错误
                }else{
                    NSLog(@"%@",dict);
                    NSLog(@"unionid===%@",dict[@"unionid"]);
                    NSLog(@"openid=====%@",dict[@"openid"]);
                    NSLog(@" RefreshToken===%@",dict[@"refresh_token"]);
                    
                    //openid
                    NSString *openid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"openid"]];
                    if (IsNilOrNull(openid)){
                        openid = @"";
                    }
                    [KUserdefaults setObject:openid forKey:KopenID];
                    
                    NSString *unionid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"unionid"]];
                    if (IsNilOrNull(unionid)){
                        unionid = @"";
                    }
                    [KUserdefaults setObject:unionid forKey:Kunionid];
                    
                    //刷新的token
                    NSString *refresh_token = [NSString stringWithFormat:@"%@",dict[@"refresh_token"]];
                    if (IsNilOrNull(refresh_token)){
                        refresh_token = @"";
                    }
                    
                    //请求的token
                    NSString *access_token = [NSString stringWithFormat:@"%@",dict[@"access_token"]];
                    if (IsNilOrNull(access_token)){
                        access_token = @"";
                    }
                    
                    //token过期时间
                    NSString *expires_in = [NSString stringWithFormat:@"%@",dict[@"expires_in"]];
                    if (IsNilOrNull(expires_in)){
                        expires_in = @"";
                    }
                    //存储AccessToken OpenId RefreshToken以便下次直接登陆
                    //AccessToken有效期两小时，RefreshToken有效期三十天
                    NSDate *oldDate = [NSDate date];    //获取AccessToken RefreshToken的一致时间
                    NSLog(@" oldDate =======%@ ",oldDate);
                    [KUserdefaults setObject:oldDate forKey:KolderData];
                    [KUserdefaults setObject:refresh_token forKey:kWeiXinRefreshToken];
                    
                    [KUserdefaults setObject:access_token forKey:KAccsess_token];
                    
                    [KUserdefaults setObject:expires_in forKey:KExpires_in];
                    
                    [KUserdefaults synchronize];
                    [self getUserInfoWithAccessToken:access_token andOpenId:openid andStateStr:stateStr];
                }
            }
        });
    });
}

#pragma mark 获取用户的信息
- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId andStateStr:(NSString *)stateStr
{
    NSLog(@"openId%@",openId);
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0 ), ^{
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([dict objectForKey:@"errcode"])
                {
                    NSString *refresh_token = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:kWeiXinRefreshToken]];
                    if (IsNilOrNull(refresh_token)){
                        refresh_token = @"";
                    }
                    //AccessToken失效
                    [self getAccessTokenWithRefreshToken:refresh_token];
                }else{
                    //获取需要的数据
                    NSLog(@"获取的用户信息%@",dict);
                    
                    [KUserdefaults setObject:dict[@"nickname"] forKey:KnickName];
                    
                    [KUserdefaults setObject:dict[@"headimgurl"] forKey:kheamImageurl];
                    [KUserdefaults synchronize];
                    //授权后跳转
                    NSString *authTypeWX = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_WxLogin_Click"]];
                    if ([authTypeWX isEqualToString:@"clickWechatBtn"]) {
                        [KUserdefaults setObject:@"" forKey:@"YDSC_WxLogin_Click"];
                        [KUserdefaults setObject:@"" forKey:@"YDSC_PhoneLogin_Click"];
                        
                        [CKCNotificationCenter postNotificationName:@"YDSC_WxLogin_Click" object:nil];
                    }
                    
                    NSString *authTypePhone = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_PhoneLogin_Click"]];
                    if([authTypePhone isEqualToString:@"clickPhoneBtn"]){
                        [KUserdefaults setObject:@"" forKey:@"YDSC_WxLogin_Click"];
                        [KUserdefaults setObject:@"" forKey:@"YDSC_PhoneLogin_Click"];
                        [CKCNotificationCenter postNotificationName:WeiXinAuthSuccess object:nil];
                    }
                }
            }
        });
    });
}


//重新获取AccessToken
- (void)getAccessTokenWithRefreshToken:(NSString *)refreshToken
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",kWXAPP_ID,refreshToken];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"errcode"])
                {
                    //授权过期
                }else
                {
                    //重新使用AccessToken获取信息
                    NSLog(@"重新使用AccessToken获取信息%@",dict);
                }
            }
        });
    });
}

-(void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件后缀不认识");
    }
    
    //如果不到3s那么图片下载完成就销毁，进入广告页面或者首页
    [_waitTimer.delegate adTimerStop];
    
}

#pragma mark - PRIVATE METHODS
-(UIImage *)getImageFromURL:(NSString *)fileURL {
    NSLog(@"开始下载图片");
    UIImage *result;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    NSLog(@"图片下载完成");
    return result;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RequestManagerReachabilityDidChangeNotification object:nil];
}

@end

