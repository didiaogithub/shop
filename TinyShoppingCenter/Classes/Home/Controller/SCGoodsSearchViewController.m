//
//  SCGoodsSearchViewController.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCGoodsSearchViewController.h"
#import "SCGoodsSearchCell.h"
#import "SCGoodsDetailViewController.h"
#import "SearchTopView.h"
#import "SCSearchGoodsModel.h"

@interface SCGoodsSearchViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, SearchTopViewDelegate>

@property (nonatomic, strong) SCSearchGoodsModel *goodModel;
@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) NSMutableArray *hotItemArr;
@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) NodataLableView *nodataLableView;
@property (nonatomic, strong) UIView *hisView;
@property (nonatomic, strong) UILabel *hisLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) NSMutableArray *recentSearchArr;//最近搜索数据

@property (nonatomic, strong) UIButton *cleanBtn;
@property (nonatomic, strong) UILabel *hisLine;
@property (nonatomic, strong) UILabel *hotLine;
@property (nonatomic, strong) UIButton *itemBtn;

@property (nonatomic, copy) NSString *isLoadMore;

@end

@implementation SCGoodsSearchViewController

-(NSMutableArray *)searchArray{
    if (_searchArray == nil) {
        _searchArray = [[NSMutableArray alloc] init];
    }
    return _searchArray;
}

-(NSMutableArray *)recentSearchArr {
    if (_recentSearchArr == nil) {
        _recentSearchArr = [NSMutableArray array];
    }
    return _recentSearchArr;
}

-(NodataLableView *)nodataLableView {
    if(_nodataLableView == nil) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0,110, SCREEN_WIDTH,SCREEN_HEIGHT - 64-49-50)];
        _nodataLableView.nodataLabel.text = @"暂无搜索结果";
        _nodataLableView.backgroundColor = [UIColor whiteColor];
    }
    return _nodataLableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品搜索";
    
    [self createOtherViews];
    
    [self createTableView];
    
    [self getHotItem];
    
    //    [self refreshData];
}

#pragma mark - 请求热门标签数据
-(void)getHotItem {
    
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetHotItemUrl];
    [HttpTool getWithUrl:homeInfoUrl params:nil success:^(id json) {
        NSDictionary *dic = json;
        [self.searchTableView.mj_header endRefreshing];
        if ([dic[@"code"] integerValue] !=  200) {
            [self showNoticeView:dic[@"msg"]];
            return ;
        }
        NSArray *goodslist = dic[@"list"];
        _hotItemArr = [NSMutableArray array];
        for (NSDictionary *goodDic in goodslist) {
            NSString *itemName = [NSString stringWithFormat:@"%@", goodDic[@"name"]];
            [self.hotItemArr addObject:itemName];
        }
        if (_hotItemArr.count > 0) {
            [self creatHotItemView];
        }
        
    } failure:^(NSError *error) {
        [self.searchTableView.mj_header endRefreshing];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

-(void)creatHotItemView{
    
    _hisLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 130+NaviAddHeight, 100, 40)];
    [self.view addSubview:_hisLabel];
    _hisLabel.text = @"历史搜索";
    _hisLabel.textColor = TitleColor;
    _hisLabel.font = [UIFont systemFontOfSize:16.0f];
    
    _cleanBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 58, 137.5+NaviAddHeight, 48, 20)];
    [_cleanBtn setImage:[UIImage imageNamed:@"addressdelete"] forState:UIControlStateNormal];
    [_cleanBtn addTarget:self action:@selector(cleanHistorySearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cleanBtn];
    
    _hisLine = [UILabel creatLineLable];
    _hisLine.frame = CGRectMake(10, 170+NaviAddHeight, SCREEN_WIDTH - 20, 1);
    [self.view addSubview:_hisLine];
    
    
    _hisView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_hisLine.frame)+20, SCREEN_WIDTH-20, 2)];
    [self.view addSubview:_hisView];
    CGFloat positionX = 0.0;
    CGFloat positionY = 0.0;
    CGFloat bgViewWidth = SCREEN_WIDTH-20;
    UIFont *btnTitleFont = [UIFont systemFontOfSize:15.0f];
    
    [_recentSearchArr removeAllObjects];
    
    if ([self readCachSearchKeyWord]>0) {
        _recentSearchArr = [NSMutableArray arrayWithArray:[self readCachSearchKeyWord]];
    }else{
        _recentSearchArr = [NSMutableArray array];
    }
    
    
    for(int i = 0;i<_recentSearchArr.count;i++) {
        //下面的方法
        CGFloat btnWidth = [self textWidth:_recentSearchArr[i] Font:btnTitleFont height:30];
        
        if(positionX + btnWidth > bgViewWidth){
            positionX = 0;
            if (btnWidth>=bgViewWidth) {
                btnWidth = bgViewWidth - positionX;
            }
            positionY += 40;
        }
        
        _itemBtn = [[UIButton alloc] initWithFrame:CGRectMake(positionX, positionY, btnWidth, 30)];
        [_itemBtn setTitle:_recentSearchArr[i] forState:UIControlStateNormal];
        [_itemBtn setTitleColor:TitleColor forState:UIControlStateNormal];
        [_itemBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _itemBtn.backgroundColor = CKYS_Color(242, 242, 242);
        _itemBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        _itemBtn.layer.cornerRadius = 5;
        _itemBtn.layer.masksToBounds = YES;
        _itemBtn.titleLabel.font = btnTitleFont;
        positionX += (btnWidth+10);
        
        _hisView.frame = CGRectMake(10, CGRectGetMaxY(_hisLine.frame)+5, SCREEN_WIDTH-20, positionY + 30)
        ;
        [_hisView addSubview:_itemBtn];
        
    }
    
    CGFloat y = CGRectGetMaxY(_hisView.frame)+30;
    if (y == 0) {
        y = 170+30;
    }
    _tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 100, 30)];
    [self.view addSubview:_tagLabel];
    _tagLabel.text = @"热门搜索";
    _tagLabel.textColor = TitleColor;
    _tagLabel.font = [UIFont systemFontOfSize:16.0f];
    
    _hotLine = [UILabel creatLineLable];
    _hotLine.frame = CGRectMake(10, CGRectGetMaxY(_tagLabel.frame), SCREEN_WIDTH - 20, 1);
    [self.view addSubview:_hotLine];
    
    _tagView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_tagLabel.frame)+10, SCREEN_WIDTH-20, 50)];
    [self.view addSubview:_tagView];
    
    positionX = 0.0;
    positionY = 0.0;
    
    for(int i = 0;i<self.hotItemArr.count;i++) {
        //下面的方法
        CGFloat btnWidth = [self textWidth:self.hotItemArr[i] Font:btnTitleFont height:30];
        
        if(positionX + btnWidth > bgViewWidth){
            positionX = 0;
            if (btnWidth>=bgViewWidth) {
                btnWidth = bgViewWidth - positionX;
            }
            positionY += 40;
        }
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(positionX, positionY, btnWidth, 30)];
        [btn setTitle:self.hotItemArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:TitleColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        btn.backgroundColor = CKYS_Color(242, 242, 242);
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        
        btn.titleLabel.font = btnTitleFont;
        positionX += (btnWidth+10);
        [_tagView addSubview:btn];
    }
}

