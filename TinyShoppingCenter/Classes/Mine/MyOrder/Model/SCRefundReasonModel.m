//
//  SCRefundReasonModel.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCRefundReasonModel.h"

@implementation SCRefundReasonModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _reasonId = value;
    }
    [super setValue:value forKey:key];
}

@end
