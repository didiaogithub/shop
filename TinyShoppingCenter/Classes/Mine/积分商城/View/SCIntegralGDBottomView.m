//
//  SCIntegralGDBottomView.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/13.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCIntegralGDBottomView.h"

@implementation SCIntegralGDBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self createUIView];
    }
    return self;
}

-(void)createUIView{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    float width = (SCREEN_WIDTH-240*SCREEN_WIDTH_SCALE)/2;
    _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_messageButton];
    [_messageButton setImage:[UIImage imageNamed:@"messageicon"] forState:UIControlStateNormal];
    _messageButton.tag = 1024;
    [_messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.bottom.mas_offset(0);
        make.width.mas_offset(width);
    }];
    
    
    _shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_shopButton];
    _shopButton.tag = 1025;
    [_shopButton setImage:[UIImage imageNamed:@"shopicon"] forState:UIControlStateNormal];
    [_shopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.equalTo(_messageButton.mas_right);
        make.bottom.mas_offset(0);
        make.width.mas_offset(width);
    }];
    
    //立即购买
    _nowBuyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_nowBuyButton];
    _nowBuyButton.backgroundColor = CKYS_Color(203, 24, 45);
    _nowBuyButton.tag = 1026;
    [_nowBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [_nowBuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nowBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.equalTo(_shopButton.mas_right);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    _waitSaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_waitSaleBtn];
    _waitSaleBtn.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [_waitSaleBtn setTitle:@"待出售" forState:UIControlStateNormal];
    [_waitSaleBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [_waitSaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.equalTo(_shopButton.mas_right);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    
    [_messageButton addTarget:self action:@selector(clickBottomButton:) forControlEvents:UIControlEventTouchUpInside];
    [_shopButton addTarget:self action:@selector(clickBottomButton:) forControlEvents:UIControlEventTouchUpInside];
    [_nowBuyButton addTarget:self action:@selector(clickBottomButton:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)showBottomType:(NSString*)type {
    
    if ([type isEqualToString:@"Sell"]) {
        _waitSaleBtn.hidden = YES;
    }else if ([type isEqualToString:@"WaitSell"]) {
        _waitSaleBtn.hidden = NO;
        [_waitSaleBtn setTitle:@"待出售" forState:UIControlStateNormal];
    }else if ([type isEqualToString:@"Sellout"]) {
        _waitSaleBtn.hidden = NO;
        [_waitSaleBtn setTitle:@"已售罄" forState:UIControlStateNormal];
    }
    [self layoutIfNeeded];
    [self layoutSubviews];
}


-(void)clickBottomButton:(UIButton *)button{
    self.nowBuyButton.enabled =NO;
    [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:2.0];//防止重复点击
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpWithTag:)]) {
        [self.delegate jumpWithTag:button.tag];
    }
}

-(void)changeButtonStatus {
    self.nowBuyButton.enabled =YES;
}

@end
