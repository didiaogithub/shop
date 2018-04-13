//
//  SCOrderListViewController.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/9.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCOrderListViewController.h"
#import "SCOrderListCell.h"
#import "SCMyOrderModel.h"
#import "SCOrderDetailViewController.h"
#import "OrderFooterView.h"
#import "SCPayViewController.h"
#import "DetailLogisticsViewController.h"
#import "SCGoodsDetailViewController.h"
#import "XWAlterVeiw.h"
#import "PaySuccessViewController.h"
#import "SCWaitReleaseCommentViewController.h"
#import "SearchTopView.h"
#import "SCCommentOrderViewController.h"

static NSString *cellIdentifier = @"SCOrderListCell";

@interface SCOrderListViewController()<UITableViewDelegate, UITableViewDataSource, XWAlterVeiwDelegate, UITextFieldDelegate, SearchTopViewDelegate, OrderFooterViewDelegate>

@property (nonatomic, strong) NSString *oidString;
@property (nonatomic, strong) UILabel *indicateLine;
@property (nonatomic, strong) XWAlterVeiw *deleteAlertView;
@property (nonatomic, strong) UITableView *orderTableView;
@property (nonatomic, strong) NSMutableArray *statusBtnArr;
@property (nonatomic, strong) NSArray *statusArr;
@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) OrderFooterView *footerView;
@property (nonatomic, strong) NSMutableArray *orderDataArr;
@property (nonatomic, strong) UIButton *allOrderButton; //全部订单
@property (nonatomic, strong) UIButton *waitPayMoneyButton; //待付款
@property (nonatomic, strong) UIButton *waitDispatchGoodsButton; //待发货
@property (nonatomic, strong) UIButton *waitConsigneeButton; //待收货
@property (nonatomic, strong) UIButton *afterSalesButton; //售后
@property (nonatomic, strong) NodataLableView *nodataLableView;
@property (nonatomic, strong) UILabel *orderNumberLable;  //订单编号
@property (nonatomic, strong) UILabel *orderStateLable;  //订单状态
@property (nonatomic, strong) SCMyOrderModel *orderModel;
@property (nonatomic, strong) XWAlterVeiw *cancelOrderAlert;
@property (nonatomic, strong) XWAlterVeiw *confirmAlert;
@property (nonatomic, assign) NSTimeInterval startInterval;
@property (nonatomic, assign) NSTimeInterval endInterval;
@property (nonatomic, strong) UIView *statusView;

@end

@implementation SCOrderListViewController

-(NSMutableArray *)orderDataArr {
    if (_orderDataArr == nil) {
        _orderDataArr = [NSMutableArray array];
    }
    return _orderDataArr;
}

-(NodataLableView *)nodataLableView {
    if(_nodataLableView == nil) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT - 64-49-50)];
        _nodataLableView.nodataLabel.text = @"暂无订单";
    }
    return _nodataLableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if(IsNilOrNull(self.statusString)){
        self.statusString = @"99";
    }
    
    [self loadDBData:_statusString];
    
    [self.orderTableView reloadData];
    [self loadMyOrderData:self.searchView.searchTextField.text];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单列表";
    
    _statusArr = @[@"1", @"2,7", @"3,4,5,6", @"4,5", @"99"];
    
    [self createTopButton];
    [self moveStatusLineWithStatus:self.statusString];
    [self createTableView];
    [self refreshData];
}

