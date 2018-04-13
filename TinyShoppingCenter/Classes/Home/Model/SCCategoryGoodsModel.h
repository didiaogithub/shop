//
//  SCCategoryGoodsModel.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/22.
//  Copyright © 2017年 ckys. All rights reserved.
//

@interface SCCategoryGoodsModel : NSObject
/** 好评率 */
@property (nonatomic, copy) NSString *fine;
/** 图片 */
@property (nonatomic, copy) NSString *path1;
/**  */
@property (nonatomic, copy) NSString *libcnt;
/** 价格 */
@property (nonatomic, copy) NSString *salesprice;
/** 商品分类类型 */
@property (nonatomic, copy) NSString *itemtype;
/** 商品分类名字 */
@property (nonatomic, copy) NSString *itemtypename;
/** 商品id */
@property (nonatomic, copy) NSString *itemid;
/** 规格 */
@property (nonatomic, copy) NSString *spec;
/** 打折后的价格 */
@property (nonatomic, copy) NSString *costprice;
/** 销量 */
@property long sales;
/** 是否是vip */
@property (nonatomic, copy) NSString *isvip;
/** 商品名字 */
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *keyName;
/** 3.0.8新增字段:商品详情页静态化页面名称 */
@property (nonatomic, copy) NSString *htmlname;
/** 3.0.8新增字段:是否为大礼包商品（true false）*/
@property (nonatomic, copy) NSString *isdlbitem;

@end
