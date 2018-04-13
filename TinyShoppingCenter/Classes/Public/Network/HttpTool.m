//
//  HttpTool.m
//  GarbageCollection
//
//  Created by luoyb on 16/6/27.
//  Copyright © 2016年 lin. All rights reserved.
//

#import "HttpTool.h"
#import "NSString+MD5.h"
#import "MessageAlert.h"


#define CKDataRequestTimeOut 10

@implementation HttpTool

+(void)getWithUrl:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure{
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    serializer.removesKeysWithNullValues = YES;
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = serializer;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    manager.requestSerializer.timeoutInterval = CKDataRequestTimeOut;
    
    NSString *uuid = IsNilOrNull(DeviceId_UUID_Value) ? @"" : DeviceId_UUID_Value;
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramDict setValue:uuid forKey:@"deviceid"];
    [paramDict setValue:@"2" forKey:@"devtype"];
    [paramDict setValue:@"2" forKey:@"apptype"];
    
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSArray *verArray = [currentVersion componentsSeparatedByString:@"."];
    NSMutableString *verStr = [NSMutableString stringWithString:@""];
    for (NSString *ver in verArray) {
        [verStr appendString:ver];
    }
    [paramDict setValue:[NSString stringWithFormat:@"%@2", verStr] forKey:@"vk"];

    NSString *apiName = url.lastPathComponent;
    NSString *md5ApiName = [apiName MD5String];
    NSString *md5Openid = [USER_OPENID MD5String];
    NSString *akString = [NSString stringWithFormat:@"%@%@", md5Openid, md5ApiName];
    NSString *ak = [akString MD5String];
    NSString *uk = [KUserdefaults objectForKey:@"YDSC_uk"];
    if (!IsNilOrNull(uk)) {
        [paramDict setValue:uk forKey:@"uk"];
    }
    
    if (![apiName isEqualToString:@"userLogin"] && !IsNilOrNull(USER_OPENID)) {
        [paramDict setValue:ak forKey:@"ak"];
        [paramDict setValue:USER_OPENID forKey:@"openid"];
    }
    
    NSLog(@"params:%@\nparameters:%@\napi:%@", params, paramDict, url);

    [manager GET:url parameters:paramDict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [responseObject mj_JSONString];
        NSLog(@"\n\n\n[---POST----Result----]:%@     --request.URL-->%@\n\n\n", jsonStr, url);
        if (success) {
            
            NSDictionary *dict = responseObject;
            NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
            //强制退出，重新登录
            if ([code isEqualToString:@"9009"]){
                [[DefaultValue shareInstance] cleanLoginStatusCacheData];

                NSString *noticeString = [NSString stringWithFormat:@"%@",dict[@"codeinfo"]];
                MessageAlert *alert = [MessageAlert shareInstance];
                [alert showAlert:noticeString];
                return;
            }
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"网络请求错误%@", error);
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    manager.requestSerializer.timeoutInterval = CKDataRequestTimeOut;
    
    NSString *uuid = IsNilOrNull(DeviceId_UUID_Value) ? @"" : DeviceId_UUID_Value;
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramDict setValue:uuid forKey:@"deviceid"];
    [paramDict setValue:@"2" forKey:@"devtype"];
    [paramDict setValue:@"2" forKey:@"apptype"];
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSArray *verArray = [currentVersion componentsSeparatedByString:@"."];
    NSMutableString *verStr = [NSMutableString stringWithString:@""];
    for (NSString *ver in verArray) {
        [verStr appendString:ver];
    }
    [paramDict setValue:[NSString stringWithFormat:@"%@2", verStr] forKey:@"vk"];
    
    NSString *apiName = url.lastPathComponent;
    NSString *md5ApiName = [apiName MD5String];
    NSString *md5Openid = [USER_OPENID MD5String];
    NSString *akString = [NSString stringWithFormat:@"%@%@", md5Openid, md5ApiName];
    NSString *ak = [akString MD5String];
    NSString *uk = [KUserdefaults objectForKey:@"YDSC_uk"];
    if (!IsNilOrNull(uk)) {
        [paramDict setValue:uk forKey:@"uk"];
    }
    
    if (![apiName isEqualToString:@"userLogin"] && !IsNilOrNull(USER_OPENID)) {
        [paramDict setValue:ak forKey:@"ak"];
        [paramDict setValue:USER_OPENID forKey:@"openid"];
    }
    
    NSLog(@"params:%@\nparameters:%@\napi:%@", params, paramDict, url);
    
    [manager POST:url parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [responseObject mj_JSONString];
        NSLog(@"\n\n\n[---POST----Result----]:%@     --request.URL-->%@\n\n\n", jsonStr, url);
        if (success) {
            NSDictionary *dict = responseObject;
            NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
            //强制退出，重新登录
            if ([code isEqualToString:@"9009"]){
                [[DefaultValue shareInstance] cleanLoginStatusCacheData];

                NSString *noticeString = [NSString stringWithFormat:@"%@",dict[@"codeinfo"]];
                MessageAlert *alert = [MessageAlert shareInstance];
                [alert showAlert:noticeString];
                return;
            }
            success(responseObject);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"网络请求错误%@", error);
        if (failure) {
            failure(error);
        }
    }];
    
}

