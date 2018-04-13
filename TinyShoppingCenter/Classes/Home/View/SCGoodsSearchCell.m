//
//  SCGoodsSearchCell.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCGoodsSearchCell.h"

@interface SCGoodsSearchCell ()

@property (nonatomic, strong) UIView *countView;
@property (nonatomic, strong) UIButton *topBigButton;

@end

@implementation SCGoodsSearchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createTopViews];
    }
    return self;
}
-(void)createTopViews{
    
    self.backgroundColor = [UIColor whiteColor];
    
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
    _iconImageView.userInteractionEnabled = YES;
    _iconImageView.layer.borderColor = [UIColor tt_grayBgColor].CGColor;
    _iconImageView.layer.borderWidth = 1;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_iconImageView setImage:[UIImage imageNamed:@"defaultover"]];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(90, 90));
    }];
    
    _nameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    _nameLable.text = @"商品名称";
    [self.contentView addSubview:_nameLable];
    _nameLable.numberOfLines = 0;
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_top);
        make.left.equalTo(_iconImageView.mas_right).offset(10);
        make.right.mas_offset(-10);
        
    }];
    //规格
    
    //规格内容
    _specLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_specLable];
    _specLable.text = @"规格";
    [_specLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLable.mas_bottom).offset(5);
        make.left.equalTo(_nameLable.mas_left);
    }];
    
    //价格
    _priceLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_priceLable];
    _priceLable.text = @"¥0.00";
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_specLable.mas_bottom).offset(15);
        make.left.equalTo(_specLable.mas_left);
        make.bottom.equalTo(_iconImageView.mas_bottom);
    }];
    
    //好评率
    _commentLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_commentLable];
    _commentLable.text = @"好评率100%";
    [_commentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLable.mas_top);
        make.right.equalTo(_nameLable.mas_right);
        make.bottom.equalTo(_priceLable.mas_bottom);
    }];
    
    UILabel *bootmLine = [UILabel creatLineLable];
    [self.contentView addSubview:bootmLine];
    [bootmLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(10);
        make.left.right.bottom.mas_offset(0);
        make.height.mas_offset(1);
    }];
    
}
#pragma mark-刷新model数据
-(void)refreshCellWithModel:(SCSearchGoodsModel *)goodModel{
    //商品图片
    NSString *imageString = goodModel.path1;
    
    if (![imageString hasPrefix:@"http"]) {
        imageString = [BaseImagestr_Url stringByAppendingString:imageString];
    }
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"defaultover"]];
    // 名称
    NSString *name = [NSString stringWithFormat:@"%@",goodModel.name];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    _nameLable.text = name;
    
    //规格
    NSString *specStr = [NSString stringWithFormat:@"%@",goodModel.spec];
    if (IsNilOrNull(specStr)) {
        specStr = @"";
    }
    _specLable.text = specStr;
    
    NSString *salesprice = [NSString stringWithFormat:@"%@", goodModel.salesprice];
    if (IsNilOrNull(salesprice)) {
        salesprice = @"";
    }else{
        salesprice = [NSString stringWithFormat:@"¥%@", goodModel.salesprice];
    }
    _priceLable.text = salesprice;
    
    //好评率
    NSString *commentStr = [NSString stringWithFormat:@"%@",goodModel.fine];
    if (IsNilOrNull(commentStr)) {
        commentStr = @"100%";
    }
    _commentLable.text = [NSString stringWithFormat:@"好评%@",commentStr];
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
