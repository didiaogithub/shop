//
//  SCGoodsDetailConfirmOrderCell.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCGoodsDetailConfirmOrderCell.h"
#import "CKC_CustomProgressView.h"

@interface SCGoodsDetailConfirmOrderCell ()
/**图片*/
@property(nonatomic,strong)UIImageView *iconImageView;
/**名称*/
@property(nonatomic,strong)UILabel *nameLable;
/**规格*/
@property(nonatomic,strong)UILabel *standardLable;
/**价格*/
@property(nonatomic,strong)UILabel *priceLable;
/**数量*/
@property(nonatomic,strong)UILabel *rightNumberLable;
/**积分数量*/
@property(nonatomic,strong)UILabel *integtalLabel;

@property (nonatomic, strong) UILabel *buyNumberLabel;
@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) UIButton *reduceButton;
@property (nonatomic, strong) UILabel *countLable;
@property (nonatomic, assign) NSInteger chooseCount;
@property (nonatomic, strong) UIView *countView;
@property (nonatomic, strong) CKC_CustomProgressView *loadingView;
@property (nonatomic, strong) JGProgressHUD *viewNetError;

@property (nonatomic, copy) NSString *limitnum;
@property (nonatomic, strong) UILabel *bottomLine;

@end

@implementation SCGoodsDetailConfirmOrderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponents];
    }
    return self;
}

-(void)initComponents {
    
    self.loadingView = [[CKC_CustomProgressView alloc] init];
    self.viewNetError = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.viewNetError.indicatorView = nil;
    self.viewNetError.userInteractionEnabled = NO;
    self.viewNetError.position = JGProgressHUDPositionBottomCenter;
    self.viewNetError.marginInsets = UIEdgeInsetsMake(0, 0, 60, 0);
    
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
    
    [_iconImageView setImage:[UIImage imageNamed:@"bkimg"]];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.mas_offset(10);
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
    
    //价格
    _priceLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
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
    _integtalLabel.text = @" ";
    [_integtalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLable.mas_bottom).offset(3);
        make.right.mas_offset(-5);
        make.height.equalTo(@(20));
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
    
    _rightNumberLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_rightNumberLable];
    _rightNumberLable.text = @"x1";    
    [_rightNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20));
        make.right.mas_offset(-5);
        make.bottom.equalTo(_iconImageView.mas_bottom).offset(-10);
    }];
    
    UILabel *lineLable = [UILabel creatLineLable];
    [self.contentView addSubview:lineLable];
    [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(10);
        make.left.right.mas_offset(0);
        make.height.mas_offset(1);
    }];
    
    _buyNumberLabel =  [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    _buyNumberLabel.text = @"购买数量:";
    [self.contentView addSubview:_buyNumberLabel];
    [_buyNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(11);
        make.left.mas_offset(10);
        make.bottom.mas_offset(0);
        make.height.equalTo(@(50));
    }];
    
    _countView = [[UIView alloc] init];
    [self.contentView addSubview:_countView];
    _countView.layer.cornerRadius = 3;
    _countView.layer.borderWidth = 1;
    _countView.layer.borderColor = CKYS_Color(130, 130, 130).CGColor;
    
    //减号按钮
    _reduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_countView addSubview:_reduceButton];
    _reduceButton.tag = 1111;
    [_reduceButton setTitle:@"-" forState:UIControlStateNormal];
    [_reduceButton setTitleColor:CKYS_Color(130, 130, 130) forState:UIControlStateNormal];
    
    //数字
    _countLable = [UILabel configureLabelWithTextColor:CKYS_Color(130, 130, 130) textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [_countView addSubview:_countLable];
    
    [_countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.centerY.equalTo(_buyNumberLabel.mas_centerY);
        make.size.mas_offset(CGSizeMake(110, 30));
    }];
    
    
    [_reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(35, 30));
    }];
    [_reduceButton addTarget:self action:@selector(clickCountButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _countLable.text = @"1";
    _countLable.layer.borderWidth = 1;
    _countLable.layer.borderColor = CKYS_Color(130, 130, 130).CGColor;
    [_countLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(33);
        make.size.mas_offset(CGSizeMake(40, 30));
    }];
    
    //加号按钮
    _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_countView addSubview:_plusButton];
    _plusButton.tag = 1112;
    [_plusButton setTitle:@"+" forState:UIControlStateNormal];
    [_plusButton setTitleColor:CKYS_Color(130, 130, 130) forState:UIControlStateNormal];
    [_plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_reduceButton.mas_top);
        make.left.equalTo(_countLable.mas_right);
        make.size.equalTo(_reduceButton);
    }];
    [_plusButton addTarget:self action:@selector(clickCountButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _bottomLine = [UILabel creatLineLable];
    [self.contentView addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_offset(1);
    }];
}


