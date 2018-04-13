//
//  YSCollectionViewController.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/5/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "YSCollectionViewController.h"
#import "YSCollectionCell.h"
#import "YSCollectionEditCell.h"
#import "SCMyCollectionModel.h"
#import "SCGoodsDetailViewController.h"
#import "SCDeleteView.h"
#import "SCNoDataView.h"
#import "SCCollectBottomView.h"
#import "XWAlterVeiw.h"

@interface YSCollectionViewController ()<UITableViewDelegate, UITableViewDataSource, SCCollectBottomViewDelegate, UIActionSheetDelegate, SCCollectionEditCellDelegate, XWAlterVeiwDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, assign) BOOL isDealWithData;
@property (nonatomic, strong) SCNoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray *requestDataArr;
@property (nonatomic, strong) SCCollectBottomView *bottomView;
@property (nonatomic, strong) XWAlterVeiw *deleteAlertView;
@property (nonatomic, assign) NSInteger deleteSecion;

@property (nonatomic, assign) NSTimeInterval startInterval;
@property (nonatomic, assign) NSTimeInterval endInterval;

@end

@implementation YSCollectionViewController

-(SCNoDataView *)noDataView {
    if (_noDataView == nil) {
        _noDataView = [[SCNoDataView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _noDataView.nodataLabel.text = @"暂无收藏信息";
    }
    return _noDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initComponents];
    
    [self requestCollectionData];
    
    _deleteSecion = 0;
    self.navigationItem.title = @"我的收藏";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _selectArr = [NSMutableArray array];
}

-(NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)requestCollectionData {
    
    _noDataView.hidden = YES;
    NSDictionary *pramaDic = @{@"openid": USER_OPENID, @"startindex":@"1", @"endindex":@"20"};
    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetCollecListUrl];
    
    [HttpTool getWithUrl:loveItemUrl params:pramaDic success:^(id json) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSDictionary *dic = json;
        NSString * status = [dic valueForKey:@"code"];
        if ([status intValue] != 200) {
            [self showNoticeView:[dic valueForKey:@"msg"]];
            return ;
        }
        
        NSArray *collectionlist = dic[@"collectionlist"];
        if (collectionlist.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
            _noDataView.hidden = NO;
            [self.dataArray removeAllObjects];
            [self.tableView tableViewDisplayView:self.noDataView ifNecessaryForRowCount:self.dataArray.count];
            
        }
        [self.dataArray removeAllObjects];
        for (NSDictionary *dict in collectionlist) {
            SCMyCollectionModel *collectM = [[SCMyCollectionModel alloc] init];
            [collectM setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:collectM];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];

        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        
        if (self.dataArray.count == 0) {
            [self.tableView tableViewDisplayView:self.noDataView ifNecessaryForRowCount:self.dataArray.count];
        }
    }];
}

-(void)initComponents {
   
    _isDealWithData = NO;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    if (@available(iOS 11.0, *)) {
        _tableView.estimatedSectionHeaderHeight = 0.1;
        _tableView.estimatedSectionFooterHeight = 0.1;
    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
    }];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(0, 0, 50, 45);
//    _editBtn.hidden = YES;
    _editBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    _editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(editMyCollection:) forControlEvents:UIControlEventTouchUpInside];
    [_editBtn setTitleColor:SubTitleColor forState:UIControlStateNormal];
//    if (@available(iOS 11.0, *)) {
//        _editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, -20);
//        UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
//        self.navigationItem.rightBarButtonItem = editItem;
//    }else{
        UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -10;
        self.navigationItem.rightBarButtonItems = @[spaceItem, editItem];
//    }
    
    _bottomView = [[SCCollectBottomView alloc] init];
    _bottomView.hidden = YES;
    _bottomView.delegate = self;
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: _bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.tableView.mas_bottom);
        make.height.mas_equalTo(49);
    }];

//    [self refreshData];
}

-(void)layoutViewsIsDeleteState:(BOOL)isDelete {
    if (isDelete) {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.right.mas_offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-49-BOTTOM_BAR_HEIGHT);
        }];
        
    }else {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
        }];
    }
}


