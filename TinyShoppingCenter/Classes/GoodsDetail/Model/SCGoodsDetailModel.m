//
//  SCGoodsDetailModel.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/22.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCGoodsDetailModel.h"

@implementation SCGoodsDetailModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        _descript = value;
    }
    [super setValue:value forKey:key];
}

@end

@implementation SCGDCommentModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
