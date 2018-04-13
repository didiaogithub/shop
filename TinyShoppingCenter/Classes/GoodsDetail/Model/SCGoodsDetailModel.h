//
//  SCGoodsDetailModel.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/22.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCGDCommentModel : NSObject
/** 昵称 */
@property (nonatomic, copy) NSString *smallname;
/** 评论内容 */
@property (nonatomic, copy) NSString *content;
/** 时间 */
@property (nonatomic, copy) NSString *time;
/** 图像 */
@property (nonatomic, copy) NSString *head;


@end


@interface SCGoodsDetailModel : NSObject

/** 介绍 */
@property (nonatomic, copy) NSString *usemethod;
/**  */
@property (nonatomic, copy) NSString *isup;
/** 好评率 */
@property (nonatomic, copy) NSString *fine;
/** 库存？ */
@property (nonatomic, copy) NSString *libcnt;
/** 商品价格 */
@property (nonatomic, copy) NSString *salesprice;
/** 商品描述 */
@property (nonatomic, copy) NSString *descript;
/** 品牌 */
@property (nonatomic, copy) NSString *brand;
/** 图片路径 */
@property (nonatomic, copy) NSString *path;
/** 评论数 */
@property (nonatomic, copy) NSString *commentnum;
/** 简介 */
@property (nonatomic, copy) NSString *property;
/** 规格 */
@property (nonatomic, copy) NSString *spec;
/** 商品id */
@property (nonatomic, copy) NSString *itemid;
/** 折扣价格 */
@property (nonatomic, copy) NSString *costprice;
/** 商品名称 */
@property (nonatomic, copy) NSString *name;
/**  */
@property (nonatomic, copy) NSString *consumeintegral;
/**  */
@property (nonatomic, copy) NSString *useyears;
/**  */
@property (nonatomic, copy) NSString *element;
/**  */
@property (nonatomic, copy) NSString *usescope;
/**  */
@property (nonatomic, copy) NSString *iscollection;
/**  */
@property (nonatomic, copy) NSString *isvip;
/** islimit:0-正常，1-待售，2-已售罄 */
@property (nonatomic, copy) NSString *islimit;

/** 图文静态页 */
@property (nonatomic, copy) NSString *htmlnameios;
/** 3.0.8是否大礼包商品 */
@property (nonatomic, copy) NSString *isdlbitem;
/** 3.0.8大礼包是否可以购买 */
@property (nonatomic, copy) NSString *isdlbsale;

/** 是否是积分商品 */
@property (nonatomic, copy) NSString *isIntegral;
/** 所需积分 */
@property (nonatomic, copy) NSString *integral;
/** 是否是海外商品 */
@property (nonatomic, copy) NSString *isoversea;

@property (nonatomic, strong) SCGDCommentModel *commentM;


@end
