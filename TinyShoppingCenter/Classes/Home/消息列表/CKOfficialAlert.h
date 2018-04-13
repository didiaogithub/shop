//
//  CKOfficialAlert.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/31.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface CKOfficialAlert : UIView

/**
 *  提供单利初始化方法
 */
+ (instancetype)shareInstance;

/**
 * 展示
 */
- (void)showAlert:(NSString *)title content:(NSString*)content;


@end
