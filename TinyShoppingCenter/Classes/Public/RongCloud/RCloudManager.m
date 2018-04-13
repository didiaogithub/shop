//
//  RCloudManager.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/14.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "RCloudManager.h"
#import <RongIMKit/RongIMKit.h> //融云
#import "SCFirstPageModel.h"

@interface RCloudManager()<RCIMReceiveMessageDelegate,RCIMUserInfoDataSource>

//@property (nonatomic, copy) NSString *ckidStr;
//@property (nonatomic, copy) NSString *smallName;
//@property (nonatomic, copy) NSString *headImageUrl;

@end

@implementation RCloudManager

+(instancetype)manager {
    static RCloudManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RCloudManager alloc] initPrivate];
    });
    return instance;
}

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        [self loginRCloud];
    }
    return self;
}

-(void)logout {
    [[RCIM sharedRCIM] logout];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

/**登录融云*/
-(void)loginRCloud{
    
    //清理缓存
//    [[RCIM sharedRCIM] clearUserInfoCache];
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_Appkey];
    NSLog(@"%@", RONGCLOUD_IM_Appkey);
    //设置会话列表头像和会话界面头像
    if (iphone6Plus) {
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(56, 56);
    } else {
        
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(46, 46);
    }
    //    [RCIM sharedRCIM].portraitImageViewCornerRadius = 10;
    //开启用户信息和群组信息的持久化
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate=self;
    //开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus=YES;
    
    [RCIM sharedRCIM].enableMessageAttachUserInfo=YES;
    
    // 开启之后在输入消息的时候对方可以看到正在输入的提示(目前只支持单聊)
    [RCIM sharedRCIM].enableTypingStatus = YES;
    
    //设置显示未注册的消息
    //如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
    [RCIM sharedRCIM].showUnkownMessage = YES;
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;
    
    // //设置头像为圆形
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    
    [KUserdefaults setObject:@"NO" forKey:@"SC_ConnectRCloudStatus"];

}


-(void)connectRCloud {
    
    RLMResults *result =  [SCFirstPageModel objectsWhere:@"firstPageKey = '1'"];
    SCFirstPageModel *firstPageM = result.firstObject;
    NSString *meid = [NSString stringWithFormat:@"%@", firstPageM.meid];
    
    if (!IsNilOrNull(meid)) {
        NSString *tokenStr = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:@"SC_RCToken"]];
        if (!IsNilOrNull(tokenStr)) {
            [self connectRongVCWithToken:tokenStr];
        }else{
            [self getToken];
        }
    }
}

-(void)getToken {

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
    
    NSString *refreshUrl = [NSString stringWithFormat:@"%@%@", MsgApi, getRongYunToken];
    NSDictionary *pramaDic = @{@"id":meid, @"name": smallname,@"pic": head};
    [HttpTool postWithUrl:refreshUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]){
            return ;
        }
        NSString *tokenStr = [NSString stringWithFormat:@"%@",dict[@"token"]];
        [self connectRongVCWithToken:tokenStr];
        
        [KUserdefaults setObject:tokenStr forKey:@"SC_RCToken"];
        [KUserdefaults synchronize];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)connectRongVCWithToken:(NSString *)token{
    
    //链接融云服务器
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        
        if (!IsNilOrNull(userId)) {
            [KUserdefaults setObject:@"YES" forKey:@"SC_ConnectRCloudStatus"];
        }
        
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
        //设置当前登录的用户信息（不设置也有头像  获取token的时候已经把 头像传入）
        [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:userId name:smallname portrait:head];
        [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;

    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        [KUserdefaults removeObjectForKey:@"SC_RCToken"];
        [self getToken];
    }];
    
    
}
#pragma mark-用户信息处理
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    
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
    
    if([userId isEqualToString:meid]){
        RCUserInfo *userInfo = [[RCUserInfo alloc]init];
        userInfo.userId = meid;
        userInfo.name = smallname;
        userInfo.portraitUri = head;
        return completion(userInfo);
    }
}
/**
 * 本地用户信息改变，调用此方法更新kit层用户缓存信息
 * @param userInfo 要更新的用户实体
 * @paramuserId  要更新的用户 Id
 */
- (void)refreshUserInfoCache:(RCUserInfo *)userInfo
                  withUserId:(NSString *)userId{
    
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
    
    if([meid isEqualToString:userId]){
        RCUserInfo *userInfo = [[RCUserInfo alloc]init];
        userInfo.userId = meid;
        userInfo.name = smallname;
        userInfo.portraitUri = head;
    }
}

#pragma mark-接受消息代理方法
- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left{
    NSLog(@"message == %@  left == %d",message,left);
}
#pragma mark- 当App处于后台时，接收到消息并弹出本地通知的回调方法
-(BOOL)onRCIMCustomLocalNotification:(RCMessage*)message
                      withSenderName:(NSString *)senderName{
    NSLog(@"%@",@"后台收到消息");
    //    如果返回 NO，SDK 会默认弹出本地通知（必须实现用户信息提供者和群组信息提供者，否则将不会有本地通知提示弹出）；
    return NO;
}
#pragma mark- 当App处于前台时，接收到消息并播放提示音的回调方法 //在前台状态收到消息时收到消息会执行。
-(BOOL)onRCIMCustomAlertSound:(RCMessage*)message{
    NSLog(@"%@",@"前台收到消息");
    //    如果返回 NO，SDK 会默认播放提示音；如果返回 YES，将由 App 全权处理该消息，SDK 不会再做任何处理。
    return NO;
}

@end
