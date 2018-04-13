//
//  ImagePicker.h
//
//  Created by 庞宏侠 on 17/2/28.
//  Copyright © 2017年 Apple. All rights reserved.
//


#import "TableViewItemCell.h"

@interface TableViewItemCell ()

@property(nonatomic,strong) UIView *bgView;

@end

@implementation TableViewItemCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.bgView = [[UIView alloc] init];
    [self.contentView addSubview:self.bgView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.top.bottom.mas_equalTo(0);
        make.height.mas_equalTo(80);
    }];
    
    self.bgView.backgroundColor = [UIColor orangeColor];
}
/**刷新数据*/
- (void)refreshCellWithModel:(GoodModel *)model{


}
@end
