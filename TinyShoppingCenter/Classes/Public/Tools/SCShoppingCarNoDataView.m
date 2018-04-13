//
//  SCShoppingCarNoDataView.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/12.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCShoppingCarNoDataView.h"

@implementation SCShoppingCarNoDataView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    self.backgroundColor = [UIColor tt_grayBgColor];
    [self addSubview:self.imageV];
    [self addSubview:self.nodataLabel];

}

-(UILabel *)nodataLabel{
    if(_nodataLabel == nil) {
        _nodataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height*0.5, self.frame.size.width, 20)];
        _nodataLabel.text = @"购物车还没有商品，去添加点什么吧~";
        _nodataLabel.textAlignment = NSTextAlignmentCenter;
        _nodataLabel.textColor = [UIColor colorWithHexString:@"#a3a3a3"];
        _nodataLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _nodataLabel;
}

-(UIImageView *)imageV {
    if (_imageV == nil) {
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 131,  99)];
        _imageV.center = CGPointMake(SCREEN_WIDTH*0.5, self.frame.size.height*0.5 - 99/2 - 15);
        _imageV.image = [UIImage imageNamed:@"emptyShoppingCart"];
    }
    return _imageV;
}

@end
