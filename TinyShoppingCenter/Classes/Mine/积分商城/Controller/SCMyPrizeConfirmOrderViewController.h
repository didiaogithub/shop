//
//  SCMyPrizeConfirmOrderViewController.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/14.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BaseViewController.h"
#import "SCMyPrizeModel.h"

@interface SCMyPrizeConfirmOrderViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SCMyPrizeModel *prizeModel;
@property (nonatomic, copy)   NSString *allMoneyString;
@property (nonatomic, copy)   NSString *typeString;
@property (nonatomic, copy)   NSString *itemid;

@end
