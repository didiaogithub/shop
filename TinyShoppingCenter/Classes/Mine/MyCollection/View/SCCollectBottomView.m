//
//  SCCollectBottomView.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/14.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCCollectBottomView.h"

@implementation SCCollectBottomView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self initwithComponnents];
    }
    return self;
}

-(void)initwithComponnents {
    
    float buttonW= 0;
    if (iphone5) {
        buttonW = 100;
    }else{
        buttonW = 120;
    }
    
    UILabel *line = [UILabel creatLineLable];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    _allSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_allSelectedButton];
    _allSelectedButton.tag = 1413;
    UIImage *nomalImage = [UIImage imageNamed:@"selectedgray"];
    UIImage * selectedImage = [UIImage imageNamed:@"selectedred"];
    [_allSelectedButton setImage:nomalImage forState:UIControlStateNormal];
    [_allSelectedButton setImage:selectedImage forState:UIControlStateSelected];
    
    [_allSelectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(10);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    
    [_allSelectedButton addTarget:self action:@selector(clickBottomButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *textLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self addSubview:textLable];
    textLable.text = @"全选";
    [textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_allSelectedButton.mas_top);
        make.left.equalTo(_allSelectedButton.mas_right).offset(5);
        make.size.mas_offset(CGSizeMake(35, 30));
    }];
//    取消收藏
    _nowGoToBuyButton = [UIButton configureButtonWithTitle:@"" titleColor:[UIColor whiteColor] bankGroundColor:[UIColor tt_redMoneyColor] cornerRadius:0 font:MAIN_TITLE_FONT borderWidth:0 borderColor:[UIColor clearColor] target:self action:@selector(clickBottomButton:)];
    [self addSubview:_nowGoToBuyButton];
    [_nowGoToBuyButton setTitle:@"取消收藏" forState:UIControlStateNormal];
    _nowGoToBuyButton.tag = 1414;
    
    [_nowGoToBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_offset(buttonW*SCREEN_WIDTH_SCALE);
    }];
}

-(void)clickBottomButton:(UIButton *)button{
    if (self.delegate  && [self.delegate respondsToSelector:@selector(cancelCollection:)]) {
        [self.delegate cancelCollection:button];
    }
}
@end

