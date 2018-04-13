//
//  SCGoodsSearchCell.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCSearchGoodsModel.h"

@interface SCGoodsSearchCell : UITableViewCell

@property(nonatomic,strong)UIImageView *iconImageView;
/**名称*/
@property(nonatomic,strong)UILabel *nameLable;
/**规格*/
@property(nonatomic,strong)UILabel *specLable;
/**价格*/
@property(nonatomic,strong)UILabel *priceLable;

@property(nonatomic,strong)UILabel *countLable;

@property(nonatomic,strong)UILabel *commentLable;

-(void)refreshCellWithModel:(SCSearchGoodsModel *)goodModel;

@end
