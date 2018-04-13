//
//  PersonalUserInfoTableViewCell.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/3/4.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "PersonalUserInfoTableViewCell.h"

@implementation PersonalUserInfoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    bankView.backgroundColor = [UIColor whiteColor];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.bottom.mas_offset(0);
        make.left.mas_offset(5);
        make.right.mas_offset(-5);
    }];
    
    //头像
    _headImageView = [[UIImageView alloc] init];
    [bankView addSubview:_headImageView];
    [_headImageView setImage:[UIImage imageNamed:@"name"]];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(12);
        make.left.mas_offset(15);
        make.width.mas_offset(50*SCREEN_WIDTH_SCALE);
        make.height.mas_offset(50*SCREEN_WIDTH_SCALE);
    }];
    _headImageView.layer.cornerRadius = 50*SCREEN_WIDTH_SCALE/2;
    _headImageView.clipsToBounds = YES;
    
    //昵称
    _nickNameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_BODYTITLE_FONT];
    [bankView addSubview:_nickNameLable];
    _nickNameLable.text = @"高来宝";
    [_nickNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView.mas_top).offset(5);
        make.left.equalTo(_headImageView.mas_right).offset(13);
    }];
    
    //时间
    _timeLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_timeLable];
    _timeLable.text = @"2月18日 11:28";
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nickNameLable.mas_bottom).offset(8);
        make.left.equalTo(_nickNameLable.mas_left);
    }];
    
    UILabel *horizalLine =[UILabel creatLineLable];
    [bankView addSubview:horizalLine];
    [horizalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView.mas_bottom).offset(12);
        make.left.mas_offset(5);
        make.right.mas_offset(-5);
        make.height.mas_offset(1);
    }];

    //发表内容
    _contentLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_contentLable];
    _contentLable.numberOfLines = 0;
    _contentLable.text = @"啊说的很适合当回事好好地好好说话或多或少的很适合当回事撒好得很撒谎或多或少和电话哈收到货很适合当回事傻乎乎的是";
    [_contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizalLine.mas_bottom).offset(AdaptedHeight(10));
        make.left.equalTo(_headImageView.mas_left);
        make.right.mas_offset(-15);
        make.bottom.mas_offset(-AdaptedHeight(10));
        
    }];

}
@end