#pragma mark - 请求订单列表数据
-(void)loadMyOrderData:(NSString*)searchkey {
    
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    
    _nodataLableView.hidden = YES;
    
    NSString *startindex = @"1";
    
    NSString *endindex = @"20";
    
    NSDictionary *parmaDic = [NSDictionary dictionary];
    NSString *searchStr = _searchView.searchTextField.text;
    if (!IsNilOrNull(searchStr)) {
        parmaDic = @{@"openid":USER_OPENID ,@"status": self.statusString, @"startindex":startindex, @"endindex":endindex, @"keywords":searchStr};
    }else{
        parmaDic = @{@"openid":USER_OPENID ,@"status": self.statusString, @"startindex":startindex, @"endindex":endindex};
    }
    
    NSString *orderListUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetOrderListUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool getWithUrl:orderListUrl params:parmaDic success:^(id json) {
        
        [self.orderTableView.mj_header endRefreshing];
        NSDictionary *itemDic = json;
        if ([itemDic[@"code"] integerValue] != 200) {
            [self.loadingView stopAnimation];
            [self showNoticeView:itemDic[@"msg"]];
            return;
        }
        
        if (!IsNilOrNull(self.searchView.searchTextField.text)) {
            NSArray *itemArr = itemDic[@"orderlist"];
            if (itemArr.count == 0) {
                _nodataLableView.hidden = NO;
                [self.orderDataArr removeAllObjects];
                [self.orderTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.orderDataArr.count];
            }
            [self.orderDataArr removeAllObjects];
            for (NSDictionary *listOrderDic in itemArr) {
                SCMyOrderModel *orderModel = [[SCMyOrderModel alloc] init];
                [orderModel setValuesForKeysWithDictionary:listOrderDic];
                orderModel.money = [NSString stringWithFormat:@"%@", listOrderDic[@"money"]];
                orderModel.ordernumber = [NSString stringWithFormat:@"%@", listOrderDic[@"ordernumber"]];
                orderModel.iscomment = [NSString stringWithFormat:@"%@", listOrderDic[@"iscomment"]];
                orderModel.balancemoney = [NSString stringWithFormat:@"%@", listOrderDic[@"balancemoney"]];
                orderModel.statusString = _statusString;
                NSArray *ordersheetArr = listOrderDic[@"itemlist"];
                if (ordersheetArr.count > 0) {
                    for (NSInteger i = 0; i<ordersheetArr.count; i++) {
                        SCMyOrderGoodsModel *orderSheet = [[SCMyOrderGoodsModel alloc] init];
                        NSDictionary *dic = ordersheetArr[i];
                        [orderSheet setValuesForKeysWithDictionary:dic];
                        orderSheet.goodsKey = [NSString stringWithFormat:@"%@_%@_%ld", orderModel.orderId, orderSheet.itemid, i];
                        [orderModel.itemlistArr addObject:orderSheet];
                    }
                }
                
                [self.orderDataArr addObject:orderModel];
            }
            
            [self.orderTableView.mj_header endRefreshing];
            [self.orderTableView.mj_footer endRefreshing];
            [self.orderTableView reloadData];
            [self.loadingView stopAnimation];
            [self setAutomaticallyAdjustsScrollViewInsets:YES];
            
            
        }else{
            NSArray *itemArr = itemDic[@"orderlist"];
            for (NSDictionary *listOrderDic in itemArr) {
                SCMyOrderModel *orderModel = [[SCMyOrderModel alloc] init];
                [orderModel setValuesForKeysWithDictionary:listOrderDic];
                orderModel.money = [NSString stringWithFormat:@"%@", listOrderDic[@"money"]];
                orderModel.ordernumber = [NSString stringWithFormat:@"%@", listOrderDic[@"ordernumber"]];
                orderModel.iscomment = [NSString stringWithFormat:@"%@", listOrderDic[@"iscomment"]];
                orderModel.balancemoney = [NSString stringWithFormat:@"%@", listOrderDic[@"balancemoney"]];
                orderModel.statusString = _statusString;
                NSArray *ordersheetArr = listOrderDic[@"itemlist"];
                if (ordersheetArr.count > 0) {
                    for (NSInteger i = 0; i<ordersheetArr.count; i++) {
                        SCMyOrderGoodsModel *orderSheet = [[SCMyOrderGoodsModel alloc] init];
                        NSDictionary *dic = ordersheetArr[i];
                        [orderSheet setValuesForKeysWithDictionary:dic];
                        orderSheet.goodsKey = [NSString stringWithFormat:@"%@_%@_%ld", orderModel.orderId, orderSheet.itemid, i];
                        [orderModel.itemlistArr addObject:orderSheet];
                    }
                }
                
                [self.orderDataArr addObject:orderModel];
            }
            
            RLMResults *orderArr = [self getDBData];
            RLMRealm *realm = [RLMRealm defaultRealm];
            if (orderArr.count > 0) {
                [realm beginWriteTransaction];
                [realm deleteObjects:orderArr];
                [realm commitWriteTransaction];
            }
            
            for (SCMyOrderModel *orderM in self.orderDataArr) {
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                [SCMyOrderModel createOrUpdateInRealm:realm withValue:orderM];
                [realm commitWriteTransaction];
            }
            
            [self loadDBData:_statusString];
        }
        [self.loadingView stopAnimation];
    } failure:^(NSError *error) {
        [self.orderTableView.mj_header endRefreshing];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        if(self.orderDataArr.count == 0){
            _nodataLableView.hidden = NO;
            [self.orderTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.orderDataArr.count];
        }
        [self.loadingView stopAnimation];
    }];
}

