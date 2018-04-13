//
//  BaseViewController.m
//  ShoppingCentre
//
//  Created by 庞宏侠 on 16/7/12.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController
- (AppDelegate *)appDelegate
{
    if (!_appDelegate) {
        _appDelegate = [AppDelegate shareAppDelegate];
    }
    return _appDelegate;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBaseUI];
    
}
-(void)createBaseUI{
    
    self.view.backgroundColor = [UIColor tt_grayBgColor];
  
    self.loadingView = [[CKC_CustomProgressView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 增加网络错误时提示
    self.viewNetError = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.viewNetError.indicatorView = nil;
    self.viewNetError.userInteractionEnabled = NO;
    self.viewNetError.position = JGProgressHUDPositionBottomCenter;
    self.viewNetError.marginInsets = UIEdgeInsetsMake(0, 0, 60, 0);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//添加提示view
- (void)showNoticeView:(NSString*)title
{
    if (self.viewNetError && !self.viewNetError.visible) {
        self.viewNetError.textLabel.text = title;
        [self.viewNetError showInView:[UIApplication sharedApplication].keyWindow];
        [self.viewNetError dismissAfterDelay:1.0f];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (self.navigationController.childViewControllers.count==1) {
        return NO;
    }
    return YES;
}

@end
