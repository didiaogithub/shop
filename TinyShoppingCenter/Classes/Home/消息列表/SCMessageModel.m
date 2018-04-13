//
//  SCMessageModel.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2018/2/1.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "SCMessageModel.h"

@implementation SCMessageModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;;
    }
    [super setValue:value forKey:key];
}

@end
