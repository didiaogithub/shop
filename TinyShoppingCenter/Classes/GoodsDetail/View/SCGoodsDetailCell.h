//
//  SCGoodsDetailCell.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/14.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCGoodsDetailCell : UITableViewCell
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

@protocol SCgoodsDetailImageBannerDelegate <NSObject>

-(void)showBigGoodsImage:(NSInteger)index;

@end

@interface SCgoodsDetailImageCell : SCGoodsDetailCell

@end


@interface SCGoodsDetailCommentCell : SCGoodsDetailCell

@end


@interface SCGoodsDetailTipCell : SCGoodsDetailCell

@end

@protocol SCCollectionGoodsDelegate <NSObject>

-(void)goodsDetailCollection:(UIButton*)button;

@end

@interface SCGoodsDetailInfoCell : SCGoodsDetailCell

@end

