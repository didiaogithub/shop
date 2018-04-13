//
//  CommentModel.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/3/6.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
@property(nonatomic,copy)NSString *headUrl;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *content;
@end
