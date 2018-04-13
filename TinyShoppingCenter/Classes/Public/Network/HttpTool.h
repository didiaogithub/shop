//
//  HttpTool.h
//  GarbageCollection
//
//  Created by luoyb on 16/6/27.
//  Copyright © 2016年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface HttpTool : NSObject

//get
+ (void)getWithUrl:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;
//post
+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;

/**上传图片新处理方法*/
+(void)uploadWithUrl:(NSString *)url andImages:(NSArray *)imageArray andPramaDic:(NSDictionary *)paramaDic completion:(void(^)(NSString *url,NSError *error))uploadBlock success:(void (^)(id responseObject))success fail:(void (^)())fail;


@end
