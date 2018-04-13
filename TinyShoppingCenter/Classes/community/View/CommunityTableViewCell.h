//
//  CommunityTableViewCell.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/2/17.
//  Copyright © 2017年 ckys. All rights reserved.


#import <UIKit/UIKit.h>

#import "PhotoContainerView.h"
@protocol CommunityTableViewCellDelagate <NSObject>
@optional
-(void)toSeePersonalCommunity;
@end
@interface CommunityTableViewCell : UITableViewCell
@property(nonatomic,weak)id<CommunityTableViewCellDelagate>delegate;

@property(nonatomic,strong)PhotoContainerView *picContainerView;
/**头像*/
@property(nonatomic,strong)UIButton *headButton;
/**昵称*/
@property(nonatomic,strong)UILabel *nickNameLable;
/**时间*/
@property(nonatomic,strong)UILabel *timeLable;

@property(nonatomic,strong)NSMutableArray *pictureArray;

/**内容*/
@property(nonatomic,strong)UILabel *contentLable;

-(void)cellRefreshWithArray:(NSMutableArray *)picArray;

@end
