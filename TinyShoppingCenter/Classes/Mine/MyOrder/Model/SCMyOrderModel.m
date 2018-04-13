//
//  SCMyOrderModel.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/24.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCMyOrderModel.h"

@implementation SCCommentOrderModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

@implementation SCMyOrderModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _orderId = value;
    }
    [super setValue:value forKey:key];
}

+(NSString *)primaryKey {
    return @"orderId";
}

@end

@implementation SCMyOrderGoodsModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(NSString *)primaryKey {
    return @"goodsKey";
}

@end
