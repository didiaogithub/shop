//
//  SCFirstPageModel.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/16.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCFirstPageModel.h"

@implementation SCFirstPageModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(NSString*)primaryKey {
    return @"firstPageKey";
}

@end


@implementation Bannerlist

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _bannerId = value;
    }
    [super setValue:value forKey:key];
}

+(NSString*)primaryKey {
    return @"primaryKey";
}

@end

@implementation Topiclist

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _topId = value;
    }
    [super setValue:value forKey:key];
}

+(NSString*)primaryKey {
    return @"primaryKey";
}

@end

@implementation Categorylist

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _categoryId = value;
    }
    [super setValue:value forKey:key];
}

+(NSString*)primaryKey {
    return @"categoryId";
}

@end

@implementation Goodslist

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _goodsId = value;
    }
    [super setValue:value forKey:key];
}

+(NSString*)primaryKey {
    return @"primaryKey";
}

@end

@implementation CkInfoModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(NSString*)primaryKey {
    return @"mobile";
}

@end



