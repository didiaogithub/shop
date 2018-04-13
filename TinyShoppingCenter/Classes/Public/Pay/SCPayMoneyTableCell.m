//
//  SCPayMoneyTableCell.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCPayMoneyTableCell.h"

@implementation SCPayMoneyTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _textLable = [UILabel configureLabelWithTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font: [UIFont systemFontOfSize:15.0]];
    [self.contentView addSubview:_textLable];
    [_textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_offset(15);
        make.size.mas_offset(CGSizeMake(110, 20));
    }];
    _textLable.text = @"待支付金额：";
    
    _moneyLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:20.0]];
    [self.contentView addSubview:_moneyLable];
    [_moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_offset(-AdaptedWidth(30));
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH - 50-60, 18));
    }];
    //分割彩线
    _sepeImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_sepeImageView];
    UIImage *sepeImage = [UIImage imageNamed:@"separateColorLine"];
    [_sepeImageView setImage:sepeImage];
    [_sepeImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(0);
        make.left.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH);
        make.height.mas_offset(3);
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
