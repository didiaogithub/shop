//
//  DefaultValue.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "DefaultValue.h"

@implementation DefaultValue

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        
    }
    return self;
}

+(instancetype)shareInstance {
    static DefaultValue *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[DefaultValue alloc] initPrivate];
    });
    return instance;
}

-(id)getDefaultValue:(NSString*)key {
    
    id value = [KUserdefaults objectForKey:key];
    if (IsNilOrNull(value)) {
         value = [self getDefaultObjectWithKey:key];
    }

    return value;
}

-(void)setDefaultValue:(NSString*)value forKey:(NSString*)key {
    //获取路径
    NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"SCDefaultValue.plist"];
    //所有的数据列表
    NSMutableDictionary *datalist= [[[NSMutableDictionary alloc]initWithContentsOfFile:filepath]mutableCopy];
    
    [datalist setValue:value forKey:key];
    [datalist writeToFile:filepath atomically:YES];
    NSLog(@"修改成功");
}

-(void)paymentAvaliable:(NSString*)value forKey:(NSString*)key {
    //获取路径
    NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"SCDefaultValue.plist"];
    //所有的数据列表
    NSMutableDictionary *datalist= [[[NSMutableDictionary alloc]initWithContentsOfFile:filepath]mutableCopy];
    NSDictionary *paymentMethod = [datalist objectForKey:@"PayMethod"];
    if ([value isEqualToString:@"0"]) {
        [paymentMethod setValue:@"NO" forKey:key];
    }else if ([value isEqualToString:@"1"]){
        [paymentMethod setValue:@"YES" forKey:key];
    }
    [datalist setValue:paymentMethod forKey:@"PayMethod"];
    [datalist writeToFile:filepath atomically:YES];
    NSLog(@"修改成功:%@", datalist);
}

-(id)getDefaultObjectWithKey:(NSString*)key {
    //获取路径
    NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"SCDefaultValue.plist"];
    //所有的数据列表
    NSMutableDictionary *datalist= [[[NSMutableDictionary alloc]initWithContentsOfFile:filepath]mutableCopy];
    return [datalist objectForKey:key];
}

-(void)defaultValue {
    
    NSArray *sandboxpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[sandboxpath objectAtIndex:0] stringByAppendingPathComponent:@"SCDefaultValue.plist"];
    NSMutableDictionary *datalist= [[[NSMutableDictionary alloc]initWithContentsOfFile:filePath]mutableCopy];
    
    if (datalist == nil) {
        NSArray *sandboxpath= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //获取完整路径
        NSString *documentsDirectory = [sandboxpath objectAtIndex:0];
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"SCDefaultValue.plist"];
        //存储根数据
        NSMutableDictionary *rootDic = [[NSMutableDictionary alloc ] init];
        
        NSString *domainName = (AppEnvironment == 0)? @"http://testofflineappmall.ckc8.com/": @"http://appmall.ckc8.com/";
//        @"http://bateappmall.ckc8.com/"

        NSString *domainNamePay = (AppEnvironment == 0)? @"http://testofflineckyspb.ckc8.com/":@"http://ckyspb.ckc8.com/";
        NSString *domainNameRes = (AppEnvironment == 0)?@"http://testofflineckysre.ckc8.com/ckc3/":@"http://ckysre.ckc8.com/ckc3/";
        NSString *domainSmsMessage = (AppEnvironment == 0)?@"http://testofflineckysmsg.ckc8.com/":@"http://ckysmsg.ckc8.com/";
        NSString *domainNameUnionPay = (AppEnvironment == 0)?@"http://testofflineckyspb.ckc8.com/":@"http://ckyspb.ckc8.com/";
        
        [rootDic setObject:domainName forKey:@"domainName"];
        [rootDic setObject:domainNamePay forKey:@"domainNamePay"];

        [rootDic setObject:domainNameRes forKey:@"domainNameRes"];
        [rootDic setObject:domainSmsMessage forKey:@"domainSmsMessage"];
        [rootDic setObject:domainNameUnionPay forKey:@"domainNameUnionPay"];
        
        NSMutableDictionary *payMethod = [[NSMutableDictionary alloc]init];
        [payMethod setObject:@"YES" forKey:@"alipay"];
        [payMethod setObject:@"NO" forKey:@"wxpay"];
        [payMethod setObject:@"NO" forKey:@"unionpay"];
        [payMethod setObject:@"NO" forKey:@"applepay"];
        [payMethod setObject:@"NO" forKey:@"jdpay"];

        [rootDic setObject:payMethod forKey:@"PayMethod"];
        
        //写入文件
        [rootDic writeToFile:plistPath atomically:YES];
        NSLog(@"%@",NSHomeDirectory());
        NSLog(@"写入成功");
    }
}

