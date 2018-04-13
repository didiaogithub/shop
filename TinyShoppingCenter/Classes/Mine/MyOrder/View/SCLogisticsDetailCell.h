//
//  SCLogisticsDetailCell.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2018/1/31.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCLogisticsModel.h"

@interface SCLogisticsDetailCell : UITableViewCell

@property (nonatomic, strong) UILabel *payLable;
@property (nonatomic, strong) UILabel *companyLable;
@property (nonatomic, strong) UILabel *logistLable;

-(void)refreshLogistWithModel:(CKCLogisticsModel*)logistModel;

@end


@interface SCLogisticsDetailInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *verticalLable;
@property (nonatomic, strong) UILabel *latestLogistLable;
@property (nonatomic, strong) UILabel *latestTimeLable;
@property (nonatomic, strong) UIImageView *imageViewR;
@property (nonatomic, strong) UILabel *bottomLable;

-(void)refreshWithLogistMsg:(CKCLogistInfoModel*)infoModel;

@end
