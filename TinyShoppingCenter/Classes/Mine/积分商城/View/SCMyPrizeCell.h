//
//  SCMyPrizeCell.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/9.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCMyPrizeModel.h"

@protocol SCPrizeCellDelegate <NSObject>

-(void)singleClick:(SCMyPrizeModel *)prizeModel anRow:(NSInteger)indexRow andSection:(NSInteger)section;

@end

@interface SCMyPrizeCell : UITableViewCell

@property (nonatomic, weak)   id<SCPrizeCellDelegate>delegate;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger indexRow;
@property (nonatomic, copy)   NSString *typeString;
@property (nonatomic, strong) SCMyPrizeModel *goodModel;
@property (nonatomic, strong) UIButton * selectedButton;
@property (nonatomic, strong) UIImageView *iconImageView;

-(void)refreshCellWithModel:(SCMyPrizeModel*)prizeModel;

@end
