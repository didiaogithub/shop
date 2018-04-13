//
//  UIButton+Common.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "UIButton+Common.h"

@implementation UIButton (Common)
+ (UIButton *)configureButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor bankGroundColor:(UIColor *)bankColor cornerRadius:(CGFloat)radius font:(UIFont *)lableFont borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setBackgroundColor:bankColor];
    button.titleLabel.font = lableFont;
    button.layer.cornerRadius = radius;
    button.layer.borderWidth = borderWidth;
    button.layer.borderColor = borderColor.CGColor;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)setTitle:(NSString *)title SelTitle:(NSString *)selTitle titleColor:(UIColor *)titleColor selColor:(UIColor *)selColor nomalImg:(NSString *)nomalStr selImg:(NSString *)selStr bankGroundColor:(UIColor *)bankColor cornerRadius:(CGFloat)radius font:(UIFont *)lableFont target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:selTitle forState:UIControlStateSelected];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitleColor:selColor forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:nomalStr] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selStr] forState:UIControlStateSelected];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setBackgroundColor:bankColor];
    button.titleLabel.font = lableFont;
    button.layer.cornerRadius = radius;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


@end
