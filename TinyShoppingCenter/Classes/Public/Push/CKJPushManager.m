//
//  CKJPushManager.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/31.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKJPushManager.h"
#import "SCFirstPageModel.h"
#import "CKOfficialAlert.h"
#import "ChatMessageViewController.h"
#import "SCMessageListViewController.h"

static NSString *appKey = @"fd875bb1453feef5501be23a";
static NSString *channel = @"App Store";
static BOOL isProduction = YES;

@implementation CKJPushManager

+(instancetype)manager {
    static CKJPushManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CKJPushManager alloc] initPrivate];
    });
    return instance;
}

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        
    }
    return self;
}

-(void)registerJPushWithapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        // iOS10 极光注册
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
        
    }  else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)categories:nil];
    }
    //Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction];
    
    //打开极光推送日志
    [JPUSHService setDebugMode];
    //开启Crash日志收集
    [JPUSHService crashLogON];
    
    [CKCNotificationCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    // 后台获取消息 跳转不同界面
    //  如果 App 状态为未运行，此函数将被调用，如果launchOptions包含UIApplicationLaunchOptionsRemoteNotificationKey表示用户点击apn 通知导致app被启动运行；如果不含有对应键值则表示 App 不是因点击apn而被启动，可能为直接点击icon被启动或其他。
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        // 程序未启动 是通过点击 通知apn消息打开app  此方法 被didReceiveRemoteNotification 替代 都会走
    }else{
       
    }
    // 清空icon 设置JPush服务器中存储的badge值 value 取值范围：[0,99999]
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

-(void)networkDidReceiveMessage:(NSNotification *)notification{
    NSLog(@"收到消息%@", notification);
}

/**
 说明用户点击通知, 进入了程序(程序还在运行中, 程序并没有被关掉) 本地消息
 */
-(void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSDictionary *apsDict = [userInfo objectForKey:@"aps"];
    NSString *content = [apsDict objectForKey:@"alert"];//内容
    NSString *title = [userInfo objectForKey:@"title"];
    if (IsNilOrNull(title)) {
        title = @"";
    }
    
    UIViewController *currentVC = [UIViewController currentVC];
    
    if (![currentVC isKindOfClass:[ChatMessageViewController class]] && ![currentVC isKindOfClass:[SCMessageListViewController class]]) {
        
        [[CKOfficialAlert shareInstance] showAlert:title content:content];
    }
}
/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}
/**
 * 推送处理3
 */
#pragma mark 注册deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    NSLog(@"\n[JPush获取Token]---[%@]",deviceToken);
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    RLMResults *result = [SCFirstPageModel objectsWhere:@"firstPageKey = '1'"];
    SCFirstPageModel *firstPageM = result.firstObject;
    NSString *meid = [NSString stringWithFormat:@"%@", firstPageM.meid];
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
    
//    // 设置别名
//    [JPUSHService setTags:0 alias:@"ff520" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//        NSLog(@"\n[推广人登录成功后设置别名]---[%@]",iAlias);
//    }];
//    
//    //查看registId
//    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
//        NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
//    }];
    
}

#pragma mark - 收到推送消息 基于iOS 7 及以上的系统版本
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"didReceiveRemoteNotification");
    
    NSLog(@"app状态%zd",application.applicationState);
    
    // iOS 10 以下 Required
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // IOS 7 Support Required
    completionHandler(UIBackgroundFetchResultNewData);
    if (application.applicationState == UIApplicationStateActive){//在应用内时收到推送
        [self appForgrounMessage:userInfo];
        NSLog(@"app进入前台UIApplicationStateActive");
        
    }else if(application.applicationState == UIApplicationStateInactive){//从应用外 滑动推送信息
        NSLog(@"app由后台进入前台UIApplicationStateInactive");
        NSLog(@"Inactive收到消息");
        [self jpshApnsMessage:userInfo];
    }else if(application.applicationState == UIApplicationStateBackground){
        //处理点击图标
        NSLog(@"Background后台收到推送消息");
        [self appBecomActiveWith:userInfo];
    }
    
    
    [JPUSHService handleRemoteNotification:userInfo];
}

#pragma mark - iOS10 收到通知（本地和远端） UNUserNotificationCenterDelegate
// iOS 10 Support 添加处理APNs通知回调方法 这个方法 是App在应用内收到的推送
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"willPresentNotification:%@",userInfo);
        [JPUSHService handleRemoteNotification:userInfo];
        completionHandler(UNNotificationPresentationOptionBadge);
        [self appForgrounMessage:userInfo];
    } else {
        completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }
    
    
}
// iOS 10 Support 这个是应用外，活跃状态
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"withCompletionHandler消息内容:%@",userInfo);
        [self jpshApnsMessage:userInfo];
        [JPUSHService handleRemoteNotification:userInfo];
    }else{
        
        
    }
    completionHandler();  // 系统要求执行这个方法
}

-(void)appForgrounMessage:(NSDictionary *)userInfo{
    NSLog(@"应用内收到的极光推送%@",userInfo);
    //处理应用内收到消息
    [self appBecomActiveWith:userInfo];
    
}
#pragma mark-处理应用内极光收到推送消息
-(void)appBecomActiveWith:(NSDictionary *)userInfo{
    NSDictionary *apsDict = [userInfo objectForKey:@"aps"];
    NSString *content = [apsDict objectForKey:@"alert"];//内容
    NSString *title = [userInfo objectForKey:@"title"];
    if (IsNilOrNull(title)) {
        title = @"";
    }
    UIViewController *currentVC = [UIViewController currentVC];
    
    if (![currentVC isKindOfClass:[ChatMessageViewController class]] && ![currentVC isKindOfClass:[SCMessageListViewController class]]) {
        
        [[CKOfficialAlert shareInstance] showAlert:title content:content];
    }
//    AudioServicesPlaySystemSound(1007);
    
    
    
}

#pragma mark-处理应用外极光收到推送消息
- (void)jpshApnsMessage:(NSDictionary *)userInfo {
    
    NSDictionary *apsDict = [userInfo objectForKey:@"aps"];
    NSString *content = [apsDict objectForKey:@"alert"];//内容
    NSString *title = [userInfo objectForKey:@"title"];
    if (IsNilOrNull(title)) {
        title = @"";
    }
    UIViewController *currentVC = [UIViewController currentVC];
    if (![currentVC isKindOfClass:[ChatMessageViewController class]] && ![currentVC isKindOfClass:[SCMessageListViewController class]]) {
        
        [[CKOfficialAlert shareInstance] showAlert:title content:content];
    }
    
}


#pragma mark 实现注册APNs失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

/**
 *  发生错误
 *
 *  @param notification 通知
 */
- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo                       = [notification userInfo];
    NSString *error                              = [userInfo objectForKey:@"error"];
    NSLog(@"%@", error);
}

#pragma mark 用户是否关闭了推送
- (BOOL)isAllowedNotification {
    //iOS8 check if user allow notification
    CGFloat iOS = [[[UIDevice currentDevice]systemVersion] doubleValue];
    
    if(iOS>=8) {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    }
    return NO;
}

//进入后台清零是因为如果在前台收到了消息，进入后台再推送消息不从零开始增加
-(void)applicationDidEnterBackground:(UIApplication *)application {
    [JPUSHService resetBadge];
}

// 点击之后badge清零
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [JPUSHService resetBadge];
    [application setApplicationIconBadgeNumber:0];
    [[UNUserNotificationCenter alloc] removeAllPendingNotificationRequests];
}

@end

