//
//  SCCouponModel.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/12/18.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BaseEncodeModel.h"

@interface SCCouponModel : BaseEncodeModel
/**
 是否展开
 */
@property (nonatomic, assign) BOOL isExpand;
/**
 是否选中
 */
@property (nonatomic, assign) BOOL isSelected;
/**
 优惠券id
 */
@property (nonatomic, copy) NSString *couponid;
/**
 满减阀值金额
 */
@property (nonatomic, copy) NSString *price;
/**
 优惠券背景路径
 */
@property (nonatomic, copy) NSString *path;
/**
 优惠券背景路径
 */
@property (nonatomic, copy) NSString *imgurl;
/**
 优惠券金额
 */
@property (nonatomic, copy) NSString *money;
/**
 优惠券名称
 */
@property (nonatomic, copy) NSString *name;
/**
 适用范围
 */
@property (nonatomic, copy) NSString *userange;
/**
 详细信息
 */
@property (nonatomic, copy) NSString *content;
/**
 详细信息
 */
@property (nonatomic, copy) NSString *details;
/**
 有效期（canuse接口返回）
 */
@property (nonatomic, copy) NSString *timelimit;
/**
 开始时间（getmyCoupons接口返回）
 */
@property (nonatomic, copy) NSString *starttime;
/**
 结束时间（getmyCoupons接口返回）
 */
@property (nonatomic, copy) NSString *endtime;
/**
 可用的商品
 */
@property (nonatomic, copy) NSString *items;
/**
 优惠券类型1：单笔券；2：满减券
 */
@property (nonatomic, copy) NSString *type;



@end
