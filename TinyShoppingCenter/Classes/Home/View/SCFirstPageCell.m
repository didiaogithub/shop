//
//  SCFirstPageCell.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/16.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCFirstPageCell.h"
#import "SDCycleScrollView.h"
#import "SCFirstPageModel.h"
#import "SCCategoryCollectCell.h"
#import "SCCategoryViewController.h"
#import "InvitationAlterVeiw.h"
#import "SCGoodsDetailViewController.h"
#import "SCFirstPageViewController.h"
#import "SCGoodsSearchViewController.h"
#import "SCBannerActiveGDVC.h"


@implementation SCFirstPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fillData:(id)data {
    
}

-(void)callWithParameter:(id)parameter {
    
}

+(CGFloat)computeHeight:(id)data {
    return 0;
}

@end

@interface SCShopInfoCell()<InvitationAlterVeiwDelegate>

@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIImageView *personalInfoView;
@property (nonatomic, strong) UIImageView *ckheadImageView;
@property (nonatomic, strong) UILabel *shopNameLable;
@property (nonatomic, strong) UILabel *samllnameLabel;
@property (nonatomic, strong) UIButton *honorButton;
@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) UIButton *telButton;
@property (nonatomic, strong) UIButton *categaryButton;
@property (nonatomic, copy)   NSString *cerPath;
@property (nonatomic, copy)   NSString *wxAccount;
@property (nonatomic, strong) InvitationAlterVeiw *invitationView;
@property (nonatomic, copy)   NSString *telephoneNumber;


@end

@implementation SCShopInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
    self.backgroundColor = [UIColor whiteColor];
    //个人信息View
    _personalInfoView = [UIImageView new];
    _personalInfoView.userInteractionEnabled = YES;
    [self addSubview:_personalInfoView];
    [_personalInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    //创客头像
    _ckheadImageView = [UIImageView new];
    _ckheadImageView.contentMode = UIViewContentModeScaleToFill;
    _ckheadImageView.layer.borderWidth = 1.0;
    _ckheadImageView.layer.borderColor = [UIColor colorWithHexString:@"#e8e8e8"].CGColor;
    [_personalInfoView addSubview:_ckheadImageView];
    [_ckheadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedWidth(10));
        make.left.mas_offset(AdaptedWidth(10));
//        make.bottom.equalTo(self.mas_bottom).offset(AdaptedWidth(-10));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(43), AdaptedWidth(43)));
    }];
    //资质 按钮
    _honorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_personalInfoView addSubview:_honorButton];
    _honorButton.tag = 190;
    [_honorButton setImage:[UIImage imageNamed:@"honour"] forState:UIControlStateNormal];
    [_honorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ckheadImageView.mas_bottom).offset(AdaptedWidth(-10));
        make.left.equalTo(_ckheadImageView.mas_right).offset(AdaptedWidth(-7));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(14), AdaptedWidth(20)));
    }];
    
    //搜索按钮
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_personalInfoView addSubview:_searchButton];
    _searchButton.tag = 193;
    [_searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [_searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedWidth(20));
        make.right.mas_offset(-AdaptedWidth(10));
//        make.size.mas_offset(CGSizeMake(30, 20));
        make.width.mas_equalTo(30);
        make.bottom.mas_offset(-AdaptedWidth(20));
    }];
    //点击拨打电话
    _telButton = [[UIButton alloc] init];
    [_personalInfoView addSubview:_telButton];
    _telButton.tag = 192;
    [_telButton setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [_telButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_searchButton);
        make.right.equalTo(_searchButton.mas_left).offset(-10);
//        make.size.mas_offset(CGSizeMake(30, 20));
        make.width.mas_equalTo(30);
    }];
    
    //点击微信头像与创客聊天
    _messageButton = [[UIButton alloc] init];
    [_personalInfoView addSubview:_messageButton];
    _messageButton.tag = 191;
    [_messageButton setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [_messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.height.equalTo(_telButton);
        make.right.equalTo(_telButton.mas_left).offset(-10);
//        make.size.mas_offset(CGSizeMake(30, 20));
        make.width.mas_equalTo(30);

    }];
    
    //官网或者创客名字
    _shopNameLable = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"#222222"] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_personalInfoView addSubview:_shopNameLable];
    [_shopNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ckheadImageView.mas_top).offset(AdaptedWidth(3.5));
        make.left.equalTo(_ckheadImageView.mas_right).offset(AdaptedWidth(10));
        make.right.equalTo(_messageButton.mas_left).offset(-10);
