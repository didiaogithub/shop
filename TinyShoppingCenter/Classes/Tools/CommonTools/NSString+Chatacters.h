//
//  NSString+Chatacters.h
//  yingzi_iOS
//
//  Created by kewei on 16/3/25.
//  Copyright © 2016年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Chatacters)

/* 将汉字装换为拼音 */
- (NSString *)pinyinOfString;

/* 汉子转换成拼音后，返回大写的首字母 */
- (NSString *)firstCharacterOfString;


- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
+(CGSize)calcuteLableHeightWith:(NSString *)lableText withLableWidth:(float)lableWidth withFont:(UIFont *)font;

@end
