//
//  PersonalPictureTableViewCell.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/3/4.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
@interface BrowsePictureTableViewCell : UITableViewCell

@property(nonatomic,strong)SDCycleScrollView *sdScrollview;
/**点击图片*/
@property(nonatomic,strong)UIImageView *showImageView;
@property(nonatomic,strong)NSMutableArray *imageArray;
-(void)cellRefreshWithPersonalPicArray:(NSMutableArray *)picArray;
@end
