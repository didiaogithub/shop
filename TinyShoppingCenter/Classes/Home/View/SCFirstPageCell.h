//
//  SCFirstPageCell.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/16.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCFirstPageCell : UITableViewCell
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

@protocol SCShopInfoDelegate <NSObject>

-(void)shopInfoClickWithTag:(NSInteger)tag;

@end

@interface SCShopInfoCell : SCFirstPageCell

@end


@interface SCCategoryCell : SCFirstPageCell

@end

@interface SCBannerCell : SCFirstPageCell

@end

@interface SCGoodListCell : SCFirstPageCell

@end

@interface SCTopiclistCell : SCFirstPageCell

@end

@interface SCTitleCell : SCFirstPageCell

@end