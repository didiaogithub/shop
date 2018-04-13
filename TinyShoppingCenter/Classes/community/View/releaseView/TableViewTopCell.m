//
//  TableViewTopCell.m
//  Created by 庞宏侠 on 17/2/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "TableViewTopCell.h"

@interface TableViewTopCell ()

@property(nonatomic,strong) UIView *bgview;

@end

@implementation TableViewTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    [CKCNotificationCenter addObserver:self selector:@selector(returnCommnet) name:@"CommentChanged" object:nil];
    
    self.bgview = [[UIView alloc] init];
    self.bgview.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgview];
    
    self.textView = [[JSTextView alloc]initWithFrame:self.bounds];
    [self.bgview addSubview:self.textView];
    //1.设置提醒文字
    self.textView.myPlaceholder = @"这一刻的想法...";
    //2.设置提醒文字颜色
    self.textView.myPlaceholderColor = [UIColor lightGrayColor];
    
    [self.bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(150);
    }];
}

-(void)returnCommnet {
    if (self.CommentCellBlock) {
        self.CommentCellBlock(self.textView.text);
    }
}

@end
