//
//  LogistFirstTableViewCell.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "LogistFirstTableViewCell.h"

@implementation LogistFirstTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    _payLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_payLable];
    _payLable.text = @"支付方式:";
    [_payLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.mas_offset(15);
    }];
    
    _companyLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_companyLable];
    _companyLable.text = @"物流公司:";
    [_companyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_payLable.mas_bottom).offset(8);
        make.left.equalTo(_payLable.mas_left);
    }];
    
    
    _logistLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_logistLable];
    _logistLable.text = @"物流单号:";
    [_logistLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_companyLable.mas_bottom).offset(8);
        make.left.equalTo(_payLable.mas_left);
    }];
    UILabel *grayLable = [[UILabel alloc] init];
    [self.contentView addSubview:grayLable];
    grayLable.backgroundColor = [UIColor tt_grayBgColor];
    [grayLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logistLable.mas_bottom).offset(20);
        make.left.right.mas_offset(0);
        make.height.mas_offset(10);
        make.bottom.mas_offset(0);
    }];
}

-(void)refreshLogistWithModel:(LogistModel*)logistModel {
    NSString *pay = [NSString stringWithFormat:@"%@", logistModel.payment];
    NSString *company = [NSString stringWithFormat:@"%@", logistModel.transname];
    NSString *transno = [NSString stringWithFormat:@"%@", logistModel.transno];

    if (IsNilOrNull(pay)) {
        pay = @"";
    }
    if (IsNilOrNull(company)) {
        company = @"";
    }
    if (IsNilOrNull(transno)) {
        transno = @"";
    }
    
    _payLable.text = [NSString stringWithFormat:@"支付方式:%@", pay];
    _companyLable.text = [NSString stringWithFormat:@"物流公司:%@", company];
    _logistLable.text = [NSString stringWithFormat:@"物流单号:%@", transno];

}

@end
