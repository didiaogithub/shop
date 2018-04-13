//
//  SCDeleteView.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCDeleteView;
@protocol SCDeleteViewDelegate<NSObject>

-(void)deleteBtnView:(SCDeleteView*)deleteBtnView deleteBtnClick:(id)parameter;

@end


@interface SCDeleteView : UIView

@property (nonatomic, weak) id<SCDeleteViewDelegate> delegate;

@end

