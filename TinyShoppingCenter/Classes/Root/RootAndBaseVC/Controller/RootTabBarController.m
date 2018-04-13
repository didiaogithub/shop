//
//  RootTabBarController.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/22.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "RootTabBarController.h"
#import "RootNavigationController.h"
#import "SCCommon.h"
#import "SCFirstPageViewController.h" /**首页*/
#import "MessageViewController.h" /**消息*/
#import "CommunityViewController.h" /**社区*/
#import "SCShoppingCarViewController.h" /**购物车*/
#import "SCMineViewController.h" /**我*/
#import "RCloudManager.h"
#import "SCFirstPageModel.h"

#define RootTabBarItemBadgeRadius 7.5f

@interface RootTabBarItem : UITabBarItem

@end

@implementation RootTabBarItem {
@private
    NSString *_rootTabBarBadgeValue;
    UILabel *_rootTabBarBadgeLabel;
}

-(NSString *)badgeValue {
    return _rootTabBarBadgeValue;
}

-(void)setBadgeValue:(NSString *)badgeValue {
    _rootTabBarBadgeValue = badgeValue;
    [self updateBadgeViewLayout];
}

-(void)updateBadgeViewLayout {
    
    NSString *viewKey = @"view";
    
    if(![SCCommon isVariableWithClass:[UITabBarItem class] varName:viewKey]) {
        return;
    }
    
    UIView *view = [self valueForKey:viewKey];
    if(!view) {
        return;
    }
    
    if(!_rootTabBarBadgeLabel) {
        _rootTabBarBadgeLabel = [[UILabel alloc] init];
        _rootTabBarBadgeLabel.backgroundColor = [UIColor redColor];
        _rootTabBarBadgeLabel.textColor = [UIColor whiteColor];
        _rootTabBarBadgeLabel.textAlignment = NSTextAlignmentCenter;
        _rootTabBarBadgeLabel.font = [UIFont systemFontOfSize:9];
        _rootTabBarBadgeLabel.layer.masksToBounds = YES;
        _rootTabBarBadgeLabel.layer.cornerRadius = RootTabBarItemBadgeRadius;
        if(view.superview) {
            [view.superview addSubview:_rootTabBarBadgeLabel];
        }
    }
    
    BOOL isHiden = _rootTabBarBadgeValue ? NO : YES;
    _rootTabBarBadgeLabel.hidden = isHiden;
    
    if(!isHiden) {
        _rootTabBarBadgeLabel.text = _rootTabBarBadgeValue;
        CGFloat minX = CGRectGetMinX(view.frame) + CGRectGetWidth(view.frame) / 2 + self.imageInsets.left + RootTabBarItemBadgeRadius;
        CGRect frame = CGRectMake(minX, 4, RootTabBarItemBadgeRadius * 2, RootTabBarItemBadgeRadius * 2);
        _rootTabBarBadgeLabel.frame = frame;
    }
}

@end

@interface RootTabBarController ()<UITabBarControllerDelegate>

@end

@implementation RootTabBarController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeComponent];
}

-(void)initializeComponent {
    // 首页
    SCFirstPageViewController *firstPage = [[SCFirstPageViewController alloc] init];
    firstPage.tabBarItem = [[RootTabBarItem alloc] init];
    firstPage.tabBarItem.image = [self imageOriginal:@"tab1"];
    firstPage.tabBarItem.selectedImage = [self imageOriginal:@"tab1red"];
    [firstPage.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    RootNavigationController *firstPageNavi = [[RootNavigationController alloc] initWithRootViewController:firstPage];
    
    // 消息
    MessageViewController *message = [[MessageViewController alloc] init];
    message.tabBarItem = [[RootTabBarItem alloc] init];
    message.tabBarItem.image = [self imageOriginal:@"tab2"];
    message.tabBarItem.selectedImage = [self imageOriginal:@"tab2red"];
    [message.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    RootNavigationController *msgNavi = [[RootNavigationController alloc] initWithRootViewController:message];
    
    //社区 暂时屏蔽此功能
    CommunityViewController *community = [[CommunityViewController alloc] init];
    community.tabBarItem = [[RootTabBarItem alloc] init];
    community.tabBarItem.tag = 2;
    community.tabBarItem.image = [self imageOriginal:@"logoIcon"];
    community.tabBarItem.selectedImage = [self imageOriginal:@"logoIcon"];
    [community.tabBarItem setImageInsets:UIEdgeInsetsMake(-5, 0, 5, 0)];
    
    
    RootNavigationController *communityNavi = [[RootNavigationController alloc] initWithRootViewController:community];
    //购物车
    SCShoppingCarViewController *shoppingCar = [[SCShoppingCarViewController alloc] init];
    shoppingCar.tabBarItem = [[RootTabBarItem alloc] init];
    shoppingCar.tabBarItem.image = [self imageOriginal:@"tab4"];
    shoppingCar.tabBarItem.selectedImage = [self imageOriginal:@"tab4red"];
    [shoppingCar.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    RootNavigationController *shoppingCarNavi = [[RootNavigationController alloc] initWithRootViewController:shoppingCar];
    
    //我
    SCMineViewController *mine= [[SCMineViewController alloc] init];
    mine.tabBarItem = [[RootTabBarItem alloc] init];
    mine.tabBarItem.image = [self imageOriginal:@"tab5"];
    mine.tabBarItem.selectedImage = [self imageOriginal:@"tab5red"];
    [mine.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    RootNavigationController *mineNavi = [[RootNavigationController alloc] initWithRootViewController:mine];
    
    self.delegate = self;
    [self setViewControllers:@[firstPageNavi, msgNavi, communityNavi, shoppingCarNavi, mineNavi]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openChatVC) name:@"openChatViewController" object:nil];
     
}

-(UIImage*)imageOriginal:(NSString*)name {
    UIImage *image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    if (viewController == [tabBarController.viewControllers objectAtIndex:2]) {
        return NO;
    }else if(viewController == [tabBarController.viewControllers objectAtIndex:1]){
        
        [[SCEnterRCloudOrToothManager manager] enterRCloudOrTooth];
    
        return NO;
    }
    return YES;
}

-(void)openChatVC {
    RLMResults *result = [SCFirstPageModel objectsWhere:@"firstPageKey = '1'"];
    SCFirstPageModel *firstPageM = result.firstObject;
    NSString *ckid = [NSString stringWithFormat:@"%@", firstPageM.ckInfoM.ckid];
    NSString *smallname = [NSString stringWithFormat:@"%@", firstPageM.ckInfoM.smallname];
    if (IsNilOrNull(smallname)) {
        smallname = @"";
    }
    NSString *head = [NSString stringWithFormat:@"%@", firstPageM.ckInfoM.logopath];
    if(IsNilOrNull(head)){
        head = [NSString stringWithFormat:@"%@%@",WebServiceAPI,DefaultHeadPath];
    }
    
    
    ChatMessageViewController *chatVC = [[ChatMessageViewController alloc] init];
    chatVC.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID
    chatVC.targetId = ckid;
    chatVC.titleString = smallname;
    chatVC.headUrl = head;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:chatVC] animated:YES completion:^{
        
    }];
}


#pragma -mark Autorotate

-(BOOL)shouldAutorotate {
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {

    return UIInterfaceOrientationPortrait;
}

#pragma -mark dealloc
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
