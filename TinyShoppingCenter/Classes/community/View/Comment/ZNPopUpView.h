//
//  ZNPopUpView.h
//  LatrogenicShared
//
//  Created by 开发_赵楠 on 15/6/6.
//  Copyright (c) 2015年 iOSMax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNPopUpView : UIView

@property (nonatomic, strong) NSArray *m_dataArray;


@property (nonatomic, copy) NSString *m_title;

@property (nonatomic, copy) NSString *m_message;

@property (nonatomic, strong) UIView *m_bcView;

- (void)show;

- (void)close;

- (UIViewController *)appRootViewController;

- (void)removeFromSuperview;

- (void)willMoveToSuperview:(UIView *)newSuperview;

@end
