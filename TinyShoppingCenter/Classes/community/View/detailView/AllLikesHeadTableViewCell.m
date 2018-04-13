//
//  AllLikesHeadTableViewCell.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/2/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "AllLikesHeadTableViewCell.h"

@implementation AllLikesHeadTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    UIView *likesbankView = [[UIView alloc] init];
    [self.contentView addSubview:likesbankView];
    [likesbankView setBackgroundColor:[UIColor whiteColor]];
    [likesbankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(-10);
    }];
    
    
    for (int i=0;i<5;i++) {
        _headImageView = [[UIImageView alloc] init];
        [likesbankView addSubview:_headImageView];
        _headImageView.layer.cornerRadius = AdaptedWidth(30)/2;
        _headImageView.clipsToBounds = YES;
        [_headImageView setImage:[UIImage imageNamed:@"name"]];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(5);
            make.left.mas_offset(5+i*(AdaptedWidth(30)+5));
            make.bottom.mas_offset(-5);
            make.height.mas_offset(AdaptedWidth(30));
            make.width.mas_offset(AdaptedWidth(30));
        }];
    }
    //多少人喜欢
    _likesLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [likesbankView addSubview:_likesLable];
    _likesLable.text = @"356个人赞了~";
    [_likesLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.equalTo(_headImageView.mas_right).offset(15);
    }];
    
//    _rightImageView = [[UIImageView alloc] init];
//    [likesbankView addSubview:_rightImageView];
//    _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [_rightImageView setImage:[UIImage imageNamed:@"rightgray"]];
//    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_offset(25);
//        make.right.mas_offset(-15);
//        make.bottom.mas_offset(-25);
//        make.width.mas_offset(25);
//        make.height.mas_offset(25);
//    }];

}
@end
