//
//  SCIntegraModel.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/28.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCIntegraModel.h"

@implementation SCIntegraModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _jfId = value;
    }
    [super setValue:value forKey:key];
}

@end
