//
//  CKCLogisticsModel.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2018/1/31.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "BaseEncodeModel.h"

@interface CKCLogistInfoModel : BaseEncodeModel

@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *time;

@end

@interface CKCLogisticsModel : BaseEncodeModel

@property (nonatomic, copy) NSString *payment;
@property (nonatomic, copy) NSString *transname;
@property (nonatomic, copy) NSString *transno;
@property (nonatomic, strong) NSMutableArray<CKCLogistInfoModel*> *infoArray;

@end
