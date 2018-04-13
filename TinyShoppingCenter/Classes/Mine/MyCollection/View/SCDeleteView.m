//
//  SCDeleteView.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCDeleteView.h"

@interface SCDeleteView ()

@property (nonatomic, strong) UIButton *deleBtn;

@end

@implementation SCDeleteView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return  self;
}

-(void)setUpViews{
    _deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleBtn setBackgroundColor:[UIColor redColor]];
    [_deleBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
    [_deleBtn addTarget:self action:@selector(deleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deleBtn];
    [_deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
}

-(void)deleBtnClick {
    if ([self.delegate respondsToSelector:@selector(deleteBtnView:deleteBtnClick:)]) {
        
        [self.delegate deleteBtnView:self deleteBtnClick:nil];
    }
}

@end
