//
//  YSCollectionEditCell.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/7/18.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCMyCollectionModel.h"

@class YSCollectionEditCell;

@protocol SCCollectionEditCellDelegate <NSObject>

-(void)scCollectionEditCell:(YSCollectionEditCell*)scCollectionEditCell clickCellIndex:(NSInteger)index deleteOrNo:(BOOL)isDelete;

@end

@interface YSCollectionEditCell : UITableViewCell

@property (nonatomic, assign) NSUInteger indexRow;
@property (nonatomic, assign) id<SCCollectionEditCellDelegate>delegate;
@property (nonatomic, strong) UIButton *editBtn;


-(void)refreshCellWithCollectionModel:(SCMyCollectionModel*)collectionM;

@end