-(void)editMyCollection:(UIButton*)btn {
    
    NSLog(@"点击了编辑");
    if ([btn.titleLabel.text isEqualToString:@"编辑"]) {
        [_editBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];

        [self.editBtn setSelected:YES];
        self.isDealWithData = YES;
        for (NSString *indexStr in _selectArr) {
            if (self.dataArray.count > [indexStr integerValue]) {
                SCMyCollectionModel *model = self.dataArray[[indexStr integerValue]];
                model.isSelect = NO;
            }
        }
        _bottomView.hidden = NO;
        [self layoutViewsIsDeleteState:YES];
        
    }else{
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:SubTitleColor forState:UIControlStateNormal];

        self.isDealWithData = NO;
        [self.editBtn setSelected:NO];

        _bottomView.hidden = YES;
        [self layoutViewsIsDeleteState:NO];
        
    }

    [self.tableView reloadData];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SCMyCollectionModel *colectM = self.dataArray[indexPath.section];
    if (_isDealWithData) {
        YSCollectionEditCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"YSCollectionEditCell%ld", indexPath.row]];
        if (cell == nil) {
            cell = [[YSCollectionEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"YSCollectionEditCell%ld", indexPath.row]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshCellWithCollectionModel:colectM];
        cell.delegate = self;
        cell.indexRow = indexPath.section;
        return cell;
    }else{
        YSCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"YSCollectionCell%ld", indexPath.section]];
        if (cell == nil) {
            cell = [[YSCollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"YSCollectionCell%ld", indexPath.row]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshCellWithCollectionModel:colectM];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_isDealWithData) {
        
        NSLog(@"跳转到商品详情");
        SCGoodsDetailViewController *detailVC = [[SCGoodsDetailViewController alloc] init];
        SCMyCollectionModel *collectM = self.dataArray[indexPath.section];
        detailVC.goodsId = [NSString stringWithFormat:@"%@", collectM.itemid];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.editBtn.selected) {
        return NO;
    }
    return YES;
}

#pragma makr-左滑删除
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *delectRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取消\n收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        _deleteSecion = indexPath.section;
        _deleteAlertView = [[XWAlterVeiw alloc] init];
        _deleteAlertView.delegate = self;
        _deleteAlertView.titleLable.text = @"确定取消收藏吗？";
        [_deleteAlertView show];
    }];
 
    return @[delectRowAction];
}

-(void)subuttonClicked {
    SCMyCollectionModel *collectM = [[SCMyCollectionModel alloc] init];
    collectM = self.dataArray[_deleteSecion];
    //itemids：一组商品id，逗号分隔
    NSString *itemid = [NSString stringWithFormat:@"%@", collectM.itemid];
    
    NSDictionary *pramaDic= @{@"openid": USER_OPENID, @"itemids": itemid};
    NSString *deloveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, CancelCollectionUrl];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool postWithUrl:deloveItemUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        [self.tableView.mj_header endRefreshing];
        NSDictionary *dic = json;
        NSString * status = [dic valueForKey:@"code"];
        if ([status intValue] != 200) {
            [self showNoticeView:[dic valueForKey:@"msg"]];
            return ;
        }
        
        [self.tableView beginUpdates];
        
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:_deleteSecion]
                      withRowAnimation:UITableViewRowAnimationFade];
        
        [self.dataArray removeObjectAtIndex:_deleteSecion];
        if (self.dataArray.count == 0) {
            self.noDataView.hidden = NO;
            [self.tableView tableViewDisplayView:self.noDataView ifNecessaryForRowCount:self.dataArray.count];
        }else{
            self.noDataView.hidden = YES;
        }
        
        [self.tableView endUpdates];
        
        [self showNoticeView:@"已取消收藏"];
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        [self.tableView.mj_header endRefreshing];
        
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

-(void)deleteMyCollectionWithId:(NSString*)itemids indexArr:(NSArray*)indexArr {
    
    NSDictionary *pramaDic= @{@"openid": USER_OPENID, @"itemids": itemids};
    NSString *deloveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, CancelCollectionUrl];
        [self.view addSubview:self.loadingView];
        [self.loadingView startAnimation];
    [HttpTool postWithUrl:deloveItemUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        [self.tableView.mj_header endRefreshing];
        NSDictionary *dic = json;
        NSString * status = [dic valueForKey:@"code"];
        if ([status intValue] != 200) {
            [self showNoticeView:[dic valueForKey:@"msg"]];
            return ;
        }
        
        [self.tableView beginUpdates];
        
        NSArray *result = [self.selectArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj2 compare:obj1]; //升序
        }];
        
        for (NSInteger i = result.count-1; i>=0; i--) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            [self.dataArray removeObjectAtIndex:i];
            
            if (self.dataArray.count == 0) {
                self.noDataView.hidden = NO;
                [self.tableView tableViewDisplayView:self.noDataView ifNecessaryForRowCount:self.dataArray.count];
            }else{
                self.noDataView.hidden = YES;
            }
        }
        
        for (NSInteger i =0 ; i<self.dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            YSCollectionEditCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.editBtn.selected = NO;
        }
        
        [self.tableView endUpdates];
        
        [self.selectArr removeAllObjects];
        [self showNoticeView:@"已取消收藏"];
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        [self.tableView.mj_header endRefreshing];

        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

