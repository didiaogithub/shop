//
//  ScrollCollectionViewCell.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/24.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "ScrollCollectionViewCell.h"
#import "MyIntegralMallViewController.h"
#import "WebDetailViewController.h"
#import "SCMyPrizeViewController.h"
#import "LuckyDrawViewController.h"

@interface ScrollCollectionViewCell ()<SDCycleScrollViewDelegate>

@end

@implementation ScrollCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self createUI];
    }
    return self;
}
-(void)createUI{
    [self setBackgroundColor:[UIColor tt_grayBgColor]];
    
    //头像和名字的背景view
    _bankGroundImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_bankGroundImageView];
    _bankGroundImageView.userInteractionEnabled = YES;
    _bankGroundImageView.backgroundColor = [UIColor tt_redMoneyColor];
    [_bankGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(70);
    }];
    
    //头像
    _headImageView = [[UIImageView alloc] init];
    [_bankGroundImageView addSubview:_headImageView];
    _headImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_headImageView setImage:[UIImage imageNamed:@"name"]];
    _headImageView.layer.cornerRadius = AdaptedHeight(40)/2;
    _headImageView.clipsToBounds = YES;
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(10);
        make.width.mas_offset(AdaptedHeight(40));
        make.height.mas_offset(AdaptedHeight(40));
    }];
    
    //名字
    _nameLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_bankGroundImageView addSubview:_nameLable];
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView.mas_top).offset(5);
        make.left.equalTo(_headImageView.mas_right).offset(10);
    }];
    
    _noticeLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [_bankGroundImageView addSubview:_noticeLable];
    _noticeLable.hidden = YES;
    [_noticeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLable.mas_bottom).offset(10);
        make.left.equalTo(_nameLable.mas_left);
        make.bottom.equalTo(_headImageView.mas_bottom);
        make.right.mas_offset(-75);
    }];

    //积分按钮
    _prizaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bankGroundImageView addSubview:_prizaButton];
    _prizaButton.backgroundColor = [UIColor orangeColor];
    _prizaButton.clipsToBounds = YES;
    _prizaButton.layer.cornerRadius = 10;
    _prizaButton.titleLabel.font = MAIN_SUBTITLE_FONT;
    [_prizaButton setTitle:@"我的奖品" forState:UIControlStateNormal];
    [_prizaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headImageView.mas_centerY);
        make.right.mas_offset(-10);
        make.width.mas_offset(70);
        make.height.mas_offset(30);
    }];
    [_prizaButton addTarget:self action:@selector(clickIntegralButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    //积分乐园
    UILabel *headerLbale = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:headerLbale];
    headerLbale.text = @"积分乐园";
    headerLbale.backgroundColor = [UIColor tt_grayBgColor];
    [headerLbale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bankGroundImageView.mas_bottom);
        make.left.mas_offset(10);
        make.right.mas_offset(0);
        make.height.mas_offset(40);
    }];
    
    
    self.sdScrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, AdaptedHeight(137)) delegate:self placeholderImage:[UIImage imageNamed:@"waitbanner"]];
    [self addSubview:self.sdScrollview];
    [self.sdScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerLbale.mas_bottom);
        make.left.right.bottom.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(137));
    }];
    
    self.sdScrollview.backgroundColor = [UIColor whiteColor];
    self.sdScrollview.currentPageDotColor = [UIColor redColor];
    self.sdScrollview.pageDotColor = [UIColor lightGrayColor];
    self.sdScrollview.imageURLStringsGroup = self.imageArray;
}

-(void)refreshCellData:(NSMutableArray*)dataArr userModel:(SCUserInfoModel*)userModel{

    self.sdScrollview.imageURLStringsGroup = dataArr;
//    [_bankGroundImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"waitbanner"]];
//
    _nameLable.text = userModel.smallname;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.head] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
    
    NSString *expiringtime = [NSString stringWithFormat:@"%@", userModel.expiringtime];
    if (IsNilOrNull(expiringtime)) {
        expiringtime = @"";
    }
    NSString *expiringintegral = [NSString stringWithFormat:@"%@", userModel.expiringintegral];
    if (IsNilOrNull(expiringintegral) || [expiringintegral integerValue] == 0) {
        [_nameLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headImageView.mas_centerY);
            make.left.equalTo(_headImageView.mas_right).offset(10);
        }];
    }else{
        [_nameLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headImageView.mas_top).offset(5);
            make.left.equalTo(_headImageView.mas_right).offset(10);
        }];
        _noticeLable.hidden = NO;
        _noticeLable.text = [NSString stringWithFormat:@"提醒:%@积分将于%@过期", expiringintegral, expiringtime];
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    [self pushToActive:index];
}
#pragma mark - 首页活动轮播事件
-(void)pushToActive:(NSInteger)index {
    
    MyIntegralMallViewController *mallVC;
    UIResponder *next = self.nextResponder;
    do {
        //判断响应者是否为视图控制器
        if ([next isKindOfClass:[MyIntegralMallViewController class]]) {
            mallVC = (MyIntegralMallViewController*)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    LuckyDrawViewController *detailVC = [[LuckyDrawViewController alloc] init];
    [mallVC.navigationController pushViewController:detailVC animated:YES];
}

-(void)clickIntegralButton{
    MyIntegralMallViewController *mallVC;
    UIResponder *next = self.nextResponder;
    do {
        //判断响应者是否为视图控制器
        if ([next isKindOfClass:[MyIntegralMallViewController class]]) {
            mallVC = (MyIntegralMallViewController*)next;
        }
        next = next.nextResponder;
    } while (next != nil);

    SCMyPrizeViewController *detailVC = [[SCMyPrizeViewController alloc] init];
    [mallVC.navigationController pushViewController:detailVC animated:YES];
}

@end
