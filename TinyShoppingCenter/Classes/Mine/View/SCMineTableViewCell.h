//
//  SCMineTableViewCell.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCMineTableViewCell : UITableViewCell
/**
 代表任意代理协议，由子类决定
 */
@property (nonatomic, weak) id delegate;

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


@protocol SCUserInfoSignUpDelegate <NSObject>

-(void)signUp;
-(void)enterToDetailUserInfo;

@end

@interface SCUserInfoCell : SCMineTableViewCell

@end

@protocol SCMineOrderCellDelegate <NSObject>

-(void)enterOrderListWithType:(NSInteger)type;

@end

@interface SCMineOrderCell : SCMineTableViewCell

@end

@interface SCMineFunctionCell : SCMineTableViewCell

@end
