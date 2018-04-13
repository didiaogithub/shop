//
//  MoneyCountView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/17.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "MoneyCountView.h"

@implementation MoneyCountView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self createUI];
    }
    return self;
}

-(void)createUI{
    UILabel *line = [UILabel creatLineLable];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    _allMoneyLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self addSubview:_allMoneyLable];
    _allMoneyLable.text = [NSString stringWithFormat:@"合计：¥"];
    [_allMoneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake((SCREEN_WIDTH - 160), 15));
    }];

    _nowToBuyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_nowToBuyButton];
    _nowToBuyButton.backgroundColor = [UIColor tt_redMoneyColor];
    [_nowToBuyButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [_nowToBuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nowToBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.right.mas_offset(0);
        make.size.mas_offset(CGSizeMake(130*SCREEN_WIDTH_SCALE, 50));
    }];
    [_nowToBuyButton addTarget:self action:@selector(clickNowBuyButton) forControlEvents:UIControlEventTouchUpInside];

}

-(void)clickNowBuyButton{
    
    NSLog(@"提交订单");
    self.nowToBuyButton.enabled =NO;
//    [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:2.0];//防止重复点击

    if (self.delegate && [self.delegate respondsToSelector:@selector(moneyCountViewButtonClicked)]) {
        [self.delegate moneyCountViewButtonClicked];
    }
}

-(void)changeButtonStatus{
    self.nowToBuyButton.enabled =YES;
}

@end
