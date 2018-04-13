//
//  MallCollectionViewCell.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/24.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "MallCollectionViewCell.h"

@interface MallCollectionViewCell()

@property (nonatomic, strong) UIImageView *goodImageView;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *specLable;
@property (nonatomic, strong) UILabel *originalLable;
@property (nonatomic, strong) UILabel *priceLable;
@property (nonatomic, strong) UILabel *integralLable;

@end

@implementation MallCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _goodImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_goodImageView];
    [_goodImageView setImage:[UIImage imageNamed:@"defaultover"]];
    [_goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_offset(0);
        make.width.mas_offset((SCREEN_WIDTH - 24)/2);
        make.height.mas_offset((SCREEN_WIDTH - 24)/2-10);
    }];

    _nameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_nameLable];
    _nameLable.text = @"商品名称文字j简单介绍";
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodImageView.mas_bottom).offset(5);
        make.left.mas_offset(5);
        make.right.mas_offset(-5);
    }];
    
    _specLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_specLable];
    _specLable.text = @"规格:150ml";
    [_specLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLable.mas_bottom).offset(5);
        make.left.equalTo(_nameLable);
    }];
    
    //右侧的价格
    _originalLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [self.contentView addSubview:_originalLable];
    _originalLable.text = @"¥99.99";
    [_originalLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_specLable.mas_top);
        make.left.equalTo(_specLable.mas_right).offset(5);
        make.right.mas_offset(-5);
    }];
    //横线
    UILabel *horizalLine = [[UILabel alloc] init];
    horizalLine.backgroundColor = SubTitleColor;
    [_originalLable addSubview:horizalLine];
    [horizalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_originalLable.mas_centerY);
        make.left.right.equalTo(_originalLable);
        make.height.mas_offset(1);
    }];
        
    _priceLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    _priceLable.text = @"¥299.99";
    [self.contentView addSubview:_priceLable];
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_specLable.mas_bottom).offset(5);
        make.left.equalTo(_nameLable);
    }];
    
    //积分
    _integralLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [self.contentView addSubview:_integralLable];
    _integralLable.text = @"+50000积分";
    [_integralLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceLable.mas_right);
        make.bottom.equalTo(_priceLable.mas_bottom);
        make.right.mas_offset(-10);
    }];
    
    
    _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_buyButton];
    [_buyButton setBackgroundColor:[UIColor tt_redMoneyColor]];
    [_buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLable.mas_bottom).offset(10);
        make.left.right.equalTo(_nameLable);
        make.height.mas_offset(40);
        make.bottom.mas_offset(-10);
    }];
    [_buyButton addTarget:self action:@selector(clickBuyButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark-点击立即购买按钮
-(void)clickBuyButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(integralMallBuy:)]) {
        [self.delegate integralMallBuy:button.tag];
    }
}

-(void)cellRefreshWithModel:(SCIntegralGoodsModel *)goodModel {
    //商品图片
    NSString *imageString = [BaseImagestr_Url stringByAppendingString:goodModel.path];
    [_goodImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"defaultover"]];
    //名称
    NSString *name = [NSString stringWithFormat:@"%@", goodModel.name];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    _nameLable.text = name;
    //价格
    NSString *salesPrice = [NSString stringWithFormat:@"%@", goodModel.salesprice];
    if (IsNilOrNull(salesPrice)) {
        salesPrice = @"¥0.00";
    }
    _priceLable.text = salesPrice;
    
    NSString *costPrice = [NSString stringWithFormat:@"%@", goodModel.costprice];
    if (IsNilOrNull(costPrice)) {
        costPrice = @"¥0.00";
    }
    _originalLable.text = costPrice;
    
    //自提商城规格
    NSString *spec = [NSString stringWithFormat:@"%@", goodModel.spec];
    if (IsNilOrNull(spec)) {
        spec = @"";
    }
    _specLable.text = spec;
    
    NSString *consumeintegral = [NSString stringWithFormat:@"%@",  goodModel.consumeintegral];
    if (IsNilOrNull(consumeintegral)) {
        consumeintegral = @"+0积分";
    }
     _integralLable.text = [NSString stringWithFormat:@"+%@积分", consumeintegral];
}
@end
