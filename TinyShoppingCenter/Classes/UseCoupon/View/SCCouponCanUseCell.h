//
//  SCCouponCanUseCell.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/12/15.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCouponModel.h"

@class SCCouponCanUseCell;
@protocol SCCouponCanUseDelegate <NSObject>

-(void)selectedCoupon:(UIButton*)btn couponM:(SCCouponModel*)couponM;

-(void)expandDetailContent:(SCCouponCanUseCell*)cell;

-(void)closeDetailContent:(SCCouponCanUseCell*)cell;


@end

@interface SCCouponCanUseCell : UITableViewCell

@property (nonatomic, weak) id<SCCouponCanUseDelegate> delegate;

-(void)refreshCouponWithCouponModel:(SCCouponModel*)couponM;

@end
