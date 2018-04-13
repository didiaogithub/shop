//
//  SCCanCommentCell.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/9/9.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCCanCommentCell.h"

@interface SCCanCommentCell ()

@property(nonatomic,strong)UIImageView *iconImageView;
/**名称*/
@property(nonatomic,strong)UILabel *nameLable;
/**购买数量*/
@property(nonatomic,strong)UILabel *numberLable;

@property(nonatomic,strong)UILabel *priceLable;

@property(nonatomic,strong)UILabel *specLabel;

@end

@implementation SCCanCommentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createWaitCommentCell];
    }
    return self;
}

-(void)createWaitCommentCell {
    
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
    _iconImageView.layer.borderColor = [UIColor tt_grayBgColor].CGColor;
    _iconImageView.layer.borderWidth = 1;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(80, 80));
    }];
    
    _nameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_nameLable];
    _nameLable.numberOfLines = 2;
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_top);
        make.left.equalTo(_iconImageView.mas_right).offset(5);
        make.right.mas_offset(-100);
    }];
    
    //价格
    _priceLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_priceLable];
    _priceLable.text = @"¥5.00";
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLable.mas_top);
        make.right.mas_offset(-5);
        make.height.equalTo(@(20));
    }];
    
    //规格
    _specLabel = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    _specLabel.text = @"规格：";
    [self.contentView addSubview:_specLabel];
    [_specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20));
        make.left.equalTo(_iconImageView.mas_right).offset(5);
        make.bottom.equalTo(_iconImageView.mas_bottom);
    }];
    //数量
    _numberLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    _numberLable.text = @"数量";
    [self.contentView addSubview:_numberLable];
    [_numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20));
        make.right.mas_offset(-5);
        make.bottom.equalTo(_iconImageView.mas_bottom);
    }];
    
    
    _rightBtn = [UIButton configureButtonWithTitle:@"去评价" titleColor:[UIColor whiteColor] bankGroundColor:[UIColor tt_redMoneyColor] cornerRadius:5 font:MAIN_SUBTITLE_FONT borderWidth:0 borderColor:[UIColor clearColor] target:self action:@selector(releaseComment)];
    [self.contentView addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(10);
        make.right.mas_offset(-5);
        make.width.mas_offset(80);
        make.height.mas_offset(25);
    }];
    
    
    UILabel *bottomLine = [UILabel creatLineLable];
    [self.contentView addSubview:bottomLine];
    
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightBtn.mas_bottom).offset(15);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.height.mas_offset(1);
        make.bottom.mas_offset(0);
    }];
}


-(void)releaseComment {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoReleaseOrderComment)]) {
        [self.delegate gotoReleaseOrderComment];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoReleaseOrderComment:)]) {
        [self.delegate gotoReleaseOrderComment:self.rightBtn.tag-333];
    }
}

#pragma mark-刷新model数据
-(void)refreshWithDetailModel:(SCOrderDetailGoodsModel*)detailModel {
    
    NSString *imageString = [NSString stringWithFormat:@"%@",detailModel.path];
    if (![imageString hasPrefix:@"http"]) {
        imageString = [BaseImagestr_Url stringByAppendingString:imageString];
    }
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"defaultover"]];
    
    NSString *name = [NSString stringWithFormat:@"%@",detailModel.name];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    _nameLable.text = name;
    
    NSString *price = [NSString stringWithFormat:@"%@",detailModel.price];
    if (IsNilOrNull(price)) {
        price = @"";
    }else{
        price = [NSString stringWithFormat:@"¥%@",detailModel.price];
    }
    _priceLable.text = price;
    
    
    NSString *spec = [NSString stringWithFormat:@"%@",detailModel.spec];
    if (IsNilOrNull(spec)) {
        spec = @"";
    }else{
        spec = [NSString stringWithFormat:@"规格:%@",detailModel.spec];
    }
    _specLabel.text = spec;
    
    NSString *number = [NSString stringWithFormat:@"%@",detailModel.count];
    if (IsNilOrNull(number)) {
        number = @"";
    }else{
        number = [NSString stringWithFormat:@"x%@",detailModel.count];
    }
    _numberLable.text = number;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
