//
//  SCCommon.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/22.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCCommon : NSObject

+(BOOL)isVariableWithClass:(Class)cls varName:(NSString *)name;

+(NSString *)getCurrentDeviceModel;

+(NSString *)getWifiName;

+(NSString*)getMobileProvider;

+ (UIImage *)imageWithColor:(UIColor*)color rect:(CGRect)rect;

@end
