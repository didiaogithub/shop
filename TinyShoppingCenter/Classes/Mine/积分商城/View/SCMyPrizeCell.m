//
//  SCMyPrizeCell.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/9.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCMyPrizeCell.h"

@interface SCMyPrizeCell ()

@property (nonatomic, strong) UIImage *nomalImage;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UILabel *textLable;
/**名称*/
@property (nonatomic, strong) UILabel *nameLable;
/**规格*/
@property (nonatomic, strong) UILabel *standardLable;
@property (nonatomic, strong) UILabel *priceLable;
@property (nonatomic, strong) UILabel *rightNumberLable;

@end

@implementation SCMyPrizeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

-(void)initViews {
    
    int imageWidth = 0;
    if (iphone5) {
        imageWidth = 80;
    }else{
        imageWidth = 100;
    }
    
    _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_selectedButton];
    _nomalImage = [UIImage imageNamed:@"selectedgray"];
    _selectedImage = [UIImage imageNamed:@"selectedred"];
    [_selectedButton setImage:_nomalImage forState:UIControlStateNormal];
    [_selectedButton setImage:_selectedImage forState:UIControlStateSelected];
    [_selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(50*SCREEN_HEIGHT_SCALE);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    [_selectedButton addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
    _iconImageView.userInteractionEnabled = YES;
    _iconImageView.layer.borderColor = [UIColor tt_lineBgColor].CGColor;
    _iconImageView.layer.borderWidth = 1;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_iconImageView setImage:[UIImage imageNamed:@"bkimg"]];
    
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.equalTo(_selectedButton.mas_right).offset(10);
        make.size.mas_offset(CGSizeMake(imageWidth, imageWidth));
    }];
    
    _nameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_nameLable];
    _nameLable.numberOfLines = 0;
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_top);
    make.left.equalTo(_iconImageView.mas_right).offset(10*SCREEN_WIDTH_SCALE);
        make.right.mas_offset(-10);
    }];
    
    //规格
    _textLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    _textLable.text = @"规格：";
    [self.contentView addSubview:_textLable];
    
    [_textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLable.mas_bottom);
        make.left.equalTo(_nameLable.mas_left);
    }];
    
    //规格内容
    _standardLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_standardLable];
    _standardLable.text = @"规格";
    [_standardLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textLable.mas_top);
        make.left.equalTo(_textLable.mas_right);
    }];
    
    //价格
    _priceLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_priceLable];
    _priceLable.text = @"¥0.00";
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_textLable.mas_bottom).offset(15);
        make.left.equalTo(_textLable.mas_left);
        make.bottom.equalTo(_iconImageView.mas_bottom);
    }];
    
    UILabel *textNumber = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    textNumber.text = @"数量：";
    [self.contentView addSubview:textNumber];
    _rightNumberLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_rightNumberLable];
    
    UILabel *lineLable = [UILabel creatLineLable];
    [self.contentView addSubview:lineLable];
    [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(10);
        make.left.right.bottom.mas_offset(0);
        make.height.mas_offset(1);
    }];
}

#pragma mark-点击cell左侧按钮
-(void)clickSelect:(UIButton *)button {
    button.selected = !button.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(singleClick:anRow:andSection:)]){
        [self.delegate singleClick:nil anRow:self.indexRow andSection:self.section];
    }
}
#pragma mark-刷新model数据
-(void)refreshCellWithModel:(SCMyPrizeModel *)prizeModel {

    
//    _selectedButton.selected = prizeModel.selected;
    
    //商品图片
    NSString *imageString = prizeModel.path;
    if (![imageString hasPrefix:@"http"] && !IsNilOrNull(prizeModel.path)) {
        imageString = [BaseImagestr_Url stringByAppendingString:prizeModel.path];
    }
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"defaultover"]];
    // 名称
    NSString *name = [NSString stringWithFormat:@"%@", prizeModel.name];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    _nameLable.text = name;
    
    //价格
    NSString *pricestr = [NSString stringWithFormat:@"%@", prizeModel.costprice];
    if (IsNilOrNull(pricestr)) {
        pricestr = @"";
    }
    _priceLable.text = [NSString stringWithFormat:@"¥%@",pricestr];
    //规格
    NSString *spec = [NSString stringWithFormat:@"%@", prizeModel.spec];
    if (IsNilOrNull(spec)) {
        spec = @"";
    }
    _standardLable.text = spec;
    
    if ([UIScreen mainScreen].bounds.size.width <= 568) {
        _standardLable.font = [UIFont systemFontOfSize:12];
        _textLable.font = [UIFont systemFontOfSize:12];
    }
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
