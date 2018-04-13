//
//  SCCommentOrderViewController.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/9/9.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BaseViewController.h"
#import "SCOrderDetailModel.h"

@interface SCCommentOrderViewController : BaseViewController

@property (nonatomic, copy) NSString *orderid;
@property (nonatomic, strong) SCOrderDetailGoodsModel *goodsM;
@property (nonatomic, copy) NSString *fromVC;

@end
