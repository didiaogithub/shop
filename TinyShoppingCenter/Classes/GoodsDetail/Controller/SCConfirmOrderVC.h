//
//  SCConfirmOrderVC.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/27.
//  Copyright © 2017年 ckys. All rights reserved.
//
//  立即购买，从商品详情进入的

#import "BaseViewController.h"

@interface SCConfirmOrderVC : BaseViewController

@property (nonatomic, strong) NSDictionary *goodsDict;
@property (nonatomic, copy) NSString *activeId;
@property (nonatomic, copy) NSString *limitnum;
@property (nonatomic, copy) NSString *integralGoodsPrice;

/**是否是大礼包商品*/
@property (nonatomic, copy) NSString *isdlbitem;


@end
