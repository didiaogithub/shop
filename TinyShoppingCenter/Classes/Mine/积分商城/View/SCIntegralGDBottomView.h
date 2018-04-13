//
//  SCIntegralGDBottomView.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/13.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCIntegralGDBottomViewDelegate<NSObject>

-(void)jumpWithTag:(NSInteger)buttonTag;

@end

@interface SCIntegralGDBottomView : UIView

@property (nonatomic, weak)  id<SCIntegralGDBottomViewDelegate>delegate;
/**消息按钮*/
@property (nonatomic, strong) UIButton *messageButton;
/**店铺按钮*/
@property (nonatomic, strong) UIButton *shopButton;
/**立即购买*/
@property (nonatomic, strong) UIButton *nowBuyButton;
/**待出售，已售罄*/
@property (nonatomic, strong) UIButton *waitSaleBtn;
/** 显示类型*/
-(void)showBottomType:(NSString*)type;

@end
