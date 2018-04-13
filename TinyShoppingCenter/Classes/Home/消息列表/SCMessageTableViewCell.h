//
//  SCMessageTableViewCell.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2018/2/1.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCMessageModel.h"

@interface SCMessageTableViewCell : UITableViewCell

-(void)refreshWithModel:(SCMessageModel *)messageModel iconName:(NSInteger)type;

@end
