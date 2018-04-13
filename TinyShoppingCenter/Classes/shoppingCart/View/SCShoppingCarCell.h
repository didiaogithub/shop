//
//  SCShoppingCarCell.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/24.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"

typedef void(^CarryBySelfBlock)(GoodModel *model,NSInteger row);

@protocol SCShoppingCarCellDelegate <NSObject>

-(void)singleClick:(GoodModel *)goodModel anRow:(NSInteger)indexRow andSection:(NSInteger)section;

@end

@interface SCShoppingCarCell : UITableViewCell

@property(nonatomic,weak)id<SCShoppingCarCellDelegate>delegate;

@property(nonatomic,assign)NSInteger section;

@property(nonatomic,assign)NSInteger indexRow;
@property(nonatomic,copy)NSString *typeString;
@property(nonatomic,assign)NSInteger chooseCount;
@property(nonatomic,strong)GoodModel *goodModel;
@property(nonatomic,strong)UIButton * selectedButton;
@property(nonatomic,strong)UIImageView *iconImageView;
/**名称*/
@property(nonatomic,strong)UILabel *nameLable;
/**规格*/
@property(nonatomic,strong)UILabel *standardLable;
@property(nonatomic,strong)UILabel *priceLable;
@property(nonatomic,strong)UIButton *plusButton;
@property(nonatomic,strong)UIButton *reduceButton;
@property(nonatomic,strong)UILabel *countLable;

@property(nonatomic,strong)UILabel *rightNumberLable;


@property (nonatomic, copy) CarryBySelfBlock block;

-(void)setBlock:(CarryBySelfBlock)block;
-(void)setModel:(GoodModel *)model;


@end
