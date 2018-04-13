//
//  AddAddressViewController.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 16/8/5.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "BaseViewController.h"
//添加收货地址
#import "AddressModel.h"
typedef void (^TransBlock)(NSString *addressString,NSString *defaultIdStr);


@interface AddAddressViewController : BaseViewController

@property(nonatomic,strong)AddressModel *addressModel;
@property(nonatomic,copy)NSString *areaNameStr;

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *telephone;
@property(nonatomic,copy)NSString *addressIdString;


@property (nonatomic, copy) NSString *actionName;


@property(nonatomic,copy)NSString *pushString;

@property(nonatomic,assign)NSInteger pushTag;

@property(nonatomic,copy)TransBlock placeBlock;


-(void)setPlaceBlock:(TransBlock)placeBlock;


@end
