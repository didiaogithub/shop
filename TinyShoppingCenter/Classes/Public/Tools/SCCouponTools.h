//
//  SCCouponTools.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/12/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCCouponTools : NSObject

/**
 单例
 
 @return self
 */
+ (instancetype)shareInstance;

/**
 获取可用或者不可以优惠券列表
 
 @param goodsIds 商品ids
 @param orderMoney 订单金额
 @param canUse 可用或者不可用
 @return 返回可用或者不可用优惠券列表
 */
- (NSArray*)showCoupons:(NSArray*)goodsIds orderMoney:(NSString *)orderMoney canUse:(BOOL)canUse;

/**
 删除下单成功使用的优惠券

 @param couponId 优惠券id
 */
- (void)deleteUsedCoupon:(NSString*)couponId;

/**
 请求所有未使用的优惠券数据（有缓存时间判断）
 */
- (void)resquestMyCouponsData;

/**
 请求所有未使用的优惠券数据（取消时使用）
 */
- (void)resquestValidCouponsData;

@end
