//
//  MallCollectionViewCell.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/24.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCIntegralGoodsModel.h"

@protocol IntegralMallBuyDelegate<NSObject>

-(void)integralMallBuy:(NSInteger)index;

@end

@interface MallCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, weak)   id<IntegralMallBuyDelegate> delegate;

-(void)cellRefreshWithModel:(SCIntegralGoodsModel *)goodModel;

@end
