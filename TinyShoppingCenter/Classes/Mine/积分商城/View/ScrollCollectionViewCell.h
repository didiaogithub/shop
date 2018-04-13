//
//  ScrollCollectionViewCell.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/24.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "SCUserInfoModel.h"
@interface ScrollCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *bankGroundImageView;
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *noticeLable;
@property(nonatomic,strong)UILabel *nameLable;
@property(nonatomic,strong)UIButton *prizaButton;
@property(nonatomic,strong)UILabel *headerLable;
@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)SDCycleScrollView *sdScrollview;

-(void)refreshCellData:(NSMutableArray*)dataArr userModel:(SCUserInfoModel*)userModel;
@end
