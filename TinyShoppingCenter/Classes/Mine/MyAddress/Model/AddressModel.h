//
//  AddressModel.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 16/8/17.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEncodeModel.h"

@interface AddressModel : BaseEncodeModel

/**id*/
@property(nonatomic,copy)NSString *ID;
/**是否是默认地址地址 是否为默认地址（0：否 1：是）*/
@property(nonatomic,copy)NSString *isdefault;
/**联系方式*/
@property(nonatomic,copy)NSString *mobile;
/**联系人*/
@property(nonatomic,copy)NSString *name;
/**详细地址*/
@property(nonatomic,copy)NSString *address;
/**省市区地址*/
@property(nonatomic,copy)NSString *area;

@end
