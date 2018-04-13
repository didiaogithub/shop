//
//  SCPrizeConfirmOrderCell.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/14.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCMyPrizeModel.h"

@interface SCPrizeConfirmOrderCell : UITableViewCell

@property (nonatomic, strong) SCMyPrizeModel *goodModel;

-(void)setModel:(SCMyPrizeModel *)model;

@end


@interface SCPrizeConfirmOrderOtherMsgCell : UITableViewCell

@property(nonatomic,assign)NSInteger chooseCount;

@property(nonatomic,strong)UILabel *logistLabale;

@property(nonatomic,strong)UILabel *numCouponsLabale;

@property(nonatomic,strong)UILabel *couponsStatusLabale;

@property(nonatomic,strong)UILabel *priceLabale;

@property(nonatomic,strong)UILabel *countLable;

@property (nonatomic, strong) NSDictionary *goodsDict;

-(void)refreshCellWithCount:(NSInteger)count money:(NSString *)allMoney;

@end
