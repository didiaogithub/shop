//
//  MineHeaderView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "MineHeaderView.h"

@implementation MineHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUIWithType];
    }
    return self;
}
-(void)createUIWithType{
    
    //先创建背景图片
    UIImageView * topBankmageView = [[UIImageView alloc]init];
    topBankmageView.image = [UIImage imageNamed:@"minebank"];
    [self addSubview:topBankmageView];
    [topBankmageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_offset(0);
    }];
    
    
    _headImageView = [[UIImageView alloc] init];
    [self addSubview:_headImageView];
    [_headImageView setImage:[UIImage imageNamed:@"name"]];
    _headImageView.layer.cornerRadius = AdaptedHeight(50)/2;
    _headImageView.clipsToBounds = YES;
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(15));
        make.left.mas_offset(SCREEN_WIDTH/2-AdaptedHeight(25));
        make.width.mas_offset(AdaptedHeight(50));
        make.height.mas_offset(AdaptedHeight(50));
       
    }];
    
    _nameLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont boldSystemFontOfSize:16.0f]];
    [self addSubview:_nameLable];
    _nameLable.text = @"名字";
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView.mas_bottom).offset(AdaptedHeight(15));
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(20));
    }];
    
}
-(void)clickBackButton{
    [[UIViewController currentVC].navigationController popViewControllerAnimated:YES];
}

@end
