//
//  SCIntegraModel.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/28.
//  Copyright © 2017年 ckys. All rights reserved.
//
//  我的积分
#import <Foundation/Foundation.h>

@interface SCIntegraModel : NSObject
/**积分id */
@property (nonatomic, copy) NSString *jfId;
/**商品id */
@property (nonatomic, copy) NSString *itemid;
/**商品 */
@property (nonatomic, copy) NSString *path;
/**标题 */
@property (nonatomic, copy) NSString *title;
/**积分来源类型（1购买商品 2签到 3填写个人资料 4 商品评论 5 积分商城购买消耗 6 积分商城取消订单返还 7 积分抽奖消耗） */
@property (nonatomic, copy) NSString *integraltype;
/**积分类型（1为收入，2为支出）*/
@property (nonatomic, copy) NSString *type;
/**积分数额 */
@property (nonatomic, copy) NSString *num;
/**积分目前有4种方式（1购买商品 2签到 3填写个人资料 4 商品评论）
 积分消耗目前有3种方式（1积分购买 2订单返还 3积分抽奖 ） */
@property (nonatomic, copy) NSString *formname;
/**积分发放或者使用时间 */
@property (nonatomic, copy) NSString *time;

@end
