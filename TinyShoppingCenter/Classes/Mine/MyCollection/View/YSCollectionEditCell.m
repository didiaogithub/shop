//
//  YSCollectionEditCell.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/7/18.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "YSCollectionEditCell.h"


@interface YSCollectionEditCell ()

@property (nonatomic, strong) UIControl *touchCotrol;

@property (nonatomic, strong) UIImageView *imageViwe;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *comment;
@property (nonatomic, strong) UILabel *specLabel;

@end

@implementation YSCollectionEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.selected = NO;
    
    [_editBtn setBackgroundImage:[UIImage imageNamed:@"selectedgray"] forState:UIControlStateNormal];
    [_editBtn setBackgroundImage:[UIImage imageNamed:@"selectedred"] forState:UIControlStateSelected];
    [_editBtn addTarget:self action:@selector(isSelectFavorGoods) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_editBtn];
    
    UIImageView *imageViwe = [UIImageView new];
    imageViwe.image = [UIImage imageNamed:@"defaultover"];
    [self.contentView addSubview: _imageViwe = imageViwe];
    
    UILabel *title = [UILabel configureLabelWithTextColor:[UIColor tt_bodyTitleColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14]];
    title.text = @"类人胶原蛋白类人胶原蛋白类人";
    title.numberOfLines = 2;
    [self.contentView addSubview:_title = title];
    
    self.specLabel = [UILabel configureLabelWithTextColor:[UIColor tt_bodyTitleColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13]];
    self.specLabel.text = @"规格：";
    [self.contentView addSubview:self.specLabel];
    
    UILabel *price = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13]];
    price.text = @"¥99.99";
    [self.contentView addSubview:_price = price];
    
    UILabel *comment = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:13]];
    comment.text = @"好评100%";
    [self.contentView addSubview:_comment = comment];
    
    _touchCotrol = [[UIControl alloc]init];
    [_touchCotrol addTarget:self action:@selector(isSelectFavorGoods) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_touchCotrol];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    
    [_touchCotrol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(0);
        make.left.mas_equalTo(self.contentView.mas_left).offset(0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
    }];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(20,20));
    }];
    
    [_imageViwe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.editBtn.mas_right).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.equalTo(@90);
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(_imageViwe.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageViwe.mas_right).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.equalTo(@90);
    }];
    
    [_specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.title.mas_bottom);
//        make.bottom.equalTo(self.price.mas_top);
        make.bottom.equalTo(self.price.mas_top).offset(-5);
        make.height.mas_equalTo(20);
        make.left.equalTo(_imageViwe.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.equalTo(@90);
    }];
    
}

-(void)isSelectFavorGoods {
    if (self.editBtn.isSelected) {
        [self.editBtn setSelected:NO];
    } else {
        [self.editBtn setSelected:YES];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scCollectionEditCell:clickCellIndex:deleteOrNo:)]) {
        
        [self.delegate scCollectionEditCell:self clickCellIndex:self.indexRow deleteOrNo:self.editBtn.isSelected];
    }
    
}

-(void)refreshCellWithCollectionModel:(SCMyCollectionModel*)collectionM {
    
    if (collectionM.isSelect) {
        [self.editBtn setSelected:YES];
    }else{
        [self.editBtn setSelected:NO];
    }
    
    [_imageViwe sd_setImageWithURL:[NSURL URLWithString:collectionM.path] placeholderImage:[UIImage imageNamed:@"defaultover"]];
    
    NSString *name = [NSString stringWithFormat:@"【%@】%@", collectionM.itemtypename ,collectionM.name];
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName:[UIColor tt_bodyTitleColor]}];
    
    NSRange range = [name rangeOfString:@"】"];
    
    [aStr setAttributes:@{NSForegroundColorAttributeName:[UIColor tt_redMoneyColor]} range:NSMakeRange(0, range.location+1)];
    
    _title.attributedText = aStr;
    
    NSString *spec = [NSString stringWithFormat:@"%@", collectionM.spec];
    if (!IsNilOrNull(spec)) {
        spec = [NSString stringWithFormat:@"规格:%@", collectionM.spec];
    }else{
        spec = @"";
    }
    _specLabel.text = spec;
    
    NSString *saleprice = [NSString stringWithFormat:@"%@", collectionM.salesprice];
    if (!IsNilOrNull(saleprice)) {
        saleprice = [NSString stringWithFormat:@"¥%@", collectionM.salesprice];
    }else{
        saleprice = @"";
    }
    _price.text = saleprice;
    
    NSString *fine = [NSString stringWithFormat:@"%@", collectionM.fine];
    if (!IsNilOrNull(fine)) {
        fine = [NSString stringWithFormat:@"好评%@", collectionM.fine];
    }else{
        fine = @"";
    }
    _comment.text = fine;
}

@end

