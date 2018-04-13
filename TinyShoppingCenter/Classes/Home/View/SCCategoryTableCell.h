//
//  SCCategoryTableCell.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/22.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCategoryGoodsModel.h"

@protocol CatogoryAddToShoppingCarDelete <NSObject>

@optional
-(void)catogoryAddGoodsToShoppingCar:(NSString*)goodsId;

-(void)addGoodsToShoppingCar:(SCCategoryGoodsModel*)cateM;

@end

@interface SCCategoryTableCell : UITableViewCell

@property (nonatomic, weak) id<CatogoryAddToShoppingCarDelete> delegate;

@property (nonatomic, strong) SCCategoryGoodsModel *goodsModel;

-(void)refreshCellWithModel:(SCCategoryGoodsModel *)goodsModel;

@end
