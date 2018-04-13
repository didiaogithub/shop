//
//  orderFooterView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "OrderFooterView.h"

@implementation OrderFooterView

- (instancetype)initWithFrame:(CGRect)frame andType:(NSString *)statusString andHasTop:(BOOL)hasTop type:(NSString *)fromVC {
    if (self = [super initWithFrame:frame]) {
        _statustring = statusString;
        [self createUIWithStatus:statusString andHasTop:hasTop type:fromVC];
    }
    return self;
}

-(void)createUIWithStatus:(NSString *)statustr andHasTop:(BOOL)hasTop type:(NSString *)fromVC {
    
    [self setBackgroundColor:[UIColor tt_grayBgColor]];
    UIView *bankView = [[UIView alloc] init];
    [self addSubview:bankView];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.bottom.mas_offset(-5);
    }];
    
    UIFont *priceFont = nil;
    if (iphone4) {
        priceFont = CHINESE_SYSTEM(11);
    }else if (iphone5){
        priceFont = CHINESE_SYSTEM(14);
    }else{
        priceFont = CHINESE_SYSTEM(15);
    }
    
    //商品数量  商品总价  运费
    _priceLable = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentRight font:priceFont];
    [bankView addSubview:_priceLable];
    
    //中间的线
    UILabel *midlleLine = [UILabel creatLineLable];
    [bankView addSubview:midlleLine];
    //右按钮
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:_rightButton];
    _rightButton.layer.cornerRadius = 3;;
    _rightButton.layer.borderColor = [UIColor tt_grayBgColor].CGColor;
    _rightButton.layer.borderWidth = 1;
    _rightButton.clipsToBounds = YES;
    _rightButton.titleLabel.font = MAIN_TITLE_FONT;
    _rightButton.backgroundColor = [UIColor redColor];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //左按钮
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:_leftButton];
    _leftButton.layer.cornerRadius = 3;;
    _leftButton.layer.borderColor = [UIColor tt_grayBgColor].CGColor;
    _leftButton.layer.borderWidth = 1;
    _leftButton.clipsToBounds = YES;
    _leftButton.titleLabel.font = MAIN_TITLE_FONT;
    [_leftButton setTitleColor:[UIColor tt_bodyTitleColor] forState:UIControlStateNormal];
    _leftButton.backgroundColor = [UIColor whiteColor];
    [_leftButton addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    if (hasTop){
        [bankView setBackgroundColor:[UIColor whiteColor]];
        
        if ([statustr isEqualToString:@"已取消"]) {
            
            [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(0);
                make.right.mas_offset(-10);
                make.left.mas_offset(10);
                make.height.mas_equalTo(0);
            }];
            
            [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(10);
                make.right.mas_offset(-10);
                make.bottom.mas_offset(-10);
                make.width.mas_offset(80);
            }];
        }else{
            
            [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(0);
                make.right.mas_offset(-10);
                make.left.mas_offset(10);
                make.height.mas_equalTo(35);
            }];
            
            [midlleLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_priceLable.mas_bottom).offset(0);
                make.left.right.mas_offset(0);
                make.height.mas_offset(0.5);
            }];
            
            [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_priceLable.mas_bottom).offset(10);
                make.right.mas_offset(-10);
                make.bottom.mas_offset(-10);
                make.width.mas_offset(80);
            }];
        }
    }else{
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(5);
            make.bottom.mas_offset(0);
            make.right.mas_offset(-10);
            make.width.mas_offset(80);
        }];
    }
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.height.equalTo(_rightButton);
        make.right.equalTo(_rightButton.mas_left).offset(-8);
    }];
    
    //订单状态（99：全部0：已取消 1：未付款；2：已付款，3：已收货；，6：已完成，7：已发货 ） 3456有删除按钮  2017.10.11  更改为已取消的也可以删除
    if ([fromVC isEqualToString:@"SCOrderListViewController"]) {
        if ([statustr isEqualToString:@"待付款"]) {
            [_leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
            [_rightButton setTitle:@"去付款" forState:UIControlStateNormal];
        }else if ([statustr isEqualToString:@"已付款"] || [statustr isEqualToString:@"退货成功"]){
            _leftButton.hidden = YES;
            _rightButton.hidden = YES;
        }else if ([statustr isEqualToString:@"已发货"]) {
            [_leftButton setTitle:@"查看物流" forState:UIControlStateNormal];
            [_rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
        }else if ([statustr isEqualToString:@"已收货"]) {
            if ([_iscomment isEqualToString:@"1"] || [_iscomment isEqualToString:@"true"]) {
                _leftButton.hidden = YES;
                [_rightButton setTitle:@"查看物流" forState:UIControlStateNormal];
            }else{
                [_leftButton setTitle:@"查看物流" forState:UIControlStateNormal];
                [_rightButton setTitle:@"去评价" forState:UIControlStateNormal];
            }
        }else if ([statustr isEqualToString:@"正在退货"]) {
            _leftButton.hidden = YES;
            [_rightButton setTitle:@"联系客服" forState:UIControlStateNormal];
            [_rightButton setTitleColor:[UIColor tt_bodyTitleColor] forState:UIControlStateNormal];
            _rightButton.backgroundColor = [UIColor whiteColor];

        }else if ([statustr isEqualToString:@"已完成"]) {
            [_rightButton setTitle:@"再次购买" forState:UIControlStateNormal];
            [_leftButton setTitle:@"删除订单" forState:UIControlStateNormal];
        }else if ([statustr isEqualToString:@"差价付款"]) {
            _leftButton.hidden = YES;
            [_rightButton setTitle:@"差价付款" forState:UIControlStateNormal];
        }else if ([statustr isEqualToString:@"支付中"]) {
            _leftButton.hidden = YES;
            [_rightButton setTitle:@"差价付款" forState:UIControlStateNormal];
        }else if ([statustr isEqualToString:@"已取消"]) {
            _leftButton.hidden = YES;
            [_rightButton setTitle:@"删除订单" forState:UIControlStateNormal];
        }
    }else{
        if ([statustr isEqualToString:@"待付款"]) {
            [_leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
            [_rightButton setTitle:@"去付款" forState:UIControlStateNormal];
        }else if ([statustr isEqualToString:@"已付款"] || [statustr isEqualToString:@"退货成功"]){
            _leftButton.hidden = YES;
            _rightButton.hidden = YES;
        }else if ([statustr isEqualToString:@"已发货"]) {
            [_leftButton setTitle:@"查看物流" forState:UIControlStateNormal];
            [_rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
        }else if ([statustr isEqualToString:@"已收货"]) {
            [_leftButton setTitle:@"查看物流" forState:UIControlStateNormal];
            [_rightButton setTitle:@"联系客服" forState:UIControlStateNormal];
            [_rightButton setTitleColor:[UIColor tt_bodyTitleColor] forState:UIControlStateNormal];

            _rightButton.backgroundColor = [UIColor whiteColor];

        }else if ([statustr isEqualToString:@"正在退货"]) {
            _leftButton.hidden = YES;
            [_rightButton setTitle:@"联系客服" forState:UIControlStateNormal];
            [_rightButton setTitleColor:[UIColor tt_bodyTitleColor] forState:UIControlStateNormal];
            _rightButton.backgroundColor = [UIColor whiteColor];

        }else if ([statustr isEqualToString:@"已完成"]) {
            [_rightButton setTitle:@"再次购买" forState:UIControlStateNormal];
            [_leftButton setTitle:@"删除订单" forState:UIControlStateNormal];
        }else if ([statustr isEqualToString:@"差价付款"]) {
            _leftButton.hidden = YES;
            [_rightButton setTitle:@"差价付款" forState:UIControlStateNormal];
        }else if ([statustr isEqualToString:@"支付中"]) {
            _leftButton.hidden = YES;
            [_rightButton setTitle:@"差价付款" forState:UIControlStateNormal];
        }else if ([statustr isEqualToString:@"已取消"]) {
            _leftButton.hidden = YES;
            [_rightButton setTitle:@"删除订单" forState:UIControlStateNormal];
        }
    }
    
}

-(void)rightBtnClick:(UIButton*)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rightButtonClick:)]) {
        [self.delegate rightButtonClick:btn];
    }

}

