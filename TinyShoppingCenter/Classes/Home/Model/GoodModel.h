//
//  GoodModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/15.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodModel : RLMObject
/**商品id*/
@property NSString *itemid;
/**状态*/
@property long status;
/**价格*/
@property NSString *price;
/**购买数量*/
@property NSString *count;
/**规格*/
@property NSString *spec;
/**图片*/
@property NSString *path;
/**商品名称*/
@property NSString *name;
/**加入时间*/
@property NSString *time;
//选中状态
@property BOOL isSelect;

@property NSString *meopenid;

/**0：非海外购订单 1：海外购订单*/
@property NSString *isoversea;

@end

