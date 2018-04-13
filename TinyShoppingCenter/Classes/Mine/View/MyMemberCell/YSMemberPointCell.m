//
//  YSMemberPointCell.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/5/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "YSMemberPointCell.h"

@interface YSMemberPointCell ()

@property (nonatomic, strong) UIImageView *imageViwe;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *date;
@property (nonatomic, strong) UILabel *point;

@end

@implementation YSMemberPointCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    _imageViwe = [UIImageView new];
    _imageViwe.image = [UIImage imageNamed:@"defaultover"];
    _imageViwe.layer.cornerRadius = 30;
    _imageViwe.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageViwe];
    
    UILabel *title = [UILabel new];
    title.text = @"类人胶原蛋白";
    title.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_title = title];
    
    _date = [UILabel new];
    _date.text = [NSString stringWithFormat:@"%@", [NSDate date]];
    _date.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_date];
    
    _point = [UILabel new];
    _point.text = @"+10";
    _point.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_point];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    
    [_imageViwe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.equalTo(@60);
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(_imageViwe.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-50);
    }];
    
    [_date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageViwe.mas_right).offset(10);
        make.bottom.equalTo(_imageViwe.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-50);
    }];
    
    [_point mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_title.mas_right).offset(5);
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    UILabel *line = [UILabel creatLineLable];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

-(void)refreshPointWithPointModel:(SCIntegraModel*)integraModel type:(NSString*)type {

    NSString *path = [NSString stringWithFormat:@"%@", integraModel.path];
    if (!IsNilOrNull(path)) {
        
        [_imageViwe sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"defaultover"]];
        _imageViwe.hidden = NO;
        [_imageViwe mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.left.equalTo(self.mas_left).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.width.equalTo(@60);
        }];
        
        [_title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.left.equalTo(_imageViwe.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-50);
        }];
        
        [_date mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageViwe.mas_right).offset(10);
            make.bottom.equalTo(_imageViwe.mas_bottom);
            make.right.equalTo(self.mas_right).offset(-50);
        }];
        
    }else{
        _imageViwe.hidden = YES;
        
        [_title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.left.equalTo(_imageViwe.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-50);
        }];
        
        [_date mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageViwe.mas_right).offset(10);
            make.bottom.equalTo(_imageViwe.mas_bottom);
            make.right.equalTo(self.mas_right).offset(-50);
        }];
    }
    
    if ([type isEqualToString:@"1"]) {
        _point.textColor = CKYS_Color(255, 160, 0);
    }else if ([type isEqualToString:@"2"]){
        _point.textColor = [UIColor tt_redMoneyColor];
    }
    _title.text = [NSString stringWithFormat:@"%@", integraModel.formname];
    _date.text = [NSString stringWithFormat:@"%@", integraModel.time];
    _point.text = [NSString stringWithFormat:@"%@", integraModel.num];

}

@end
