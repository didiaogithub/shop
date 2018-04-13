//
//  RootBaseViewController.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/15.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingAndMsgTipView.h"

@interface RootBaseViewController : UIViewController

@property (nonatomic, strong) LoadingAndMsgTipView *loadingView;
@property (nonatomic, strong) UIView *netTip;

@end
