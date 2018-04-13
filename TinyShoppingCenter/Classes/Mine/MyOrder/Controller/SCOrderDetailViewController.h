//
//  SCOrderDetailViewController.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/9.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BaseViewController.h"
#import "SCMyOrderModel.h"
#import "AddressModel.h"

@interface SCOrderDetailViewController : BaseViewController

@property (nonatomic, strong) SCMyOrderModel *orderModel;
@property (nonatomic, copy)   NSString *orderstatusString;
@property (nonatomic, copy)   NSString *orderid;
@property (nonatomic, copy)   NSString *fromVC;

//刷新新地址
-(void)reloadOrderWithNewAdress:(AddressModel*)addressModel;
//隐藏更改地址按钮
-(void)hiddenChangeAddressBtn;

@end
