//
//  CommunityTableViewCell.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/2/17.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CommunityTableViewCell.h"
@interface CommunityTableViewCell ()<UIScrollViewDelegate>
{
    UIView *_picView;
}
@property(nonatomic,strong)UILabel *noticeLabel;
@end
@implementation CommunityTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    //头像按钮
    _headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_headButton];
    [_headButton setImage:[UIImage imageNamed:@"name"] forState:UIControlStateNormal];
    _headButton.layer.cornerRadius = AdaptedWidth(40)/2;
    _headButton.layer.masksToBounds = YES;
    [_headButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10));
        make.left.mas_offset(AdaptedWidth(10));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(40), AdaptedWidth(40)));
    }];
    [_headButton addTarget:self action:@selector(clickCommunityHead) forControlEvents:UIControlEventTouchUpInside];
    //名称
    _nickNameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_BODYTITLE_FONT];
    [self.contentView addSubview:_nickNameLable];
    _nickNameLable.text = @"昵称";
    [_nickNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headButton.mas_top).offset(5);
        make.left.equalTo(_headButton.mas_right).offset(AdaptedWidth(10));
    }];
    //时间
    _timeLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_timeLable];
    _timeLable.text = @"7月6日 17:29";
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nickNameLable.mas_bottom);
        make.left.equalTo(_nickNameLable.mas_left);
    }];

    //内容
    _contentLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_contentLable];
    _contentLable.numberOfLines = 0;
    _contentLable.text = @"测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容";
    [_contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLable.mas_bottom).offset(5);
        make.left.equalTo(_timeLable.mas_left);
        make.right.mas_offset(-AdaptedWidth(10));
    }];
    
    self.picContainerView = [[PhotoContainerView alloc] initWithWidth:SCREEN_WIDTH - AdaptedWidth(70)];
    [self.contentView addSubview:self.picContainerView];
    [self.picContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLable.mas_bottom).offset(AdaptedHeight(10));
        make.left.equalTo(_nickNameLable.mas_left);
        make.right.mas_offset(-AdaptedWidth(10));
        make.bottom.mas_offset(0);
    }];
    
}
/**点击社区头像按钮*/
-(void)clickCommunityHead{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toSeePersonalCommunity)]) {
        [self.delegate toSeePersonalCommunity];
    }
}
/**刷新 数据*/
-(void)cellRefreshWithArray:(NSMutableArray *)picArray{
    self.pictureArray = picArray;
    CGFloat picContainerH = [self.picContainerView setupPicUrlArray:self.pictureArray];
    [self.picContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(picContainerH);
    }];
 
}


@end
