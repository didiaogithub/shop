//
//  UIImage+Common.h
//  yingzi_iOS
//
//  Created by YW on 15/7/15.
//  Copyright (c) 2015年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_Common)
- (UIImage*)scaledToSize:(CGSize)targetSize;//压缩图片
-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;
+ (UIImage *)imageWithColor:(UIColor *)aColor;
+ (UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;
//旋转图片
+ (UIImage *)fixOrientation:(UIImage *)aImage;
/**
 *  获取网络图片的宽和高
 *
 *  @param imgUrl 传入网络图片url
 *
 *  @return 返回一个数组 有俩内容：@[w,h];
 */
+ (NSMutableArray *)getImgWidthAndHeight:(NSString *)imgUrl;


@end
