//
//  PaySuccessView.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaySuccessView : UIView

@property(nonatomic,strong)UIImageView *leftImageView;
@property(nonatomic,strong)UILabel *payTypeLable;
@property(nonatomic,strong)UILabel *moneyLable;
@property(nonatomic,strong)UIButton *seeOrderButton;
@property(nonatomic,strong)UIButton *continueButton;
/**支付方式*/
@property (nonatomic, assign) NSInteger paymentType;
/**支付总金额*/
@property (nonatomic, copy) NSString *payfeeStr;
@property (nonatomic, copy) NSString *orderid;

-(instancetype)initWithFrame:(CGRect)frame paymentType:(NSInteger)paymentType payfeeStr:(NSString *)payfeeStr orderid:(NSString *)orderid;

@end
