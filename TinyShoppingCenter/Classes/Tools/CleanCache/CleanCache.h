
//  CleanCache.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/20.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^cleanCacheBlock)();


@interface CleanCache : NSObject

/**
 *  清理缓存
 */
+(void)cleanCache:(cleanCacheBlock)block;

/**
 *  整个缓存目录的大小
 */
+(float)folderSizeAtPath;
/**
 *  计算单个文件大小
 */
+(long long)fileSizeAtPath:(NSString *)filePath;

@end
