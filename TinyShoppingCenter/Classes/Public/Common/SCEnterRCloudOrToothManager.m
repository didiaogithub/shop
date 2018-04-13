//
//  SCEnterRCloudOrToothManager.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/12.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCEnterRCloudOrToothManager.h"
#import "SCFirstPageModel.h"

@implementation SCEnterRCloudOrToothManager

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        
    }
    return self;
}

+(instancetype)manager {
    static SCEnterRCloudOrToothManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[SCEnterRCloudOrToothManager alloc] initPrivate];
    });
    return instance;
}

-(void)enterRCloudOrTooth {
    RLMResults *result =  [SCFirstPageModel objectsWhere:@"firstPageKey = '1'"];
    SCFirstPageModel *firstPageM = result.firstObject;
    NSString *ckid = [NSString stringWithFormat:@"%@", firstPageM.ckInfoM.ckid];
    NSString *smallname = [NSString stringWithFormat:@"%@", firstPageM.ckInfoM.smallname];
    if (IsNilOrNull(smallname)) {
        smallname = @"";
    }
    NSString *head = [NSString stringWithFormat:@"%@", firstPageM.ckInfoM.logopath];
    if(IsNilOrNull(head)){
        head = [NSString stringWithFormat:@"%@%@",WebServiceAPI,DefaultHeadPath];
    }
    
    if (IsNilOrNull(ckid) || [ckid isEqualToString:@"0"]) {
        [[SobotManager shareInstance] startSobotCustomerService];
    }else{
        
        ChatMessageViewController *chatVC = [[ChatMessageViewController alloc] init];
        chatVC.conversationType = ConversationType_PRIVATE;
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID
        chatVC.targetId = ckid;
        chatVC.titleString = smallname;
        chatVC.headUrl = head;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:chatVC] animated:YES completion:^{
            
        }];
    }
}

@end
