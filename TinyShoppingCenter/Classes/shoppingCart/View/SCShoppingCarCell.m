//
//  SCShoppingCarCell.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/24.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCShoppingCarCell.h"

@interface SCShoppingCarCell ()
{
    UIImage *nomalImage;
    UIImage *selectedImage;
    UILabel *textLable;
    UIView *_countView;
    
}
@end

@implementation SCShoppingCarCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

-(void)initViews {
    
    int imageWidth = 0;
    if (iphone5) {
        imageWidth = 80;
    }else{
        imageWidth = 100;
    }
    
    _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_selectedButton];
    nomalImage = [UIImage imageNamed:@"selectedgray"];
    selectedImage = [UIImage imageNamed:@"selectedred"];
    [_selectedButton setImage:nomalImage forState:UIControlStateNormal];
    [_selectedButton setImage:selectedImage forState:UIControlStateSelected];
    [_selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(50*SCREEN_HEIGHT_SCALE);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    [_selectedButton addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
    _iconImageView.userInteractionEnabled = YES;
    _iconImageView.layer.borderColor = [UIColor tt_lineBgColor].CGColor;
    _iconImageView.layer.borderWidth = 1;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_iconImageView setImage:[UIImage imageNamed:@"bkimg"]];
    
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.equalTo(_selectedButton.mas_right).offset(10);
        make.size.mas_offset(CGSizeMake(imageWidth, imageWidth));
    }];
    
    _nameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_nameLable];
    _nameLable.numberOfLines = 0;
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_top);
        make.left.equalTo(_iconImageView.mas_right).offset(10*SCREEN_WIDTH_SCALE);
        make.right.mas_offset(-10);
        
    }];
    //规格
    
    textLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    textLable.text = @"规格：";
    [self.contentView addSubview:textLable];

    [textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLable.mas_bottom);
        make.left.equalTo(_nameLable.mas_left);
    }];
    
    //规格内容
    _standardLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_standardLable];
    _standardLable.text = @"规格";
    [_standardLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLable.mas_top);
        make.left.equalTo(textLable.mas_right);
    }];
    
    //价格
    _priceLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_priceLable];
    _priceLable.text = @"¥0.00";
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(textLable.mas_bottom).offset(15);
        make.left.equalTo(textLable.mas_left);
        make.bottom.equalTo(_iconImageView.mas_bottom);
    }];
    
    UILabel *textNumber = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    textNumber.text = @"数量：";
    [self.contentView addSubview:textNumber];
    _rightNumberLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_rightNumberLable];
    
    //自提商城进来 右边是加减按钮
    _countView = [[UIView alloc] init];
    [self.contentView addSubview:_countView];
    _countView.layer.cornerRadius = 3;
    _countView.layer.borderWidth = 1;
    _countView.layer.borderColor = CKYS_Color(130, 130, 130).CGColor;
    
    //减号按钮
    _reduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_countView addSubview:_reduceButton];
    _reduceButton.tag = 1111;
    [_reduceButton setTitle:@"-" forState:UIControlStateNormal];
    [_reduceButton setTitleColor:CKYS_Color(130, 130, 130) forState:UIControlStateNormal];
    
    //数字
    _countLable = [UILabel configureLabelWithTextColor:CKYS_Color(130, 130, 130) textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [_countView addSubview:_countLable];
    
    [_countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.bottom.equalTo(_priceLable.mas_bottom);
        if ([UIScreen mainScreen].bounds.size.height <=568) {
            make.size.mas_offset(CGSizeMake(85, 25));
        }else{
            make.size.mas_offset(CGSizeMake(110, 30));
        }
    }];
    
    
    [_reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        if ([UIScreen mainScreen].bounds.size.height <=568) {
            make.size.mas_offset(CGSizeMake(25, 25));
        }else{
            make.size.mas_offset(CGSizeMake(35, 30));
        }
    }];
    [_reduceButton addTarget:self action:@selector(clickCountButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _countLable.text = @"1";
    _countLable.layer.borderWidth = 1;
    _countLable.layer.borderColor = CKYS_Color(130, 130, 130).CGColor;
    [_countLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        if ([UIScreen mainScreen].bounds.size.height <=568) {
            make.left.mas_offset(25);
            make.size.mas_offset(CGSizeMake(35, 25));
        }else{
            make.left.mas_offset(33);
            make.size.mas_offset(CGSizeMake(40, 30));
        }
    }];
    
    //加号按钮
    _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_countView addSubview:_plusButton];
    _plusButton.tag = 1112;
    [_plusButton setTitle:@"+" forState:UIControlStateNormal];
    [_plusButton setTitleColor:CKYS_Color(130, 130, 130) forState:UIControlStateNormal];
    [_plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_reduceButton.mas_top);
        make.left.equalTo(_countLable.mas_right);
        make.size.equalTo(_reduceButton);
    }];
    [_plusButton addTarget:self action:@selector(clickCountButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lineLable = [UILabel creatLineLable];
    [self.contentView addSubview:lineLable];
    [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(10);
        make.left.right.bottom.mas_offset(0);
        make.height.mas_offset(1);
    }];
    
    
}
-(void)setBlock:(CarryBySelfBlock)block{
    _block = block;
    
}
#pragma mark-点击减号 和   加号 按钮
-(void)clickCountButton:(UIButton *)button{
    if (button.tag == 1111) { //减号
        if ((self.chooseCount - 1) <= 0 || self.chooseCount == 0) {
            self.chooseCount = 1;
        }else{
            self.chooseCount  = self.chooseCount -1;
        }
    }else{
        if (self.chooseCount  > 100 || self.chooseCount == 100) {
            self.chooseCount  = 99;
        }else{
            self.chooseCount  = self.chooseCount +1;
        }
    }
    
    _countLable.text = [NSString stringWithFormat:@"%zd", self.chooseCount];
    
    GoodModel *classM = [[GoodModel alloc] init];
    classM.itemid = _goodModel.itemid;
    classM.status = _goodModel.status;
    classM.price = _goodModel.price;
    classM.count = [NSString stringWithFormat:@"%zd", self.chooseCount];
    classM.spec = _goodModel.spec;
    classM.path = _goodModel.path;
    classM.name = _goodModel.name;
    classM.meopenid = _goodModel.meopenid;
    classM.isSelect = _selectedButton.selected;

    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [GoodModel createOrUpdateInRealm:realm withValue:classM];
    [realm commitWriteTransaction];
    if (_block){
        _block(classM,self.indexRow);
    }
    
}
#pragma mark-点击cell左侧按钮
-(void)clickSelect:(UIButton *)button
{
    button.selected = !button.selected;
    
    GoodModel *classM = [[GoodModel alloc] init];
    classM.itemid = _goodModel.itemid;
    classM.status = _goodModel.status;
    classM.price = _goodModel.price;
    classM.count = [NSString stringWithFormat:@"%zd", self.chooseCount];
    classM.spec = _goodModel.spec;
    classM.path = _goodModel.path;
    classM.name = _goodModel.name;
    classM.meopenid = _goodModel.meopenid;
    classM.isSelect = _selectedButton.selected;
    classM.isoversea = _goodModel.isoversea;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [GoodModel createOrUpdateInRealm:realm withValue:classM];
    [realm commitWriteTransaction];
    
//    _goodModel.isSelect = _selectedButton.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(singleClick:anRow:andSection:)]){
        [self.delegate singleClick:classM anRow:self.indexRow andSection:self.section];
    }
}
#pragma mark-刷新model数据
-(void)setModel:(GoodModel *)model{
    _goodModel = model;
    _selectedButton.selected = model.isSelect;
    self.chooseCount = [[NSString stringWithFormat:@"%@",model.count] integerValue];
    
    
    //商品图片
    NSString *imageString = model.path;
    if (![imageString hasPrefix:@"http"]) {
        imageString = [BaseImagestr_Url stringByAppendingString:model.path];
    }
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"defaultover"]];
    // 名称
    NSString *name = [NSString stringWithFormat:@"%@",model.name];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    _nameLable.text = name;
    
    //价格
    NSString *pricestr = [NSString stringWithFormat:@"%@",model.price];
    if (IsNilOrNull(pricestr)) {
        pricestr = @"";
    }
    _priceLable.text = [NSString stringWithFormat:@"¥%@",pricestr];
    
    _countLable.text = [NSString stringWithFormat:@"%@",model.count];
    
    //规格
    NSString *spec = [NSString stringWithFormat:@"%@",model.spec];
    if (IsNilOrNull(spec)) {
        spec = @"";
    }
    _standardLable.text = spec;
    
    if ([UIScreen mainScreen].bounds.size.width <= 568) {
        _standardLable.font = [UIFont systemFontOfSize:12];
        textLable.font = [UIFont systemFontOfSize:12];
    }
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

