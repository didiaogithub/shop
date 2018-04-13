//
//  SCCommentModel.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/22.
//  Copyright © 2017年 ckys. All rights reserved.
//
//  评论列表的model

#import <Foundation/Foundation.h>

@interface SCCommentImgModel : NSObject

@property (nonatomic, copy) NSString *path;

@end

@interface SCCommentModel : NSObject

/** 昵称 */
@property (nonatomic, copy) NSString *smallname;
/** 评分 */
@property (nonatomic, copy) NSString *score;
/** 评论内容 */
@property (nonatomic, copy) NSString *content;
/** 时间 */
@property (nonatomic, copy) NSString *time;
/** 图像 */
@property (nonatomic, copy) NSString *head;
/** 图片数组 */
@property (nonatomic, strong) NSMutableArray *imgPathArray;


@end
