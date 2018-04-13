//
//  SCOrderListCell.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/9.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCOrderListCell.h"

@interface SCOrderListCell()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *textNumber;
@property (nonatomic, strong) UILabel *lineLable;
/**购买商品图标*/
@property (nonatomic, strong) UIImageView *goodsImageView;
/**商品描述*/
@property (nonatomic, strong) UILabel *descriptionLable;
/**商品数量*/
@property (nonatomic, strong) UILabel *numberLable;
/**商品价格*/
@property (nonatomic, strong) UILabel *priceLable;

@end

@implementation SCOrderListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI {
    //底层view
    _bgView = [[UIView alloc] init];
    _bgView.layer.cornerRadius = 5;
    [self.contentView addSubview: _bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    //左边商品图标
    _goodsImageView = [[UIImageView alloc] init];
    _goodsImageView.layer.borderColor = [UIColor tt_lineBgColor].CGColor;
    _goodsImageView.layer.borderWidth = 1;
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_bgView addSubview:_goodsImageView];
    
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(85, 85));
        make.bottom.mas_offset(-10);
    }];
    
    _lineLable = [UILabel creatLineLable];
    [_bgView addSubview:_lineLable];
    
    _descriptionLable = [UILabel configureLabelWithTextColor:CKYS_Color(51, 51, 51) textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_bgView addSubview:_descriptionLable];
    
    
    _textNumber = [UILabel configureLabelWithTextColor:CKYS_Color(157, 158, 159) textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_bgView addSubview: _textNumber];
    _textNumber.text = @"规格：";
    
    //数量
    _numberLable = [UILabel configureLabelWithTextColor:CKYS_Color(77, 77, 78) textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_bgView addSubview:_numberLable];
    //商品单价
    _priceLable = [UILabel configureLabelWithTextColor:CKYS_Color(77, 77, 78) textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_bgView addSubview:_priceLable];
    
}

- (void)refreshWithModel:(SCMyOrderGoodsModel *)model {
    
    NSString *imageStr = [NSString stringWithFormat:@"%@", model.path];
    if (![imageStr hasPrefix:@"http"]) {
        imageStr = [BaseImagestr_Url stringByAppendingString:imageStr];
    }
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"defaultover"]];
    NSString *name = [NSString stringWithFormat:@"%@",model.name];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    _descriptionLable.text = name;
    _descriptionLable.numberOfLines = 2;
    [_descriptionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsImageView.mas_top).offset(10);
        make.left.equalTo(_goodsImageView.mas_right).offset(5);
        make.right.mas_offset(-100);
    }];
    
    //价格
    NSString *priceStr = [NSString stringWithFormat:@"%@",model.price];
    if (IsNilOrNull(priceStr)) {
        priceStr = @"";
    }else{
        priceStr = [NSString stringWithFormat:@"¥%@",model.price];
    }
    _priceLable.text = priceStr;
    
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_descriptionLable.mas_top);
        make.right.mas_offset(-10);
        make.height.equalTo(@(20));
    }];
    
    //数量
    NSString *countStr = [NSString stringWithFormat:@"%@",model.count];
    if (IsNilOrNull(countStr)) {
        countStr = @"";
    }else{
        countStr = [NSString stringWithFormat:@"x%@",model.count];
    }
    _numberLable.text = countStr;
    [_numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20));
        make.right.mas_offset(-10);
        make.bottom.equalTo(_goodsImageView.mas_bottom).offset(-10);
    }];
    
    //规格
    NSString *spec = [NSString stringWithFormat:@"%@", model.spec];
    if (IsNilOrNull(spec)) {
        spec = @"";
    }else{
        spec = [NSString stringWithFormat:@"规格:%@", model.spec];
    }
    _textNumber.text = spec;
    if (IsNilOrNull(name)) {
        [_textNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_goodsImageView.mas_right).offset(5);
            make.bottom.equalTo(_goodsImageView.mas_bottom).offset(-10);
        }];
        
    }else{
        [_textNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(20));
            make.left.equalTo(_goodsImageView.mas_right).offset(5);
            make.bottom.equalTo(_goodsImageView.mas_bottom).offset(-10);
        }];
    }
    
    [_lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(5);
        make.right.mas_offset(-5);
        make.height.mas_offset(1);
        make.bottom.mas_offset(0);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
