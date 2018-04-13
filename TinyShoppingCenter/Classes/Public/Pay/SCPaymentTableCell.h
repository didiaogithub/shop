//
//  SCPaymentTableCell.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCPaymentTableCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImageView *leftIamgeView;
@property (nonatomic, strong) UIButton *rightButton;

@end
