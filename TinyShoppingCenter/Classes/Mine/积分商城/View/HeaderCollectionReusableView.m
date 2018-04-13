//
//  HeaderCollectionReusableView.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/24.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@implementation HeaderCollectionReusableView
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    [self setBackgroundColor:[UIColor tt_grayBgColor]];

    
    _titleLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self addSubview:_titleLable];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.bottom.mas_offset(0);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
    }];
    
}
/**
 *   设置相应的数据
 */
-(void)reusableViewHearderTitle:(NSString *)title{
    self.titleLable.text = title;
}
@end
