//
//  SCPointExplainCell.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/28.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCPointExplainCell.h"

@implementation SCPointExplainCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initComponents];
    }
    return self;
}

-(void)initComponents {
    
    UILabel *label = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13]];
    label.frame = CGRectMake(10, 0, SCREEN_WIDTH - 20, 170);
    label.numberOfLines = 0;
    [self addSubview:label];
    label.text = @"为答谢客户支持，特别推出积分系统。积分可以通过多渠道获取，只需动动手指，积分轻松入账。\n【积分获取方式】\n(1)购买指定商品送积分；\n(2)指定时间段内签到送积分；\n(3)指定商品评价送积分；\n(4)完善个人资料送积分。\n【积分使用规则】\n(1)积分商城内购物消耗积分；\n(2)积分商城内抽奖消耗积分。";

};

@end