#pragma mark - 上传图片 发表评论时
+(void)uploadWithUrl:(NSString *)url andImages:(NSArray *)imageArray andPramaDic:(NSDictionary *)paramaDic completion:(void(^)(NSString *url,NSError *error))uploadBlock success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = serializer;
    manager.requestSerializer.timeoutInterval = CKDataRequestTimeOut;
    
    NSString *uuid = IsNilOrNull(DeviceId_UUID_Value) ? @"" : DeviceId_UUID_Value;
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:paramaDic];
    [paramDict setValue:uuid forKey:@"deviceid"];
    [paramDict setValue:@"2" forKey:@"devtype"];
    [paramDict setValue:@"2" forKey:@"apptype"];
    

    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSArray *verArray = [currentVersion componentsSeparatedByString:@"."];
    NSMutableString *verStr = [NSMutableString stringWithString:@""];
    for (NSString *ver in verArray) {
        [verStr appendString:ver];
    }
    [paramDict setValue:[NSString stringWithFormat:@"%@2", verStr] forKey:@"vk"];
    
    NSString *apiName = url.lastPathComponent;
    NSString *md5ApiName = [apiName MD5String];
    NSString *md5Openid = [USER_OPENID MD5String];
    NSString *akString = [NSString stringWithFormat:@"%@%@", md5Openid, md5ApiName];
    NSString *ak = [akString MD5String];
    NSString *uk = [KUserdefaults objectForKey:@"YDSC_uk"];
    if (!IsNilOrNull(uk)) {
        [paramDict setValue:uk forKey:@"uk"];
    }
    
    if (![apiName isEqualToString:@"userLogin"] && !IsNilOrNull(USER_OPENID)) {
        [paramDict setValue:ak forKey:@"ak"];
        [paramDict setValue:USER_OPENID forKey:@"openid"];
    }
    
    NSLog(@"params:%@\nparameters:%@\napi:%@", paramaDic, paramDict, url);
    
    
    [manager POST:url parameters:paramaDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for(NSInteger i = 0; i < imageArray.count; i++)
        {
            UIImage * image = [imageArray objectAtIndex: i];
            // 压缩图片
            
            // 添加一个标记 去分图片名称
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            if (data.length>100*1024) {
                if (data.length>1024*1024) {//1M以及以上
                    data = UIImageJPEGRepresentation(image, 0.1);
                }else if (data.length>512*1024) {//0.5M-1M
                    data = UIImageJPEGRepresentation(image, 0.5);
                }else if (data.length>200*1024) {//0.25M-0.5M
                    data = UIImageJPEGRepresentation(image, 0.9);
                }
            }

            // 上传的参数名
            NSString *now = [NSDate nowTime:@"yyyyMMddHHmmss"];
            NSString * Name = [NSString stringWithFormat:@"%@%zi",now,i+1];
            // 上传filename
            NSString * fileName = [NSString stringWithFormat:@"%@.jpg", Name];
            
            [formData appendPartWithFileData:data name:@"headfile" fileName:fileName mimeType:@"image/jpeg"];
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"上传进度");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSDictionary *dict = responseObject;
            NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
            //强制退出，重新登录
            if ([code isEqualToString:@"9009"]){
                [[DefaultValue shareInstance] cleanLoginStatusCacheData];

                NSString *noticeString = [NSString stringWithFormat:@"%@",dict[@"codeinfo"]];
                MessageAlert *alert = [MessageAlert shareInstance];
                [alert showAlert:noticeString];
                return;
            }
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"[Fail---%@]",error.localizedDescription);
        if (fail) {
            fail(error);
        }
    }];
}

@end