//        make.height.mas_equalTo(20);
        
    }];
    //昵称
    _samllnameLabel = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"#6e6e6e"] textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [_personalInfoView addSubview:_samllnameLabel];
    [_samllnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shopNameLable.mas_bottom).offset(AdaptedWidth(5));;
        make.left.equalTo(_shopNameLable.mas_left);
        make.right.equalTo(_messageButton.mas_left).offset(-10);
        make.height.mas_equalTo(20);
        
    }];
    
    
    [_honorButton addTarget:self action:@selector(clikTopButton:) forControlEvents:UIControlEventTouchUpInside];
    [_messageButton addTarget:self action:@selector(clikTopButton:) forControlEvents:UIControlEventTouchUpInside];
    [_telButton addTarget:self action:@selector(clikTopButton:) forControlEvents:UIControlEventTouchUpInside];
    [_searchButton addTarget:self action:@selector(clikTopButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 点击电话按钮  资质证书按钮  聊天按钮
-(void)clikTopButton:(UIButton *)button{
    button.adjustsImageWhenHighlighted = NO;
    NSInteger buttonTag = button.tag - 190;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopInfoClickWithTag:)]) {
        [self.delegate shopInfoClickWithTag:buttonTag];
    }
}

-(void)copyInvitationCode {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.invitationView.titleLable.text;
    if(pasteboard == nil){
        NSLog(@"复制失败");
    }else{
        NSLog(@"复制成功");
    }
}

