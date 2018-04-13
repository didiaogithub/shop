//
//  SCShoppingCarConfirmOrderCell.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/24.
//  Copyright © 2017年 ckys. All rights reserved.
//
//  从购物车进入确认订单的cell

#import <UIKit/UIKit.h>
#import "GoodModel.h"

@interface SCShoppingCarConfirmOrderCell : UITableViewCell

@property(nonatomic,strong)GoodModel *goodModel;

-(void)setModel:(GoodModel *)model;

@end

@protocol SCConfirmOrderChooseCouponDelegate<NSObject>

-(void)shoppingCarConfirmOrderChooseCoupon;

@end

//购物车确认订单othercell
@interface SCShoppingCarConfirmOrderOtherMsgCell : UITableViewCell

@property(nonatomic,assign)NSInteger chooseCount;

@property(nonatomic,strong)UILabel *logistLabale;

@property(nonatomic,strong)UILabel *numCouponsLabale;

@property(nonatomic,strong)UILabel *couponsStatusLabale;

@property(nonatomic,strong)UILabel *priceLabale;

@property(nonatomic,strong)UILabel *countLable;

@property (nonatomic, strong) NSDictionary *goodsDict;

@property (nonatomic, weak) id<SCConfirmOrderChooseCouponDelegate> delegate;

-(void)refreshCellWithCount:(NSInteger)count money:(NSString *)allMoney;

-(void)refreshCouponAndMoney:(NSString*)couponMoney usablecount:(NSString*)usablecount;

@end