#pragma mark-点击减号 和加号 按钮
-(void)clickCountButton:(UIButton *)button{
    if (self.chooseCount == 0) {
        self.chooseCount = 1;

    }
    if (button.tag == 1111) { //减号
        if ((self.chooseCount - 1) <= 0 || self.chooseCount == 0) {
            self.chooseCount = 1;
        }else{
            self.chooseCount  = self.chooseCount -1;
        }
    }else{
        
        if (!IsNilOrNull(self.limitnum)) {
            if (self.chooseCount == [self.limitnum integerValue]) {
                NSString *limitTip = [NSString stringWithFormat:@"活动商品，最多购买%@件", self.limitnum];
                [self showNoticeView:limitTip];
                return;
            }
        }
        
        if (self.chooseCount  > 100 || self.chooseCount == 100) {
            self.chooseCount  = 99;
        }else{
            self.chooseCount  = self.chooseCount +1;
        }
    }
    _countLable.text = [NSString stringWithFormat:@"%zd", self.chooseCount];
    _rightNumberLable.text = [NSString stringWithFormat:@"x%zd", self.chooseCount];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GDConfrimOrderChangeBuyCount" object:nil userInfo:@{@"BuyCount":_countLable.text}];
}

-(void)refreshCellWithGoodsDict:(NSDictionary *)goodsDict limitnum:(NSString*)limitnum {
    
    _limitnum = limitnum;
    
    if (!IsNilOrNull(_limitnum) && ([_limitnum integerValue] == 1)) {
        _buyNumberLabel.hidden = YES;
        _countView.hidden = YES;
        _bottomLine.hidden = YES;
        int imageWidth = 0;
        if (iphone5) {
            imageWidth = 80;
        }else{
            imageWidth = 100;
        }
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(15);
            make.left.mas_offset(10);
            make.size.mas_offset(CGSizeMake(imageWidth, imageWidth));
            make.bottom.mas_offset(-15);
        }];
        
        [_buyNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
        [_countView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
        
    }else{
        _buyNumberLabel.hidden = NO;
        _countView.hidden = NO;
        _bottomLine.hidden = NO;
        int imageWidth = 0;
        if (iphone5) {
            imageWidth = 80;
        }else{
            imageWidth = 100;
        }
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(15);
            make.left.mas_offset(10);
            make.size.mas_offset(CGSizeMake(imageWidth, imageWidth));
        }];
        
        [_buyNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_iconImageView.mas_bottom).offset(11);
            make.left.mas_offset(10);
            make.bottom.mas_offset(0);
            make.height.equalTo(@(50));
        }];
        
        [_countView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.centerY.equalTo(_buyNumberLabel.mas_centerY);
            make.size.mas_offset(CGSizeMake(110, 30));
        }];
    }
    
    //商品图片
    NSString *imageString = [NSString stringWithFormat:@"%@", goodsDict[@"path"]];
    if (![imageString hasPrefix:@"http"]) {
        imageString = [BaseImagestr_Url stringByAppendingString:imageString];
    }
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"defaultover"]];
    // 名称
    NSString *name = [NSString stringWithFormat:@"%@", goodsDict[@"name"]];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    _nameLable.text = name;
    
    NSString *salesprice = [NSString stringWithFormat:@"%@", goodsDict[@"salesprice"]];
    if (IsNilOrNull(salesprice)) {
        salesprice = @"";
    }else{
        salesprice = [NSString stringWithFormat:@"¥%@", goodsDict[@"salesprice"]];
    }
    _priceLable.text = salesprice;
    
    NSString *integral = [NSString stringWithFormat:@"%@", goodsDict[@"integral"]];
    if (IsNilOrNull(integral) || [integral isEqualToString:@"0"]) {
        integral = @"";
    }else{
        integral = [NSString stringWithFormat:@"%@积分", goodsDict[@"integral"]];
    }
    _integtalLabel.text = integral;
    
    _rightNumberLable.text = @"x1";
    //规格
    NSString *spec = [NSString stringWithFormat:@"%@",goodsDict[@"spec"]];
    if (IsNilOrNull(spec)) {
        spec = @"";
    }else{
        spec = [NSString stringWithFormat:@"规格:%@",goodsDict[@"spec"]];
    }
    _standardLable.text = spec;
}