-(void)fillData:(id)data {
    NSDictionary *dict = data;
    SCFirstPageModel *firstM = [[SCFirstPageModel alloc] init];
    firstM.ckInfoM = dict[@"data"];
    
    firstM.headerPic = [NSString stringWithFormat:@"%@", dict[@"headerPic"]];
    
    [_personalInfoView sd_setImageWithURL:[NSURL URLWithString:firstM.headerPic]];

    if ([firstM.ckInfoM.logopath hasPrefix:@"http"] || [firstM.ckInfoM.logopath hasPrefix:@"https"]) {
        [_ckheadImageView sd_setImageWithURL:[NSURL URLWithString:firstM.ckInfoM.logopath]placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
    }else{
        NSString *imageString = [Base_Imagestr_Url stringByAppendingString:[NSString stringWithFormat:@"%@", firstM.ckInfoM.logopath]];
        [_ckheadImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
    }
    
    NSString *showcer = [NSString stringWithFormat:@"%@", firstM.ckInfoM.cershow];
    if ([showcer isEqualToString:@"false"] || [showcer isEqualToString:@"0"]) {
        _honorButton.hidden = YES;
    }else{
        _honorButton.hidden = NO;
        self.cerPath = firstM.ckInfoM.cerpath;
    }
    
    NSString *wxShow = [NSString stringWithFormat:@"%@", firstM.ckInfoM.wxshow];
    if ([wxShow isEqualToString:@"false"] || [wxShow isEqualToString:@"0"]) {
        _messageButton.hidden = YES;
    }else{
        _messageButton.hidden = NO;
    }
    
    NSString *telephoneShow = [NSString stringWithFormat:@"%@", firstM.ckInfoM.mobileshow];
    if ([telephoneShow isEqualToString:@"false"] || [telephoneShow isEqualToString:@"0"]) {
        _telButton.hidden = YES;
        [_messageButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_searchButton);
            make.right.equalTo(_searchButton.mas_left).offset(-10);
            make.size.mas_offset(CGSizeMake(30, 20));
        }];
        
    }else{
        _telButton.hidden = NO;
        [_messageButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.height.equalTo(_telButton);
            make.right.equalTo(_telButton.mas_left).offset(-10);
            make.size.mas_offset(CGSizeMake(30, 20));
        }];
    }
    
    
    self.telephoneNumber = [NSString stringWithFormat:@"%@", firstM.ckInfoM.mobile];
    self.wxAccount = firstM.ckInfoM.wxaccount;
    
    
    NSString *shopName = [NSString stringWithFormat:@"%@", firstM.ckInfoM.name];
    NSString *smallname = [NSString stringWithFormat:@"%@", firstM.ckInfoM.smallname];
    if (!IsNilOrNull(shopName) && !IsNilOrNull(smallname)) {
        [_shopNameLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_ckheadImageView.mas_top).offset(AdaptedWidth(3.5));
            make.left.equalTo(_ckheadImageView.mas_right).offset(AdaptedWidth(10));
            make.right.equalTo(_messageButton.mas_left).offset(-10);
            make.height.mas_equalTo(20);
        }];
        
        [_samllnameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_shopNameLable.mas_bottom).offset(AdaptedWidth(5));;
            make.left.equalTo(_shopNameLable.mas_left);
            make.right.equalTo(_messageButton.mas_left).offset(-10);
            make.height.mas_equalTo(20);
        }];
    }else if (!IsNilOrNull(shopName) && IsNilOrNull(smallname)){
        smallname = @"";
        [_shopNameLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_ckheadImageView.mas_top);
            make.left.equalTo(_ckheadImageView.mas_right).offset(AdaptedWidth(10));
            make.right.equalTo(_messageButton.mas_left).offset(-10);
            make.bottom.equalTo(_ckheadImageView.mas_bottom);
        }];
        [_samllnameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_shopNameLable.mas_bottom).offset(AdaptedWidth(5));;
            make.left.equalTo(_shopNameLable.mas_left);
            make.right.equalTo(_messageButton.mas_left).offset(-10);
            make.height.mas_equalTo(0);
        }];
    }else if (IsNilOrNull(shopName) && !IsNilOrNull(smallname)){
        shopName = @"";
        [_shopNameLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_ckheadImageView.mas_top);
            make.left.equalTo(_ckheadImageView.mas_right).offset(AdaptedWidth(10));
            make.right.equalTo(_messageButton.mas_left).offset(-10);
            make.height.mas_equalTo(0);
        }];
        
        [_samllnameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_ckheadImageView.mas_top);
            make.left.equalTo(_ckheadImageView.mas_right).offset(AdaptedWidth(10));
            make.right.equalTo(_messageButton.mas_left).offset(-10);
            make.bottom.equalTo(_ckheadImageView.mas_bottom);
        }];
    }else{
        shopName = @"";
        smallname = @"";
    }
    _shopNameLable.text = shopName;
    _samllnameLabel.text = smallname;
}

@end


@interface SCCategoryCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *cateCollectView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *idArr;

@end

@implementation SCCategoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.cateCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AdaptedHeight(40)) collectionViewLayout:layout];
    self.cateCollectView.backgroundColor = [UIColor whiteColor];
    self.cateCollectView.delegate = self;
    self.cateCollectView.dataSource = self;
    [self addSubview:self.cateCollectView];
}

