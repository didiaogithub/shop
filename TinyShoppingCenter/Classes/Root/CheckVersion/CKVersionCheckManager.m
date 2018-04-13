//
//  CKVersionCheckManager.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/13.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKVersionCheckManager.h"
#import "CKCUpdateAlertView.h"

@interface CKVersionCheckManager()<UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertView *updateAlert;

@end

@implementation CKVersionCheckManager

+(instancetype)shareInstance {
    static CKVersionCheckManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CKVersionCheckManager alloc] initPrivate];
    });
    
    return instance;
}

-(instancetype)initPrivate {
    self = [super init];
    if (self) {

    }
    return self;
}

-(void)checkVersion {
    //服务器的版本
    NSString *serviceVersion = [KUserdefaults objectForKey:ServerVersion];
    NSString *forceUpdate = [KUserdefaults objectForKey:Forceupdate];

    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (IsNilOrNull(serviceVersion) || [currentVersion isEqualToString:serviceVersion]) {
        [self requestServiceVersion:^(NSString *latestVersion, NSString *force){
            [self compareVersion:latestVersion forceUpdate:force];
        }];
    }else if([currentVersion compare:serviceVersion] == NSOrderedAscending){
        NSString *appmallverinfo = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_updateInfo"]];
        if (IsNilOrNull(appmallverinfo)) {
            [self requestServiceVersion:^(NSString *latestVersion, NSString *force){
                [self compareVersion:latestVersion forceUpdate:force];
            }];
        }else{
            [self showUpdateAlert:forceUpdate];
        }
    }else{
        
    }
}

-(void)compareVersion:(NSString*)serviceVersion forceUpdate:(NSString*)forceUpdate {
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    if ([currentVersion isEqualToString:serviceVersion]) {
        //如果是第一次安装或者更新的，清除所有缓存，清除已请求的服务器版本号；
        if ([self isFirstLoadCurrentVersion]) {
            
//            [[DefaultValue shareInstance] defaultValue];
//            [[CacheManager shareInstance] cleanAllCacheData];
            [KUserdefaults removeObjectForKey:ServerVersion];
        }else{
            if (!IsNilOrNull(currentVersion)) {
                [KUserdefaults setObject:currentVersion forKey:CKLastVersionKey];
            }
        }
    }else if([currentVersion compare:serviceVersion] == NSOrderedAscending){
        [self showUpdateAlert:forceUpdate];
    }else{
    
    }
}

-(void)requestServiceVersion:(void(^)(NSString *serviceVersion, NSString *force))serviceVersionBlock {
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, PayMethodUrl];
    
    [HttpTool getWithUrl:requestUrl params:nil success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            return ;
        }
        
        //优惠券有效时长
        NSString *coupontime = [NSString stringWithFormat:@"%@", dict[@"coupontime"]];
        if (IsNilOrNull(coupontime)) {
            coupontime = @"600";
        }
        [KUserdefaults setObject:coupontime forKey:@"YDSC_coupontime"];
        
        //是否开放推荐有奖功能
        NSString *couponbgurl = [NSString stringWithFormat:@"%@", dict[@"couponbgurl"]];
        if (IsNilOrNull(couponbgurl)) {
            couponbgurl = @"";
        }
        [KUserdefaults setObject:couponbgurl forKey:@"YDSC_couponbgurl"];
        
        
        //警告提示信息
        NSString *payalertmsg = [NSString stringWithFormat:@"%@", dict[@"payalertmsg"]];
        if (IsNilOrNull(payalertmsg)) {
            payalertmsg = @"";
        }
        [KUserdefaults setObject:payalertmsg forKey:@"payalertmsg"];
        
        //是否显示积分商城
        NSString *mallintegralshow = [dict objectForKey:@"mallintegralshow"];
        if (!IsNilOrNull(mallintegralshow)) {
            [KUserdefaults setObject:mallintegralshow forKey:MallintegralShowOrNot];
        }
        
        //是否显示消息中心
        NSString *appmallmsg = [dict objectForKey:@"appmallmsg"];
        if (!IsNilOrNull(appmallmsg)) {
            [KUserdefaults setObject:appmallmsg forKey:@"YDSC_msgShow"];
        }
        
        NSString *ckappdownloadmsg = [dict objectForKey:@"ckappdownloadmsg"];
        if (!IsNilOrNull(ckappdownloadmsg)) {
            [KUserdefaults setObject:ckappdownloadmsg forKey:@"BecomeCKMsg"];
        }
        
        NSString *ckappiosver = [dict objectForKey:@"malliosversion"];
        if (!IsNilOrNull(ckappiosver)) {
            [KUserdefaults setObject:ckappiosver forKey:ServerVersion];
        }
        
        NSString *ckappiosforce = [dict objectForKey:@"malliosforce"];
        if (!IsNilOrNull(ckappiosforce)) {
            [KUserdefaults setObject:ckappiosforce forKey:Forceupdate];
        }
        
        NSString *appmallverinfo = [dict objectForKey:@"appmallverinfo"];
        if (!IsNilOrNull(appmallverinfo)) {
            [KUserdefaults setObject:appmallverinfo forKey:@"YDSC_updateInfo"];
        }
        
        NSString *downLoadUrl = [NSString stringWithFormat:@"%@",dict[@"malldownloadurl"]];
        if (IsNilOrNull(downLoadUrl)) {
            downLoadUrl = @"https://itunes.apple.com/cn/app/id1164737320";
        }
        [KUserdefaults setObject:downLoadUrl forKey:AppStoreUrl];
        [KUserdefaults synchronize];
        
        [self updateDomain:dict];
        
        if (!IsNilOrNull(ckappiosver)) {
            serviceVersionBlock(ckappiosver, ckappiosforce);
        }
        
    } failure:^(NSError *error) {

    }];
    
}

