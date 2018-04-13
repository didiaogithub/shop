//
//  CommunityShowGoodsTableViewCell.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/2/17.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"


@interface CommunityShowGoodsTableViewCell : UITableViewCell
@property(nonatomic,assign)NSInteger indexRow;
/**商品图片*/
@property(nonatomic,strong)UIImageView *iconIamgeView;
/**商品名字*/
@property(nonatomic,strong)UILabel *goodNameLable;
/**商品价格*/
@property(nonatomic,strong)UILabel *priceLable;
/**会员价格*/
@property(nonatomic,strong)UILabel *VIPPriceLable;
/**右箭头*/
@property(nonatomic,strong)UIButton *rightButton;
/**社区首页 用的是右箭头图标  发帖用的是删除按钮图标*/
@property(nonatomic,copy)NSString *typeString;

- (void)refreshCellWithModel:(GoodModel *)model;


@end
