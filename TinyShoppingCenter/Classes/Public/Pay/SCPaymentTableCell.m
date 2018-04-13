//
//  SCPaymentTableCell.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCPaymentTableCell.h"

@implementation SCPaymentTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI {
    
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(1);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    _leftIamgeView = [[UIImageView alloc] init];
    [bankView addSubview:_leftIamgeView];
    _leftIamgeView.contentMode = UIViewContentModeScaleAspectFit;
    [_leftIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(15));
        make.left.mas_offset(15);
        make.bottom.mas_offset(-AdaptedHeight(15));
    }];
    
    //选择按钮
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:_rightButton];
    _rightButton.userInteractionEnabled = NO;
    
    [_rightButton setImage:[UIImage imageNamed:@"giftwhite"] forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"selectedred"] forState:UIControlStateSelected];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.bottom.mas_offset(0);
        make.right.mas_offset(-AdaptedWidth(30));
        make.width.mas_offset(AdaptedWidth(30));
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
