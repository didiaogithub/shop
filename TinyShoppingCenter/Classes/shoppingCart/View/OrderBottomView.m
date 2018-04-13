//
//  OrderBottomView.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 16/8/10.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "OrderBottomView.h"

@interface OrderBottomView()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation OrderBottomView

-(instancetype)initWithFrame:(CGRect)frame andType:(NSString *)type{
    self = [super initWithFrame:frame];
    if(self){
        [self createUIWithType:type];
    }
    return self;
}
-(void)createUIWithType:(NSString *)type{
    
    _bgView = [UIView new];
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    float buttonW= 0;
    if (iphone5) {
        buttonW = 100;
    }else{
        buttonW = 120;
    }
    
    UILabel *line = [UILabel creatLineLable];
    [_bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    _allSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_allSelectedButton];
    _allSelectedButton.tag = 788;
    UIImage *nomalImage = [UIImage imageNamed:@"selectedgray"];
    UIImage * selectedImage = [UIImage imageNamed:@"selectedred"];
    [_allSelectedButton setImage:nomalImage forState:UIControlStateNormal];
    [_allSelectedButton setImage:selectedImage forState:UIControlStateSelected];
    [_allSelectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_top).offset(10);
        make.left.equalTo(_bgView.mas_left).offset(10);
        make.size.mas_offset(CGSizeMake(30, 30));
        make.bottom.equalTo(_bgView.mas_bottom).offset(-10);

    }];
    
    [_allSelectedButton addTarget:self action:@selector(clickBottomButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *textLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_bgView addSubview:textLable];
    textLable.text = @"全选";
    [textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_allSelectedButton.mas_top);
        make.left.equalTo(_allSelectedButton.mas_right).offset(5);
        make.size.mas_offset(CGSizeMake(35, 30));
    }];
    

    //总计
    _realPayMoneyLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_bgView addSubview:_realPayMoneyLable];
    _realPayMoneyLable.text = @"合计：¥0.00";
    [_realPayMoneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLable.mas_top);
        make.height.mas_offset(30);
        make.left.equalTo(textLable.mas_right);
        make.width.mas_offset(SCREEN_WIDTH - 90-buttonW);
    }];

      //立即购买
    _nowGoToBuyButton = [UIButton configureButtonWithTitle:@"" titleColor:[UIColor whiteColor] bankGroundColor:[UIColor tt_redMoneyColor] cornerRadius:0 font:MAIN_TITLE_FONT borderWidth:0 borderColor:[UIColor clearColor] target:self action:@selector(clickBottomButton:)];
    [_bgView addSubview:_nowGoToBuyButton];
    _nowGoToBuyButton.tag = 789;
 
    [_nowGoToBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_top);
        make.right.equalTo(_bgView.mas_right);
        make.bottom.equalTo(_bgView.mas_bottom);
        make.width.mas_offset(buttonW);
    }];
    
    
    _deleteButton = [UIButton configureButtonWithTitle:@"删除" titleColor:[UIColor whiteColor] bankGroundColor:[UIColor tt_redMoneyColor] cornerRadius:0 font:MAIN_TITLE_FONT borderWidth:0 borderColor:[UIColor clearColor] target:self action:@selector(clickBottomButton:)];
    [_bgView addSubview:_deleteButton];
    _deleteButton.tag = 790;
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(_nowGoToBuyButton);
        make.width.mas_offset(140);
    }];
    _deleteButton.hidden = YES;
    
    _collectedButton = [UIButton configureButtonWithTitle:@"移动到收藏夹" titleColor:[UIColor whiteColor] bankGroundColor:CKYS_Color(231, 182, 47) cornerRadius:0 font:MAIN_TITLE_FONT borderWidth:0 borderColor:[UIColor clearColor] target:self action:@selector(clickBottomButton:)];
    [_bgView addSubview:_collectedButton];
    _collectedButton.tag = 791;
    [_collectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(_deleteButton);
        make.right.equalTo(_deleteButton.mas_left);
    }];
    _collectedButton.hidden = YES;


    
    if ([type isEqualToString:@"no"]){
        [_nowGoToBuyButton setTitle:@"确认" forState:UIControlStateNormal];
        _realPayMoneyLable.hidden = YES;
    }else{
        [_nowGoToBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        _realPayMoneyLable.hidden = NO;
    }
    

}
-(void)clickBottomButton:(UIButton *)button{
    
    self.nowGoToBuyButton.enabled =NO;
    [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:2.0];//防止重复点击
    
    if (self.delegate  && [self.delegate respondsToSelector:@selector(bottomViewButtonClicked:)]) {
        [self.delegate bottomViewButtonClicked:button];
    }
}

-(void)changeButtonStatus {
    self.nowGoToBuyButton.enabled =YES;
}

@end