- (void)showNoticeView:(NSString*)title {
    if (self.viewNetError && !self.viewNetError.visible) {
        self.viewNetError.textLabel.text = title;
        [self.viewNetError showInView:[UIApplication sharedApplication].keyWindow];
        [self.viewNetError dismissAfterDelay:1.0f];
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


@interface SCConfirmOrderOtherMsgCell()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *leftLable;
@property (nonatomic, strong) UIView *integralView;
@property (nonatomic, strong) UILabel *useIntegral;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIView *couponView;
@property (nonatomic, strong) UILabel *couponLabel;
@property (nonatomic, strong) UILabel *couponCanUseL;
@property (nonatomic, strong) UILabel *couponPriceLabel;
@property (nonatomic, strong) UIImageView *rightArrow;


@end

@implementation SCConfirmOrderOtherMsgCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponents];
    }
    return self;
}

-(void)initComponents {
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTotalMoney:) name:@"GDConfrimOrderChangeBuyCount" object:nil];
    
    self.backgroundColor = [UIColor tt_grayBgColor];
    
    UIView *numView = [[UIView alloc] init];
    [self.contentView addSubview:numView];
    numView.backgroundColor = [UIColor whiteColor];
    
    UILabel *numLeftLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [numView addSubview:numLeftLable];
    numLeftLable.text = @"购买数量:";
    
    UIView *countView = [[UIView alloc] init];
    [numView addSubview:countView];
    countView.layer.cornerRadius = 3;
    countView.layer.borderWidth = 1;
    countView.layer.borderColor = [UIColor tt_grayBgColor].CGColor;
    
    UIImageView *boderImageView = [[UIImageView alloc] init];
    [countView addSubview:boderImageView];
    [boderImageView setImage:[UIImage imageNamed:@"numberborder"]];
    
    
    //配送方式
    _topView = [[UIView alloc] init];
    [self.contentView addSubview:_topView];
    _topView.backgroundColor = [UIColor whiteColor];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(45);
    }];
    
    _leftLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_topView addSubview:_leftLable];
    _leftLable.text = @"配送方式:";
    [_leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(10);
    }];
    
    _logistLabale = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_topView addSubview:_logistLabale];
    _logistLabale.text = @"快递 免运费";
    [_logistLabale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_leftLable);
        make.right.mas_offset(-10);
    }];
    
    //优惠券
    self.couponView = [[UIView alloc] init];
    [self.contentView addSubview:self.couponView];
    self.couponView.backgroundColor = [UIColor whiteColor];
    [self.couponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).offset(1);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(45);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCoupon)];
    [self.couponView addGestureRecognizer:tap];
    
    self.countLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.couponView addSubview:self.countLable];
    self.countLable.text = @"优惠券:";
    [self.countLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(60);
        make.left.mas_offset(10);
    }];
    
    self.couponCanUseL = [UILabel new];
    [self.couponView addSubview:self.couponCanUseL];
    self.couponCanUseL.text = @" 0张可用 ";
    self.couponCanUseL.textColor = [UIColor whiteColor];
    self.couponCanUseL.layer.cornerRadius = 2.0;
    self.couponCanUseL.layer.masksToBounds = YES;
    self.couponCanUseL.backgroundColor = [UIColor tt_redMoneyColor];
    [self.couponCanUseL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.couponLabel.mas_centerY);
        make.left.equalTo(self.countLable.mas_right).offset(2);
    }];
    
    self.rightArrow = [UIImageView new];
    self.rightArrow.userInteractionEnabled = YES;
    self.rightArrow.image = [UIImage imageNamed:@"rightgray"];
    [self.couponView addSubview:self.rightArrow];
    [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.couponLabel.mas_centerY);
        make.right.mas_offset(-10);
        make.width.mas_equalTo(10);
    }];
    
    self.couponPriceLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    self.couponPriceLabel.text = @"未使用";
    [self.couponView addSubview:self.couponPriceLabel];
    [self.couponPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.couponLabel.mas_centerY);
        make.right.equalTo(self.rightArrow.mas_left).offset(-5);
        make.width.mas_equalTo(100);
    }];
    
    //积分
    _integralView = [[UIView alloc] init];
    [self.contentView addSubview:_integralView];
    _integralView.backgroundColor = [UIColor whiteColor];
    [_integralView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.couponView.mas_bottom).offset(1);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(45);
    }];
    _useIntegral = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_integralView addSubview:_useIntegral];
    _useIntegral.text = @"使用积分:";
    [_useIntegral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(10);
    }];
    
    _costIntegralLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_integralView addSubview:_costIntegralLabel];
    _costIntegralLabel.text = @"  ";
    [_costIntegralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_useIntegral);
        make.right.mas_offset(-10);
    }];
    
    _bottomView = [[UIView alloc] init];
    [self.contentView addSubview:_bottomView];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.couponView.mas_bottom).offset(47);
        make.left.right.height.equalTo(_topView);
        make.bottom.mas_offset(0);
    }];
    
    _priceLabale = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_bottomView addSubview:_priceLabale];
    [_priceLabale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.right.mas_offset(-10);
    }];
    
    _priceLabale.text = @"共0件商品 合计:¥0.00";
    
}

