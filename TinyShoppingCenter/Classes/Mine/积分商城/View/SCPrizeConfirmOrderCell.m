//
//  SCPrizeConfirmOrderCell.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/14.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCPrizeConfirmOrderCell.h"

@interface SCPrizeConfirmOrderCell ()
/**图片*/
@property (nonatomic, strong) UIImageView *iconImageView;
/**名称*/
@property (nonatomic, strong) UILabel *nameLable;
/**规格*/
@property (nonatomic, strong) UILabel *standardLable;
/**价格*/
@property (nonatomic, strong) UILabel *priceLable;
/**数量*/
@property (nonatomic, strong) UILabel *rightNumberLable;
/**积分数量*/
@property (nonatomic, strong) UILabel *integtalLabel;

@end

@implementation SCPrizeConfirmOrderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponents];
    }
    return self;
}

-(void)initComponents {
    
    int imageWidth = 0;
    if (iphone5) {
        imageWidth = 80;
    }else{
        imageWidth = 100;
    }
    
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
    _iconImageView.userInteractionEnabled = YES;
    _iconImageView.layer.borderColor = [UIColor tt_lineBgColor].CGColor;
    _iconImageView.layer.borderWidth = 1;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_iconImageView setImage:[UIImage imageNamed:@"defaultover"]];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.size.mas_offset(CGSizeMake(imageWidth, imageWidth));
    }];
    
    _nameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_nameLable];
    _nameLable.numberOfLines = 2;
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_top).offset(10);
        make.left.equalTo(_iconImageView.mas_right).offset(5);
        make.right.mas_offset(-100);
    }];
    
    //规格内容
    _standardLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_standardLable];
    _standardLable.text = @"规格";
    [_standardLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20));
        make.left.equalTo(_iconImageView.mas_right).offset(5);
        make.bottom.equalTo(_iconImageView.mas_bottom).offset(-10);
    }];
    
    //价格
    _priceLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_priceLable];
    _priceLable.text = @"¥0.00";
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLable.mas_top);
        make.right.mas_offset(-5);
        make.height.equalTo(@(20));
    }];
    
    //积分数量
    _integtalLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_integtalLabel];
    _integtalLabel.text = @"0积分";
    [_integtalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLable.mas_bottom).offset(3);
        make.right.mas_offset(-5);
        make.height.equalTo(@(20));
    }];
    
    
    _rightNumberLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_rightNumberLable];
    [_rightNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20));
        make.right.mas_offset(-5);
        make.bottom.equalTo(_iconImageView.mas_bottom).offset(-10);
    }];
    
    UILabel *lineLable = [UILabel creatLineLable];
    [self.contentView addSubview:lineLable];
    [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(10);
        make.left.right.bottom.mas_offset(0);
        make.height.mas_offset(1);
    }];
}

-(void)setModel:(SCMyPrizeModel *)model {
    
    _goodModel = model;
    //商品图片
    NSString *imageString = [NSString stringWithFormat:@"%@",model.path];
    if (![imageString hasPrefix:@"http"]) {
        imageString = [BaseImagestr_Url stringByAppendingString:model.path];
    }
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"defaultover"]];
    // 名称
    NSString *name = [NSString stringWithFormat:@"%@",model.name];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    _nameLable.text = name;
    
    //价格
    NSString *pricestr = [NSString stringWithFormat:@"%@",model.costprice];
    if (IsNilOrNull(pricestr)) {
        pricestr = @"";
    }else{
        pricestr = [NSString stringWithFormat:@"¥%@",model.costprice];
    }
    _priceLable.text = pricestr;
    
    NSString *count = [NSString stringWithFormat:@"%@",model.num];
    if (IsNilOrNull(count)) {
        count = @"";
    }else{
        count = [NSString stringWithFormat:@"x%@",model.num];
    }
    
    _rightNumberLable.text = count;
    //规格
    NSString *spec = [NSString stringWithFormat:@"%@",model.spec];
    if (IsNilOrNull(spec)) {
        spec = @"";
    }else{
        spec = [NSString stringWithFormat:@"规格:%@",model.spec];
    }
    _standardLable.text = spec;
    
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


@interface SCPrizeConfirmOrderOtherMsgCell()

@end

@implementation SCPrizeConfirmOrderOtherMsgCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponents];
    }
    return self;
}

-(void)initComponents {
    
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
    countView.layer.borderColor = [UIColor tt_lineBgColor].CGColor;
    
    UIImageView *boderImageView = [[UIImageView alloc] init];
    [countView addSubview:boderImageView];
    [boderImageView setImage:[UIImage imageNamed:@"numberborder"]];
    
    
    //配送方式
    UIView *topView = [[UIView alloc] init];
    [self.contentView addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(45);
    }];
    
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
    
    
    UIView *bottomView = [[UIView alloc] init];
    [self.contentView addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(1);
        make.left.right.height.equalTo(topView);
        make.bottom.mas_offset(0);
    }];
    
    _priceLabale = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bottomView addSubview:_priceLabale];
    [_priceLabale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.right.mas_offset(-10);
    }];
    
    _priceLabale.text = @"共0件商品 合计:¥0.00";
    
}

#pragma mark-刷新
-(void)refreshCellWithCount:(NSInteger)count money:(NSString *)allMoney{
    
    if (IsNilOrNull(allMoney)) {
        allMoney = @"0.00";
    }
    _priceLabale.text = [NSString stringWithFormat:@"共%ld件商品 %@", count, allMoney];
    
}

-(void)changeTotalMoney:(NSNotification*)userInfo {
    
    NSDictionary *buyCountDic = userInfo.userInfo;
    NSString *count = [NSString stringWithFormat:@"%@", buyCountDic[@"BuyCount"]];
    
    NSString *money = [NSString stringWithFormat:@"%@", self.goodsDict[@"salesprice"]];
    if (IsNilOrNull(money)) {
        money = @"0";
    }
    
    double totalMoney = [money doubleValue] * [count integerValue];
    _priceLabale.text = [NSString stringWithFormat:@"共%@件商品 %.2f", count, totalMoney];
}

@end

