//
//  SCGDCommentViewController.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BaseViewController.h"
#import "SCGoodsDetailModel.h"

@interface SCGDCommentViewController : BaseViewController

@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *limit;
@property (nonatomic, copy) NSString *libcnt;
@property (nonatomic, strong) SCGoodsDetailModel *goodsDM;

@end
