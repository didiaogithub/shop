//
//  YSMemberPointViewController.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/5/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "YSMemberPointViewController.h"
#import "YSPointCell.h"
#import "SCIntegraModel.h"
#import "SCPointExplainCell.h"

@interface YSMemberPointViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *imageViwe;
@property (nonatomic, strong) UILabel *totalPoint;
@property (nonatomic, strong) UILabel *explain;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) NSMutableArray *nameArr;
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, assign) NSInteger curPage;

@property (nonatomic, strong) NodataLableView *nodataLableView;
@property (nonatomic, copy)   NSString *type;

@property (nonatomic, strong) UIWebView *pointWebView;
@property (nonatomic, strong) UIImageView *noData;

@end

@implementation YSMemberPointViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的积分";
    self.view.backgroundColor = [UIColor whiteColor];
//    [self initComponents];
//    
//    self.type = @"0";
//    [self requestDataWithType: self.type];
    
    [self refreshUI];
}

-(void)refreshUI {
    RequestReachabilityStatus status = [RequestManager reachabilityStatus];
    switch (status) {
        case RequestReachabilityStatusReachableViaWiFi:
        case RequestReachabilityStatusReachableViaWWAN: {
            [self initViews];
        }
            break;
        default: {
            if (_noData == nil) {
                _noData = [[UIImageView alloc] initWithFrame:self.view.bounds];
                [self.view addSubview:_noData];
                _noData.userInteractionEnabled = YES;
                _noData.image = [UIImage imageNamed:@"NoNetHold"];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshUI)];
                [_noData addGestureRecognizer:tap];
            }
        }
            break;
    }
}

