//
//  CommunityShowGoodsTableViewCell.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/2/17.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CommunityShowGoodsTableViewCell.h"

@implementation CommunityShowGoodsTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{

    UIView *goodView = [[UIView alloc] init];
    [self.contentView addSubview:goodView];
    goodView.layer.cornerRadius = 5;
    goodView.layer.borderWidth = 0.5;
    goodView.layer.borderColor = [UIColor tt_lineBgColor].CGColor;
    
    [goodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(5);
        make.left.mas_offset(5);
        make.right.mas_offset(-5);
        make.bottom.mas_offset(-2);
    }];
    
    //商品图标
    _iconIamgeView = [[UIImageView alloc] init];
    [goodView addSubview:_iconIamgeView];
    _iconIamgeView.contentMode = UIViewContentModeScaleAspectFit;
    [_iconIamgeView setImage:[UIImage imageNamed:@"defaultover"]];
    [_iconIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedWidth(5));
        make.left.mas_offset(AdaptedWidth(5));
        make.width.mas_offset(AdaptedWidth(40));
        make.height.mas_offset(AdaptedWidth(40));
        make.bottom.mas_offset(-AdaptedWidth(5));
    }];
    
    //商品名称
    _goodNameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [goodView addSubview:_goodNameLable];
    _goodNameLable.numberOfLines = 0;
    [_goodNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.right.mas_offset(-AdaptedWidth(40));
        make.left.equalTo(_iconIamgeView.mas_right).offset(10);

    }];
    
    //商品价格
    _priceLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [goodView addSubview:_priceLable];
    _priceLable.text = @"¥0.00";
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodNameLable.mas_bottom).offset(8);
        make.left.equalTo(_goodNameLable.mas_left);
        make.bottom.mas_offset(-10);
    }];
    //会员价格
    _VIPPriceLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [goodView addSubview:_VIPPriceLable];
    _VIPPriceLable.text = @"VIP ¥0.00";
    [_VIPPriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLable.mas_top);
        make.left.equalTo(_priceLable.mas_right).offset(15);
        make.bottom.equalTo(_priceLable.mas_bottom);
    }];
    
    //右侧箭头
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [goodView addSubview:_rightButton];
    _rightButton.userInteractionEnabled = NO;
    [_rightButton setImage:[UIImage imageNamed:@"rightdirection"] forState:UIControlStateNormal];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_offset(0);
        make.width.mas_offset(AdaptedWidth(40));
    }];

}

- (void)refreshCellWithModel:(GoodModel *)model{
    if ([self.typeString isEqualToString:@"1"]) {//社区首页
     [_rightButton setImage:[UIImage imageNamed:@"rightgray"] forState:UIControlStateNormal];
    }else if ([self.typeString isEqualToString:@"2"]){
     [_rightButton setImage:[UIImage imageNamed:@"deletered"] forState:UIControlStateNormal];
    }
    
    NSString *imageurl = [NSString stringWithFormat:@"%@",model.path];
    if (IsNilOrNull(imageurl)) {
        [_iconIamgeView setImage:[UIImage imageNamed:@"defaultover"]];
    }
    [_iconIamgeView sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:[UIImage imageNamed:@"defaultover"]];
    
    //名称
    NSString *name = [NSString stringWithFormat:@"%@",model.name];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    _goodNameLable.text = name;
    
    //价格
    NSString *price = [NSString stringWithFormat:@"%@",model.price];
    if (IsNilOrNull(price)) {
        price = @"";
    }
    _priceLable.text = [NSString stringWithFormat:@"¥%@",price];
    
     //VIP 价格
    NSString *specialPrice = [NSString stringWithFormat:@"%@",model.price];
    if (IsNilOrNull(specialPrice)) {
        specialPrice = @"";
    }
    _VIPPriceLable.text = [NSString stringWithFormat:@"VIP ¥%@",specialPrice];
    
    
}

@end
