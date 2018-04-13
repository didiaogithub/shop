//
//  SCReleaseCommentCell.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/9/9.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCReleaseCommentCell.h"
#import "HXPhotoViewController.h"
#import "HXPhotoView.h"

@interface SCReleaseCommentCell()<HXPhotoViewDelegate>
//
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *numberLable;
@property (nonatomic, strong) UILabel *priceLable;
@property (nonatomic, strong) UILabel *specLabel;
//
@property (nonatomic, strong) UILabel *leftLable;
//
@property (nonatomic, strong) UIView *bgview;
//
@property (nonatomic, strong) HXPhotoManager *manager;
@property (nonatomic, strong) HXPhotoView *photoView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation SCReleaseCommentCell

-(HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.openCamera = YES;
        _manager.cacheAlbum = YES;
        _manager.lookLivePhoto = YES;
        _manager.open3DTouchPreview = YES;
        _manager.cameraType = HXPhotoManagerCameraTypeSystem;
        _manager.photoMaxNum = 3;
        _manager.videoMaxNum = 0;
        _manager.maxNum = 3;
        _manager.saveSystemAblum = NO;
        _manager.UIManager.navBar = ^(UINavigationBar *navBar) {
        };
    }
    return _manager;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponnets];
    }
    return self;
}

-(void)initComponnets {
    
    [CKCNotificationCenter addObserver:self selector:@selector(returnCommnet) name:@"CommentChanged" object:nil];

    
    [self createGoodsView];
    
    [self createStarView];

    [self commentContent];
    
    [self commentPicView];
    
}

-(void)createGoodsView {
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
    
    UILabel *bottomLine = [UILabel creatLineLable];
    [self.contentView addSubview:bottomLine];
}

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

-(void)createStarView {
    _leftLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_leftLable];
    _leftLable.text = @"综合评价";
    [_leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(100);
        make.left.mas_offset(10);
        make.height.mas_offset(50);
    }];
    
    _startView = [[StarEvaluateView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2/3, 100, SCREEN_WIDTH/3, 50) starIndex:0 starWidth:20 space:3.f defaultImage:[UIImage imageNamed:@"smallstargray"] lightImage:[UIImage imageNamed:@"smallstarred"] isCanTap:YES];
    [self.contentView addSubview:_startView];
}

-(void)commentContent {
    
    self.bgview = [[UIView alloc] init];
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
        make.top.mas_offset(150);
        make.height.mas_equalTo(155);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(150);
    }];
    self.bgview.backgroundColor = [UIColor whiteColor];
}

-(void)returnCommnet {
    if (_contentBlock != nil) {
        _contentBlock(self.textView.text);
    }
}

-(void)returnCommentContent:(CommentContentBlock)contentBlock {
    _contentBlock = contentBlock;
}

-(void)returnCommentImageBlock:(CommentImageBlock)imageBlock {
    _imageBlock = imageBlock;
}

static const CGFloat kPhotoViewMargin = 12.0;

-(void)commentPicView {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 310, SCREEN_WIDTH, 130+10)];
    scrollView.alwaysBounceVertical = YES;
    [self.contentView addSubview:scrollView];
    self.scrollView = scrollView;
    
    scrollView.scrollEnabled = NO;
    
    CGFloat width = scrollView.frame.size.width;
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(kPhotoViewMargin, kPhotoViewMargin, width - kPhotoViewMargin * 2, 0);
    photoView.delegate = self;
    photoView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:photoView];
    self.photoView = photoView;
}

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    NSSLog(@"所有:%ld - 照片:%ld - 视频:%ld",allList.count,photos.count,videos.count);
    [HXPhotoTools getImageForSelectedPhoto:photos type:HXPhotoToolsFetchHDImageType completion:^(NSArray<UIImage *> *images) {
        NSSLog(@"%@",images);
        
        if (self.imageBlock != nil) {
            self.imageBlock(images);
        }
    }];
}

-(void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}

-(void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSSLog(@"%@",NSStringFromCGRect(frame));
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
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
