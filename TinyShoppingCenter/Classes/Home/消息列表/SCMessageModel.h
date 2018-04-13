//
//  SCMessageModel.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2018/2/1.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "BaseEncodeModel.h"

@interface SCMessageModel : BaseEncodeModel

/**消息id*/
@property (nonatomic, copy) NSString *ID;
/**标题*/
@property (nonatomic, copy) NSString *title;
/**消息内容*/
@property (nonatomic, copy) NSString *msg;
/**时间*/
@property (nonatomic, copy) NSString *time;

@end
