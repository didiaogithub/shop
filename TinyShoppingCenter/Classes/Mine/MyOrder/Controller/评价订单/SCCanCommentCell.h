//
//  SCCanCommentCell.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/9/9.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCOrderDetailModel.h"

@protocol ReleaseOrderCommentDelegate <NSObject>

@optional
-(void)gotoReleaseOrderComment;

-(void)gotoReleaseOrderComment:(NSInteger)tag;

@end

@interface SCCanCommentCell : UITableViewCell

@property (nonatomic, weak)   id<ReleaseOrderCommentDelegate> delegate;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, copy)   NSString *orderid;

-(void)refreshWithDetailModel:(SCOrderDetailGoodsModel*)detailModel;

@end
