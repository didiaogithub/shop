//
//  UITableView+PlaceHolder.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/25.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "UITableView+PlaceHolder.h"

@implementation UITableView (PlaceHolder)

-(void)tableViewDisplayView:(UIView *)displayView ifNecessaryForRowCount:(NSUInteger)rowCount {
    
    [self setBackgroundColor:[UIColor tt_grayBgColor]];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (rowCount == 0) {
        self.backgroundView = displayView;
        self.scrollEnabled = YES;
    } else {
        self.scrollEnabled = YES;
        self.backgroundView = nil;
    }
}

@end
