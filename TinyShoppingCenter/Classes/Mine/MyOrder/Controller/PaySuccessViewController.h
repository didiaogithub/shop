//
//  PaySuccessViewController.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BaseViewController.h"

@interface PaySuccessViewController : BaseViewController

/**支付方式*/
@property (nonatomic, assign) NSInteger paymentType;
/**支付总金额*/
@property (nonatomic, copy) NSString *payfeeStr;

@property (nonatomic, copy) NSString *orderid;

/**是否是大礼包商品*/
@property (nonatomic, copy) NSString *isdlbitem;

@end
