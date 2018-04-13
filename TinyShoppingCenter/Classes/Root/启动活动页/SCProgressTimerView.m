//
//  SCProgressTimerView.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/31.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCProgressTimerView.h"

#define UIColorMake(r, g, b, a) [UIColor colorWithRed:r / 255. green:g / 255. blue:b / 255. alpha:a]

@interface SCProgressTimerView ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation SCProgressTimerView

-(UILabel *)label{
    if (_label == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        label.textAlignment = NSTextAlignmentCenter;
        label.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        label.backgroundColor = [UIColor blackColor];
        label.layer.cornerRadius = 12.5f;
        label.layer.masksToBounds = YES;
        label.text = @"跳过";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        _label = label;
    }
    return _label;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();//获取上下文对象  只要是用了 CoreGraPhics  就必须创建他
    CGContextSetLineWidth(context, 2);//显然是设置线宽
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);// 设置颜色
    CGContextAddArc(context, self.frame.size.width/2.0, self.frame.size.height/2.0, self.bounds.size.width/2.0 - 5, 0 , self.count/300.0 * 2* M_PI, 0);//这就是画曲线了
    /*
     CGContextAddArc(上下文对象    ,     圆心x,     圆心y,     曲线开始点,    曲线结束点,     半径);
     */
    CGContextStrokePath(context);
}

- (void)time{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(action) userInfo:nil repeats:YES];
}

- (void)action{
    self.count++;//时间累加
    
    if (self.count == 300) {
        //到达时间以后取消定时器
        [self.timer invalidate];
        self.timer = nil;
        if (self.delegate && [self.delegate respondsToSelector:@selector(adTimerStop)]) {
            [self.delegate adTimerStop];
        }
    }
    //倒计时
//    if (self.count%100 == 0) {
//        self.label.text = [NSString stringWithFormat:@"%lds",5 - self.count/100];
//    }
    self.label.text = @"跳过";
    [self setNeedsDisplay];
}

-(void)stop {
    [self.timer invalidate];
    self.timer = nil;
}


@end