-(void)showUpdateAlert:(NSString*)forceUpdate {
    
    NSString *appmallverinfo = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_updateInfo"]];
    if (IsNilOrNull(appmallverinfo)) {
        appmallverinfo = @"";
    }
    
    if([forceUpdate isEqualToString:@"1"]){
        [[CKCUpdateAlertView shareInstance] showUpdateAlert:appmallverinfo forceUpdate:YES];
    }else{
        [[CKCUpdateAlertView shareInstance] showUpdateAlert:appmallverinfo forceUpdate:NO];
    }
    
//    NSString *appStr = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:AppStoreUrl]];
//    NSURL *appUrl = [NSURL URLWithString:appStr];
//    if([forceUpdate isEqualToString:@"1"]){
//        //弹窗提示用户有新版本，只能选择去更新，不能进行其他操作，即使重启，弹窗也在。也只能去更新
//        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"更新提示" message:@"发现新版本,请前往更新!" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction * action = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            UIViewController *vc = [[UIApplication sharedApplication].keyWindow rootViewController];
//            [vc presentViewController:alertVC animated:YES completion:nil];
//            [[UIApplication sharedApplication] openURL:appUrl];
//        }];
//
//        [alertVC addAction:action];
//        UIViewController *vc = [[UIApplication sharedApplication].keyWindow rootViewController];
//        [vc presentViewController:alertVC animated:YES completion:nil];
//
//    }else if([forceUpdate isEqualToString:@"0"]){
//        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"更新提示" message:@"发现新版本,请前往更新!" preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//
//        UIAlertAction * action = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
////            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1164737320"];
////            [[UIApplication sharedApplication]openURL:url];
//            [[UIApplication sharedApplication] openURL:appUrl];
//        }];
//
//        [alertVC addAction:action];
//        [alertVC addAction:actionCancel];
//        UIViewController * vc = [[UIApplication sharedApplication].keyWindow rootViewController];
//        [vc presentViewController:alertVC animated:YES completion:nil];
//    }
}

-(BOOL)isFirstLoadCurrentVersion {
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *lastVersion = [KUserdefaults objectForKey:CKLastVersionKey];
    
    if (!lastVersion) {
        [KUserdefaults setObject:currentVersion forKey:CKLastVersionKey];
        return YES;
    }else if (![lastVersion isEqualToString:currentVersion]) {
        [KUserdefaults setObject:currentVersion forKey:CKLastVersionKey];
        return YES;  
    }  
    return NO;
}

-(void)showForceUpdate {
    //服务器的版本
    NSString *serviceVersion = [KUserdefaults objectForKey:ServerVersion];
    NSString *forceUpdate = [KUserdefaults objectForKey:Forceupdate];
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if([currentVersion compare:serviceVersion] == NSOrderedAscending && [forceUpdate isEqualToString:@"1"]){
        [self showUpdateAlert:forceUpdate];
    }
}

#pragma mark - 更新域名
-(void)updateDomain:(NSDictionary*)dict {
    
    NSString *domainImgRegetUrl = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainImgRegetUrl"]];
    if (!IsNilOrNull(domainImgRegetUrl)) {
        if (![domainImgRegetUrl hasSuffix:@"/"]) {
            domainImgRegetUrl = [domainImgRegetUrl stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainImgRegetUrl forKey:@"domainImgRegetUrl"];
    }
    
    NSString *domainNameRes = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainNameRes"]];
    if (!IsNilOrNull(domainNameRes)) {
        if (![domainNameRes hasSuffix:@"/"]) {
            domainNameRes = [domainNameRes stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainNameRes forKey:@"domainNameRes"];
    }
    
    NSString *domainNamePay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainNamePay"]];
    if (!IsNilOrNull(domainNamePay)) {
        if (![domainNamePay hasSuffix:@"/"]) {
            domainNamePay = [domainNamePay stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainNamePay forKey:@"domainNamePay"];
    }
    
    NSString *domainSmsMessage = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainSmsMessage"]];
    if (!IsNilOrNull(domainSmsMessage)) {
        if (![domainSmsMessage hasSuffix:@"/"]) {
            domainSmsMessage = [domainSmsMessage stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainSmsMessage forKey:@"domainSmsMessage"];
    }
    
    NSString *domainNameUnionPay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainUnionPay"]];
    if (!IsNilOrNull(domainNameUnionPay)) {
        if (![domainNameUnionPay hasSuffix:@"/"]) {
            domainNameUnionPay = [domainNameUnionPay stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainNameUnionPay forKey:@"domainNameUnionPay"];
    }
}



@end
