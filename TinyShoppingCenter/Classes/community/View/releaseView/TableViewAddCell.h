//
//  ImagePicker.h
//
//  Created by 庞宏侠 on 17/2/28.
//  Copyright © 2017年 Apple. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol TableViewAddCellDelegate <NSObject>

@optional
-(void)comeToAddGoods;

@end

@interface TableViewAddCell : UITableViewCell

@property(nonatomic,strong)id<TableViewAddCellDelegate>delegate;


@end