-(RLMResults *)getDBData {
    if ([_statusString isEqualToString:@"99"]) {
        RLMResults *results = [[CacheData shareInstance] search:[SCMyOrderModel class] predicate:nil sorted:@"ordertime" ascending:NO];
        return results;
    }
    NSString *predicate = [NSString stringWithFormat:@"statusString = '%@'", _statusString];
    
    RLMResults *results = [[CacheData shareInstance] search:[SCMyOrderModel class] predicate:predicate sorted:@"ordertime" ascending:NO];
    return results;
}

-(void)loadDBData:(NSString*)statusStr {
    
    [self.orderDataArr removeAllObjects];
    
    RLMResults *orderArr = [self getDBData];
    if (orderArr.count > 0) {
        for (SCMyOrderModel *orderM in orderArr) {
            [self.orderDataArr addObject:orderM];
        }
        SCMyOrderModel *orderModel = orderArr.lastObject;
        _oidString = [NSString stringWithFormat:@"%@", orderModel.orderId];
    }else{
        _nodataLableView.hidden = NO;
        [self.orderTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.orderDataArr.count];
    }
    
    [self.orderTableView.mj_header endRefreshing];
    [self.orderTableView.mj_footer endRefreshing];
    [self.orderTableView reloadData];
    [self.loadingView stopAnimation];
}

/**创建订单状态按钮*/
-(void)createTopButton{
    
    _searchView = [[SearchTopView alloc] initWithFrame:CGRectMake(0, 74+NaviAddHeight, SCREEN_WIDTH, 35) andHeight:35];
    _searchView.searchTextField.placeholder = @"商品名称/订单号/收件人/收件人电话/昵称";
    _searchView.delegate = self;
    [self.view addSubview:_searchView];
    
    self.statusView = [[UIView alloc] init];
    self.statusView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.statusView];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchView.mas_bottom).offset(10);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(50);
    }];
    float buttonH = 50;
    _statusBtnArr = [NSMutableArray array];
    NSArray *titleArr = @[@"待付款", @"待收货", @"待评价", @"退货", @"全部"];
    
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UIButton *btn = [self createOrderButtonWithframe:CGRectMake((SCREEN_WIDTH/5)*i, 0, SCREEN_WIDTH/5, buttonH) andTag:140+i andAction:@selector(clickOrderButton:) andtitle:titleArr[i]];
        [self.statusView addSubview:btn];
        [_statusBtnArr addObject:btn];
    }
    _allOrderButton.selected = YES;
    
    self.indicateLine = [[UILabel alloc] init];
    self.indicateLine.backgroundColor = [UIColor tt_redMoneyColor];
    [self.statusView addSubview:self.indicateLine];
    [self.indicateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(47);
        make.left.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH/5);
        make.height.mas_offset(3);
    }];
    
}

#pragma mark - 搜索代理方法
-(void)keyboardSearchWithString:(NSString *)searchStr {
    
    [self loadMyOrderData:_searchView.searchTextField.text];
    
}

-(void)clickBtnSearch:(UIButton *)button {
    NSLog(@"按键搜索");
    [_searchView.searchTextField resignFirstResponder];
    [self loadMyOrderData:_searchView.searchTextField.text];
}


-(void)updateBtnSelectedState:(UIButton*)button {
    for (NSInteger i = 0; i < _statusBtnArr.count; i++) {
        UIButton *btn = _statusBtnArr[i];
        btn.selected = NO;
        btn.userInteractionEnabled = YES;
    }
    self.statusString = _statusArr[button.tag - 140];
    [self moveStatusLineWithStatus:self.statusString];
    button.selected = YES;
    [button setUserInteractionEnabled:NO];
}
//移动红线
-(void)moveStatusLineWithStatus:(NSString *)status{
    
    
    float leftX = 0;
    if ([self.statusString isEqualToString:@"1"]){//待付款
        leftX = 0;
    }else if ([self.statusString isEqualToString:@"2,7"]){//待发货
        leftX = SCREEN_WIDTH/5;
    }else if ([self.statusString isEqualToString:@"3,4,5,6"]){//已完成
        leftX = SCREEN_WIDTH*2/5;
    }else if ([self.statusString isEqualToString:@"4,5"]){//退换货
        leftX = SCREEN_WIDTH*3/5;
    }else{ //99:全部
        leftX = SCREEN_WIDTH*4/5;
    }
    [self.indicateLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(leftX);
    }];
}

