//
//  SCCommentListHeaderView.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCCommentListHeaderView.h"

@interface SCCommentListHeaderView ()

@property (nonatomic, strong) UIView *bankView;

@end

@implementation SCCommentListHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self createUIView];
    }
    return self;
}

-(void)createUIView {
    
    _bankView = [[UIView alloc] init];
    [self addSubview:_bankView];
    _bankView.backgroundColor = [UIColor whiteColor];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(-5);
    }];
    
    UILabel * textLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:15]];
    [_bankView addSubview:textLable];
    textLable.text = @"综合评分";
    [textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.mas_offset(0);
        make.right.mas_offset(-SCREEN_WIDTH/2);
    }];
    
    _scoreLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:17]];
    [_bankView addSubview:_scoreLable];
    _scoreLable.text = @"5.0";
    
    [_scoreLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLable.mas_bottom).offset(8);
        make.left.right.equalTo(textLable);
        make.bottom.mas_offset(-15);
    }];
    
    //右边的线
    UILabel *lineLable = [UILabel creatLineLable];
    [_bankView addSubview:lineLable];
    [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(5);
        make.bottom.mas_offset(-5);
        make.left.equalTo(textLable.mas_right);
        make.width.mas_offset(1);
    }];
}

-(void)realoadView:(NSString*)commentScore {
    _scoreLable.text = commentScore;
    float leftX = (SCREEN_WIDTH/2-120)/2;
    _starView = [[StarEvaluateView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+leftX,20,120, 50) starIndex:[commentScore integerValue] starWidth:20 space:5.f defaultImage:[UIImage imageNamed:@"bigstargray"] lightImage:[UIImage imageNamed:@"bigstarred"] isCanTap:NO];
    [_bankView addSubview:_starView];
    
}

@end
