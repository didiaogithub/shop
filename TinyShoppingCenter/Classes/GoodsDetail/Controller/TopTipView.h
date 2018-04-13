//
//  TopTipView.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/12/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopTipView;

@protocol TopTipViewDelegate<NSObject>

- (void)topTipView:(TopTipView*)topView closeTip:(UIButton*)btn;

@end

@interface TopTipView : UIView

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, weak) id<TopTipViewDelegate> delegate;

@end
