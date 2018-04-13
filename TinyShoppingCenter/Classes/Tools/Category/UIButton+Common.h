//
//  UIButton+Common.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Common)
+ (UIButton *)configureButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor bankGroundColor:(UIColor *)bankColor cornerRadius:(CGFloat)radius font:(UIFont *)lableFont borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor target:(id)target action:(SEL)action;

+ (UIButton *)setTitle:(NSString *)title SelTitle:(NSString *)selTitle titleColor:(UIColor *)titleColor selColor:(UIColor *)selColor nomalImg:(NSString *)nomalStr selImg:(NSString *)selStr bankGroundColor:(UIColor *)bankColor cornerRadius:(CGFloat)radius font:(UIFont *)lableFont target:(id)target action:(SEL)action;
@end
