//
//  SCAdGoodsViewController.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/31.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCAdGoodsViewController.h"
#import "SCAdImageView.h"
#import "SCLoginViewController.h"
#import "RootNavigationController.h"

@interface SCAdGoodsViewController ()<ADImageViewDelegate>

@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) SCAdImageView *imageV;

@end

@implementation SCAdGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
    
}

-(void)initUI {
    _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _imgV.backgroundColor = [UIColor whiteColor];
    _imgV.image = [UIImage imageNamed:@"launchBg.jpg"];
    _imgV.userInteractionEnabled = YES;
    [self.view addSubview:_imgV];
    
    _imageV = [[SCAdImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AdaptedHeight(450))];
    _imageV.userInteractionEnabled = YES;
    
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *imgPath = [documentsDirectoryPath stringByAppendingString:@"/MyImage.jpg"];
    NSData *data = [NSData dataWithContentsOfFile:imgPath];
    UIImage *img = [UIImage imageWithData:data];
    
    _imageV.image = img;
    _imageV.delegate = self;
    [_imageV startShowingPage];
    [_imgV addSubview:_imageV];
}

-(void)removeAdViewFromWindow {
    
    NSString *str = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:KloginStatus]];
    if (IsNilOrNull(str)) {
        [self goWelcom];
    }else{
        [self enterFirstPage];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
