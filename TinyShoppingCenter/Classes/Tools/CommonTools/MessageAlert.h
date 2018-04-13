//
//  XWAlterVeiw.h
//  XWAleratView
//
//  Created by 庞宏侠. on 15/12/25.
//  Copyright © 2015年 庞宏侠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageAlert : UIView

/**
 *  提供单利初始化方法
 */
+ (instancetype)shareInstance;

/**
 * 展示
 */
- (void)showAlert:(NSString *)title;


@end