-(void)clickOrderButton:(UIButton *)button{
    //    订单状态（99：全部0：已取消 1：未付款；2：已付款；3:已收货 4：正在退货，5：退货成功，6：已完成，7：已发货 8  支付中）
    
    [self updateBtnSelectedState:button];
    [self loadDBData:_statusString];
    [self loadMyOrderData:_searchView.searchTextField.text];
}

#pragma mark-创建tableView
-(void)createTableView{
    
    _orderTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_orderTableView];
    
    _orderTableView.estimatedRowHeight = 44;
    _orderTableView.estimatedSectionHeaderHeight = 0;
    _orderTableView.estimatedSectionFooterHeight = 0;
    _orderTableView.backgroundColor = [UIColor tt_grayBgColor];
    [_orderTableView registerClass:[SCOrderListCell class] forCellReuseIdentifier:cellIdentifier];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    [_orderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
        make.top.equalTo(self.statusView.mas_bottom).offset(7);
    }];
    
}

#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderDataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SCMyOrderModel *orderM = self.orderDataArr[section];
    return orderM.itemlistArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SCOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SCOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.orderDataArr count]) {
        SCMyOrderModel *orderM = self.orderDataArr[indexPath.section];
        SCMyOrderGoodsModel *goodsM = orderM.itemlistArr[indexPath.row];
        [cell refreshWithModel:goodsM];
    }
    
    return cell;
}

/**段头*/
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    headerView.backgroundColor = [UIColor whiteColor];
    _orderNumberLable = [UILabel configureLabelWithTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [headerView addSubview:_orderNumberLable];
    _orderNumberLable.text = @"订单编号:";
    _orderNumberLable.frame = CGRectMake(10, 0, (SCREEN_WIDTH-100), 45);
    
    _orderStateLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    _orderStateLable.text = @"";
    [headerView addSubview:_orderStateLable];
    [_orderStateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top);
        make.right.equalTo(headerView.mas_right).offset(-10);
        make.bottom.equalTo(headerView.mas_bottom);
        make.width.mas_equalTo(80);
    }];
    
    
    UILabel  *headertLineLable = [UILabel creatLineLable];
    [headerView addSubview:headertLineLable];
    headertLineLable.frame = CGRectMake(10, 45, SCREEN_WIDTH-20, 1);
    if ([self.orderDataArr count]) {
        
        SCMyOrderModel *orderModel = self.orderDataArr[section];
        _orderStateLable.text = [NSString stringWithFormat:@"%@",orderModel.orderstatus];
        
        NSString *orderfrom = [NSString stringWithFormat:@"%@", orderModel.orderfrom];
        if ([orderfrom isEqualToString:@"3"]) {
            //退换货才加标识
            NSString *orderNo = [NSString stringWithFormat:@"订单编号：%@", orderModel.no];
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:orderNo];
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:@"order_changeGoods"];
            attch.bounds = CGRectMake(5, -5, 25, 25);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri appendAttributedString:string];
            _orderNumberLable.attributedText = attri;
        }else{
            _orderNumberLable.text = [NSString stringWithFormat:@"订单编号：%@", orderModel.no];
        }
    }
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
//*段尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    SCMyOrderModel *orderModel = self.orderDataArr[section];
    NSString *statustr = [NSString stringWithFormat:@"%@",orderModel.orderstatus];
    
    if ([statustr isEqualToString:@"已付款"] || [statustr isEqualToString:@"退货成功"]) {
    
        UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        bgview.backgroundColor = [UIColor tt_grayBgColor];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        view.backgroundColor = [UIColor whiteColor];
        [bgview addSubview:view];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 35)];
        NSString *allMoney = [NSString stringWithFormat:@"%@", orderModel.money];
        if (IsNilOrNull(allMoney)) {
            allMoney = @"0.00";
        }
        
        label.textColor = [UIColor tt_monthGrayColor];
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentRight;
        if (iphone4) {
            label.font = CHINESE_SYSTEM(11);
        }else if (iphone5){
            label.font = CHINESE_SYSTEM(14);
        }else{
            label.font = CHINESE_SYSTEM(15);
        }
        
        NSString *count = [NSString stringWithFormat:@"%@",orderModel.ordernumber];
        NSString *str = [NSString stringWithFormat:@"全国包邮，共%@件商品，合计:¥%@", count, allMoney];
        
        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:str];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range1 = [[hintString string]rangeOfString:@"合计:"];
        NSRange range = NSMakeRange(range1.location+range1.length, hintString.length - range1.location-range1.length);
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor tt_redMoneyColor] range:range];
        label.attributedText = hintString;
        
        [view addSubview:label];
        return bgview;
        
    }else{
        
        _footerView = [[OrderFooterView alloc] initWithFrame:CGRectZero andType:statustr andHasTop:YES type:@"SCOrderListViewController"];
        _footerView.delegate = self;
        NSString *iscomment = [NSString stringWithFormat:@"%@", orderModel.iscomment];
        [_footerView refreshButton:iscomment];
        _footerView.rightButton.tag = section + 170;
        _footerView.leftButton.tag = section + 160;
        
        NSString *allMoney = [NSString stringWithFormat:@"%@", orderModel.money];
        if (IsNilOrNull(allMoney)) {
            allMoney = @"0.00";
        }
        
        if([statustr isEqualToString:@"已取消"]){
            
        }else{
            NSString *count = [NSString stringWithFormat:@"%@",orderModel.ordernumber];
            NSString *str = [NSString stringWithFormat:@"全国包邮，共%@件商品，合计:¥%@", count, allMoney];
            
            NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:str];
            //获取要调整颜色的文字位置,调整颜色
            NSRange range1 = [[hintString string]rangeOfString:@"合计:"];
            NSRange range = NSMakeRange(range1.location+range1.length, hintString.length - range1.location-range1.length);
            [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor tt_redMoneyColor] range:range];
            _footerView.priceLable.attributedText = hintString;
        }

        return _footerView;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    SCMyOrderModel *orderModel = self.orderDataArr[section];
    
    NSString *statustr = [NSString stringWithFormat:@"%@",orderModel.orderstatus];
    if ([statustr isEqualToString:@"已付款"] || [statustr isEqualToString:@"退货成功"]){
        return 40;
    }else{
        if ([statustr isEqualToString:@"已取消"]){
            return 55;
        }
        return 95;
    }
}

