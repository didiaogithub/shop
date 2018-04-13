//
//  SCJPushMsgAlertView.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2018/1/31.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "SCJPushMsgAlertView.h"

@interface SCJPushMsgAlertView ()
{
    CGFloat Padding;
}

@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

#define AlertH SCREEN_HEIGHT/5*2.0
//#define Padding 30

@implementation SCJPushMsgAlertView

+(instancetype)shareInstance {
    static SCJPushMsgAlertView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SCJPushMsgAlertView alloc] initPrivate];
    });
    return instance;
}

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        [self initComponent];
    }
    return self;
}

-(void)initComponent {
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    //最外层view
    
    Padding = 30;
    
    self.bigView = [[UIView alloc]init];
    [self addSubview:self.bigView];
    self.bigView.backgroundColor = [UIColor whiteColor];
    self.bigView.layer.cornerRadius = 5;
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(Padding);
        make.right.mas_offset(-Padding);
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(AlertH);
    }];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.confirmBtn];
    [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:TitleColor forState:UIControlStateNormal];
    self.confirmBtn.layer.cornerRadius = 20.0;
    self.confirmBtn.layer.masksToBounds = YES;
    [self.confirmBtn addTarget:self action:@selector(dismissFFAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bigView.mas_bottom).offset(-10);
        make.right.equalTo(self.bigView.mas_right).offset(-20);
        make.left.equalTo(self.bigView.mas_left).offset(20);
        make.height.mas_equalTo(40);
    }];
    
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.bigView addSubview:self.contentScrollView];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(Padding);
        make.right.equalTo(self.mas_right).offset(-Padding);
        make.top.equalTo(self.bigView.mas_top).offset(15);
        make.bottom.equalTo(self.confirmBtn.mas_top).offset(-10);
    }];
    
    
    self.contentLabel = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"#666666"] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:15]];
    [self.contentScrollView addSubview:self.contentLabel];
    self.contentLabel.numberOfLines = 0;
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScrollView.mas_top);
        make.left.equalTo(self.mas_left).offset(Padding+10);
        make.right.equalTo(self.mas_right).offset(-Padding-10);
    }];
    
}

-(void)dismissFFAlertView {
    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)showJPushMsgAlert:(NSString*)content {
    
    CGSize s = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2*(Padding+10), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    self.contentScrollView.contentSize = CGSizeMake(0, s.height);
    self.contentLabel.text = content;
    
    [self.bigView layoutIfNeeded];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        self.alpha = 1;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _bigView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

@end
