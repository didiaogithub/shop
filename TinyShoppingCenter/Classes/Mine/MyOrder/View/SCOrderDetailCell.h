//
//  SCOrderDetailCell.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2018/1/24.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCOrderDetailCell : UITableViewCell

/**
 代表任意代理协议，有子类决定
 */
@property(nonatomic,weak) id delegate;

/**
 由子类实现，数据填充方法
 */
-(void)fillData:(id)data;

/**
 由子类实现，由子类决定此方法用途
 */
-(void)callWithParameter:(id)parameter;

/**
 高度计算，由子类完成
 */
+(CGFloat)computeHeight:(id)data;

@end


@interface CKLogisticsCell : SCOrderDetailCell

@property (nonatomic, strong) UIImageView *leftImgageView;
@property (nonatomic, strong) UILabel *logistLable;

@end


@interface CKOrderGetterCell : SCOrderDetailCell

@property (nonatomic, strong) UIView *bankView;
@property (nonatomic, strong) UILabel *getterLable;
@property (nonatomic, strong) UILabel *telPhoneLable;

@end


@interface CKOrderAddressCell : SCOrderDetailCell

@property (nonatomic, strong) UIView *bankView;
@property (nonatomic, strong) UIImageView *addressImageView;
@property (nonatomic, strong) UILabel *addressDetailLable;

@end



@interface CKOrderChangeAddressCell : SCOrderDetailCell

@property (nonatomic, strong) UIView *bankView;
@property (nonatomic, strong) UIButton *changeAdrrBtn;
@property (nonatomic, copy)   NSString *oidStr;
@property (nonatomic, copy)   NSString *paytime;
@property (nonatomic, copy)   NSString *ordertime;
@property (nonatomic, copy)   NSString *orderStatus;
@property (nonatomic, copy)   NSString *limitTime;
@property (nonatomic, copy)   NSString *systime;
@property (nonatomic, copy)   NSString *orderNo;

@property (nonatomic, copy)   NSString *gettername;
@property (nonatomic, copy)   NSString *gettermobile;
@property (nonatomic, copy)   NSString *area;
@property (nonatomic, copy)   NSString *address;
@property (nonatomic, copy)   NSString *isNeedRealName;
@end


@interface CKOrderSpaImageCell : SCOrderDetailCell

@property (nonatomic, strong) UIView *bankView;
@property (nonatomic, strong) UIImageView *bottomImageView;

@end


@protocol CKGoodDetailCellDelegate <NSObject>

-(void)orderDetailGoodsRightBtnClick:(UIButton*)btn;

-(void)orderDetailGoodsLeftBtnClick:(UIButton*)btn;

@end

@interface CKGoodDetailCell : SCOrderDetailCell

@end


@interface CKOrderPaymentCell : SCOrderDetailCell

@end

@interface CKOrderInfoCell : SCOrderDetailCell


@end

#pragma mark - 积分返点cell
@interface SCReturnIntegralCell : SCOrderDetailCell


@end

@class CKOriginalOrderInfoCell;
@protocol CKOriginalOrderInfoCellDelegate <NSObject>

- (void)showOriginalOrderDetail:(CKOriginalOrderInfoCell*)originalOrderInfoCell index:(NSInteger)index;
- (void)closeOriginalOrderDetail:(CKOriginalOrderInfoCell*)originalOrderInfoCell index:(NSInteger)index;

@end

//原订单信息
@interface CKOriginalOrderInfoCell : SCOrderDetailCell

@end

//原订单订单商品信息
@interface CKOriginalOrderGoodsCell : SCOrderDetailCell

@end


@class CKChangeOrderInfoCell;
@protocol CKChangeOrderInfoCellDelegate <NSObject>

- (void)showChangeOrderDetail:(CKChangeOrderInfoCell*)changeOrderInfoCell index:(NSInteger)index;
- (void)closeChangeOrderDetail:(CKChangeOrderInfoCell*)changeOrderInfoCell index:(NSInteger)index;

@end

//换货订单信息
@interface CKChangeOrderInfoCell : SCOrderDetailCell

@end

//换货订单商品信息
@interface CKChangOrderGoodsCell : SCOrderDetailCell

@end
