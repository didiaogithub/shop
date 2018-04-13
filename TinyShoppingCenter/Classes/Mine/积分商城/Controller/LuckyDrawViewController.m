//
//  LuckyDrawViewController.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/26.
//  Copyright © 2017年 ckys. All rights reserved.
//


#import "LuckyDrawViewController.h"
#import "SCMyPrizeViewController.h"
#import "YSMemberPointViewController.h"

@interface LuckyDrawViewController ()<CAAnimationDelegate>

@property (copy, nonatomic)   NSString *strPrise;
@property (strong, nonatomic) UILabel *labPrise;
@property (strong, nonatomic) UIButton *startButton;
@property (strong, nonatomic) UIButton *integralButton;
@property (strong, nonatomic) UIButton *myRewardButton;
@property (strong, nonatomic) UIImageView *zhuanPanImageView;

@end

@implementation LuckyDrawViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"幸运转盘";
    [self createUI];
   
}
-(void)createUI{
    //背景
    UIImageView *imgViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(0,64,SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    imgViewBg.image = [UIImage imageNamed:@"bg.png"];
    imgViewBg.userInteractionEnabled = YES;
    [self.view addSubview:imgViewBg];
    
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 45)];
    [imgViewBg addSubview:topView];
    topView.backgroundColor = CKYS_Color(61, 149, 162);
    
    _integralButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [topView addSubview:_integralButton];
    _integralButton.titleLabel.font = MAIN_TITLE_FONT;
    _integralButton.backgroundColor = CKYS_Color(76,186,202);
    [_integralButton setTitle:@"积分:0" forState:UIControlStateNormal];
    [_integralButton addTarget:self action:@selector(enterMyIntegral) forControlEvents:UIControlEventTouchUpInside];
    [_integralButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_offset(5);
        make.bottom.mas_offset(-5);
        make.width.mas_offset(70);
    }];
    
    _myRewardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [topView addSubview:_myRewardButton];
    _myRewardButton.titleLabel.font = MAIN_TITLE_FONT;
    [_myRewardButton setTitle:@"我的奖品" forState:UIControlStateNormal];
    _myRewardButton.backgroundColor = CKYS_Color(76,186,202);
    [_myRewardButton addTarget:self action:@selector(enterMyPrizeList) forControlEvents:UIControlEventTouchUpInside];
    [_myRewardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(_integralButton);
        make.left.equalTo(_integralButton.mas_right).offset(5);
    }];

   
    //转盘
    _zhuanPanImageView = [[UIImageView alloc] init];
    _zhuanPanImageView.image = [UIImage imageNamed:@"zhuanpan.png"];
    _zhuanPanImageView.userInteractionEnabled = YES;
    [self.view addSubview:_zhuanPanImageView];
    [_zhuanPanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(124);
        make.left.mas_offset((SCREEN_WIDTH-250)/2);
        make.width.mas_offset(250);
        make.height.mas_offset(250);
    }];

    
    //开始或停止按钮
    _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_zhuanPanImageView addSubview:_startButton];
    [_startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_zhuanPanImageView);
        make.width.mas_offset(60);
        make.height.mas_offset(60);
    }];
    [_startButton addTarget:self action:@selector(_startButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 50, 20)];
    v.backgroundColor = [UIColor greenColor];

    [self.view addSubview:v];
    
    
    //底部文字
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_zhuanPanImageView.mas_bottom).offset(30);
        make.left.mas_offset(30);
        make.right.mas_offset(-30);
        make.bottom.mas_offset(-15);
    }];
    UILabel *titleLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [bottomView addSubview:titleLable];
    titleLable.text = @"抽奖规则";
    titleLable.layer.cornerRadius = 5;
    titleLable.clipsToBounds = YES;
    titleLable.backgroundColor = [UIColor tt_redMoneyColor];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.height.mas_offset(30);
    }];
    
    UILabel *textLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bottomView addSubview:textLable];
    textLable.numberOfLines = 0;
    [textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLable.mas_bottom).offset(10);
        make.left.right.equalTo(titleLable);
    }];
    textLable.text = @"关于积分消费:\n1.顾客每次抽奖需要消耗2个积分，扣除积分不退换，每天参与抽奖次数不限。\n关于奖品\n1.奖品由公司根据目前最热销的商品设定。\n2.中奖商品不需要运输，用户可免费获得试用。\n3.中奖商品费用由公司承担。";

}

#pragma mark - 进入我的积分页面
-(void)enterMyIntegral {
    YSMemberPointViewController *point = [[YSMemberPointViewController alloc] init];
    [self.navigationController pushViewController:point animated:YES];
}

#pragma mark - 进入我的奖品列表
-(void)enterMyPrizeList {
    SCMyPrizeViewController *myPrize = [[SCMyPrizeViewController alloc] init];
    [self.navigationController pushViewController:myPrize animated:YES];
}

#pragma mark-开始抽奖
- (void)_startButtonClick
{
    NSInteger angle;
    NSInteger randomNum = arc4random()%100;
    if (randomNum>=91 && randomNum<=99) {
        angle = 300;
        _strPrise = @"一等奖";
    } else if (randomNum>=76 && randomNum<= 90) {
        angle = 60;
        _strPrise = @"二等奖";
    } else if (randomNum >=51 && randomNum<=75) {
        angle = 180;
        _strPrise = @"三等奖";
    } else {
        angle = 240;
        _strPrise = @"没中奖";
    }
    
    _startButton.enabled = NO;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:angle*M_PI/180 ];
    rotationAnimation.duration = 0.5f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.delegate = self;
    rotationAnimation.fillMode=kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    [_zhuanPanImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

//动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [UIView animateWithDuration:2.0
                     animations:^{
                         
                        
                     }
                     completion:^(BOOL finished) {
                         _labPrise.text = [NSString stringWithFormat:@"中奖结果 : %@", _strPrise];
                         _startButton.enabled = YES;
                         
                     }];

}

@end
