//
//  SCCouponTools.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/12/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCCouponTools.h"
#import "SCCouponModel.h"

@implementation SCCouponTools

+(instancetype)shareInstance {
    static SCCouponTools *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SCCouponTools alloc] initPrivate];
    });
    return instance;
}

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        
    }
    return self;
}

#pragma mark - 获取可用或者不可以优惠券列表
- (NSArray*)showCoupons:(NSArray*)goodsIds orderMoney:(NSString *)orderMoney canUse:(BOOL)canUse {
    
    NSMutableArray *canUseArray = [NSMutableArray array];
    NSMutableArray *canNotUseArray = [NSMutableArray array];

    NSArray *couponsArray = [[XNArchiverManager shareInstance] xnUnarchiverObject:KMyCouponList];
    for (NSDictionary *dict in couponsArray) {
        SCCouponModel *couponM = [[SCCouponModel alloc] init];
        [couponM setValuesForKeysWithDictionary:dict];
        //优惠券使用规则匹配
        for (NSString *goodsId in goodsIds) {
            NSArray *itemArray = [couponM.items componentsSeparatedByString:@","];
            if ([itemArray containsObject:goodsId]) {
                if ([couponM.type isEqualToString:@"2"]) {
                    if ([orderMoney doubleValue] >= [couponM.price doubleValue]) {
                        [canUseArray addObject:dict];
                        break;
                    }
                }else{
                    [canUseArray addObject:dict];
                    break;
                }
            }
        }
        if (![canUseArray containsObject:dict]) {
            [canNotUseArray addObject:dict];
        }
    }
    
//    canUseArray = [canUseArray valueForKeyPath:@"@distinctUnionOfObjects.self"];
    if (canUse) {
        return canUseArray;
    }
    return canNotUseArray;
}

- (void)deleteUsedCoupon:(NSString*)couponId {
    
    NSArray *couponsArray = [[XNArchiverManager shareInstance] xnUnarchiverObject:KMyCouponList];
    NSMutableArray *useableCouponArr = [NSMutableArray arrayWithArray:couponsArray];
    for (NSDictionary *dict in couponsArray) {
        NSString *couponsId = [NSString stringWithFormat:@"%@", dict[@"id"]];
        SCCouponModel *couponM = [[SCCouponModel alloc] init];
        [couponM setValuesForKeysWithDictionary:dict];
        if ([couponsId isEqualToString:couponId]) {
            [useableCouponArr removeObject:dict];
        }
    }
    [[XNArchiverManager shareInstance] xnArchiverObject:useableCouponArr archiverName:KMyCouponList];
}

- (void)resquestMyCouponsData {
    
    //2018.1.12增加推荐奖励图片地址为空时不请求优惠券信息的判断
    NSString *couponbgurl = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_couponbgurl"]];
    if (IsNilOrNull(couponbgurl)) return;
    
    NSString *couponCacheDate = [KUserdefaults objectForKey:@"CouponCacheDate"];
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";
    NSTimeInterval nowTime = [nowDate timeIntervalSince1970];
    NSTimeInterval value = nowTime - [couponCacheDate doubleValue];
    NSLog(@"间隔------%f秒", value);
    
    NSString *coupontime = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_coupontime"]];//优惠券缓存有效时长
    if (value >= [coupontime doubleValue]) {
        [self resquestValidCouponsData];
    }
}

- (void)resquestValidCouponsData {
    
    //2018.1.12增加推荐奖励图片地址为空时不请求优惠券信息的判断
    NSString *couponbgurl = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_couponbgurl"]];
    if (IsNilOrNull(couponbgurl)) return;
    
    
    //没有openid时会崩溃
    if (IsNilOrNull(USER_OPENID)) return;
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetMyCoupons];
    NSDictionary *params = @{@"openid":USER_OPENID, @"type":@"0"};//type:0未使用，1已使用，2已过期
    [HttpTool getWithUrl:requestUrl params:params success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            return ;
        }
        
        NSArray *list = dict[@"coupons"];
        [[XNArchiverManager shareInstance] xnArchiverObject:list archiverName:KMyCouponList];
        
        //设置缓存时间
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";
        NSTimeInterval startTime = [nowDate timeIntervalSince1970];
        [KUserdefaults setObject:[NSString stringWithFormat:@"%f", startTime] forKey:@"CouponCacheDate"];
        
    } failure:^(NSError *error) {
        //成功有数据更新，失败不更新
    }];
}

@end
