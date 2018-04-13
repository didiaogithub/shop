//
//  SCMineTableViewCell.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCMineTableViewCell.h"
#import "SCUserInfoModel.h"

@implementation SCMineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fillData:(id)data {
    
}

-(void)callWithParameter:(id)parameter {
    
}

+(CGFloat)computeHeight:(id)data {
    return 0;
}

@end

@interface SCUserInfoCell()
/**头像背景*/
@property (nonatomic, strong) UIImageView *headBankImageView;
/**头像*/
@property (nonatomic, strong) UIImageView *headImgV;
/**昵称*/
@property (nonatomic, strong) UILabel *nameLable;
/**积分按钮*/
@property (nonatomic, strong) UIButton *integralButton;

@property (nonatomic, strong) SCUserInfoModel *userInfoM;
/**签到按钮*/
@property (nonatomic, strong) UIButton *signUpButton;

@end

@implementation SCUserInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI {
    
    //背景图片
    _headBankImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_headBankImageView];
    UIImage *image = [UIImage imageNamed:@"minebank"];
    
    [_headBankImageView setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [_headBankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    
    //签到按钮
    _signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_signUpButton];
    [_signUpButton setTitle:@"签到" forState:UIControlStateNormal];
    [_signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.right.mas_offset(-10);
        make.size.mas_offset(CGSizeMake(60, 40));
    }];
    [_signUpButton addTarget:self action:@selector(clickSignUpButton) forControlEvents:UIControlEventTouchUpInside];
    
    _headImgV = [UIImageView new];
    [self.contentView addSubview:_headImgV];
    _headImgV.layer.cornerRadius = 60/2;
    _headImgV.clipsToBounds = YES;
    _headImgV.userInteractionEnabled = YES;
    
    NSString *headUrl = [KUserdefaults objectForKey:@"YDSC_USER_HEAD"];
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"name"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadButton)];
    [_headImgV addGestureRecognizer:tap];
    
    [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(30);
        make.left.mas_offset(SCREEN_WIDTH/2 - 60/2);
        make.size.mas_offset(CGSizeMake(60, 60));
    }];
    
    //微信名字
    _nameLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:MAIN_BODYTITLE_FONT];
    [self.contentView addSubview:_nameLable];
    _nameLable.font = [UIFont boldSystemFontOfSize:17];
    _nameLable.text = @" ";
    _nameLable.textAlignment = NSTextAlignmentCenter;
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImgV.mas_bottom).offset(8);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
    }];
    //积分按钮
    _integralButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_integralButton];
    [_integralButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLable.mas_bottom).offset(8);
        make.bottom.mas_offset(-15);
        make.left.mas_offset(SCREEN_WIDTH/2-60);
        make.width.mas_offset(120);
        
    }];
    [_integralButton setTitle:@"积分:0" forState:UIControlStateNormal];
    [_integralButton setBackgroundColor:[UIColor tt_redMoneyColor]];
    _integralButton.titleLabel.font = MAIN_TITLE_FONT;
    _integralButton.layer.cornerRadius = 15;
    _integralButton.layer.masksToBounds = YES;
}

-(void)fillData:(id)data {
    self.userInfoM = data;
    NSString *integral = [NSString stringWithFormat:@"%@", self.userInfoM.integral];
    if (IsNilOrNull(integral)) {
        integral = @"积分:0";
    }
    [_integralButton setTitle:[NSString stringWithFormat:@"积分:%@", integral] forState:UIControlStateNormal];
    
    NSString *headPath = [NSString stringWithFormat:@"%@", self.userInfoM.head];
    if ([headPath hasPrefix:@"http"]) {
        [_headImgV sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:[UIImage imageNamed:@"name"]];
    }
    
    NSString *smallname = [NSString stringWithFormat:@"%@", self.userInfoM.smallname];
    if (IsNilOrNull(smallname)) {
        smallname = @"";
    }
    _nameLable.text = smallname;

}

-(void)clickHeadButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(enterToDetailUserInfo)]) {
        [self.delegate enterToDetailUserInfo];
    }
}

-(void)clickSignUpButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(signUp)]) {
        [self.delegate signUp];
    }
}

@end


