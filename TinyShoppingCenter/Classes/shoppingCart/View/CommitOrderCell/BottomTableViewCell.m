//
//  BottomTableViewCell.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/21.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BottomTableViewCell.h"
@interface BottomTableViewCell()
@property(nonatomic,strong)UIButton *reduceButton;
@property(nonatomic,strong)UIButton *plusButton;

@end
@implementation BottomTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(NSString *)typeStr{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUIWithType:typeStr];
    }
    return self;
}
-(void)createUIWithType:(NSString *)type{
     self.backgroundColor = [UIColor tt_grayBgColor];
    //1.从积分商城 购买和立即购买 可以选择数量  0.购物车购买没有选择数量
    
    UIView *numView = [[UIView alloc] init];
    [self.contentView addSubview:numView];
    numView.backgroundColor = [UIColor whiteColor];
    
    UILabel *numLeftLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [numView addSubview:numLeftLable];
    numLeftLable.text = @"购买数量:";
    
    UIView * countView = [[UIView alloc] init];
    [numView addSubview:countView];
    countView.layer.cornerRadius = 3;
    countView.layer.borderWidth = 1;
    countView.layer.borderColor = [UIColor tt_grayBgColor].CGColor;

    
    //减号按钮
    _reduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [countView addSubview:_reduceButton];
    _reduceButton.tag = 1111;
    [_reduceButton setTitle:@"-" forState:UIControlStateNormal];
    [_reduceButton setTitleColor:CKYS_Color(130, 130, 130) forState:UIControlStateNormal];
    
    //数字
    _countLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [countView addSubview:_countLable];
    _countLable.text = @"1";
    _countLable.layer.borderWidth = 1;
    _countLable.layer.borderColor = [UIColor tt_grayBgColor].CGColor;
    
    //加号按钮
    _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [countView addSubview:_plusButton];
    _plusButton.tag = 1112;
    [_plusButton setTitle:@"+" forState:UIControlStateNormal];
    [_plusButton setTitleColor:CKYS_Color(130, 130, 130) forState:UIControlStateNormal];

    UIImageView *boderImageView = [[UIImageView alloc] init];
    [countView addSubview:boderImageView];
    [boderImageView setImage:[UIImage imageNamed:@"numberborder"]];
    
    
    //配送方式
    UIView *topView = [[UIView alloc] init];
    [self.contentView addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];

    if([type isEqualToString:@"1"]){
        [numView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_offset(0);
            make.height.mas_offset(45);
        }];
        
        [numLeftLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
            make.left.mas_offset(10);
        }];
        [countView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.top.mas_offset(15/2);
            make.bottom.mas_offset(-15/2);
            make.size.mas_offset(CGSizeMake(110, 30));
        }];
        
        //减号按钮
        [_reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.left.mas_offset(0);
            make.size.mas_offset(CGSizeMake(35, 30));
        }];
        [_reduceButton addTarget:self action:@selector(clickCountButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //数字

        [_countLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.left.mas_offset(33);
            make.size.mas_offset(CGSizeMake(40, 30));
        }];
        
        
        //加号按钮
        [_plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_reduceButton.mas_top);
            make.left.equalTo(_countLable.mas_right);
            make.size.equalTo(_reduceButton);
        }];
        [_plusButton addTarget:self action:@selector(clickCountButton:) forControlEvents:UIControlEventTouchUpInside];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(numView.mas_bottom).offset(1);
            make.left.right.mas_offset(0);
            make.height.mas_offset(45);
        }];
    
    }else{
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_offset(0);
            make.height.mas_offset(45);
        }];
    
    }
    UILabel *leftLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [topView addSubview:leftLable];
    leftLable.text = @"配送方式:";
    [leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(10);
    }];
    
    _logistLabale = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [topView addSubview:_logistLabale];
    _logistLabale.text = @"快递 免运费";
    [_logistLabale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(leftLable);
        make.right.mas_offset(-10);
    }];
    
    
    UIView *middleView = [[UIView alloc] init];
    [self.contentView addSubview:middleView];
    middleView.backgroundColor = [UIColor whiteColor];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(1);
        make.left.right.height.equalTo(topView);
    }];
    
    UILabel *middleLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [middleView addSubview:middleLable];
    [middleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(10);
    }];
    
    _numCouponsLabale = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [middleView addSubview:_numCouponsLabale];
    _numCouponsLabale.layer.cornerRadius = 5;
    _numCouponsLabale.clipsToBounds = YES;
    _numCouponsLabale.backgroundColor = [UIColor tt_redMoneyColor];
    [_numCouponsLabale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(8);
        make.left.equalTo(middleLable.mas_right).offset(15);
        make.bottom.mas_offset(-8);
        make.width.mas_offset(70);
    }];
    _numCouponsLabale.text = @"0张可用";
    
    _couponsStatusLabale = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [middleView addSubview:_couponsStatusLabale];
    [_couponsStatusLabale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(middleLable);
        make.right.mas_offset(-30);
        
    }];
    
    UIImageView *rightImageView = [[UIImageView alloc] init];
    [middleView addSubview:rightImageView];
    [rightImageView setImage:[UIImage imageNamed:@"rightdirection"]];
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(13);
        make.width.mas_offset(10);
        make.right.mas_offset(-10);
        make.bottom.mas_offset(-13);
    }];
    
    
    if ([type isEqualToString:@"1"]){
        middleLable.text = @"使用积分:";
        _numCouponsLabale.hidden = YES;
        rightImageView.hidden = YES;
        _couponsStatusLabale.text = @"0积分";
    }else{
        middleLable.text = @"优惠券:";
        _numCouponsLabale.hidden = NO;
        rightImageView.hidden = NO;
        _couponsStatusLabale.text = @"未使用";
    }
    

    UIView *bottomView = [[UIView alloc] init];
    [self.contentView addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView.mas_bottom).offset(1);
        make.left.right.height.equalTo(topView);
        make.bottom.mas_offset(0);
    }];
    
    _priceLabale = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bottomView addSubview:_priceLabale];
    [_priceLabale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.right.mas_offset(-10);
    }];
    
    _priceLabale.text = @"共3件商品   合计: ¥180.00";
    
}
#pragma mark-点击减号 和   加号 按钮
-(void)clickCountButton:(UIButton *)button{
    
    if (button.tag == 1111) { //减号
        if ((self.chooseCount - 1) <= 0 || self.chooseCount == 0) {
            self.chooseCount = 1;
        }else{
            self.chooseCount  = self.chooseCount -1;
        }
    }else{
        if (self.chooseCount  > 100 || self.chooseCount == 100) {
            self.chooseCount  = 99;
        }else{
            self.chooseCount  = self.chooseCount +1;
        }
    }
    _countLable.text = [NSString stringWithFormat:@"%zd",self.chooseCount];
}

#pragma mark-刷新
-(void)refreshCellWithCount:(NSInteger *)count money:(NSString *)allMoney{




}

@end
