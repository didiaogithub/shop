//
//  LikesTableViewCell.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "LikesTableViewCell.h"

@implementation LikesTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _headImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_headImageView];
    _headImageView.clipsToBounds = YES;
    _headImageView.layer.cornerRadius = 25;
    [_headImageView setImage:[UIImage imageNamed:@"name"]];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(8);
        make.left.mas_offset(15);
        make.height.mas_offset(50);
        make.width.mas_offset(50);
    }];
    
    _nameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_nameLable];
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView.mas_top).offset(12);
        make.left.equalTo(_headImageView.mas_right).offset(20);
        make.right.mas_offset(-10);
    }];
    _nameLable.text = @"测试";
    UILabel *bottomLine = [UILabel creatLineLable];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView.mas_bottom).offset(8);
        make.left.right.bottom.mas_offset(0);
        make.height.mas_offset(1);
    }];
}

@end
