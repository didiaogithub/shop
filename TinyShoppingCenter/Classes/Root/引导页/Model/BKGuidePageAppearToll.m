//
//  BKGuidePageAppearToll.m
//  bestkeep
//
//  Created by Mr. Wu on 16/11/18.
//  Copyright © 2016年 utouu. All rights reserved.
//

#import "BKGuidePageAppearToll.h"
#define BKVersionKey @"version"

#define BKapperKey @"apperKey"//保存指定的版本;

#define BKapperVersion @"3.0.0"  //保存哪个版本引导页更新了,如果没有更新,就不要改,如果更新了,改为当前版本;3.0.0代表从3.0.0开始一直没有更新引导页;
@implementation BKGuidePageAppearToll

+(BOOL)AppearGuidePage{
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    currentVersion = [currentVersion substringToIndex:3];
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:BKVersionKey];
    
    //如果用户安装了
    if (lastVersion.length) {
        //获取上次更新引导页的版本;
        NSString *apper = [[NSUserDefaults standardUserDefaults]objectForKey:BKapperKey];
        //如果指定的版本 等于现在的版本,并且是第一次显示;
        if ([BKapperVersion isEqualToString:currentVersion] && ![apper isEqualToString:BKapperVersion]) {
            [[NSUserDefaults standardUserDefaults]setObject:BKapperVersion forKey:BKapperKey];//保存指定的版本,第二次进入的时候就不需要显示了;
            [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:BKVersionKey];
            return YES;
        }
        
        
        
        //指定的版本不等于现在的版本,不显示;
        else{
            [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:BKVersionKey];
            return NO;
        }
    }
    //如果用户没安装,进入引导页;
    else{
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:BKVersionKey];
         [[NSUserDefaults standardUserDefaults]setObject:BKapperVersion forKey:BKapperKey];//保存指定的版本,第二次进入的时候就不需要显示了;
        return YES;
    }
    
}

@end
