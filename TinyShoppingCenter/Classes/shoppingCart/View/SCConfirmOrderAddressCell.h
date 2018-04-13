//
//  SCConfirmOrderAddressCell.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/9/3.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface SCConfirmOrderAddressCell : UITableViewCell

-(void)refreshWithAddressModel:(AddressModel *)addressModel;

@end
