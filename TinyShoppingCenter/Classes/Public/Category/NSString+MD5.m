//
//  NSString+MD5.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2018/1/10.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

- (NSString *)MD5String {
    const char* cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    
    NSMutableString *str = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [str appendFormat:@"%02x", result[i]];
    }
    return [NSString stringWithString:str];
}

@end
