//
//  SCUseCouponViewController.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/12/15.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^CouponBlock)(NSString *price, NSString *couponId);

@interface SCUseCouponViewController : BaseViewController

@property (nonatomic, copy)   CouponBlock couponBlock;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableArray *useabelCouponArray;
@property (nonatomic, strong) NSMutableArray *unuseabelCouponArray;
@property (nonatomic, copy)   NSString *orderMoney;
@property (nonatomic, strong) NSArray *goodsIdArray;
@property (nonatomic, copy)   NSString *couponId;
@property (nonatomic, copy)   NSString *coupontMoney;

@end
