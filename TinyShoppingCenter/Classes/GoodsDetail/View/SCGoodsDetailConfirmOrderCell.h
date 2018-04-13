//
//  SCGoodsDetailConfirmOrderCell.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCGoodsDetailConfirmOrderCell : UITableViewCell

-(void)refreshCellWithGoodsDict:(NSDictionary *)goodsDict limitnum:(NSString*)limitnum;

@end


@protocol GDConfirmOrderChooseCouponDelegate<NSObject>

-(void)goodsDetailConfirmOrderChooseCoupon;

@end
//商品详情确认订单othercell
@interface SCConfirmOrderOtherMsgCell : UITableViewCell

@property (nonatomic, assign) NSInteger chooseCount;

@property (nonatomic, strong) UILabel *logistLabale;

@property (nonatomic, strong) UILabel *costIntegralLabel;

@property (nonatomic, strong) UILabel *numCouponsLabale;

@property (nonatomic, strong) UILabel *couponsStatusLabale;

@property (nonatomic, strong) UILabel *priceLabale;

@property (nonatomic, strong) UILabel *countLable;

@property (nonatomic, strong) NSDictionary *goodsDict;

@property (nonatomic, weak) id<GDConfirmOrderChooseCouponDelegate> delegate;

-(void)refreshIntegralCellWithIntegral:(NSString *)integral;

-(void)setDict:(NSDictionary*)goodsDict;

-(void)refreshCellWithCount:(NSInteger)count money:(NSString *)allMoney;

-(void)refreshCouponAndMoney:(NSString*)couponMoney usablecount:(NSString*)usablecount;

@end