/** 获取所有支付方式*/
-(NSArray*)getAllPaymentMethod {
    NSDictionary *payMethod = [self getDefaultObjectWithKey:@"PayMethod"];
    return payMethod.allKeys;
}
/** 获取可用的支付方式*/
-(NSArray*)getAvailablePaymentMethod {
    
    NSMutableArray *values = [NSMutableArray array];
    NSDictionary *payMethod = [self getDefaultObjectWithKey:@"PayMethod"];
    for (NSString *keyStr in payMethod.allKeys) {
        NSString *valueStr = [payMethod objectForKey:keyStr];
        if ([valueStr isEqualToString:@"YES"]) {
            [values addObject:keyStr];
        }
    }
    return values;
}


/**域名*/
-(NSString*)domainName {
    NSString *keyStr = @"domainName";
    return [self getDefaultValue:keyStr];
}
/**微信支付宝支付服务*/
-(NSString*)domainNamePay {
    NSString *keyStr = @"domainNamePay";
    return [self getDefaultValue:keyStr];
}

/**银联支付服务*/
-(NSString*)domainNameUnionPay {
    NSString *keyStr = @"domainNameUnionPay";
    return [self getDefaultValue:keyStr];
}

/**消息服务*/
-(NSString*)domainSmsMessage {
    NSString *keyStr = @"domainSmsMessage";
    return [self getDefaultValue:keyStr];
}
/**上传图片资源路径*/
-(NSString*)domainNameRes {
    NSString *keyStr = @"domainNameRes";
    return [self getDefaultValue:keyStr];
}

/**下载图片资源路径*/
-(NSString*)baseImagestr {
    NSString *keyStr = @"domainImgRegetUrl";
    return [self getDefaultValue:keyStr];
}

-(void)resetDefaultDomain {
    
    NSString *domainName = (AppEnvironment == 0)? @"http://testofflineappmall.ckc8.com/": @"http://appmall.ckc8.com/";
    NSString *domainNamePay = (AppEnvironment == 0)? @"http://testofflineckyspb.ckc8.com/":@"http://ckyspb.ckc8.com/";
    NSString *domainNameRes = (AppEnvironment == 0)?@"http://testofflineckysre.ckc8.com/ckc3/":@"http://ckysre.ckc8.com/ckc3/";
//    NSString *baseImagestr = (AppEnvironment == 0)?@"http://testofflineckysre.ckc8.com/ckc3/Uploads/":@"http://ckysre.ckc8.com/ckc3/Uploads/";
    NSString *domainSmsMessage = (AppEnvironment == 0)?@"http://testofflineckysmsg.ckc8.com/":@"http://ckysmsg.ckc8.com/";
    NSString *domainNameUnionPay = (AppEnvironment == 0)?@"http://testofflineckyspb.ckc8.com/":@"http://ckyspb.ckc8.com/";
    
    [self setDefaultValue:domainName forKey:@"domainName"];
    [self setDefaultValue:domainNamePay forKey:@"domainNamePay"];
    [self setDefaultValue:domainNameRes forKey:@"domainNameRes"];
//    [self setDefaultValue:baseImagestr forKey:@"domainImgRegetUrl"];
    [self setDefaultValue:domainSmsMessage forKey:@"domainSmsMessage"];
    [self setDefaultValue:domainNameUnionPay forKey:@"domainNameUnionPay"];
}


-(void)cleanLoginStatusCacheData {
    [KUserdefaults setObject:@"NO" forKey:@"SC_ConnectRCloudStatus"];
    [KUserdefaults removeObjectForKey:Kmobile];
    [KUserdefaults removeObjectForKey:KopenID];
    [KUserdefaults removeObjectForKey:Kunionid];
    [KUserdefaults removeObjectForKey:kheamImageurl];
    [KUserdefaults removeObjectForKey:@"YDSC_USER_MOBILE"];
    [KUserdefaults removeObjectForKey:@"SC_RCToken"];
    [KUserdefaults removeObjectForKey:KloginStatus];
    [KUserdefaults removeObjectForKey:@"USER_OPENID"];
    [KUserdefaults removeObjectForKey:KnickName];
    [KUserdefaults removeObjectForKey:@"YDSC_USER_HEAD"];

    //退出登录移除默认地址缓存
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:USER_DefaultAddress];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
}

@end
