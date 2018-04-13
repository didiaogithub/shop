//
//  CouponsOrderCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/7/6.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "CouponsOrderCell.h"

@interface CouponsOrderCell ()
@end
@implementation CouponsOrderCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    //底层view
    UIView * bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(1);
        make.bottom.mas_offset(-1);
        make.left.right.mas_offset(0);
    }];
    
   //收紧人
    _nickNameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_nickNameLable];
    

    //商品单价
    _priceLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_priceLable];
    
    UILabel *textLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(15))];
    [bankView addSubview:textLable];
    textLable.text = @"订单金额:";
    
    
    [_nickNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(AdaptedWidth(10));
        make.height.mas_offset(50);
    }];

    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_nickNameLable);
        make.right.mas_offset(-AdaptedWidth(15));
    }];
    [textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_nickNameLable);
        make.right.equalTo(_priceLable.mas_left).offset(-10);
    }];
    
    _nickNameLable.text = @"昵称：style";
    _priceLable.text = @"¥890.00";
    
    
    
}

@end
