//
//  SCGoodsDetailBottomView.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCGoodsDetailBottomViewDelegate<NSObject>

-(void)pushToOtherVCWithButtonTag:(NSInteger)buttonTag;

@end

@interface SCGoodsDetailBottomView : UIView

@property (nonatomic, weak)  id<SCGoodsDetailBottomViewDelegate>delegate;
/**消息按钮*/
@property (nonatomic, strong) UIButton *messageButton;
/**店铺按钮*/
@property (nonatomic, strong) UIButton *shopButton;
/**加入购物车*/
@property (nonatomic, strong) UIButton *joinShoppingCarButton;
/**立即购买*/
@property (nonatomic, strong) UIButton *nowBuyButton;
/**待出售，已售罄*/
@property (nonatomic, strong) UIButton *waitSaleBtn;
/** 显示类型*/
-(void)showBottomType:(NSString*)type;

@end
