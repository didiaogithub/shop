//
//  AppDelegate.h
//  MoveShoppingMall
//
//  Created by 庞宏侠 on 17/2/7.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) NSInteger paymentType;
@property (assign, nonatomic) CGFloat headButtonSize;

+ (AppDelegate* )shareAppDelegate;

@end

