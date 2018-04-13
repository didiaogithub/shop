//
//  BaseViewController.h
//  ShoppingCentre
//
//  Created by 庞宏侠 on 16/7/12.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKC_CustomProgressView.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) CKC_CustomProgressView *loadingView;
@property (nonatomic, strong) JGProgressHUD *viewNetError;
@property (nonatomic, strong) AppDelegate * appDelegate;

//添加提示view
- (void)showNoticeView:(NSString*)title;

@end
