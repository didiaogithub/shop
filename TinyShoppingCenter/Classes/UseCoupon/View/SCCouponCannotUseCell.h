//
//  SCCouponCannotUseCell.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/12/15.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCouponModel.h"

@class SCCouponCannotUseCell;
@protocol SCCouponCannotUseDelegate <NSObject>

-(void)expandCannotUserDetailContent:(SCCouponCannotUseCell*)cell;
-(void)closeCannotUserDetailContent:(SCCouponCannotUseCell*)cell;


@end

@interface SCCouponCannotUseCell : UITableViewCell

@property (nonatomic, weak) id<SCCouponCannotUseDelegate> delegate;

-(void)refreshCouponWithCouponModel:(SCCouponModel*)couponM;

@end
