//
//  SCCategoryCollectCell.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/21.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCCategoryCollectCell.h"
#import "SCFirstPageModel.h"

@interface SCCategoryCollectCell()

@property (nonatomic, strong) UILabel *catoNameLabel;

@end

@implementation SCCategoryCollectCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
    
    self.backgroundColor = [UIColor whiteColor];
    self.catoNameLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:16]];
    self.catoNameLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.catoNameLabel];
    [self.catoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.centerY.equalTo(self.mas_centerY).offset(4);
    }];
}

+(CGSize)calculateSize:(id)data {
    
    if (!data) {
        return CGSizeZero;
    }
    
    Categorylist *cateM = data;
    
    CGSize titleSize = [cateM.name boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName, nil] context:nil].size;
    return CGSizeMake(AdaptedWidth(titleSize.width)+15, AdaptedHeight(40));
}

-(void)fillData:(id)data{
    
    Categorylist *cateM = data;
    self.catoNameLabel.text = cateM.name;
    
}



@end
