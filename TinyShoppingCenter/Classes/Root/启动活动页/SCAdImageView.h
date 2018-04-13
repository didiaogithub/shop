//
//  SCAdImageView.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/31.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADImageViewDelegate <NSObject>

-(void)removeAdViewFromWindow;

@end

@interface SCAdImageView : UIImageView

@property (nonatomic, weak) id<ADImageViewDelegate> delegate;

+(instancetype)shareInstance;

-(void)startShowingPage;

@end
