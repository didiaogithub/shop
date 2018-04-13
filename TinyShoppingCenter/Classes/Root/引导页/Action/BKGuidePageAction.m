//
//  BKGuidePageAction.m
//  bestkeep
//
//  Created by yons on 16/11/16.
//  Copyright © 2016年 utouu. All rights reserved.
//

#import "BKGuidePageAction.h"
#import "BKGuidePageController.h"
#import "BKGuidePageAppearToll.h"
@implementation BKGuidePageAction

-(id)BKGuideAppear{
    BOOL appear =  [BKGuidePageAppearToll AppearGuidePage];
    if (appear == YES) {
//    BKGuidePageController *con = [[BKGuidePageController alloc]init];
//    [[UIApplication sharedApplication].keyWindow.rootViewController = con presentViewController:con animated:NO completion:nil];
        BKGuidePageController *guideVc = [[BKGuidePageController alloc]init];
//        [UIApplication sharedApplication].keyWindow.rootViewController = guideVc;
//        [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        AppDelegate *app = [AppDelegate shareAppDelegate];
        app.window.rootViewController = guideVc;
        [app.window makeKeyAndVisible];
        return @"1";
    }else{
        return @"0";
    }
}

@end