-(void)fillData:(id)data {
    NSDictionary *dict = data;    
    RLMArray *arr = dict[@"data"];
    self.dataArr = [NSMutableArray array];
    self.titleArr = [NSMutableArray array];
    self.idArr = [NSMutableArray array];
    
    Categorylist *cateM = [[Categorylist alloc] init];
    cateM.name = @"全部";
    cateM.categoryId = @"0";
//    [arr insertObject:cateM atIndex:0];
    for (Categorylist *cateM in arr) {
        CellModel *CategoryM = [self creatCellModel:[SCCategoryCollectCell class] userInfo:cateM size:[SCCategoryCollectCell calculateSize:cateM]];
        SectionModel *sectionModel = [self createSectionModel:@[CategoryM] headerHeight:10 footerHeight:20];
        [self.dataArr addObject:sectionModel];
        [self.titleArr addObject:cateM.name];
        [self.idArr addObject:cateM.categoryId];

    }
    
    
    CellModel *CategoryM = [self creatCellModel:[SCCategoryCollectCell class] userInfo:cateM size:[SCCategoryCollectCell calculateSize:cateM]];
    SectionModel *sectionModel = [self createSectionModel:@[CategoryM] headerHeight:10 footerHeight:20];
    [self.dataArr insertObject:sectionModel atIndex:0];
    
    if (![self.titleArr containsObject:@"全部"]) {
        [self.titleArr insertObject:@"全部" atIndex:0];
    }
    
    if (![self.idArr containsObject:@"0"]) {
        [self.idArr insertObject:@"0" atIndex:0];
    }
    
    for (SectionModel *sectionModel in self.dataArr) {
        for (CellModel *cellModel in sectionModel.cells) {
            [self.cateCollectView registerClass:NSClassFromString(cellModel.className) forCellWithReuseIdentifier:cellModel.reuseIdentifier];
        }
    }
    [self.cateCollectView reloadData];
}

-(CellModel *)creatCellModel:(Class)cls userInfo:(id)userInfo size:(CGSize)size{
    CellModel *model = [[CellModel alloc]init];
    model.userInfo = userInfo;
    model.size = size;
    model.className = NSStringFromClass(cls);
    return model;
}

-(SectionModel*)createSectionModel:(NSArray<CellModel*>*)items headerHeight:(CGFloat)headerHeight footerHeight:(CGFloat)footerHeight {
    SectionModel *model = [SectionModel sectionModelWithTitle:nil cells:items];
    model.headerhHeight = headerHeight;
    model.footerHeight = footerHeight;
    return model;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if(self.dataArr){
        return self.dataArr.count;
    }
    return 0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    SectionModel *s = self.dataArr[section];
    if(s.cells) {
        return s.cells.count;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SectionModel *s = self.dataArr[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    
    SCCategoryCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:item.reuseIdentifier forIndexPath:indexPath];
    SEL selector = NSSelectorFromString(@"fillData:");
    if([cell respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
        [cell performSelector:selector withObject:item.userInfo];
#pragma clang diagnostic pop
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SectionModel *s = self.dataArr[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    return item.size;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SCFirstPageViewController *homeVC;
    UIResponder *next = self.nextResponder;
    do {
        //判断响应者是否为视图控制器
        if ([next isKindOfClass:[SCFirstPageViewController class]]) {
            homeVC = (SCFirstPageViewController*)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    
    
    SCCategoryViewController *category = [[SCCategoryViewController alloc] init];
    category.titleArr = self.titleArr;
    category.categoryIdArr = self.idArr;
    category.selectedIndex = indexPath.section;
    [homeVC.navigationController pushViewController:category animated:YES];
}


@end


@interface SCBannerCell()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *idArray;
@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSString *type;

@end

@implementation SCBannerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 185*SCREEN_WIDTH/375.0f)];
    _myScrollView.showsVerticalScrollIndicator = NO;
    _myScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_myScrollView];
    
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 185*SCREEN_WIDTH/375.0f) delegate:self placeholderImage:[UIImage imageNamed:@"defaultbanner"]];
    
    self.cycleScrollView.backgroundColor = [UIColor whiteColor];
    self.cycleScrollView.currentPageDotColor = [UIColor redColor];
    self.cycleScrollView.pageDotColor = [UIColor lightGrayColor];
    self.cycleScrollView.imageURLStringsGroup = _imageArray;
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentLeft;
    [self.myScrollView addSubview:self.cycleScrollView];
    
}
- (void)fillData:(id)data {
    //    if (!data) {
    //        return;
    //    }
    
    _imageArray = [NSMutableArray array];
    _idArray = [NSMutableArray array];
    NSArray *dataArr = data[@"data"];
    for (Bannerlist *bannerM in dataArr) {
        if (!IsNilOrNull(bannerM.path)) {
            [_imageArray addObject:bannerM.path];
        }
        [_idArray addObject:bannerM];
    }
    self.cycleScrollView.imageURLStringsGroup = _imageArray;
    self.myScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
    self.cycleScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    [self pushToActive:index];
}

