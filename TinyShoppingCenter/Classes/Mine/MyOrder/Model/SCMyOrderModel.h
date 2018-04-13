//
//  SCMyOrderModel.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/24.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SCCommentOrderModel : NSObject
/** 图片路径*/
@property (nonatomic, copy) NSString *path;
/** 规格*/
@property (nonatomic, copy) NSString *spec;
/** 数量*/
@property (nonatomic, copy) NSString *count;
/** 商品名称*/
@property (nonatomic, copy) NSString *name;
/** 商品id*/
@property (nonatomic, copy) NSString *itemid;
/** 金额*/
@property (nonatomic, copy) NSString *price;

@end



@interface SCMyOrderGoodsModel : RLMObject
/** 图片路径*/
@property (nonatomic, copy) NSString *path;
/** 规格*/
@property (nonatomic, copy) NSString *spec;
/** 数量*/
@property (nonatomic, copy) NSString *count;
/** 商品名称*/
@property (nonatomic, copy) NSString *name;
/** 商品id*/
@property (nonatomic, copy) NSString *itemid;
/** 金额*/
@property (nonatomic, copy) NSString *price;
//主键
@property (nonatomic, copy) NSString *goodsKey;
// 海外商品
@property (nonatomic, copy) NSString *isoversea;
@end
RLM_ARRAY_TYPE(SCMyOrderGoodsModel)



@interface SCMyOrderModel : RLMObject

/** 订单id*/
@property (nonatomic, copy) NSString *orderId;
/** 是否存在物流信息*/
@property (nonatomic, copy) NSString *iftransno;
/** 订单状态 汉字形式状态*/
@property (nonatomic, copy) NSString *orderstatus;
/** 订单状态 数字形式状态*/
@property (nonatomic, copy) NSString *statusString;
/** 订单商品数量*/
@property (nonatomic, copy) NSString *ordernumber;
/** 收货地址*/
@property (nonatomic, copy) NSString *getteraddress;
/** 邮费*/
@property (nonatomic, copy) NSString *transfee;
/** 下单时间*/
@property (nonatomic, copy) NSString *ordertime;
/** 收货人*/
@property (nonatomic, copy) NSString *gettername;
/** 支付方式*/
@property (nonatomic, copy) NSString *paymethod;
/** 订单号*/
@property (nonatomic, copy) NSString *no;
/** 订单商品是否已全部评价*/
@property (nonatomic, copy) NSString *iscomment;
/** 联系电话*/
@property (nonatomic, copy) NSString *gettermobile;
/** 订单金额*/
@property (nonatomic, copy) NSString *ordermoney;
/** 订单金额*/
@property (nonatomic, copy) NSString *money;
/** 订单金额*/
@property (nonatomic, copy) NSString *favormoney;
/** 补差额*/
@property (nonatomic, copy) NSString *balancemoney;
/** 3:换货订单*/
@property (nonatomic, copy) NSString *orderfrom;

/** 订单商品列表*/
@property RLMArray<SCMyOrderGoodsModel*><SCMyOrderGoodsModel> *itemlistArr;

@end


