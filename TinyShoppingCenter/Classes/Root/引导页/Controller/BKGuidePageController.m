//
//  BKGuidePageController.m
//  bestkeep
//
//  Created by yons on 16/11/16.
//  Copyright © 2016年 utouu. All rights reserved.
//

#import "BKGuidePageController.h"
#import "BKGuidePageCell.h"
#import "SCLoginViewController.h"
#import "RootNavigationController.h"
#import "CommonLoginViewController.h"



@interface BKGuidePageController ()
@property(nonatomic,strong)UIPageControl *control;

@end

@implementation BKGuidePageController

static NSString * const reuseIdentifier = @"Cell";

static NSString *ID = @"cell";
- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[BKGuidePageCell class] forCellWithReuseIdentifier:ID];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self setUpPageControl];
}
- (void)setUpPageControl
{
    UIPageControl *control = [[UIPageControl alloc] init];
    control.numberOfPages = 3;
    control.pageIndicatorTintColor = [UIColor blackColor];
    control.currentPageIndicatorTintColor = [UIColor redColor];
    control.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 40, CGRectGetWidth(self.view.frame), 20);
    _control = control;
    [_control addTarget:self action:@selector(ChagePage:) forControlEvents:UIControlEventValueChanged];
   // [self.view addSubview:control];
}
-(void)ChagePage:(UIPageControl*)PageControl{
    NSInteger index = PageControl.currentPage;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]    atScrollPosition:0 animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    _control.currentPage = page;
}

#pragma mark - UICollectionView代理和数据源

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BKGuidePageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NSString *imageName = [NSString stringWithFormat:@"guide%ld.jpg",indexPath.row + 1];
    cell.image = [UIImage imageNamed:imageName];
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
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
