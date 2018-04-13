//
//  UITableView+PlaceHolder.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/25.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (PlaceHolder)

-(void)tableViewDisplayView:(UIView *)displayView ifNecessaryForRowCount:(NSUInteger)rowCount;

@end