-(void)initViews {
    
    if (@available(iOS 11.0, *)) {
        _pointWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NaviAddHeight-BOTTOM_BAR_HEIGHT-64)];
    }else{
        _pointWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    
    _pointWebView.scrollView.showsVerticalScrollIndicator = NO;
    NSString *uk = [KUserdefaults objectForKey:@"YDSC_uk"];
    NSString *urlStr = [NSString stringWithFormat:@"%@front/appmall/html/myintegral.html?ckys_openid=%@&uk=%@", WebServiceAPI, USER_OPENID, uk];
//    NSString *urlStr = [NSString stringWithFormat:@"%@front/appmall/html/myintegral.html?ckys_openid=%@", WebServiceAPI, USER_OPENID];
    [self.view addSubview:_pointWebView];
    
    [_pointWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}


//-(NodataLableView *)nodataLableView {
//    if(_nodataLableView == nil) {
//        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT - 64-49-50)];
//        _nodataLableView.nodataLabel.text = @"暂无积分信息";
//    }
//    return _nodataLableView;
//}
//
//-(NSMutableArray *)dataArray {
//    if (_dataArray == nil) {
//        _dataArray = [NSMutableArray array];
//    }
//    return _dataArray;
//}
//
//-(void)requestDataWithType:(NSString*)type {
//    
//    _nodataLableView.hidden = YES;
//    [_dataArray removeAllObjects];
//
//    NSString *startindex = [NSString stringWithFormat:@"%ld", self.dataArray.count];
//    
////    if (self.dataArr.count != 0 && self.dataArr.count < 20) {
////        [self.cateTableView.mj_header endRefreshing];
////        [self.cateTableView.mj_footer endRefreshingWithNoMoreData];
////        return;
////    }
//    
//    NSString *endindex = [NSString stringWithFormat:@"%ld", self.dataArray.count + 20];
//    NSDictionary *pramaDic= @{@"openid":USER_OPENID, @"type":type, @"startindex":startindex, @"endindex":endindex};
//    
//    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetMemberPointUrl];
//    [self.view addSubview:self.loadingView];
//    [self.loadingView startAnimation];
//    
//    [HttpTool getWithUrl:loveItemUrl params:pramaDic success:^(id json) {
//        [self.loadingView stopAnimation];
//        
//        NSDictionary *dic = json;
//        NSString * status = [dic valueForKey:@"code"];
//        if ([status intValue] != 200) {
//            [self showNoticeView:[dic valueForKey:@"msg"]];
//            return ;
//        }
//        
//        NSString *integralnum = [NSString stringWithFormat:@"%@", dic[@"integralnum"]];
//        if (IsNilOrNull(integralnum)) {
//            integralnum = @"0";
//        }
//        _totalPoint.text = integralnum;
//        
//        NSArray *integrallist = dic[@"integrallist"];
//        for (NSDictionary *dict in integrallist) {
//            SCIntegraModel *point = [[SCIntegraModel alloc] init];
//            [point setValuesForKeysWithDictionary:dict];
//            [self.dataArray addObject:point];
//        }
//        [self.collectView reloadData];
//    } failure:^(NSError *error) {
//        [self.loadingView stopAnimation];
//        [self showNoticeView:@"网络出错了"];
////        if (self.dataArray.count == 0) {
////            _nodataLableView.hidden = NO;
////            [self.collectView collectionViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArray.count];
////        }
//    }];
//}
//
//- (void)initComponents {
//    [self setupNavigationItem];
//    
//    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 100)];
//    _headerView.backgroundColor = [UIColor darkGrayColor];
//    [self.view addSubview:_headerView];
//    
//    _imageViwe = [UIImageView new];
//    _imageViwe.image = [UIImage imageNamed:@"defaultover"];
//    _imageViwe.layer.cornerRadius = 30;
//    _imageViwe.layer.masksToBounds = YES;
//    [_headerView addSubview:_imageViwe];
//    
//    _totalPoint = [UILabel new];
//    _totalPoint.text = @"0";
//    [_headerView addSubview:_totalPoint];
//    
//    _explain = [UILabel new];
//    _explain.text = @"我的积分";
//    [_headerView addSubview:_explain];
//
//    [_imageViwe mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(_headerView.mas_centerY);
//        make.left.equalTo(_headerView.mas_left).offset(30);
//        make.width.equalTo(@60);
//        make.height.equalTo(@60);
//    }];
//    
//    [_totalPoint mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_imageViwe.mas_top);
//        make.left.equalTo(_imageViwe.mas_right).offset(15);
//        make.width.equalTo(@100);
//    }];
//    
//    [_explain mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_imageViwe.mas_right).offset(15);
//        make.bottom.equalTo(_imageViwe.mas_bottom);
//        make.width.equalTo(@100);
//    }];
//    
//    
//    [self setupScrollTitleView];
//    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 210, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) collectionViewLayout:layout];
//    _collectView.backgroundColor = [UIColor whiteColor];
//    _collectView.delegate = self;
//    _collectView.dataSource = self;
//    _collectView.pagingEnabled = YES;
//    [_collectView registerClass:[SCPointExplainCell class] forCellWithReuseIdentifier:@"SCPointExplainCell"];
//    [_collectView registerClass:[YSPointCell class] forCellWithReuseIdentifier:@"YSPointCell"];
//    [self.view addSubview:_collectView];
//}
//
//- (void)setupScrollTitleView {
//    
//    [self setUpViewsWithCategoryNames:[NSArray arrayWithObjects:@"积分明细",@"收入",@"支出",@"积分规则",nil]];
//}
//
//-(void)setUpViewsWithCategoryNames:(NSArray *)names{
//    
//    _nameArr = [NSMutableArray arrayWithArray:names];
//    
//    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 174, SCREEN_WIDTH, 36)];
//    _scrollView.backgroundColor = [UIColor whiteColor];
//    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 36);
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.showsVerticalScrollIndicator = NO;
//    _scrollView.delegate = self;
//    _scrollView.scrollEnabled = YES;
//    [self.view addSubview:_scrollView];
//    
//    _btnArr = [NSMutableArray array];
//    for (int i = 0; i < names.count; i++) {
//        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.tag = i;
//        button.titleLabel.font = [UIFont systemFontOfSize:14];
//        
//        [button setTitle:names[i] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        button.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//        [button addTarget:self action:@selector(titleBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
//        [_scrollView addSubview:button];
//        [_btnArr addObject:button];
//    }
//    UIView * bottomLineView = [[UIView alloc]init];
//    self.bottomLineView = bottomLineView;
//    bottomLineView.backgroundColor = [UIColor redColor];
//    [self.scrollView addSubview:bottomLineView];
//    [self layoutSubview];
//}
//
//-(void)layoutSubview{
//    
//    _scrollView.scrollEnabled = NO;
//    CGFloat buttonWidth = 0;
//    buttonWidth = SCREEN_WIDTH/self.nameArr.count;
//    for (int i = 0; i < self.btnArr.count; i++) {
//        
//        UIButton * btn = self.btnArr[i];
//        btn.frame = CGRectMake(i*buttonWidth, 0, buttonWidth, 30);
//        if (i == 0) {
//            btn.selected = YES;
//            CGSize size = [self getSizeWithText:btn.titleLabel.text];
//            [_bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.mas_equalTo(btn.mas_centerX);
//                make.top.mas_equalTo(btn.mas_bottom).offset(0);
//                make.width.mas_equalTo(size.width);
//                make.height.mas_equalTo(@(3));
//            }];
//        }
//    }
//}
//
//-(void)setCurPage:(NSInteger)curPage{
//    _curPage = curPage;
//    UIButton *button = self.btnArr[_curPage];
//    [self titleBtnTouch:button];
//}
//
////点击button响应事件
//-(void)titleBtnTouch:(UIButton *)button{
//    
//    NSInteger tagValue = button.tag;
//    for (UIButton * btn in self.btnArr) {
//        if (btn.tag != tagValue) {
//            btn.selected = NO;
//        }else{
//            btn.selected = YES;
//        }
//    }
//    CGSize size = [self getSizeWithText:button.titleLabel.text];
//    //设置指示条位置
//    [UIView animateWithDuration:0.5 animations:^{
//        [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(button.mas_centerX);
//            make.top.mas_equalTo(button.mas_bottom).offset(0);
//            make.width.mas_equalTo(size.width);
//            make.height.mas_equalTo(@(3));
//        }];
//        
//    }];
//    
//    if (button.tag != 3) {
//        self.type = [NSString stringWithFormat:@"%ld", button.tag];
//        [self requestDataWithType:self.type];
//    }
//    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:button.tag];
//    [self.collectView scrollToItemAtIndexPath:path atScrollPosition:  UICollectionViewScrollPositionLeft animated:NO];
//}
//
////结束减速
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if ([scrollView isKindOfClass:[UICollectionView class]]){
//        NSInteger row=(scrollView.contentOffset.x+SCREEN_WIDTH/2.0)/SCREEN_WIDTH;
//        self.curPage = row;
//        
//    }
//}
//
///**
// *   获取字符宽度
// */
//- (CGSize)getSizeWithText:(NSString*)text{
//    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
//    style.lineBreakMode = NSLineBreakByCharWrapping;
//    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 24) options: NSStringDrawingUsesLineFragmentOrigin   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSParagraphStyleAttributeName:style} context:nil].size;
//    return CGSizeMake(size.width, 24);
//}
//
//
//- (void)setupNavigationItem {
//    //    UIBarButtonItem *rItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editCollection)];
//    //    self.navigationItem.rightBarButtonItem = rItem;
//    
//    shareButton.hidden = NO;
//    [shareButton setTitle:@"编辑" forState:UIControlStateNormal];
//    [shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    
//    
//}
//
//-(void)clickShareButton{
//    NSLog(@"点击了编辑");
//    
//}
//
//- (void)editCollection {
//    
//    NSLog(@"点击了编辑");
//}
//
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//
//    return 4;
//}
//
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 1;
//}
//
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 3) {
//        SCPointExplainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SCPointExplainCell" forIndexPath:indexPath];
//        return cell;
//    }else{
//        YSPointCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YSPointCell" forIndexPath:indexPath];
//        
//        [cell refreshList:self.dataArray type:self.type];
//        return cell;
//    }
//}
//
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
