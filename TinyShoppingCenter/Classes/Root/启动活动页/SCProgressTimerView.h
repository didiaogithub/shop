//
//  SCProgressTimerView.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/31.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADTimerDelegate <NSObject>

-(void)adTimerStop;

@end

@interface SCProgressTimerView : UIView

@property (nonatomic, weak) id<ADTimerDelegate> delegate;

@property (nonatomic, assign) NSInteger count;

-(void)stop;

-(void)time;

@end