/**点击进入详情*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SCMyOrderModel *orderM = self.orderDataArr[indexPath.section];
    SCOrderDetailViewController *checkOrder = [[SCOrderDetailViewController alloc] init];
    checkOrder.orderModel = orderM;
    checkOrder.orderstatusString = orderM.orderstatus;
    checkOrder.orderid = orderM.orderId;
    [self.navigationController pushViewController:checkOrder animated:YES];
}

-(void)refreshData {
    __weak typeof(self) weakSelf = self;
    self.orderTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.orderTableView.mj_header beginRefreshing];
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
                    [strongSelf loadMyOrderData:_searchView.searchTextField.text];
                }else{
                    [strongSelf.orderTableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [strongSelf showNoticeView:NetWorkNotReachable];
                [strongSelf.orderTableView.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    
    self.orderTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [weakSelf loadMoreData];
    }];
}

#pragma mark - 上拉加载更多订单列表数据
-(void)loadMoreData {
    
    _nodataLableView.hidden = YES;
    
    NSString *startindex = [NSString stringWithFormat:@"%ld", self.orderDataArr.count+1];
    
    NSString *endindex = [NSString stringWithFormat:@"%ld", [startindex integerValue]+20];
    
    NSDictionary *parmaDic = [NSDictionary dictionary];
    NSString *searchStr = _searchView.searchTextField.text;
    if (!IsNilOrNull(searchStr)) {
        parmaDic = @{@"openid":USER_OPENID ,@"status": self.statusString, @"startindex":startindex, @"endindex":endindex, @"keywords":searchStr};
    }else{
        parmaDic = @{@"openid":USER_OPENID ,@"status": self.statusString, @"startindex":startindex, @"endindex":endindex};
    }
    
    NSString *orderListUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI, GetOrderListUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool getWithUrl:orderListUrl params:parmaDic success:^(id json) {
        [self.orderTableView.mj_footer endRefreshing];
        NSDictionary *itemDic = json;
        if ([itemDic[@"code"] integerValue] != 200) {
            [self.loadingView stopAnimation];
            [self showNoticeView:itemDic[@"msg"]];
            return;
        }
        NSArray *itemArr = itemDic[@"orderlist"];
        if (itemArr.count == 0) {
            [self.loadingView stopAnimation];
            [self.orderTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        for (NSDictionary *listOrderDic in itemArr) {
            SCMyOrderModel *orderModel = [[SCMyOrderModel alloc] init];
            [orderModel setValuesForKeysWithDictionary:listOrderDic];
            orderModel.money = [NSString stringWithFormat:@"%@", listOrderDic[@"money"]];
            orderModel.ordernumber = [NSString stringWithFormat:@"%@", listOrderDic[@"ordernumber"]];
            orderModel.iscomment = [NSString stringWithFormat:@"%@", listOrderDic[@"iscomment"]];
            orderModel.balancemoney = [NSString stringWithFormat:@"%@", listOrderDic[@"balancemoney"]];
            orderModel.statusString = _statusString;
            NSArray *ordersheetArr = listOrderDic[@"itemlist"];
            if (ordersheetArr.count > 0) {
                
                for (NSInteger i = 0; i<ordersheetArr.count; i++) {
                    SCMyOrderGoodsModel *orderSheet = [[SCMyOrderGoodsModel alloc] init];
                    NSDictionary *dic = ordersheetArr[i];
                    [orderSheet setValuesForKeysWithDictionary:dic];
                    orderSheet.goodsKey = [NSString stringWithFormat:@"%@_%@_%ld", orderModel.orderId, orderSheet.itemid, i];
                    [orderModel.itemlistArr addObject:orderSheet];
                }
            }
            
            [self.orderDataArr addObject:orderModel];
        }
        
        [self.orderTableView reloadData];
        [self.loadingView stopAnimation];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        [self.orderTableView.mj_footer endRefreshing];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

/**创建 统一 button*/
-(UIButton *)createOrderButtonWithframe:(CGRect)frame andTag:(NSInteger)tag andAction:(SEL)action andtitle:(NSString *)title{
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:TitleColor forState:UIControlStateNormal];
    button.titleLabel.font = MAIN_TITLE_FONT;
    button.frame = frame;
    button.tag = tag;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    switch (tag-140) {
        case 0:
            _allOrderButton = button;
            break;
        case 1:
            _waitPayMoneyButton = button;
            break;
        case 2:
            _waitDispatchGoodsButton = button;
            break;
        case 3:
            _waitConsigneeButton = button;
            break;
        case 4:
            _afterSalesButton = button;
            break;
            
        default:
            break;
    }
    
    return button;
}