-(void)typeBtnClick:(UIButton*)btn {
    
    NSString *str = [NSString stringWithFormat:@"%@", btn.titleLabel.text];
    
    _hisLabel.hidden = YES;
    _hisView.hidden = YES;
    _hisLine.hidden = YES;
    _tagView.hidden = YES;
    _tagLabel.hidden = YES;
    _hotLine.hidden = YES;
    _cleanBtn.hidden = YES;
    
    _searchView.searchTextField.text = str;
    
    [self cacheSearchKey];
    
    [self getSearchData:str];
}

-(CGFloat)textWidth:(NSString *)text Font:(UIFont *)font height:(CGFloat)height {
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.width + 20;
}

#pragma mark-请求搜索数据
-(void)getSearchData:(NSString*)keyword {
    [self.searchArray removeAllObjects];
    
    _nodataLableView.hidden = YES;
    NSDictionary *pramaDic = @{@"openid":USER_OPENID, @"keyword":keyword, @"startindex":@"0", @"endindex":@"100"};
    
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, CategoryUrl];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        [self.searchTableView.mj_footer endRefreshing];
        
        NSDictionary *dic = json;
        [self.searchTableView.mj_header endRefreshing];
        if ([dic[@"code"] integerValue] !=  200) {
            [self showNoticeView:dic[@"msg"]];
            return ;
        }
        
        NSLog(@"%@", dic);
        NSArray *goodslist = dic[@"goodslist"];
        if ([_isLoadMore isEqualToString:@"YES"]) {
            if (goodslist.count == 0) {
                [self.searchTableView.mj_footer endRefreshingWithNoMoreData];
            }
            _isLoadMore = @"";
        }
        
        if (goodslist.count == 0) {
            _nodataLableView.hidden = NO;
            [self.searchTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.searchArray.count];
            [self.searchTableView setBackgroundColor:[UIColor whiteColor]];
            
        }
        
        for (NSDictionary *goodDic in goodslist) {
            _goodModel = [[SCSearchGoodsModel alloc] init];
            [_goodModel setValuesForKeysWithDictionary:goodDic];
            [self.searchArray addObject:_goodModel];
        }
        [self.searchTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        [self.searchTableView.mj_footer endRefreshing];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}
/**创建搜索框*/
-(void)createOtherViews{
    _searchView = [[SearchTopView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, 45) andHeight:45];
    _searchView.delegate = self;
    [self.view addSubview:_searchView];
    
}

