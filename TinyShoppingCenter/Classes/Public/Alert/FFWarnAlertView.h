//
//  FFWarnAlertView.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2018/1/10.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FFWarnAlertViewDelegate <NSObject>

@optional
- (void)clickFFWarnAlertView;

@end

@interface FFWarnAlertView : UIView

@property (nonatomic, weak) id<FFWarnAlertViewDelegate>delegate;
@property (nonatomic, strong) UILabel *titleLable;

- (void)showFFWarnAlertView;

@end