@interface SCMineOrderCell ()
/**订单图片*/
@property (nonatomic, strong) UIImageView *orderImageView;
/**我的订单*/
@property (nonatomic, strong) UILabel *orderLable;
/**查看全部订单*/
@property (nonatomic, strong) UILabel *checkAllMyOrderLable;
/**右箭头*/
@property (nonatomic, strong) UIImageView *rightImageView;
/**线*/
@property (nonatomic, strong) UILabel *lineLable;
/**订单相关image*/
@property (nonatomic, strong) UIImageView *statusImageView;
/**订单状态*/
@property (nonatomic, strong) UIButton *statusButton;
/**全部订单按钮*/
@property (nonatomic, strong) UIButton *allOrderButton;

@end

@implementation  SCMineOrderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI {
    //订单图标
    _orderImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_orderImageView];
    _orderImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_orderImageView setImage:[UIImage imageNamed:@"order"]];
    
    [_orderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(15);
        make.size.mas_offset(CGSizeMake(25, 25));
    }];
    //我的订单  lable
    _orderLable = [UILabel configureLabelWithTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_orderLable];
    _orderLable.text = @"我的订单";
    [_orderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderImageView.mas_top).offset(5);
        make.left.equalTo(_orderImageView.mas_right).offset(10);
    }];
    //右箭头
    _rightImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_rightImageView];
    _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_rightImageView setImage:[UIImage imageNamed:@"rightgray"]];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderLable.mas_top);
        make.right.mas_offset(-10);
        make.size.mas_offset(CGSizeMake(10, 15));
    }];
    
    //查看全部订单
    _checkAllMyOrderLable = [UILabel configureLabelWithTextColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_checkAllMyOrderLable];
    _checkAllMyOrderLable.text = @"查看全部订单";
    [_checkAllMyOrderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rightImageView.mas_centerY);
        make.right.equalTo(_rightImageView.mas_left).offset(-3);
    }];
    
    //我的全部订单按钮
    _allOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_allOrderButton];
    _allOrderButton.tag = 24;
    _allOrderButton.backgroundColor = [UIColor clearColor];
    
    [_allOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.height.mas_offset(50);
    }];
    [_allOrderButton addTarget:self action:@selector(clickStatusButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //线
    _lineLable = [UILabel creatLineLable];
    [self.contentView addSubview:_lineLable];
    [_lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(_orderImageView.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    
    
    NSArray *imageArr = @[@"fukuan", @"shouhuo", @"pingjia", @"tuihuo"];
    float spaceW = (SCREEN_WIDTH - 10)/4; //宽
    
    for (int i = 0; i<4; i++) {
        
        UIImage *stutsImage = [UIImage imageNamed:imageArr[i]];
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_statusButton];
        [_statusButton setImage:stutsImage forState:UIControlStateNormal];
        [_statusButton setBackgroundColor:[UIColor clearColor]];
        [_statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_lineLable.mas_bottom);
            make.left.mas_offset(spaceW*i);
            make.height.mas_offset(70);
            make.width.mas_offset(spaceW);
        }];
        _statusButton.tag = 20+i;
        [_statusButton addTarget:self action:@selector(clickStatusButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}
#pragma mark-点击订单状态button
-(void)clickStatusButton:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(enterOrderListWithType:)]) {
        [self.delegate enterOrderListWithType:button.tag];
    }
}

@end


@interface SCMineFunctionCell()

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *minefunctionLable;

@end

@implementation SCMineFunctionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI {
    
    _leftImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_leftImageView];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.mas_offset(15);
        make.size.mas_offset(CGSizeMake(25, 20));
    }];
    _minefunctionLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_minefunctionLable];
    
    
    [_minefunctionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImageView.mas_right).offset(15);
        make.centerY.equalTo(_leftImageView.mas_centerY);
    }];
    UILabel *lineLabale = [UILabel creatLineLable];
    [self.contentView addSubview:lineLabale];
    [lineLabale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_minefunctionLable.mas_bottom);
        make.left.mas_offset(15);
        make.bottom.mas_offset(0);
    }];
}

-(void)fillData:(id)data {
    NSDictionary *dict = data;
    
    _leftImageView.image = [UIImage imageNamed:dict[@"image"]];
    _minefunctionLable.text = dict[@"title"];
}

@end
