//
//  CommunityComentTableViewCell.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/2/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CommunityComentTableViewCell.h"

@implementation CommunityComentTableViewCell
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
    _headImageView.layer.cornerRadius = 20*SCREEN_WIDTH_SCALE;
    _headImageView.clipsToBounds = YES;
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.mas_offset(15);
        make.width.mas_offset(40*SCREEN_WIDTH_SCALE);
        make.height.mas_offset(40*SCREEN_WIDTH_SCALE);
    }];
    [_headImageView setImage:[UIImage imageNamed:@"name"]];
    //昵称
    _nickNameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_nickNameLable];
    _nickNameLable.text = @"一小妞";
    [_nickNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView.mas_top).offset(5);
        make.left.equalTo(_headImageView.mas_right).offset(10);
        
    }];
    
    //时间
    _timeLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [self.contentView addSubview:_timeLable];
    _timeLable.text = @"今天 12：30";
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nickNameLable.mas_bottom).offset(5);
        make.left.equalTo(_nickNameLable.mas_left);
        
    }];
    //内容
    _commentLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_commentLable];
    _commentLable.numberOfLines = 0;
    _commentLable.text = @"腾讯体育2月27日讯 2017斯诺克单局限时赛战罢后，迎来新排名节点。";
    [_commentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLable.mas_bottom).offset(5);
        make.left.equalTo(_nickNameLable.mas_left);
        make.bottom.mas_offset(-15);
        make.right.mas_offset(-15);
        
    }];

    //点赞图标
    _likesButton = [[UIButton alloc] init];
    [self.contentView addSubview:_likesButton];
    _likesButton.titleLabel.font = CHINESE_SYSTEM(AdaptedHeight(11));
    _likesButton.tag = 152;
    _likesButton.titleLabel.text = @"10";
    [_likesButton setImage:[UIImage imageNamed:@"likes"] forState:UIControlStateNormal];
    [_likesButton setImage:[UIImage imageNamed:@"likesred"] forState:UIControlStateSelected];
    
    _likesButton.contentMode = UIViewContentModeScaleAspectFit;
    [_likesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nickNameLable.mas_top);
        make.right.mas_offset(-15);
        make.width.mas_offset(60);
        make.height.mas_offset(30);
    }];
    [_likesButton addTarget:self action:@selector(clickLikesButton:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)clickLikesButton:(UIButton *)button{
    button.selected = !button.selected;
    
    NSInteger likeCount = [_likesButton.titleLabel.text integerValue];
    if (!button.selected){
        [_likesButton setImage:[UIImage imageNamed:@"likes"] forState:UIControlStateNormal];
        [_likesButton setTitleColor:TitleColor forState:UIControlStateNormal];
    
        likeCount --;
    }else{
        [_likesButton setImage:[UIImage imageNamed:@"likesred"] forState:UIControlStateNormal];
        [_likesButton setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];
        likeCount ++;
    }
    [_likesButton setTitle:[NSString stringWithFormat:@"%zd",likeCount] forState:UIControlStateNormal];

    //    NSDictionary * pramaDic = @{@"ckid":@"",@"itemid":@"",@"openid":@""};
    //        if(!likesButton.selected)//点赞
    //        {
    //            NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,@""];
    //            [HttpTool postWithUrl:loveItemUrl params:pramaDic success:^(id json) {
    //                NSDictionary *dic = json;
    //                NSString * status = [dic valueForKey:@"code"];
    //                if ([status intValue] != 200) {
    //                    [self showNoticeView:[dic valueForKey:@"codeinfo"]];
    //                    return ;
    //                }
    //                [likesButton setImage:[UIImage imageNamed:@"likesred"] forState:UIControlStateSelected];
    //                likesButton.selected = YES;
    //                NSLog(@"收藏成功");
    //                //取消收藏成功刷新数据
    //
    //            } failure:^(NSError *error) {
    //                [self showNoticeView:@"网络出错了"];
    //
    //            }];
    //
    //        }else
    //        {
    //            NSString *deloveItemUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,@""];
    //            [HttpTool postWithUrl:deloveItemUrl params:pramaDic success:^(id json) {
    //                NSDictionary *dic = json;
    //                NSString * status = [dic valueForKey:@"code"];
    //                if ([status intValue] != 200) {
    //                    [self showNoticeView:[dic valueForKey:@"codeinfo"]];
    //                    return ;
    //                }
    //                [likesButton setImage:[UIImage imageNamed:@"likes"] forState:UIControlStateNormal];
    //                NSLog(@"取消点赞成功");
    //                likesButton.selected = NO;
    //
    //            } failure:^(NSError *error) {
    //                [self showNoticeView:@"网络出错了"];
    //            }];
    //        }
    
    
}
-(void)cellrefreshWithCommentModel:(CommentModel *)commentModel{



}
@end