#pragma mark - FooterViewDelegate
-(void)leftButtonClick:(UIButton *)btn {
    
    SCMyOrderModel *orderM = self.orderDataArr[btn.tag - 160];
    _orderModel = orderM;
    if ([btn.titleLabel.text isEqualToString:@"取消订单"]) {
        [self cancelOrder:orderM];//未付款的可以取消
    }else if ([btn.titleLabel.text isEqualToString:@"删除订单"]) {
        [self confirmCancelOrder:orderM];
    }else if ([btn.titleLabel.text isEqualToString:@"查看物流"]) {
        
        NSString *iftransno = [NSString stringWithFormat:@"%@", orderM.iftransno];
        if ([iftransno isEqualToString:@"false"] || [iftransno isEqualToString:@"0"] || IsNilOrNull(iftransno)) {
            
        }else{
            NSString *oidString = [NSString stringWithFormat:@"%@",_orderModel.orderId];
            //点击进入物流详情
            DetailLogisticsViewController *detailLogist = [[DetailLogisticsViewController alloc] init];
            detailLogist.oidString = oidString;
            [self.navigationController pushViewController:detailLogist animated:YES];
        }
    }
}

-(void)rightButtonClick:(UIButton *)btn {
    SCMyOrderModel *orderM = self.orderDataArr[btn.tag - 170];
    _orderModel = orderM;
    
    if ([btn.titleLabel.text isEqualToString:@"去付款"]) {
        [self payOrder:orderM];
    }else if ([btn.titleLabel.text isEqualToString:@"再次购买"]) {
        [self buyAgain:orderM];//再次购买
    }else if ([btn.titleLabel.text isEqualToString:@"联系客服"]) {
        [self contactCS:orderM];
    }else if ([btn.titleLabel.text isEqualToString:@"确认收货"]) {
        [self confirmReceiveGoods:orderM];
    }else if ([btn.titleLabel.text isEqualToString:@"去评价"]) {
        NSMutableArray *temp = [NSMutableArray array];
        for (SCMyOrderGoodsModel *orderGoodsM in orderM.itemlistArr) {
            SCOrderDetailGoodsModel *commentM = [[SCOrderDetailGoodsModel alloc] init];
            commentM.path = [NSString stringWithFormat:@"%@", orderGoodsM.path];
            commentM.spec = [NSString stringWithFormat:@"%@", orderGoodsM.spec];
            commentM.count = [NSString stringWithFormat:@"%@", orderGoodsM.count];
            commentM.name = [NSString stringWithFormat:@"%@", orderGoodsM.name];
            commentM.itemid = [NSString stringWithFormat:@"%@", orderGoodsM.itemid];
            commentM.price = [NSString stringWithFormat:@"%@", orderGoodsM.price];
            [temp addObject:commentM];
        }
        
        if (temp.count > 1) {
            SCWaitReleaseCommentViewController *releaseComment = [[SCWaitReleaseCommentViewController alloc] init];
            releaseComment.orderid = orderM.orderId;
            [self.navigationController pushViewController:releaseComment animated:YES];
        }else if(temp.count == 1){
            SCCommentOrderViewController *releaseComment = [[SCCommentOrderViewController alloc] init];
            releaseComment.orderid = orderM.orderId;
            SCOrderDetailGoodsModel *commentM = temp.firstObject;
            releaseComment.goodsM = commentM;
            [self.navigationController pushViewController:releaseComment animated:YES];
        }else{
            
        }
    }else if ([btn.titleLabel.text isEqualToString:@"查看物流"]) {
        
        NSString *iftransno = [NSString stringWithFormat:@"%@", orderM.iftransno];
        if ([iftransno isEqualToString:@"false"] || [iftransno isEqualToString:@"0"] || IsNilOrNull(iftransno)) {
            
        }else{
            NSString *oidString = [NSString stringWithFormat:@"%@",_orderModel.orderId];
            //点击进入物流详情
            DetailLogisticsViewController *detailLogist = [[DetailLogisticsViewController alloc] init];
            detailLogist.oidString = oidString;
            [self.navigationController pushViewController:detailLogist animated:YES];
        }
    }else if ([btn.titleLabel.text isEqualToString:@"差价付款"]) {
        [self payOrder:orderM];
    }else if ([btn.titleLabel.text isEqualToString:@"删除订单"]) {
        [self confirmCancelOrder:orderM];
    }
}
#pragma mark - 取消订单
-(void)cancelOrder:(SCMyOrderModel *)orderM {
    
    _deleteAlertView = [[XWAlterVeiw alloc] init];
    _deleteAlertView.delegate = self;
    _deleteAlertView.titleLable.text = @"确定取消该订单？";
    _deleteAlertView.type = @"取消订单";
    [_deleteAlertView show];
    
}
#pragma mark - 再次购买，跳转到首页
-(void)buyAgain:(SCMyOrderModel *)orderM {
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - 去付款
-(void)payOrder:(SCMyOrderModel *)orderM {
    SCPayViewController *payMoney = [[SCPayViewController alloc] init];
    payMoney.payfeeStr = [NSString stringWithFormat:@"%@", orderM.ordermoney];
    
    NSString *balancemoney = [NSString stringWithFormat:@"%@", orderM.balancemoney];
    if (!IsNilOrNull(balancemoney) && [balancemoney doubleValue] > 0) {
        //补差价
        payMoney.money = balancemoney;
    }else{
        //实付款
        payMoney.money = [NSString stringWithFormat:@"%@", orderM.money];
    }
    payMoney.orderid = orderM.orderId;
    NSString *orderNo = [NSString stringWithFormat:@"%@", orderM.no];
    if ([orderNo hasPrefix:@"ckdlb"]) {
        payMoney.isdlbitem = @"1";
    }
    [self.navigationController pushViewController:payMoney animated:YES];
}
#pragma mark - 删除订单
-(void)confirmCancelOrder:(SCMyOrderModel *)orderM {
    _deleteAlertView = [[XWAlterVeiw alloc] init];
    _deleteAlertView.delegate = self;
    _deleteAlertView.titleLable.text = @"确定删除该订单？";
    _deleteAlertView.type = @"删除订单";
    [_deleteAlertView show];
}

-(void)deleteOrder {
    NSDictionary *pramaDic = @{@"orderids": _orderModel.orderId};
    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, DelOrderUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:loveItemUrl params:pramaDic success:^(id json) {
        
        NSDictionary *dic = json;
        NSString * status = [dic valueForKey:@"code"];
        if ([status intValue] != 200) {
            [self.loadingView stopAnimation];
            [self showNoticeView:[dic valueForKey:@"msg"]];
            return ;
        }
        [self showNoticeView:@"删除成功"];
        NSString *predict = [NSString stringWithFormat:@"orderId = '%@'", _orderModel.orderId];
        RLMResults *result = [SCMyOrderModel objectsWhere:predict];
        RLMRealm *realm = [RLMRealm defaultRealm];
        if (result.count>0) {
            [realm beginWriteTransaction];
            [realm deleteObject:result.firstObject];
            [realm commitWriteTransaction];
        }
        
        [self loadMyOrderData:_searchView.searchTextField.text];
        [self.loadingView stopAnimation];
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        [self.loadingView stopAnimation];
    }];
}

