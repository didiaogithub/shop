//
//  SCEverydayGuideVC.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/14.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCEverydayGuideVC.h"
#import "SDCycleScrollView.h"
#import "CommonLoginViewController.h"
#import "SCLoginViewController.h"
#import "RootNavigationController.h"

@interface SCEverydayGuideVC()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end

@implementation SCEverydayGuideVC

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
}

-(void)initUI {
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _myScrollView.showsVerticalScrollIndicator = NO;
    _myScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_myScrollView];
    
    UIImage *image = [[UIImage alloc] init];
    if (SCREEN_HEIGHT < 568) {
        image = [UIImage imageNamed:@"iphone4.png"];
    }else if(SCREEN_HEIGHT == 568){
        image = [UIImage imageNamed:@"iphone5.png"];
    }else if(SCREEN_HEIGHT == 667){
        image = [UIImage imageNamed:@"iphone6.png"];
    }else if(SCREEN_HEIGHT == 736){
        image = [UIImage imageNamed:@"iphone7p.png"];
    }else if(SCREEN_HEIGHT == 812){
        image = [UIImage imageNamed:@"iphoneX.png"];
    }
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self placeholderImage:image];
    
    self.cycleScrollView.backgroundColor = [UIColor whiteColor];
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    self.cycleScrollView.autoScroll = NO;
    self.cycleScrollView.infiniteLoop = NO;
    self.cycleScrollView.imageURLStringsGroup = _imageArray;
    [self.myScrollView addSubview:self.cycleScrollView];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    if (index == _imageArray.count - 1) {
        NSString *iosCheckCode = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"IOS_CheckCode"]];
        if ([iosCheckCode isEqualToString:@"200"]) {
            [self normalLaunchApp];
        }else{
            [self showCheckLoginView];
        }
    }
}

-(void)normalLaunchApp {
    NSString *str = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:KloginStatus]];
    if (IsNilOrNull(str)) {
        [self goWelcom];
    }else{
        [self enterFirstPage];
    }
}

-(void)showCheckLoginView {
    NSLog(@"去注册登录吧");
    CommonLoginViewController *login = [[CommonLoginViewController alloc] init];
    RootNavigationController *loginNavi = [[RootNavigationController alloc] initWithRootViewController:login];
//    [UIApplication sharedApplication].keyWindow.rootViewController = loginNavi;
//    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    AppDelegate *app = [AppDelegate shareAppDelegate];
    app.window.rootViewController = loginNavi;
    [app.window makeKeyAndVisible];
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

@end