-(void)leftBtnClick:(UIButton*)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftButtonClick:)]) {
        [self.delegate leftButtonClick:btn];
    }
}

-(void)refreshButton:(NSString*)iscomment {
    _iscomment = iscomment;
    if ([_statustring isEqualToString:@"待付款"]) {
        [_leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [_rightButton setTitle:@"去付款" forState:UIControlStateNormal];
    }else if ([_statustring isEqualToString:@"已付款"] || [_statustring isEqualToString:@"退货成功"]){
        _leftButton.hidden = YES;
        _rightButton.hidden = YES;
    }else if ([_statustring isEqualToString:@"已发货"]) {
        [_leftButton setTitle:@"查看物流" forState:UIControlStateNormal];
        [_rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if ([_statustring isEqualToString:@"已收货"]) {
        if ([_iscomment isEqualToString:@"1"] || [_iscomment isEqualToString:@"true"]) {
            _leftButton.hidden = YES;
            [_rightButton setTitle:@"查看物流" forState:UIControlStateNormal];
            [_rightButton setTitleColor:[UIColor tt_bodyTitleColor] forState:UIControlStateNormal];
            _rightButton.backgroundColor = [UIColor whiteColor];
        }else{
            [_leftButton setTitle:@"查看物流" forState:UIControlStateNormal];
            [_rightButton setTitle:@"去评价" forState:UIControlStateNormal];
        }
    }else if ([_statustring isEqualToString:@"正在退货"]) {
        _leftButton.hidden = YES;
        [_rightButton setTitle:@"联系客服" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor tt_bodyTitleColor] forState:UIControlStateNormal];
        _rightButton.backgroundColor = [UIColor whiteColor];
        
    }else if ([_statustring isEqualToString:@"已完成"]) {
        [_rightButton setTitle:@"再次购买" forState:UIControlStateNormal];
        [_leftButton setTitle:@"删除订单" forState:UIControlStateNormal];
    }else if ([_statustring isEqualToString:@"差价付款"]) {
        _leftButton.hidden = YES;
        [_rightButton setTitle:@"差价付款" forState:UIControlStateNormal];
    }else if ([_statustring isEqualToString:@"支付中"]) {
        _leftButton.hidden = YES;
        [_rightButton setTitle:@"差价付款" forState:UIControlStateNormal];
    }else if ([_statustring isEqualToString:@"已完成"] || [_statustring isEqualToString:@"已取消"]) {
        _leftButton.hidden = YES;
        [_rightButton setTitle:@"删除订单" forState:UIControlStateNormal];
    }
}

@end
