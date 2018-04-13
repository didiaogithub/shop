//
//  SCConfirmOrderAddressCell.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/9/3.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCConfirmOrderAddressCell.h"
#import "ChangeMyAddressViewController.h"

@interface SCConfirmOrderAddressCell()

@property (nonatomic, strong) UIView *bankView;
@property (nonatomic, strong) UIImageView *addressImageView;
@property (nonatomic, strong) UILabel *addressNameLable;
@property (nonatomic, strong) UILabel *addressDetailLable;
@property (nonatomic, strong) UILabel *addressTelPhoneLable;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, strong) UIImageView *defaultImageView;

@end

@implementation SCConfirmOrderAddressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _bankView = [[UIView alloc] init];
    [self.contentView addSubview:_bankView];
    _bankView.backgroundColor = [UIColor whiteColor];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.bottom.mas_offset(-10);
        make.right.mas_offset(0);
    }];
    
    //联系人
    _addressNameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_BODYTITLE_FONT];
    [_bankView addSubview:_addressNameLable];
    _addressNameLable.font = [UIFont boldSystemFontOfSize:16];
    
    
    //联系电话
    _addressTelPhoneLable = [UILabel configureLabelWithTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:MAIN_BODYTITLE_FONT];
    [_bankView addSubview:_addressTelPhoneLable];
    _addressTelPhoneLable.font = [UIFont boldSystemFontOfSize:16];
    
    //电话右边的默认地址图标
    _defaultImageView = [[UIImageView alloc] init];
    [_bankView addSubview:_defaultImageView];
    _defaultImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_defaultImageView setImage:[UIImage imageNamed:@"defaultAddress"]];
    
    //地址图标
    _addressImageView = [[UIImageView alloc] init];
    [_bankView addSubview:_addressImageView];
    UIImage *headimage = [UIImage imageNamed:@"location"];
    _addressImageView.image = [headimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //详细地址
    _addressDetailLable = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_bankView addSubview:_addressDetailLable];
    
    //右箭头图标
    _rightImageView = [[UIImageView alloc] init];
    [_bankView addSubview:_rightImageView];
    _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_rightImageView setImage:[UIImage imageNamed:@"rightdirection"]];
    
    //底边
    _bottomImageView = [[UIImageView alloc] init];
    [_bankView addSubview:_bottomImageView];
    [_bottomImageView setImage:[UIImage imageNamed:@"separateColorLine"]];
    
    
    //联系人
    [_addressNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.mas_offset(30);
    }];
    
    //联系电话
    [_addressTelPhoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressNameLable.mas_top);
        make.left.equalTo(_addressNameLable.mas_right).offset(15);
    }];
    
    [_defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressNameLable.mas_top);
        make.left.equalTo(_addressTelPhoneLable.mas_right).offset(5);
        make.height.mas_offset(20);
        make.width.mas_offset(40);
    }];
    
//    
//    //定位图片
//    [_addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_addressNameLable.mas_bottom).offset(15);
//        make.left.mas_offset(10);
//        make.size.mas_offset(CGSizeMake(17, 20));
//    }];
    
    //选中默认地址
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressNameLable.mas_bottom);
        make.right.mas_offset(-15);
        make.size.mas_offset(CGSizeMake(16, 26));
    }];
    //详细地址
    _addressDetailLable.numberOfLines = 0;
    [_addressDetailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressNameLable.mas_bottom).offset(15);
        make.left.equalTo(_addressNameLable.mas_left);
    }];
    
    //定位图片
    [_addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_addressNameLable.mas_bottom).offset(15);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(17, 20));
        make.centerY.equalTo(_addressDetailLable.mas_centerY);
    }];

    _rightImageView.hidden = NO;
    [_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressDetailLable.mas_bottom).offset(20);
        make.width.mas_offset(SCREEN_WIDTH);
        make.bottom.mas_offset(0);
        make.height.mas_offset(3);
    }];
    
    //底边
    _bottomImageView = [[UIImageView alloc] init];
    [_bankView addSubview:_bottomImageView];
    [_bottomImageView setImage:[UIImage imageNamed:@"separateColorLine"]];
    [_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_offset(0);
        make.height.mas_offset(3);
    }];
}

-(void)refreshWithAddressModel:(AddressModel *)addressModel {
    _addressNameLable.text = [NSString stringWithFormat:@"%@",addressModel.name];
    NSString *address = [NSString stringWithFormat:@"%@",addressModel.area];
    NSString *detaiAddress = [NSString stringWithFormat:@"%@",addressModel.address];
    if(IsNilOrNull(address)){
        address = @"";
    }
    if(IsNilOrNull(detaiAddress)) {
        detaiAddress = @"";
    }
    _addressDetailLable.text = [NSString stringWithFormat:@"%@ %@",address,detaiAddress];
    NSString *mobile = [NSString stringWithFormat:@"%@",addressModel.mobile];
    if (IsNilOrNull(mobile)) {
        mobile = @"";
    }
    _addressTelPhoneLable.text = mobile;
    
    NSString *isdefault = [NSString stringWithFormat:@"%@",addressModel.isdefault];
    if (IsNilOrNull(isdefault)) {
        isdefault = @"";
    }

    [_addressDetailLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-41*SCREEN_WIDTH_SCALE);
    }];
    
    
    if ([isdefault isEqualToString:@"0"] || [isdefault isEqualToString:@"false"]) {
        _defaultImageView.hidden = YES;
    }else{
        _defaultImageView.hidden = NO;
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