#pragma mark - 首页活动轮播事件
-(void)pushToActive:(NSInteger)index {
    
    SCFirstPageViewController *homeVC;
    UIResponder *next = self.nextResponder;
    do {
        //判断响应者是否为视图控制器
        if ([next isKindOfClass:[SCFirstPageViewController class]]) {
            homeVC = (SCFirstPageViewController*)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    
    Bannerlist *bannerM  = _idArray[index];
    
    NSString *activeId = [NSString stringWithFormat:@"%@", bannerM.activityid];
    if (!IsNilOrNull(activeId) && ![activeId isEqualToString:@"0"]) {
        if(!IsNilOrNull(bannerM.bannerId) && ![bannerM.bannerId isEqualToString:@"0"]){
            SCBannerActiveGDVC *detail = [[SCBannerActiveGDVC alloc] init];
            if (IsNilOrNull(bannerM.link)) {
                return;
            }
            detail.link = bannerM.link;
            detail.goodsId = bannerM.bannerId;
            detail.activeID = bannerM.activityid;
            detail.limitnum = bannerM.limitnum;
            detail.showBuyBottom = @"YES";
            [homeVC.navigationController pushViewController:detail animated:YES];
        }else{
            SCBannerActiveGDVC *detail = [[SCBannerActiveGDVC alloc] init];
            if (IsNilOrNull(bannerM.link)) {
                return;
            }
            detail.link = bannerM.link;
            detail.activeID = bannerM.activityid;
            detail.showBuyBottom = @"NO";
            [homeVC.navigationController pushViewController:detail animated:YES];
        }
    }else{
        if(!IsNilOrNull(bannerM.bannerId) && ![bannerM.bannerId isEqualToString:@"0"]){
            SCGoodsDetailViewController *detail = [[SCGoodsDetailViewController alloc] init];
            detail.goodsId = bannerM.bannerId;
            [homeVC.navigationController pushViewController:detail animated:YES];
        }else{
            SCBannerActiveGDVC *detail = [[SCBannerActiveGDVC alloc] init];
            if (IsNilOrNull(bannerM.link)) {
                return;
            }
            detail.link = bannerM.link;
            detail.showBuyBottom = @"NO";
            [homeVC.navigationController pushViewController:detail animated:YES];
        }
    }
}

@end

@interface SCGoodListCell()

@property (nonatomic, strong) UIImageView *goodsImgV;

@end

@implementation SCGoodListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize {

    self.backgroundColor = [UIColor tt_grayBgColor];
    self.goodsImgV = [UIImageView new];
    self.goodsImgV.backgroundColor = [UIColor tt_grayBgColor];
    self.goodsImgV.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.goodsImgV];
    
    [self.goodsImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

-(void)fillData:(id)data {

    NSDictionary *dict = data;
    
    Goodslist *goods = dict[@"data"];
    
    [self.goodsImgV sd_setImageWithURL:[NSURL URLWithString:goods.imgpath] placeholderImage:[UIImage imageNamed:@"defaultindexover"]];
    
}

@end

@interface SCTopiclistCell()

@property (nonatomic, strong) UIImageView *goodsImgV;

@end

@implementation SCTopiclistCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
    
    self.goodsImgV = [UIImageView new] ;
    [self addSubview:self.goodsImgV];
    
    [self.goodsImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

-(void)fillData:(id)data {
    
    NSDictionary *dict = data;
    
    Topiclist *topM = dict[@"data"];
    
    [self.goodsImgV sd_setImageWithURL:[NSURL URLWithString:topM.path] placeholderImage:[UIImage imageNamed:@"defaultindexover"]];
    
}


@end

@interface SCTitleCell()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SCTitleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
    
    self.titleLabel = [UILabel configureLabelWithTextColor:[UIColor tt_bodyTitleColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:14]];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"精选单品";
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

@end


