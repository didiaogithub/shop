//
//  TableViewTopCell.h
//  发贴
//
//  Created by 庞宏侠 on 17/2/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSTextView.h"

@interface TableViewTopCell : UITableViewCell

@property (nonatomic, strong) JSTextView *textView;

//@property (nonatomic, copy) NSString *postType;
//处理block 返回的图片
//@property (nonatomic) void (^TopCellBlock)(NSArray *images,NSString *text,BOOL isUpdate);

@property (nonatomic) void (^CommentCellBlock)(NSString *text);

@end
