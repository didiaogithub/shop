//
//  TTAttibuteLabel.m
//  TT_Project
//
//  Created by 庞宏侠 on 16/11/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TTAttibuteLabel.h"

@implementation TTAttibuteLabel

- (void)tt_setText:(NSString *)text color:(UIColor *)color left:(NSString *)left right:(NSString *)right
{
    
    // 集中设置
    NSString *textStr = [NSString stringWithFormat:@"%@%@%@",left,text,right];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:textStr];
    [AttributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:[UIColor tt_redMoneyColor]} range:NSMakeRange(left.length, text.length)];
    [AttributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, left.length)];
    [AttributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(left.length + text.length,1)];
    [self setAttributedText:AttributedStr];
    
}
- (void)tt_stocksetText:(NSString *)text left:(NSString *)left right:(NSString *)right anleftColor:(UIColor *)leftColor andMiddlecolor:(UIColor *)middleColor andRightColor:(UIColor *)rightColor leftFont:(float)leftfont midFont:(float)midFont rightFont:(float)rightFont{
    // 集中设置
    NSString *textStr = [NSString stringWithFormat:@"%@%@%@",left,text,right];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:textStr];
    [AttributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:midFont],NSForegroundColorAttributeName:middleColor} range:NSMakeRange(left.length, text.length)];
    
    [AttributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:leftfont],NSForegroundColorAttributeName:leftColor} range:NSMakeRange(0, left.length)];
    
    [AttributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:rightFont],NSForegroundColorAttributeName:rightColor} range:NSMakeRange(left.length + text.length,1)];
    [self setAttributedText:AttributedStr];
}

- (void)setTextLeft:(NSString *)leftstr right:(NSString *)rightstr{
    // 集中设置
    NSString *textStr = [NSString stringWithFormat:@"%@%@",leftstr,rightstr];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:textStr];
    [AttributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:SubTitleColor} range:NSMakeRange(0, leftstr.length)];
    [AttributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:TitleColor} range:NSMakeRange(leftstr.length, rightstr.length)];

    [self setAttributedText:AttributedStr];
}

- (void)setTextLeft:(NSString *)leftstr right:(NSString *)rightstr andLeftColor:(UIColor *)leftColor andRightColor:(UIColor *)rightColor andLeftFont:(float)leftFont andRightFont:(float)rightFont{
    // 集中设置
    NSString *textStr = [NSString stringWithFormat:@"%@%@",leftstr,rightstr];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:textStr];
    [AttributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:leftFont],NSForegroundColorAttributeName:leftColor} range:NSMakeRange(0, leftstr.length)];
    [AttributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:rightFont],NSForegroundColorAttributeName:rightColor} range:NSMakeRange(leftstr.length, rightstr.length)];
    
    [self setAttributedText:AttributedStr];
}

@end