#pragma mark - 确认收货
-(void)confirmReceiveGoods:(SCMyOrderModel *)orderM {
    _deleteAlertView = [[XWAlterVeiw alloc] init];
    _deleteAlertView.delegate = self;
    _deleteAlertView.titleLable.text = @"确定已经收到货物？";
    _deleteAlertView.type = @"确认收货";
    [_deleteAlertView show];
}


-(void)subuttonClicked{
    
    if ([_deleteAlertView.type isEqualToString:@"确认收货"]) {
        [self confirmReceiveGoods];
    }else if ([_deleteAlertView.type isEqualToString:@"取消订单"]) {
        [self confirmCancelOrder];
    }else if ([_deleteAlertView.type isEqualToString:@"删除订单"]) {
        [self deleteOrder];
    }
}

-(void)confirmCancelOrder {
    NSDictionary *pramaDic = @{@"orderid": _orderModel.orderId};
    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, CancelOrderUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:loveItemUrl params:pramaDic success:^(id json) {
        
        NSDictionary *dic = json;
        NSString * status = [dic valueForKey:@"code"];
        if ([status intValue] != 200) {
            [self.loadingView stopAnimation];
            [self showNoticeView:[dic valueForKey:@"msg"]];
            return ;
        }
        [self showNoticeView:@"取消成功"];
        //取消成功后更新优惠券缓存
        [[SCCouponTools shareInstance] resquestValidCouponsData];
        
        NSString *predict = [NSString stringWithFormat:@"orderId = '%@'", _orderModel.orderId];
        RLMResults *result = [SCMyOrderModel objectsWhere:predict];
        RLMRealm *realm = [RLMRealm defaultRealm];
        if (result.count > 0) {
            [realm beginWriteTransaction];
            [realm deleteObject:result.firstObject];
            [realm commitWriteTransaction];
            
        }
        
        [self loadMyOrderData:_searchView.searchTextField.text];
        
        [self.loadingView stopAnimation];
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        [self.loadingView stopAnimation];
    }];
}

-(void)confirmReceiveGoods {
    NSDictionary *pramaDic = @{@"orderid": _orderModel.orderId};
    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, ConfirmReceiveUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:loveItemUrl params:pramaDic success:^(id json) {
        NSDictionary *dic = json;
        NSString * status = [dic valueForKey:@"code"];
        if ([status intValue] != 200) {
            [self.loadingView stopAnimation];
            [self showNoticeView:[dic valueForKey:@"msg"]];
            return ;
        }
        NSString *predict = [NSString stringWithFormat:@"orderId = '%@'", _orderModel.orderId];
        RLMResults *result = [SCMyOrderModel objectsWhere:predict];
        RLMRealm *realm = [RLMRealm defaultRealm];
        if (result.count > 0) {
            [realm beginWriteTransaction];
            [realm deleteObject:result.firstObject];
            [realm commitWriteTransaction];
        }
        [self loadMyOrderData:_searchView.searchTextField.text];
        [self.loadingView stopAnimation];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 联系客服
-(void)contactCS:(SCMyOrderModel *)orderM {
    [[SobotManager shareInstance] startSobotCustomerService];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

@end
