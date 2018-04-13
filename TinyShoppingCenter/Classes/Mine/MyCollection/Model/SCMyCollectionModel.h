//
//  SCMyCollectionModel.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/24.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCMyCollectionModel : NSObject
/**好评率*/
@property (nonatomic, copy) NSString *fine;
/**库存*/
@property (nonatomic, copy) NSString *libcnt;
/**价格*/
@property (nonatomic, copy) NSString *salesprice;
/**vip价格*/
@property (nonatomic, copy) NSString *specialprice;
/**类型*/
@property (nonatomic, copy) NSString *itemtype;
/**图片路径*/
@property (nonatomic, copy) NSString *path;
/**评论*/
@property (nonatomic, copy) NSString *comment;
/**价格*/
@property (nonatomic, copy) NSString *price;
/**类型名字*/
@property (nonatomic, copy) NSString *itemtypename;
/**商品id*/
@property (nonatomic, copy) NSString *itemid;
/**规格*/
@property (nonatomic, copy) NSString *spec;
/**是否是特殊商品*/
@property (nonatomic, copy) NSString *ifspecial;
/**销量*/
@property (nonatomic, copy) NSString *sales;
/**vip价格*/
@property (nonatomic, copy) NSString *costprice;
/**是否是vip*/
@property (nonatomic, copy) NSString *isvip;
/**商品名称*/
@property (nonatomic, copy) NSString *name;
/***/
@property (nonatomic, assign) BOOL isSelect;

@end
