//
//  YSMemberPointCell.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/5/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCIntegraModel.h"

@interface YSMemberPointCell : UITableViewCell

-(void)refreshPointWithPointModel:(SCIntegraModel*)integraModel type:(NSString*)type;

@end
