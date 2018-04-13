//
//  ZNPopUpView.m
//  LatrogenicShared
//
//  Created by 开发_赵楠 on 15/6/6.
//  Copyright (c) 2015年 iOSMax. All rights reserved.
//

#import "ZNPopUpView.h"
@interface ZNPopUpView ()

@property (nonatomic, strong) NSMutableDictionary *m_infoDict;

@end

@implementation ZNPopUpView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}



- (void)initView{
    
}

#pragma mark - Action
/** 展现 */
- (void)show{
    [self initView];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:true];
    UIViewController *topVC = [self appRootViewController];
    [topVC.view addSubview:self];
}

/** 关闭 */
- (void)close{
    [self removeFromSuperview];
}

- (UIViewController *)appRootViewController{
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }    
    return topVC;
}

- (void)removeFromSuperview{
    
    [self.m_bcView removeFromSuperview];
    self.m_bcView = nil;
    CGFloat H = CGRectGetHeight(self.frame);
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, H);
        
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.m_bcView) {
        self.m_bcView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.m_bcView.backgroundColor = [UIColor blackColor];
        self.m_bcView.alpha = 0.6f;
        self.m_bcView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
         [self.m_bcView addGestureRecognizer:tap];
    }
    
    [topVC.view addSubview:self.m_bcView];
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat H = CGRectGetHeight(self.frame);
        self.frame = CGRectMake(0, SCREEN_HEIGHT-H, SCREEN_WIDTH, H);
    }];
    
    [super willMoveToSuperview:newSuperview];
}

@end
