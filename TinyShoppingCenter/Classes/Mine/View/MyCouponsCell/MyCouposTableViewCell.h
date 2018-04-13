//
//  FinalTeamTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/10.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCouposModel.h"

@interface MyCouposTableViewCell : UITableViewCell


@property(nonatomic, copy) void (^showMoreTextBlock)(MyCouposModel *couponsModel);
@property(nonatomic,strong)MyCouposModel *couponsModel;
@property(nonatomic,strong) UIView *topCotentView;
@property(nonatomic,strong) UIView *detailContentView;
@property(nonatomic,strong) MASConstraint *aConstrain;
@property(nonatomic,strong) MASConstraint *bConstrain;
@property(nonatomic,copy)NSString *typeString;
@property(nonatomic,assign)NSInteger index;

/**价格*/
@property(nonatomic,strong)UILabel *priceLable;
/**满多少返多少*/
@property(nonatomic,strong)UILabel *rebateLable;
/**标题*/
@property(nonatomic,strong)UILabel *titleLable;
/**时间*/
@property(nonatomic,strong)UILabel *timeLable;
/**详细信息*/
@property(nonatomic,strong)UIButton *detailButton;
@property(nonatomic,strong)UILabel *detailLable;
-(void)refreshWithListModel:(MyCouposModel *)couposModel;
@end
