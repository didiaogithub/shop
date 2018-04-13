//
//  SelectedGoodsViewController.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/3/1.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodModel.h"
typedef void(^releaseBlock)(NSMutableArray *selectedArray,GoodModel*goodModel);
@interface SelectedGoodsViewController : BaseViewController
@property(nonatomic,copy)releaseBlock releaseBlock;
-(void)setReleaseBlock:(releaseBlock)releaseBlock;

@end
