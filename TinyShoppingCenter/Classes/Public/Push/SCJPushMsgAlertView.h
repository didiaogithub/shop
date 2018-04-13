//
//  SCJPushMsgAlertView.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2018/1/31.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCJPushMsgAlertView : UIView

+(instancetype)shareInstance;

-(void)showJPushMsgAlert:(NSString*)content;

@end
