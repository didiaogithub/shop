//
//  ImagePicker.h
//
//  Created by 庞宏侠 on 17/2/28.
//  Copyright © 2017年 Apple. All rights reserved.
//


#import "TableViewAddCell.h"

@interface TableViewAddCell ()

@property(nonatomic,strong) UIView *bgView;

@property(nonatomic,strong) UIButton *addBtn;
@end

@implementation TableViewAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
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
    }];
    
    self.addBtn = [[UIButton alloc] init];
    [self.bgView addSubview:self.addBtn];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(8);
        make.height.mas_equalTo(AdaptedHeight(50));
        make.bottom.mas_equalTo(-8);
    }];
    
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    self.addBtn.layer.cornerRadius = 5;
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.layer.borderWidth = 1;
    self.addBtn.layer.borderColor = [UIColor tt_lineBgColor].CGColor;
    self.addBtn.titleLabel.font = MAIN_TITLE_FONT;
    [self.addBtn setTitleColor:SubTitleColor forState:UIControlStateNormal];
    [self.addBtn setTitle:@"添加商品" forState:UIControlStateNormal];
    
    [self.addBtn addTarget:self action:@selector(tapAdd) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tapAdd
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(comeToAddGoods)]) {
        [self.delegate comeToAddGoods];
    }
  
}

@end
