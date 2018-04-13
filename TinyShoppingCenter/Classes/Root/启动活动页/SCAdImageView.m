//
//  SCAdImageView.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/31.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCAdImageView.h"
#import "SCProgressTimerView.h"
#import "RootNavigationController.h"
#import "SCLoginViewController.h"

@interface SCAdImageView()<ADTimerDelegate>
{
    SCProgressTimerView *timer1;
}


@end

@implementation SCAdImageView

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        
    }
    return self;
}

+(instancetype)shareInstance {
    static SCAdImageView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[SCAdImageView alloc] initPrivate];
    });
    return instance;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

#pragma mark - PUBLIC METHODS
- (void)startShowingPage {
    [self addWindowAction];
}

-(void)addWindowAction{
    
    timer1 = [[SCProgressTimerView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 25, 40, 40)];
    timer1.count = 0;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:timer1];
    timer1.delegate = self;
    [timer1 time];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 25, 50, 50)];
    [btn addTarget:self action:@selector(enterMainPage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushPage)];
    [self addGestureRecognizer:tap];
    
}

-(void)enterMainPage {
    [self stopProgress];

}

-(void)adTimerStop {
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeAdViewFromWindow)]) {
        [self.delegate removeAdViewFromWindow];
    }
}

-(void)pushPage {
    
    NSString *link = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_AD_link"]];
    NSString *itemid = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_AD_itemid"]];
    NSString *activeid = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_AD_activityid"]];

    
    if (!IsNilOrNull(activeid) && ![activeid isEqualToString:@"0"]) {
        if (IsNilOrNull(link)) {
            
        }else{
            [timer1 stop];
            
            [KUserdefaults setObject:@"YES" forKey:@"YDSC_CLICKED_AD"];
            
            NSString *str = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:KloginStatus]];
            if (IsNilOrNull(str)) {
                [self goWelcom];
            }else{
                [self enterFirstPage];
            }
        }
    }else{
        if(!IsNilOrNull(itemid) && ![itemid isEqualToString:@"0"]){
            [timer1 stop];
            
            [KUserdefaults setObject:@"YES" forKey:@"YDSC_CLICKED_AD"];
            
            NSString *str = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:KloginStatus]];
            if (IsNilOrNull(str)) {
                [self goWelcom];
            }else{
                [self enterFirstPage];
            }
        }else{
            if (IsNilOrNull(link)) {
                
            }else{
                [timer1 stop];
                
                [KUserdefaults setObject:@"YES" forKey:@"YDSC_CLICKED_AD"];
                
                NSString *str = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:KloginStatus]];
                if (IsNilOrNull(str)) {
                    [self goWelcom];
                }else{
                    [self enterFirstPage];
                }
            }
        }
    }
}


-(void)goWelcom{
    SCLoginViewController *welcome =[[SCLoginViewController alloc] init];
    RootNavigationController *welcomeNav = [[RootNavigationController alloc] initWithRootViewController:welcome];
//    [UIApplication sharedApplication].keyWindow.rootViewController = welcomeNav;
//    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    AppDelegate *app = [AppDelegate shareAppDelegate];
    app.window.rootViewController = welcomeNav;
    [app.window makeKeyAndVisible];
}

-(void)enterFirstPage {
    RootTabBarController *rootVC = [[RootTabBarController alloc]init];
//    [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
//    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    AppDelegate *app = [AppDelegate shareAppDelegate];
    app.window.rootViewController = rootVC;
    [app.window makeKeyAndVisible];
}


- (void)stopProgress {
    [timer1 stop];
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeAdViewFromWindow)]) {
        [self.delegate removeAdViewFromWindow];
    }
}

@end
