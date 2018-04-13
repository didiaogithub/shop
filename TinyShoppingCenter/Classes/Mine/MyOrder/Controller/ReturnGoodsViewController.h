//
//  ReturnGoodsViewController.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BaseViewController.h"
#import "SCOrderDetailModel.h"

@interface ReturnGoodsViewController : BaseViewController

@property (nonatomic, strong) SCOrderDetailGoodsModel *detailModel;
@property (nonatomic, copy) NSString *orderid;

@end