-(void)refreshData {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header beginRefreshing];
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";
        strongSelf.endInterval = [nowDate timeIntervalSince1970];
        NSTimeInterval value = strongSelf.endInterval - strongSelf.startInterval;
        CGFloat second = [[NSString stringWithFormat:@"%.2f",value] floatValue];//秒
        NSLog(@"间隔------%f秒",second);
        strongSelf.startInterval = strongSelf.endInterval;
        
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                if (value >= Interval) {
                    [strongSelf.dataArray removeAllObjects];
                    [strongSelf requestCollectionData];
                }else{
                    [strongSelf.tableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [strongSelf showNoticeView:NetWorkNotReachable];
                [strongSelf.tableView.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestMoreCollectionGoods];
    }];
}

-(void)requestMoreCollectionGoods {
    
    _noDataView.hidden = YES;
    
    NSString *startindex = [NSString stringWithFormat:@"%ld", self.dataArray.count+1];
    NSString *endindex = [NSString stringWithFormat:@"%ld", [startindex integerValue]+20];
    
    NSDictionary *pramaDic = @{@"openid": USER_OPENID, @"startindex":startindex, @"endindex":endindex};
    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetCollecListUrl];
    
    [HttpTool getWithUrl:loveItemUrl params:pramaDic success:^(id json) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSDictionary *dic = json;
        NSString * status = [dic valueForKey:@"code"];
        if ([status intValue] != 200) {
            [self showNoticeView:[dic valueForKey:@"msg"]];
            return ;
        }
        
        NSArray *collectionlist = dic[@"collectionlist"];
        if (collectionlist.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        for (NSDictionary *dict in collectionlist) {
            SCMyCollectionModel *collectM = [[SCMyCollectionModel alloc] init];
            [collectM setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:collectM];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        
        if (self.dataArray.count == 0) {
            [self.tableView tableViewDisplayView:self.noDataView ifNecessaryForRowCount:self.dataArray.count];
        }
    }];
}

-(void)scCollectionEditCell:(YSCollectionEditCell *)scCollectionEditCell clickCellIndex:(NSInteger)index deleteOrNo:(BOOL)isDelete {
    if (index < self.dataArray.count) {
        
        SCMyCollectionModel *model = self.dataArray[index];
        model.isSelect = isDelete;
        
        [self.tableView reloadData];
    }
    
    NSString * indexStr = [NSString stringWithFormat:@"%ld",(long)index];
    if (isDelete) {
        
        [_selectArr addObject:indexStr];
    } else {
        
        for (NSString * str  in _selectArr) {
            
            if ([str isEqualToString:indexStr]) {
                
                [_selectArr removeObject:indexStr];
                break;
            }
        }
    }
    if (_selectArr.count != self.dataArray.count) {
        [_bottomView.allSelectedButton setSelected:NO];

    }else{
        [_bottomView.allSelectedButton setSelected:YES];
    }
}

-(void)cancelCollection:(UIButton *)button {
    
    NSInteger buttonTag = button.tag - 1413;
    if (buttonTag == 0){
        [self.selectArr removeAllObjects];
        button.selected = !button.selected;
        BOOL btselected = button.selected;
        NSMutableArray *tmp = [NSMutableArray array];
        
        for (int i = 0;i<self.dataArray.count;i++) {
            SCMyCollectionModel *model = self.dataArray[i];
            model.isSelect = btselected;
            NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)i];
            [self.selectArr addObject:indexStr];
            [tmp addObject:model];
        }
        if (tmp.count > 0) {
            [self.dataArray removeAllObjects];
            self.dataArray = tmp;
        }
        [self.tableView reloadData];

    }else{
        [self.selectArr removeAllObjects];
        for (int i = 0;i<self.dataArray.count;i++) {
            SCMyCollectionModel *goodModel = [self.dataArray objectAtIndex:i];
            if (goodModel.isSelect) {//选中
                [self.selectArr addObject:[NSString stringWithFormat:@"%d", i]];
            }
        }
        if (![self.selectArr count]) {
            [self showNoticeView:@"请先选择商品"];
            return;
        }
        
        NSMutableArray * temArr = [NSMutableArray array];
        NSMutableArray * temArr2 = [NSMutableArray array];
        for (NSString * indx in _selectArr) {
            if ([indx intValue] < self.dataArray.count) {
                SCMyCollectionModel *collectM = self.dataArray[[indx intValue]];
                [temArr addObject:collectM.itemid];
                [temArr2 addObject:collectM];
            }
        }
        //itemids：一组商品id，逗号分隔
        NSString *itemids = [temArr componentsJoinedByString:@","];
        [self deleteMyCollectionWithId:itemids indexArr:@[_selectArr]];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
