//
//  SobotManager.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SobotManager.h"
#import <SobotKit/SobotKit.h>
#import <UserNotifications/UserNotifications.h>
#import "SCFirstPageModel.h"

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface SobotManager()<UNUserNotificationCenterDelegate>

@end

@implementation SobotManager

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        
    }
    return self;
}

+(instancetype)shareInstance {
    static SobotManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[SobotManager alloc] initPrivate];
    });
    return instance;
}

-(void)registerSobot:(UIApplication *)application {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10")) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert |UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }else{
        [self registerPush:application];
    }
    // **** 设置推送是否是测试环境 ******
    [[ZCLibClient getZCLibClient] setIsDebugMode:YES];
    [self startSobotCustomerService];
}

-(void)registerPush:(UIApplication *)application{
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //IOS8
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
        
        [application registerUserNotificationSettings:notiSettings];
    }
}

#pragma mark - 启动智齿客服
-(void)startSobotCustomerService {
    [IQKeyboardManager sharedManager].enable = NO;
    // 启动
    ZCLibInitInfo *initInfo = [ZCLibInitInfo new];
    // 企业编号 必填
    initInfo.appKey = WisdomTooth_AppKey;
    // 用户id，用于标识用户，建议填
    NSString *mobile = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:@"YDSC_USER_MOBILE"]];
    
    if (!IsNilOrNull(mobile)) {
        initInfo.userId = [NSString stringWithFormat:@"商城APP%@", mobile];
    }
    //自定义用户参数
    [self customUserInformationWith:initInfo];
    
    ZCKitInfo *uiInfo=[ZCKitInfo new];
    // 自定义用户参数
    [self customerUI:uiInfo];
    
    [[ZCLibClient getZCLibClient] setLibInitInfo:initInfo];
    
    [ZCSobot startZCChatView:uiInfo with:[UIViewController currentVC] target:nil pageBlock:^(ZCUIChatController *object, ZCPageBlockType type) {
        // 点击返回
        if(type==ZCPageBlockGoBack){ // 点击返回
            NSLog(@"点击了返回按钮");
            [[UIViewController currentVC] dismissViewControllerAnimated:YES completion:^{
                
            }];
            [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
            [IQKeyboardManager sharedManager].enable = YES;
            
        }else if (type==ZCPageBlockLoadFinish){
            // 加载界面完成，可对UI进行修改，此处不设置键盘弹起的高度不对
            [IQKeyboardManager sharedManager].enable = NO;
            [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
        }
    } messageLinkClick:nil];
}
// 智齿SDK自定义UI示例
-(void)customerUI:(ZCKitInfo *)kitInfo{
    // 点击返回是否触发满意度评价
    kitInfo.isOpenEvaluation = YES;
    // 评价完人工是否关闭会话（人工满意度评价后释放会话）
    kitInfo.isCloseAfterEvaluation = YES;
    
    // 机器人优先模式，是否直接显示转人工按钮，默认YES
    kitInfo.isShowTansfer= YES;
}
// 自定义用户信息参数
-(void)customUserInformationWith:(ZCLibInitInfo*)initInfo{
    
    NSString *mobile = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:@"YDSC_USER_MOBILE"]];
    
    RLMResults *result =  [SCFirstPageModel objectsWhere:@"firstPageKey = '1'"];
    SCFirstPageModel *firstPageM = result.firstObject;
    NSString *meid = [NSString stringWithFormat:@"%@", firstPageM.meid];
    NSString *smallname = [NSString stringWithFormat:@"%@", firstPageM.smallname];
    if (IsNilOrNull(smallname)) {
        smallname = meid;
    }
    NSString *head = [NSString stringWithFormat:@"%@", firstPageM.headimg];
    if(IsNilOrNull(head)){
        head = [NSString stringWithFormat:@"%@%@",WebServiceAPI,DefaultHeadPath];
    }
    
    // 用户手机号码
    initInfo.phone = mobile;
    // 用户昵称
    if (!IsNilOrNull(smallname)) {
        initInfo.realName = [NSString stringWithFormat:@"商城用户%@", smallname];
    }
    // 用户头像链接地址
    initInfo.avatarUrl = head;
}

@end