-(void)clickBtnSearch:(UIButton *)button{
    
    //键盘退下
    [_searchView.searchTextField resignFirstResponder];
    
    if (IsNilOrNull(_searchView.searchTextField.text)) {
        [self showNoticeView:@"请输入搜索内容"];
        if (self.searchArray.count == 0) {
            _nodataLableView.hidden = YES;
            _hisLabel.hidden = NO;
            _hisView.hidden = NO;
            _hisLine.hidden = NO;
            _tagView.hidden = NO;
            _tagLabel.hidden = NO;
            _hotLine.hidden = NO;
            _cleanBtn.hidden = NO;
        }
        return;
    }
    
    
    [self.searchArray removeAllObjects];
    
    _hisLabel.hidden = YES;
    _hisView.hidden = YES;
    _hisLine.hidden = YES;
    _tagView.hidden = YES;
    _tagLabel.hidden = YES;
    _hotLine.hidden = YES;
    _cleanBtn.hidden = YES;
    
    [self cacheSearchKey];
    [self getSearchData:_searchView.searchTextField.text];
    
}

-(void)keyboardSearchWithString:(NSString *)searchStr {
    [_searchView.searchTextField resignFirstResponder];
    
    if (IsNilOrNull(_searchView.searchTextField.text)) {
        [self showNoticeView:@"请输入搜索内容"];
        if (self.searchArray.count == 0) {
            _nodataLableView.hidden = YES;
            _hisLabel.hidden = NO;
            _hisView.hidden = NO;
            _hisLine.hidden = NO;
            _tagView.hidden = NO;
            _tagLabel.hidden = NO;
            _hotLine.hidden = NO;
            _cleanBtn.hidden = NO;
        }
        return;
    }
    
    [self.searchArray removeAllObjects];
    
    _hisLabel.hidden = YES;
    _hisView.hidden = YES;
    _hisLine.hidden = YES;
    _tagView.hidden = YES;
    _tagLabel.hidden = YES;
    _hotLine.hidden = YES;
    _cleanBtn.hidden = YES;
    
    [self cacheSearchKey];
    
    [self getSearchData:_searchView.searchTextField.text];
    
    
}

/**创建tableView*/
-(void)createTableView{
    _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+55+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-55-+NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_searchTableView];
    _searchTableView.backgroundColor = [UIColor whiteColor];
    _searchTableView.rowHeight = UITableViewAutomaticDimension;
    _searchTableView.estimatedRowHeight = 44;
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SCGoodsSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCGoodsSearchCell"];
    if (cell == nil) {
        cell = [[SCGoodsSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCGoodsSearchCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.searchArray count]) {
        _goodModel = self.searchArray[indexPath.row];
        [cell refreshCellWithModel:_goodModel];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SCGoodsDetailViewController *detailVC = [[SCGoodsDetailViewController alloc] init];
    SCSearchGoodsModel *goodsM = self.searchArray[indexPath.row];
    detailVC.goodsId = [NSString stringWithFormat:@"%@", goodsM.itemid];
    [self.navigationController pushViewController:detailVC animated:YES];
}

//最近搜索关键字写入本地
-(void)cacheSearchKey {
    
    NSMutableArray *temp = [NSMutableArray array];
    [temp addObjectsFromArray:[self readCachSearchKeyWord]];
    
    if (!IsNilOrNull(_searchView.searchTextField.text)) {
        if (![temp containsObject:_searchView.searchTextField.text]) {
            //            [temp addObject:_searchView.searchTextField.text];
            [temp insertObject:_searchView.searchTextField.text atIndex:0];
        }
    }
    
    if (temp.count >0) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *filePath = [path stringByAppendingPathComponent:@"RecentSearchList"];
        [NSKeyedArchiver archiveRootObject:temp toFile:filePath];
    }
}

-(NSArray*)readCachSearchKeyWord {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"RecentSearchList"];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return array;
}

-(void)cleanHistorySearch {
    NSLog(@"删除历史搜索记录");
    NSMutableArray *temp = [NSMutableArray array];
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"RecentSearchList"];
    [NSKeyedArchiver archiveRootObject:temp toFile:filePath];
    
    [_recentSearchArr removeAllObjects];
    
    [_hisLabel removeFromSuperview];
    [_cleanBtn removeFromSuperview];
    [_hisLine removeFromSuperview];
    [_hisView removeFromSuperview];
    [_tagLabel removeFromSuperview];
    [_tagView removeFromSuperview];
    [_hotLine removeFromSuperview];
    
    [self creatHotItemView];
}

-(void)refreshData{
    __typeof (self) __weak weakSelf = self;
    self.searchTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isLoadMore = @"YES";
        NSArray *arr = [self readCachSearchKeyWord];
        [weakSelf getSearchData:arr.lastObject];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
