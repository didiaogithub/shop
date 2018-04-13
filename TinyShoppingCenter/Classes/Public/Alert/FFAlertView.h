//
//  FFAlertView.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/12/14.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFAlertView : UIView

+(instancetype)shareInstance;

-(void)showAlert:(NSString *)title;

-(void)showAlert:(NSString *)title content:(NSString*)content;

@end
