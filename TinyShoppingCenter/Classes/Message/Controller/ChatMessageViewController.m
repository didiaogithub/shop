//
//  ChatMessageViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/7/10.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "ChatMessageViewController.h"
#import "SCFirstPageModel.h"

@interface ChatMessageViewController ()<RCIMUserInfoDataSource, RCIMConnectionStatusDelegate>

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *backBgBtn;

@end

@implementation ChatMessageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    
    self.navigationItem.title = self.titleString;
    
    [self setupLeftNaviItem];
    
//    删除指定位置的方法： 删除掉定位模块
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
    //去除红包模块
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
    //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.portraitUri = self.headUrl;
    userInfo.userId = self.targetId;
    userInfo.name = self.titleString;
    
    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:self.targetId];
    
    self.displayUserNameInCell = NO;
    [[RCIMClient sharedRCIMClient] getRemoteHistoryMessages:ConversationType_PRIVATE targetId:self.targetId recordTime:0 count:20 success:^(NSArray *messages) {
        NSLog(@"获取历史消息成功:%@", messages);

    } error:^(RCErrorCode status) {
        NSLog(@"获取历史消息失败");
    }];
}

-(void)setupLeftNaviItem {
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RootNavigationBack"] style:UIBarButtonItemStylePlain target:self action:@selector(exitChatViewController)];
    left.tintColor = [UIColor blackColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.leftBarButtonItem = left;
    }else{
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -10;
        self.navigationItem.leftBarButtonItems = @[spaceItem, left];
    }
}



-(void)exitChatViewController {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark-用户信息处理
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    if([userId isEqualToString:self.targetId]){
        RCUserInfo *userInfo = [[RCUserInfo alloc]init];
        userInfo.userId = self.targetId;
        userInfo.name = self.titleString;
        userInfo.portraitUri = self.headUrl;
        return completion(userInfo);
    }
}

/*!
 发送消息完成的回调
 
 @param stauts          发送状态，0表示成功，非0表示失败
 @param messageCotent   消息内容
 */
- (void)didSendMessage:(NSInteger)stauts
               content:(RCMessageContent *)messageCotent{
    
//  [NSString stringContainsEmoji:textMessage.content]
    
    NSLog(@"发送消息完成的回调%zd",stauts);

    RCTextMessage *textMessage = (RCTextMessage *)messageCotent;
    NSString *postContent = @"";
    if ([messageCotent isKindOfClass:[RCTextMessage class]]){
        postContent = textMessage.content;
    }else if([messageCotent isKindOfClass:[RCImageMessage class]]){
       postContent = @"图片消息";
    }else if ([messageCotent isKindOfClass:[RCVoiceMessage class]]){
       postContent = @"语音消息";
    }
    
    RLMResults *result =  [SCFirstPageModel objectsWhere:@"firstPageKey = '1'"];
    SCFirstPageModel *firstPageM = result.firstObject;
    NSString *meid = [NSString stringWithFormat:@"%@", firstPageM.meid];
    NSString *ckid = [NSString stringWithFormat:@"%@", firstPageM.ckInfoM.ckid];
  
    
    NSString *postMesageUrl = [NSString stringWithFormat:@"%@%@", MsgApi, @"Msg/Wxmall/writeMsg"];
    NSDictionary *pramaDic = @{@"senderid":meid,@"rcvid":ckid ,@"content":postContent};
    [HttpTool postWithUrl:postMesageUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            NSLog(@"%@",dict[@"codeinfo"]);
            return;
        }
        
    } failure:^(NSError *error) {
        NSLog(@"保存消息失败");
    }];
    
}

/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    NSLog(@"融云链接的状态码%zd",status);

}

@end
