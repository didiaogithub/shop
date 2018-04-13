//
//  PaySuccessView.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "PaySuccessView.h"
#import "SCOrderDetailViewController.h"

@implementation PaySuccessView

-(instancetype)initWithFrame:(CGRect)frame paymentType:(NSInteger)paymentType payfeeStr:(NSString *)payfeeStr orderid:(NSString *)orderid {
    if (self = [super initWithFrame:frame]) {
        [self createUIWith:paymentType payfeeStr:payfeeStr orderid:orderid];
    }
    return self;
}


-(void)createUIWith:(NSInteger)paymentType payfeeStr:(NSString *)payfeeStr orderid:(NSString *)orderid {
    
    self.paymentType = paymentType;
    self.payfeeStr = payfeeStr;
    self.orderid = orderid;
    
    _leftImageView = [[UIImageView alloc] init];
    [self addSubview:_leftImageView];
    [_leftImageView setImage:[UIImage imageNamed:@"paysuccess"]];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.left.mas_offset(60);
        make.width.mas_offset(55);
        make.height.mas_offset(80);
    }];
    
    //支付方式
    UILabel *payText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self addSubview:payText];
    payText.text = @"支付方式:";
    [payText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftImageView.mas_top);
        make.left.equalTo(_leftImageView.mas_right).offset(20);
    }];
    
    _payTypeLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self addSubview:_payTypeLable];
    if (paymentType == 1) {
        _payTypeLable.text = @"微信支付";
    }else if (paymentType == 2) {
        _payTypeLable.text = @"支付宝支付";
    }else if (paymentType == 3) {
        _payTypeLable.text = @"银联支付";
    }else{
        _payTypeLable.text = @"";
    }
    [_payTypeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payText.mas_top);
        make.left.equalTo(payText.mas_right).offset(5);
    }];
    
    //支付金额
    UILabel *moneyText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self addSubview:moneyText];
    
    moneyText.text = @"支付金额:";
    [moneyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payText.mas_bottom).offset(8);
        make.left.equalTo(payText.mas_left);
    }];
    
    _moneyLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self addSubview:_moneyLable];
    
    if (IsNilOrNull(payfeeStr)) {
        self.payfeeStr = @"0.00";
    }
    _moneyLable.text = [NSString stringWithFormat:@"¥%@", self.payfeeStr];
    
    [_moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyText.mas_top);
        make.left.equalTo(moneyText.mas_right).offset(5);
    }];
    
    
    UILabel *bottomLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:11]];
    [self addSubview:bottomLable];
    bottomLable.text = @"我们将会尽快安排发货";
    [bottomLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyText.mas_bottom).offset(8);
        make.left.equalTo(payText.mas_left);
        make.bottom.equalTo(_leftImageView.mas_bottom);
    }];
    
    UILabel *lineLbale = [UILabel creatLineLable];
    [self addSubview:lineLbale];
    [lineLbale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftImageView.mas_bottom).offset(15);
        make.left.right.mas_offset(0);
        make.height.mas_offset(1);
    }];
    
    _seeOrderButton = [UIButton configureButtonWithTitle:@"查看订单" titleColor:TitleColor bankGroundColor:[UIColor whiteColor] cornerRadius:10 font:MAIN_TITLE_FONT borderWidth:1 borderColor:TitleColor target:self action:@selector(clickButton:)];
    [self addSubview:_seeOrderButton];
    _seeOrderButton.tag = 80;
    [_seeOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLbale.mas_bottom).offset(15);
        make.right.mas_offset(-(SCREEN_WIDTH/2 + 15));
        make.width.mas_offset(110);
        make.height.mas_offset(40);
    }];
    
    _continueButton = [UIButton configureButtonWithTitle:@"继续购物" titleColor:TitleColor bankGroundColor:[UIColor whiteColor] cornerRadius:10 font:MAIN_TITLE_FONT borderWidth:1 borderColor:TitleColor target:self action:@selector(clickButton:)];
    [self addSubview:_continueButton];
    _continueButton.tag = 81;
    [_continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(_seeOrderButton);
        make.left.mas_offset((SCREEN_WIDTH/2 + 15));
    }];

}

-(void)clickButton:(UIButton *)button {
    NSInteger tag = button.tag - 80;
    if (tag == 0){
        SCOrderDetailViewController *checkVc = [[SCOrderDetailViewController alloc] init];
        checkVc.orderid = self.orderid;
        checkVc.fromVC = @"PaySuccess";
        [[UIViewController currentVC].navigationController pushViewController:checkVc animated:YES];
    }else{
        [[UIViewController currentVC].navigationController popToRootViewControllerAnimated:YES];
        RootTabBarController *rootVC = [[RootTabBarController alloc] init];
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        window.rootViewController = rootVC;
        rootVC.selectedIndex = 0;
    }
}

@end
