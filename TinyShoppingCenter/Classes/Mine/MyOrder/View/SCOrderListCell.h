//
//  SCOrderListCell.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/9.
//  Copyright © 2017年 ckys. All rights reserved.
//
//  订单列表页cell

#import <UIKit/UIKit.h>
#import "SCMyOrderModel.h"

@interface SCOrderListCell : UITableViewCell

- (void)refreshWithModel:(SCMyOrderGoodsModel*)model;

@end
