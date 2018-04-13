//
//  UserTableViewCell.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/2/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    //头像
    
    _headImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_headImageView];
    [_headImageView setImage:[UIImage imageNamed:@"name"]];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(10);
        make.width.mas_offset(AdaptedWidth(40));
        make.height.mas_offset(AdaptedWidth(40));
    }];
    _headImageView.layer.cornerRadius = AdaptedWidth(40)/2;
    _headImageView.clipsToBounds = YES;
    
    //昵称
    _nickNameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_BODYTITLE_FONT];
    [self.contentView addSubview:_nickNameLable];
    _nickNameLable.text = @"高来宝";
    [_nickNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView.mas_top).offset(5);
        make.left.equalTo(_headImageView.mas_right).offset(10);
    }];
    
    //时间
    _timeLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_timeLable];
    _timeLable.text = @"2月18日 11:28";
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nickNameLable.mas_bottom).offset(5);
        make.left.equalTo(_nickNameLable.mas_left);
    }];
    
    
    //点赞图标
    _likeImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_likeImageView];
    [_likeImageView setImage:[UIImage imageNamed:@"likes"]];
    _likeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nickNameLable.mas_top);
        make.right.mas_offset(-15);
        make.width.mas_offset(30);
        make.height.mas_offset(20);
    }];
    
    //点赞人数
    _likesLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_SUBTITLE_FONT];
    [self.contentView addSubview:_likesLable];
    _likesLable.text = @"100";
    [_likesLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_likeImageView.mas_bottom).offset(5);
        make.right.mas_offset(0);
        make.left.mas_offset(SCREEN_WIDTH-60);
        make.width.mas_offset(60);
    }];
    
    //点赞按钮
    _likesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_likesButton];
    _likesButton.tag = 151;
    [_likesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nickNameLable.mas_top);
        make.right.mas_offset(0);
        make.width.mas_offset(60);
        make.height.mas_offset(60);
    }];
    
    [_likesButton addTarget:self action:@selector(clickUserButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //分享按钮
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_shareButton];
    _shareButton.tag = 150;
    [_shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    _shareButton.imageEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
    [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nickNameLable.mas_top);
        make.right.equalTo(_likeImageView.mas_left).offset(-10);
        make.width.mas_offset(30);
        make.height.mas_offset(50);
    }];
    
    [_shareButton addTarget:self action:@selector(clickUserButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //发表内容
    _contentLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_contentLable];
    _contentLable.numberOfLines = 0;
    _contentLable.text = @"啊说的很适合当回事好好地好好说话或多或";
     [_contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(_headImageView.mas_bottom).offset(10);
         make.left.equalTo(_headImageView.mas_left);
         make.right.mas_offset(-15);
         
     }];
    UILabel *bottomline = [UILabel creatLineLable];
    [self.contentView addSubview:bottomline];
    [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLable.mas_bottom).offset(15);
        make.left.equalTo(_contentLable.mas_left);
        make.height.mas_offset(1);
        make.right.equalTo(_contentLable.mas_right);
        make.bottom.mas_offset(0);
    }];
}
-(void)clickUserButton:(UIButton *)button{
    NSInteger tag = button.tag - 150;
    button.selected = !button.selected;
    if (tag == 0){
        
    }else{
        NSInteger likeCount = [_likesLable.text integerValue];
        if (!button.selected){
            [_likeImageView setImage:[UIImage imageNamed:@"likes"]];
            _likesLable.textColor = TitleColor;
            likeCount --;
        }else{
            [_likeImageView setImage:[UIImage imageNamed:@"likesred"]];
            _likesLable.textColor = [UIColor tt_redMoneyColor];
            likeCount ++;
        }
    
        _likesLable.text = [NSString stringWithFormat:@"%zd",likeCount];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clikCellWithLikesButton:)]) {
        [self.delegate clikCellWithLikesButton:button];
    }
}
@end
