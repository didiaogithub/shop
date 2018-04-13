//
//  CouponsView.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/21.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCouposModel.h"
@protocol CouponsViewDelegate <NSObject>
@optional
-(void)refreshUIWithBtn:(UIButton *)button;

@end
@interface CouponsView : UIView
@property(nonatomic,weak)id<CouponsViewDelegate>delegate;
@property(nonatomic,strong) UIView *topCotentView;
@property(nonatomic,strong) UIView *detailContentView;
@property(nonatomic,strong) MASConstraint *aConstrain;
@property(nonatomic,strong) MASConstraint *bConstrain;


@property(nonatomic,strong)MyCouposModel *couponsMode;

@property(nonatomic,copy)NSString *typeString;
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

-(instancetype)initWithFrame:(CGRect)frame andType:(NSString *)type;



@end