#pragma mark-刷新金额
-(void)refreshCellWithCount:(NSInteger)count money:(NSString *)allMoney{
    _priceLabale.text = [NSString stringWithFormat:@"共%ld件商品 合计:¥%@", count, allMoney];
}

#pragma mark-刷新积分
-(void)refreshIntegralCellWithIntegral:(NSString *)integral {
    _costIntegralLabel.text = [NSString stringWithFormat:@"%@积分", integral];
}

-(void)refreshCouponAndMoney:(NSString*)couponMoney usablecount:(NSString*)usablecount {
    if (!IsNilOrNull(couponMoney)) {
        self.couponPriceLabel.text = [NSString stringWithFormat:@"-%@", couponMoney];
        self.couponPriceLabel.textColor = [UIColor tt_redMoneyColor];
    }else{
        self.couponPriceLabel.textColor = TitleColor;
        self.couponPriceLabel.text = @"未使用";
    }
    
    if (IsNilOrNull(usablecount)) {
        usablecount = @"0";
    }
    self.couponCanUseL.text = [NSString stringWithFormat:@" %@张可用 ", usablecount];
}

-(void)setDict:(NSDictionary*)goodsDict {
    self.goodsDict = goodsDict;
    
    NSString *integral = [NSString stringWithFormat:@"%@", self.goodsDict[@"integral"]];
    if (IsNilOrNull(integral) || [integral isEqualToString:@"0"]) {
        _couponView.hidden = NO;
        _costIntegralLabel.text = @"0";
        _integralView.hidden = YES;
        [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.couponView.mas_bottom).offset(1);
            make.left.right.height.equalTo(_topView);
            make.bottom.mas_offset(0);
        }];
        [_priceLabale mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
            make.right.mas_offset(-10);
        }];
        
    }else{
        _couponView.hidden = YES;
        //积分
        _integralView.hidden = NO;
        [_integralView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom).offset(1);
            make.left.right.mas_offset(0);
            make.height.mas_equalTo(45);
        }];
        [_useIntegral mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
            make.left.mas_offset(10);
        }];
        [_costIntegralLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_useIntegral);
            make.right.mas_offset(-10);
        }];
        
        
        [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom).offset(47);
            make.left.right.height.equalTo(_topView);
            make.bottom.mas_offset(0);
        }];
        
        [_priceLabale mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
            make.right.mas_offset(-10);
        }];
    }
    
}

-(void)changeTotalMoney:(NSNotification*)userInfo {
    
    NSDictionary *buyCountDic = userInfo.userInfo;
    NSString *count = [NSString stringWithFormat:@"%@", buyCountDic[@"BuyCount"]];
    
    //    NSString *money = money = [NSString stringWithFormat:@"%@", self.goodsDict[@"salesprice"]];
    //    if (IsNilOrNull(money)) {
    //        money = @"0";
    //    }
    //
    //    double totalMoney = [money doubleValue] * [count integerValue];
    //    _priceLabale.text = [NSString stringWithFormat:@"共%@件商品 合计:¥%.2f", count, totalMoney];
    
    NSString *integral = [NSString stringWithFormat:@"%@", self.goodsDict[@"integral"]];
    if (IsNilOrNull(integral) || [integral isEqualToString:@"0"]) {
        integral = @"0";
    }else{
        NSInteger totalIntegral = [integral integerValue] * [count integerValue];
        _costIntegralLabel.text = [NSString stringWithFormat:@"%ld积分", totalIntegral];
    }
}

-(void)chooseCoupon {
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsDetailConfirmOrderChooseCoupon)]) {
        [self.delegate goodsDetailConfirmOrderChooseCoupon];
    }
}

@end
