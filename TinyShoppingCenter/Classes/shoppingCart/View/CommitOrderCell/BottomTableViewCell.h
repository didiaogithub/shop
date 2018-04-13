//
//  BottomTableViewCell.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/21.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomTableViewCell : UITableViewCell

@property(nonatomic,assign)NSInteger chooseCount;
@property(nonatomic,strong)UILabel *logistLabale;
@property(nonatomic,strong)UILabel *numCouponsLabale;
@property(nonatomic,strong)UILabel *couponsStatusLabale;
@property(nonatomic,strong)UILabel *priceLabale;
@property(nonatomic,strong)UILabel *countLable;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(NSString *)typeStr;

-(void)refreshCellWithCount:(NSInteger *)count money:(NSString *)allMoney;
@end
