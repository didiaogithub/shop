//
//  SobotManager.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SobotManager : NSObject

+(instancetype)shareInstance;

-(void)registerSobot:(UIApplication *)application;

-(void)startSobotCustomerService;

@end
