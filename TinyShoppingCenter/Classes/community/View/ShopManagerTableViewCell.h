//
//  ShopManagerTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/15.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"

typedef void(^CarryBySelfBlock)(GoodModel *model,NSInteger row);
@protocol ShopManagerTableViewCellDelegate <NSObject>
-(void)singleClick:(GoodModel *)goodModel anRow:(NSInteger)indexRow andSection:(NSInteger)section;

@end
@interface ShopManagerTableViewCell : UITableViewCell
@property(nonatomic,weak)id<ShopManagerTableViewCellDelegate>delegate;

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
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTypeStr:(NSString *)typeStr;

@end
