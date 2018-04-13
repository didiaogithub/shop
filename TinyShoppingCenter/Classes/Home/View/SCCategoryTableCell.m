//
//  SCCategoryTableCell.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/22.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCCategoryTableCell.h"

@interface SCCategoryTableCell()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *specLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *originalPriceLable;
@property (nonatomic, strong) UILabel *salesLabel;
@property (nonatomic, strong) UIButton *shoppingCar;

@end

@implementation SCCategoryTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize {

    self.backgroundColor = [UIColor whiteColor];
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];

    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self);
    }];
    
    self.imageV = [UIImageView new];
    self.imageV.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:self.imageV];
    _imageV.layer.borderColor = [UIColor tt_lineBgColor].CGColor;
    _imageV.layer.borderWidth = 1;
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_offset(AdaptedWidth(10));
        make.size.mas_equalTo(CGSizeMake(AdaptedWidth(80), AdaptedWidth(80)));
        make.bottom.mas_offset(-AdaptedWidth(10));
    }];
    
    self.nameLabel = [UILabel configureLabelWithTextColor:[UIColor tt_bodyTitleColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:15.0]];
    if (SCREEN_HEIGHT <= 568) {
        self.nameLabel.font = [UIFont systemFontOfSize:14.0];
    }
//    self.nameLabel.numberOfLines = 2;
    [bgView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedWidth(10));
        make.left.equalTo(self.imageV.mas_right).offset(AdaptedWidth(5));
        make.right.mas_offset(-AdaptedWidth(10));
    }];
    
    self.specLabel = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    if (SCREEN_HEIGHT <= 568) {
        self.specLabel.font = [UIFont systemFontOfSize:12.0];
    }
    [bgView addSubview:self.specLabel];
    [self.specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.left.equalTo(self.imageV.mas_right).offset(AdaptedWidth(5));
        make.right.mas_offset(-AdaptedWidth(30));
        make.height.mas_offset(AdaptedWidth(17));

    }];
    
    self.salesLabel = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    if (SCREEN_HEIGHT <= 568) {
        self.salesLabel.font = [UIFont systemFontOfSize:12.0];
    }
    [bgView addSubview:self.salesLabel];
    [self.salesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV.mas_right).offset(AdaptedWidth(5));
        make.right.mas_offset(-AdaptedWidth(30));
        make.bottom.mas_offset(-AdaptedWidth(10));
        make.height.mas_equalTo(AdaptedWidth(17));
    }];
    
    //价格
    self.priceLabel = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:16.0f]];
    if (SCREEN_HEIGHT <= 568) {
        self.priceLabel.font = [UIFont systemFontOfSize:15.0];
    }
    [bgView addSubview:self.priceLabel];
    self.priceLabel.text = @"¥0.00";
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV.mas_right).offset(AdaptedWidth(5));
        make.height.mas_offset(AdaptedWidth(17));
        make.bottom.equalTo(self.salesLabel.mas_top);
    }];
    //原价
    _originalPriceLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [bgView addSubview:_originalPriceLable];
    _originalPriceLable.text = @"(原价0.0)";
    [_originalPriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.priceLabel.mas_bottom);
        make.left.equalTo(self.priceLabel.mas_right).offset(AdaptedWidth(5));
        make.height.mas_offset(AdaptedWidth(13));
    }];
    
    //原价上的线
    UILabel *horizalLine = [[UILabel alloc] init];
    horizalLine.backgroundColor = SubTitleColor;
    [bgView addSubview:horizalLine];
    [horizalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_originalPriceLable.mas_top).offset(6.5);
        make.left.equalTo(_originalPriceLable.mas_left);
        make.right.equalTo(_originalPriceLable.mas_right);
        make.height.mas_offset(1);
    }];
    
    self.shoppingCar = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:self.shoppingCar];
    [self.shoppingCar setImage:[UIImage imageNamed:@"cateShoppingCar"] forState:UIControlStateNormal];
    [self.shoppingCar addTarget:self action:@selector(addToShoppingCar) forControlEvents:UIControlEventTouchUpInside];
    [self.shoppingCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-AdaptedWidth(10));
        make.bottom.mas_offset(-AdaptedWidth(10));
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UILabel *bottomLine = [UILabel creatLineLable];
    [bgView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_offset(0);
        make.height.mas_equalTo(1);
    }];
}

-(void)addToShoppingCar {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addGoodsToShoppingCar:)]) {
        [self.delegate addGoodsToShoppingCar:_goodsModel];
    }
}

-(void)refreshCellWithModel:(SCCategoryGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:_goodsModel.path1] placeholderImage:[UIImage imageNamed:@"defaultover"]];
    
    NSString *goodsName = [NSString stringWithFormat:@"%@", _goodsModel.name];
    if (IsNilOrNull(goodsName)) {
        goodsName = @"";
    }
    self.nameLabel.text = goodsName;
    
    NSString *spec = [NSString stringWithFormat:@"%@", _goodsModel.spec];
    if (IsNilOrNull(spec)) {
        spec = @"";
    }else{
        spec = [NSString stringWithFormat:@"规格:%@", _goodsModel.spec];
    }
    self.specLabel.text = spec;
    
    NSString *isVip = [NSString stringWithFormat:@"%@", _goodsModel.isvip];
    if ([isVip isEqualToString:@"0"] || [isVip isEqualToString:@"false"]) {
        
        NSString *salesprice = [NSString stringWithFormat:@"%@", _goodsModel.salesprice];
        if (IsNilOrNull(salesprice)) {
            salesprice = @"";
        }else{
            salesprice = [NSString stringWithFormat:@"¥%@", _goodsModel.salesprice];
        }
        _priceLabel.text = salesprice;
        
        NSString *costprice = [NSString stringWithFormat:@"%@", _goodsModel.costprice];
        if (IsNilOrNull(costprice)) {
            costprice = @"";
        }else{
            costprice = [NSString stringWithFormat:@"(VIP%@)", _goodsModel.costprice];
        }
        _originalPriceLable.text = costprice;
        
    }else{
        NSString *salesprice = [NSString stringWithFormat:@"%@", _goodsModel.salesprice];
        if (IsNilOrNull(salesprice)) {
            salesprice = @"";
        }else{
            salesprice = [NSString stringWithFormat:@"¥%@", _goodsModel.salesprice];
        }
        _priceLabel.text = salesprice;
        
        NSString *costprice = [NSString stringWithFormat:@"%@", _goodsModel.costprice];
        if (IsNilOrNull(costprice)) {
            costprice = @"";
        }else{
            costprice = [NSString stringWithFormat:@"(原价%@)", _goodsModel.costprice];
        }
        _originalPriceLable.text = costprice;
    }
    
    NSString *sales = [NSString stringWithFormat:@"%ld", _goodsModel.sales];
    if (IsNilOrNull(sales)) {
        sales = @"";
    }else{
        sales = [NSString stringWithFormat:@"已售%ld", _goodsModel.sales];
    }
    
    self.salesLabel.text = sales;

}


@end
