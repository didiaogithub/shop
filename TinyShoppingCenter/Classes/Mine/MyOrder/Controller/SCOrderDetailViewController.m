//
//  SCOrderDetailViewController.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/9.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCOrderDetailViewController.h"
#import "DetailLogisticsViewController.h"
#import "SCPayViewController.h"
#import "OrderFooterView.h"
#import "XWAlterVeiw.h"
#import "SCGoodsDetailViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "SCOrderDetailModel.h"
#import "ChangeMyAddressViewController.h"
#import "SCOrderDetailCell.h"
#import "CKCLogisticsDetailVC.h"

@interface SCOrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource, XWAlterVeiwDelegate, OrderFooterViewDelegate, CKOriginalOrderInfoCellDelegate, CKChangeOrderInfoCellDelegate>

@property (nonatomic, strong) XWAlterVeiw *alertView;
@property (nonatomic, strong) UITableView *checkOrderTableView;
@property (nonatomic, strong) NSMutableArray *orderDetailArray;
@property (nonatomic, strong) OrderFooterView *footerView;
@property (nonatomic, strong) XWAlterVeiw *deleteAlertView;
@property (nonatomic, copy)   NSString *iftransno;//是否邮寄

@property (nonatomic, copy)   NSString *gettername;//是否邮寄
@property (nonatomic, copy)   NSString *gettermobile;//是否邮寄
@property (nonatomic, copy)   NSString *getteraddress;//是否邮寄
@property (nonatomic, copy)   NSString *integralnum;//返点积分

@property (nonatomic, strong) UIButton *originalOrderBtn;
@property (nonatomic, strong) SCOrderDetailModel *orderDetailModel;
@property (nonatomic, strong) NSMutableArray *tableDataArr;

@end


@implementation SCOrderDetailViewController

-(NSMutableArray *)tableDataArr {
    if (_tableDataArr == nil) {
        _tableDataArr = [NSMutableArray array];
    }
    return _tableDataArr;
}

-(NSMutableArray *)orderDetailArray{
    if (_orderDetailArray == nil) {
        _orderDetailArray = [[NSMutableArray alloc] init];
    }
    return _orderDetailArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initComponents];
    
    [self createBottomView];
    //请求订单详情数据
    [self requestOrderDetailData];
}

-(void)initComponents {
    
    _checkOrderTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_checkOrderTableView];
    _checkOrderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _checkOrderTableView.backgroundColor = [UIColor tt_grayBgColor];
    
    self.checkOrderTableView.rowHeight = UITableViewAutomaticDimension;
    self.checkOrderTableView.estimatedRowHeight = 44;
    _checkOrderTableView.dataSource = self;
    _checkOrderTableView.delegate = self;
    if (@available(iOS 11.0, *)) {
        self.checkOrderTableView.estimatedSectionHeaderHeight = 0.1;
        self.checkOrderTableView.estimatedSectionFooterHeight = 0.1;
    }
    
    [_checkOrderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.equalTo(self.footerView.mas_top);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight);
        }else{
            make.top.equalTo(self.view.mas_top).offset(0);
        }
    }];
    

    //更新地址失败隐藏修改地址按钮
    [CKCNotificationCenter addObserver:self selector:@selector(hiddenChangeAddressBtn) name:@"OrderUpdateAddrFailNoti" object:nil];
}

#pragma mark - 创建查看原订单按钮
- (void)createCheckBtn {
    self.originalOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.originalOrderBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    if (IPHONE_X) {
        self.originalOrderBtn.frame = CGRectMake(SCREEN_WIDTH - 90, self.view.frame.size.height *0.5 - 110, 90, 30);
    }else if (iphone6Plus){
        self.originalOrderBtn.frame = CGRectMake(SCREEN_WIDTH - 90, self.view.frame.size.height *0.5 - 75, 90, 30);
    }else if (iphone6){
        self.originalOrderBtn.frame = CGRectMake(SCREEN_WIDTH - 90, self.view.frame.size.height *0.5 - 63, 90, 29);
    }else{
        self.originalOrderBtn.frame = CGRectMake(SCREEN_WIDTH - 90, self.view.frame.size.height *0.5 - 32, 90, 25);
        self.originalOrderBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    
    [self.originalOrderBtn setTitle:@"查看原订单" forState:UIControlStateNormal];
    [self.originalOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.originalOrderBtn addTarget:self action:@selector(checkOriginalOrder:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.originalOrderBtn];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.originalOrderBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.originalOrderBtn.bounds;
    maskLayer.path = path.CGPath;
    self.originalOrderBtn.layer.mask = maskLayer;
    self.originalOrderBtn.layer.backgroundColor = [UIColor colorWithRed:226/255.0 green:35/255.0 blue:26/255.0 alpha:0.8].CGColor;
}

#pragma mark - 查看原订单
- (void)checkOriginalOrder:(UIButton*)sender {
    if ([sender.titleLabel.text isEqualToString:@"查看原订单"]) {
        [sender setTitle:@"关闭原订单" forState:UIControlStateNormal];

        for (NSInteger i = 0; i < self.orderDetailModel.olddetailArry.count; i++) {
            CellModel *originalM = [self createCellModel:[CKOriginalOrderInfoCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.orderDetailModel.olddetailArry,@"data", [NSString stringWithFormat:@"%ld", i], @"tag", nil] height:50];
            originalM.delegate = self;
            
            SectionModel *section31 = [self createSectionModel:@[originalM] headerHeight:0.0001 footerHeight:0.0001];
            
            if (!IsNilOrNull(self.integralnum) && [self.integralnum integerValue] > 0){
                [self.tableDataArr insertObject:section31 atIndex:self.tableDataArr.count - 2];
            }else{
                [self.tableDataArr insertObject:section31 atIndex:self.tableDataArr.count - 1];
            }
        }
        
        for (NSInteger i = 0; i < self.orderDetailModel.newdetailArry.count; i++) {
            CellModel *originalM = [self createCellModel:[CKChangeOrderInfoCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.orderDetailModel.newdetailArry, @"data", [NSString stringWithFormat:@"%ld", i], @"tag", nil] height:50];
            originalM.delegate = self;
            
            CGFloat headerHeight = i==0 ? 10:0.0001;
            
            SectionModel *section31 = [self createSectionModel:@[originalM] headerHeight:headerHeight footerHeight:0.0001];
            if (!IsNilOrNull(self.integralnum) && [self.integralnum integerValue] > 0){
                [self.tableDataArr insertObject:section31 atIndex:self.tableDataArr.count - 2];
            }else{
                [self.tableDataArr insertObject:section31 atIndex:self.tableDataArr.count - 1];
            }
        }
    }else{
        [sender setTitle:@"查看原订单" forState:UIControlStateNormal];
        
        //删除原订单cell
        NSMutableArray *tempArray = [self.tableDataArr copy];
        for (SectionModel *sModel in tempArray) {
            for (CellModel *item in sModel.cells) {
                if ([item.className isEqualToString:NSStringFromClass([CKOriginalOrderInfoCell class])] || [item.className isEqualToString:NSStringFromClass([CKOriginalOrderGoodsCell class])] || [item.className isEqualToString:NSStringFromClass([CKChangeOrderInfoCell class])] || [item.className isEqualToString:NSStringFromClass([CKChangOrderGoodsCell class])]) {
                    [self.tableDataArr removeObject:sModel];
                }
            }
        }
    }
    [self.checkOrderTableView reloadData];
}

#pragma mark - CKOriginalOrderInfoCellDelegate
- (void)showOriginalOrderDetail:(CKOriginalOrderInfoCell *)originalOrderInfoCell index:(NSInteger)index {
    
    NSLog(@"展开%ld--- %@", index, originalOrderInfoCell);
    
    NSMutableArray *tempArray = [NSMutableArray array];
    CKOldDetailModel *oldDetailM = [[CKOldDetailModel alloc] init];
    oldDetailM = self.orderDetailModel.olddetailArry[index];
    
    for (NSInteger i = 0; i < oldDetailM.goodsArray.count; i++) {
        CellModel *originalM = [self createCellModel:[CKOriginalOrderGoodsCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:oldDetailM.goodsArray[i],@"data", nil] height:[CKOriginalOrderGoodsCell computeHeight:oldDetailM.goodsArray[i]]];
        originalM.delegate = self;
        [tempArray addObject:originalM];
    }
    
    //获取要添加的index
    NSMutableArray *indexArr = [NSMutableArray array];
    for (NSInteger i = 0; i<self.tableDataArr.count; i++) {
        SectionModel *sModel = self.tableDataArr[i];
        for (CellModel *item in sModel.cells) {
            if ([item.className isEqualToString:NSStringFromClass([CKOriginalOrderInfoCell class])]) {
                [indexArr addObject:[NSString stringWithFormat:@"%ld", i]];
            }
        }
    }
    
    NSInteger insertIndex = [[indexArr objectAtIndex:index] integerValue] + 1;
    
    SectionModel *section31 = [self createSectionModel:tempArray headerHeight:0.0001 footerHeight:0.0001];
    [self.tableDataArr insertObject:section31 atIndex:insertIndex];
    [self.checkOrderTableView reloadData];
}

- (void)closeOriginalOrderDetail:(CKOriginalOrderInfoCell *)originalOrderInfoCell index:(NSInteger)index {
    NSLog(@"收缩%ld--- %@", index, originalOrderInfoCell);
    
    //删除原订单cell
    CKOldDetailModel *oldDetailM = self.orderDetailModel.olddetailArry[index];
    NSMutableArray *tempArray = [self.tableDataArr copy];
    for (SectionModel *sModel in tempArray) {
        for (CellModel *item in sModel.cells) {
            if ([item.className isEqualToString:NSStringFromClass([CKOriginalOrderGoodsCell class])]) {
                NSDictionary *dict = item.userInfo;
                CKGoodsDetailModel *goodsM = dict[@"data"];
                if ([oldDetailM.goodsArray containsObject:goodsM]) {
                    [self.tableDataArr removeObject:sModel];
                }
            }
        }
    }
    
    [self.checkOrderTableView reloadData];
}


#pragma mark - CKChangeOrderInfoCellDelegate
- (void)showChangeOrderDetail:(CKChangeOrderInfoCell *)changeOrderInfoCell index:(NSInteger)index {
    NSLog(@"展开%ld--- %@", index, changeOrderInfoCell);
    
    CKChangeDetailModel *changeModel = [[CKChangeDetailModel alloc] init];
    changeModel = self.orderDetailModel.newdetailArry[index];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSInteger i = 0; i < changeModel.goodsArray.count; i++) {
        CellModel *originalM = [self createCellModel:[CKChangOrderGoodsCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:changeModel.goodsArray[i],@"data", nil] height:[CKChangOrderGoodsCell computeHeight:changeModel.goodsArray[i]]];
        originalM.delegate = self;
        [tempArray addObject:originalM];
    }
    
    //获取要添加的index
    NSMutableArray *indexArr = [NSMutableArray array];
    for (NSInteger i = 0; i<self.tableDataArr.count; i++) {
        SectionModel *sModel = self.tableDataArr[i];
        for (CellModel *item in sModel.cells) {
            if ([item.className isEqualToString:NSStringFromClass([CKChangeOrderInfoCell class])]) {
                [indexArr addObject:[NSString stringWithFormat:@"%ld", i]];
            }
        }
    }
    
    NSInteger insertIndex = [[indexArr objectAtIndex:index] integerValue] + 1;
    
    SectionModel *section31 = [self createSectionModel:tempArray headerHeight:0.0001 footerHeight:0.0001];
    [self.tableDataArr insertObject:section31 atIndex:insertIndex];
    [self.checkOrderTableView reloadData];
}

- (void)closeChangeOrderDetail:(CKChangeOrderInfoCell *)changeOrderInfoCell index:(NSInteger)index {
    NSLog(@"收缩%ld--- %@", index, changeOrderInfoCell);
    
    //删除原订单cell
    CKChangeDetailModel *changeModel = self.orderDetailModel.newdetailArry[index];
    NSMutableArray *tempArray = [self.tableDataArr copy];
    for (SectionModel *sModel in tempArray) {
        for (CellModel *item in sModel.cells) {
            if ([item.className isEqualToString:NSStringFromClass([CKChangOrderGoodsCell class])]) {
                NSDictionary *dict = item.userInfo;
                CKGoodsDetailModel *goodsM = dict[@"data"];
                if ([changeModel.goodsArray containsObject:goodsM]) {
                    [self.tableDataArr removeObject:sModel];
                }
            }
        }
    }
    
    [self.checkOrderTableView reloadData];
}

#pragma mark - 请求订单详情数据
-(void)requestOrderDetailData{
    [self.orderDetailArray removeAllObjects];
    [self.tableDataArr removeAllObjects];
    NSString *orderDetailUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,OrderDetailUrl];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    NSDictionary *pramaDic = @{@"orderid": self.orderid};
    
    [HttpTool getWithUrl:orderDetailUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"msg"]];
            return ;
        }
        
        _orderDetailModel = [[SCOrderDetailModel alloc] init];
        [_orderDetailModel setValuesForKeysWithDictionary:dict];
        _orderDetailModel.olddetailArry = [NSMutableArray array];
        _orderDetailModel.newdetailArry = [NSMutableArray array];
        for (NSDictionary *oldDict in dict[@"olddetail"]) {
            CKOldDetailModel *oldDetailM = [[CKOldDetailModel alloc] init];
            [oldDetailM setValuesForKeysWithDictionary:oldDict];
            oldDetailM.goodsArray = [NSMutableArray array];
            for (NSDictionary *goodsDict in oldDict[@"goodsdetail"]) {
                CKGoodsDetailModel *goodsM = [[CKGoodsDetailModel alloc] init];
                [goodsM setValuesForKeysWithDictionary:goodsDict];
                [oldDetailM.goodsArray addObject:goodsM];
            }
            [_orderDetailModel.olddetailArry addObject:oldDetailM];
        }
        
        for (NSDictionary *newDict in dict[@"newdetail"]) {
            CKChangeDetailModel *newDetailM = [[CKChangeDetailModel alloc] init];
            [newDetailM setValuesForKeysWithDictionary:newDict];
            newDetailM.goodsArray = [NSMutableArray array];
            for (NSDictionary *goodsDict in newDict[@"goodsdetail"]) {
                CKGoodsDetailModel *goodsM = [[CKGoodsDetailModel alloc] init];
                [goodsM setValuesForKeysWithDictionary:goodsDict];
                [newDetailM.goodsArray addObject:goodsM];
            }
            [_orderDetailModel.newdetailArry addObject:newDetailM];
        }
        
        //创建查看原订单按钮
        NSArray *olddetail = [dict objectForKey:@"olddetail"];
        if ([olddetail count] > 0) {
            [self createCheckBtn];
        }
        
        [self bindData:dict];

        NSString *confirm = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"ConfirmReceiveGoods"]];
        if ([confirm isEqualToString:@"ConfirmReceiveGoods"]) {
            [self createBottomView];
            [KUserdefaults removeObjectForKey:@"ConfirmReceiveGoods"];
        }
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}

-(void)bindData:(NSDictionary *)dict {
    
    SCOrderDetailModel *orderM = [[SCOrderDetailModel alloc] init];
    [orderM setValuesForKeysWithDictionary:dict];
    orderM.itemlistArr = [NSMutableArray array];
    for (NSDictionary *goodsDic in dict[@"itemlist"]) {
        SCOrderDetailGoodsModel *goodsM = [[SCOrderDetailGoodsModel alloc] init];
        [goodsM setValuesForKeysWithDictionary:goodsDic];
        [orderM.itemlistArr addObject:goodsM];
    }
    [self.orderDetailArray addObject:orderM];
    
    
    //物流信息
    CellModel *logisticsModel = [self createCellModel:[CKLogisticsCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dict,@"data", nil] height:100];
    SectionModel *section0 = [self createSectionModel:@[logisticsModel] headerHeight:0.0001 footerHeight:0.0001];
    [self.tableDataArr addObject:section0];
    //收货人和电话
    CellModel *getterModel = [self createCellModel:[CKOrderGetterCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dict, @"data", nil] height:50];
    SectionModel *section1 = [self createSectionModel:@[getterModel] headerHeight:0.0001 footerHeight:0.0001];
    [self.tableDataArr addObject:section1];
    //收获地址
    CellModel *addressModel = [self createCellModel:[CKOrderAddressCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dict,@"data", @"default", @"type", nil] height:50*SCREEN_WIDTH/375.0f];
    SectionModel *section12 = [self createSectionModel:@[addressModel] headerHeight:0.0001 footerHeight:0.0001];
    [self.tableDataArr addObject:section12];
    
    //更改订单地址
    //商品item订单状态（0：已取消 1：待付款；2：已付款，3：已收货；4:正在退货 5：退货成功，6：已完成，7：已发货 ）
    self.orderstatusString = [NSString stringWithFormat:@"%@", dict[@"orderstatus"]];
    if ([self.orderstatusString isEqualToString:@"待付款"]) {
        CellModel *changeAddressModel = [self createCellModel:[CKOrderChangeAddressCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dict,@"data", self.orderid, @"orderid", nil] height:40];
        SectionModel *section13 = [self createSectionModel:@[changeAddressModel] headerHeight:0.0001 footerHeight:0.0001];
        [self.tableDataArr addObject:section13];
    }else{
        NSInteger limitTime = [[dict objectForKey:@"limittime"] integerValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";
        
        NSString *paytime = [dict objectForKey:@"paytime"];
        NSString *ordertime = [dict objectForKey:@"ordertime"];
        
        NSDate *payDate;
        if (!IsNilOrNull(paytime)) {
            payDate = [dateFormatter dateFromString:paytime];
        }else{
            payDate = [dateFormatter dateFromString:ordertime];
        }
        NSTimeInterval pay = [payDate timeIntervalSince1970];
        NSTimeInterval dateNow = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval value = dateNow - pay;
        
        CGFloat second = [[NSString stringWithFormat:@"%.2f",value] floatValue];//秒
        NSLog(@"间隔------%f秒",second);
        
        if ([self.orderstatusString isEqualToString:@"已付款"] && second < (limitTime*60) && limitTime > 0) {
            CellModel *changeAddressModel = [self createCellModel:[CKOrderChangeAddressCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dict,@"data", self.orderid, @"orderid", nil] height:40];
            SectionModel *section13 = [self createSectionModel:@[changeAddressModel] headerHeight:0.0001 footerHeight:0.0001];
            [self.tableDataArr addObject:section13];
        }
    }
    
    //分隔彩线
    CellModel *spaImageModel = [self createCellModel:[CKOrderSpaImageCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dict,@"data", nil] height:3];
    SectionModel *section14 = [self createSectionModel:@[spaImageModel] headerHeight:0.0001 footerHeight:10];
    [self.tableDataArr addObject:section14];
    //订单商品列表
    SCOrderDetailModel *orderDetailM = self.orderDetailArray.firstObject;
    
    for (SCOrderDetailGoodsModel *orderM in orderDetailM.itemlistArr) {
        
        CellModel *goodsModel = [self createCellModel:[CKGoodDetailCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:orderM,@"data", self.orderid, @"orderid", nil] height:[CKGoodDetailCell computeHeight:orderM]];
        SectionModel *section2 = [self createSectionModel:@[goodsModel] headerHeight:0.0001 footerHeight:0.0001];
        [self.tableDataArr addObject:section2];
    }
    
    //应付款信息
    CellModel *payInfoModel = [self createCellModel:[CKOrderPaymentCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dict,@"data", self.orderDetailModel.favormoney, @"favormoney", self.orderstatusString, @"orderStatus", self.orderDetailModel.money, @"money", self.orderDetailModel.ordermoney, @"orderMoney", nil] height:[CKOrderPaymentCell computeHeight:[NSDictionary dictionaryWithObjectsAndKeys: self.orderDetailModel.favormoney, @"favormoney", nil]]];
    SectionModel *section31 = [self createSectionModel:@[payInfoModel] headerHeight:0.0001 footerHeight:0.0001];
    [self.tableDataArr addObject:section31];
    //支付、物流信息
    CellModel *infoModel = [self createCellModel:[CKOrderInfoCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dict,@"data", self.orderDetailModel.orderfrom, @"orderfrom", self.orderDetailModel.balancemoney, @"balancemoney", nil] height:[CKOrderInfoCell computeHeight:[NSDictionary dictionaryWithObjectsAndKeys:dict,@"data", self.orderDetailModel.orderfrom, @"orderfrom", self.orderDetailModel.balancemoney, @"balancemoney", nil]]];
    SectionModel *section3 = [self createSectionModel:@[infoModel] headerHeight:10 footerHeight:10];
    [self.tableDataArr addObject:section3];
    //返积分信息
    self.integralnum = [NSString stringWithFormat:@"%@", dict[@"integralnum"]];
    if (!IsNilOrNull(self.integralnum) && [self.integralnum integerValue] > 0) {
        CellModel *pointModel = [self createCellModel:[SCReturnIntegralCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.integralnum, @"integralnum", nil] height:50];
        SectionModel *section4 = [self createSectionModel:@[pointModel] headerHeight:10 footerHeight:10];
        [self.tableDataArr addObject:section4];
    }
    
    [self.checkOrderTableView reloadData];
}

-(CellModel*)createCellModel:(Class)cls userInfo:(id)userInfo height:(CGFloat)height {
    CellModel *model = [[CellModel alloc] init];
    model.selectionStyle = UITableViewCellSelectionStyleNone;
    model.userInfo = userInfo;
    model.height = height;
    model.className = NSStringFromClass(cls);
    return model;
}

-(SectionModel*)createSectionModel:(NSArray<CellModel*>*)items headerHeight:(CGFloat)headerHeight footerHeight:(CGFloat)footerHeight {
    SectionModel *model = [SectionModel sectionModelWithTitle:nil cells:items];
    model.headerhHeight = headerHeight;
    model.footerHeight = footerHeight;
    return model;
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_tableDataArr){
        return _tableDataArr.count;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SectionModel *s = _tableDataArr[section];
    if(s.cells) {
        return s.cells.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionModel *s = _tableDataArr[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    
    SCOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:item.reuseIdentifier];
    if(!cell) {
        cell = [[NSClassFromString(item.className) alloc] initWithStyle:item.style reuseIdentifier:item.reuseIdentifier];
    }
    cell.selectionStyle = item.selectionStyle;
    cell.accessoryType = item.accessoryType;
    cell.delegate = item.delegate;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionModel *s = _tableDataArr[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    
    if(item.title) {
        cell.textLabel.text = item.title;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor colorWithRed:0.294 green:0.298 blue:0.302 alpha:1.00];
    }
    if(item.subTitle) {
        cell.detailTextLabel.text = item.subTitle;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.294 green:0.298 blue:0.302 alpha:1.00];
    }
    
    SEL selector = NSSelectorFromString(@"fillData:");
    if([cell respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
        [cell performSelector:selector withObject:item.userInfo];
#pragma clang diagnostic pop
    }
}

#pragma mark - tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionModel *s = _tableDataArr[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    return item.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SectionModel *s = _tableDataArr[section];
    return s.headerhHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    SectionModel *s = _tableDataArr[section];
    return s.footerHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if ([self.iftransno isEqualToString:@"false"] || [self.iftransno isEqualToString:@"0"] || IsNilOrNull(self.iftransno)) {

        }else{
            //点击进入物流详情
            CKCLogisticsDetailVC *detailLogist = [[CKCLogisticsDetailVC alloc] init];
            detailLogist.oidString = [NSString stringWithFormat:@"%@",self.orderid];
            [self.navigationController pushViewController:detailLogist animated:YES];
//            DetailLogisticsViewController *detailLogist = [[DetailLogisticsViewController alloc] init];
//            detailLogist.oidString = [NSString stringWithFormat:@"%@",self.orderid];;
//            [self.navigationController pushViewController:detailLogist animated:YES];
        }
    }
}

#pragma mark - 更新地址
-(void)reloadOrderWithNewAdress:(AddressModel*)addressModel {
    
    NSInteger index = 0;
    NSInteger getterIndex = 0;
    
    for (NSInteger i = 0; i < self.tableDataArr.count; i++) {
        SectionModel *section = self.tableDataArr[i];
        for (NSInteger j = 0; j < section.cells.count; j++) {
            CellModel *cell = section.cells[j];
            if ([cell.className isEqualToString:@"CKOrderGetterCell"]) {
                getterIndex = i;
            }
            if ([cell.className isEqualToString:@"CKOrderAddressCell"]) {
                index = i;
            }
        }
    }
    
    NSDictionary *getterDic = @{@"gettername": addressModel.name, @"gettermobile": addressModel.mobile};
    
    CellModel *getterModel = [self createCellModel:[CKOrderGetterCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:getterDic,@"data", nil] height:50];
    SectionModel *section11 = [self createSectionModel:@[getterModel] headerHeight:0.0001 footerHeight:0.0001];
    
    
    NSString *address = [NSString stringWithFormat:@"%@%@", addressModel.area, addressModel.address];
    
    CellModel *addressM = [self createCellModel:[CKOrderAddressCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:address,@"data", @"changed", @"type", nil] height:50*SCREEN_WIDTH/375.0f];
    SectionModel *section12 = [self createSectionModel:@[addressM] headerHeight:0.0001 footerHeight:0.0001];
    
    if (getterIndex != 0) {
        [self.tableDataArr replaceObjectAtIndex:getterIndex withObject:section11];
    }
    
    if (index != 0) {
        [self.tableDataArr replaceObjectAtIndex:index withObject:section12];
    }
    [self.checkOrderTableView reloadData];
}

#pragma mark - 隐藏更改地址按钮
-(void)hiddenChangeAddressBtn {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.tableDataArr.count; i++) {
        SectionModel *section = self.tableDataArr[i];
        for (NSInteger j = 0; j < section.cells.count; j++) {
            CellModel *cell = section.cells[j];
            if ([cell.className isEqualToString:@"CKOrderChangeAddressCell"]) {
                index = i;
            }
        }
    }
    
    if (index != 0) {
        [self.tableDataArr removeObjectAtIndex:index];
        [self.checkOrderTableView reloadData];
    }
}

#pragma mark - 创建底部按钮
- (void)createBottomView {
    
    if ([self.fromVC isEqualToString:@"PaySuccess"]) {
        [_checkOrderTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight);
            }else{
                make.top.equalTo(self.view.mas_top).offset(0);
            }
            
        }];
    }else{
        
        _footerView = [[OrderFooterView alloc] initWithFrame:CGRectZero andType:self.orderstatusString andHasTop:NO type:nil];
        
        [self.view addSubview:_footerView];
        _footerView.delegate = self;
        _footerView.backgroundColor = [UIColor whiteColor];
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
            make.height.mas_equalTo(50);
        }];
        
        [_checkOrderTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.bottom.equalTo(self.footerView.mas_top);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight);
            }else{
                make.top.equalTo(self.view.mas_top).offset(0);
            }
        }];
    }
}

-(void)leftButtonClick:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"取消订单"]) {
        [self cancelOrderWithOrderid];//未付款的可以取消
    }else if ([btn.titleLabel.text isEqualToString:@"删除订单"]) {
        [self confirmDeleteOrder];
    }else if ([btn.titleLabel.text isEqualToString:@"查看物流"]) {
        if ([self.iftransno isEqualToString:@"false"] || [self.iftransno isEqualToString:@"0"] || IsNilOrNull(self.iftransno)) {
            
        }else{
            //点击进入物流详情
            DetailLogisticsViewController *detailLogist = [[DetailLogisticsViewController alloc] init];
            detailLogist.oidString = [NSString stringWithFormat:@"%@",self.orderid];;
            [self.navigationController pushViewController:detailLogist animated:YES];
        }
    }
}

-(void)rightButtonClick:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"去付款"]) {
        [self payOrder];
    }else if ([btn.titleLabel.text isEqualToString:@"再次购买"]) {
        [self buyAgain];//再次购买
    }else if ([btn.titleLabel.text isEqualToString:@"联系客服"]) {
        [self contactCS];
    }else if ([btn.titleLabel.text isEqualToString:@"确认收货"]) {
        [self clickConfirmReceiveGoods];
    }else if ([btn.titleLabel.text isEqualToString:@"差价付款"]) {
        [self payOrder];
    }else if ([btn.titleLabel.text isEqualToString:@"删除订单"]) {
        [self confirmDeleteOrder];
    }
}

#pragma mark - 取消订单
-(void)cancelOrderWithOrderid {
    _deleteAlertView = [[XWAlterVeiw alloc] init];
    _deleteAlertView.delegate = self;
    _deleteAlertView.titleLable.text = @"确定取消该订单？";
    _deleteAlertView.type = @"取消订单";
    [_deleteAlertView show];
}

-(void)confirmDeleteOrder {
    _deleteAlertView = [[XWAlterVeiw alloc] init];
    _deleteAlertView.delegate = self;
    _deleteAlertView.titleLable.text = @"确定删除该订单？";
    _deleteAlertView.type = @"删除订单";
    [_deleteAlertView show];
}

#pragma mark - 再次购买，跳首页
-(void)buyAgain {
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 去付款
- (void)payOrder {
    SCOrderDetailModel *orderM = self.orderDetailArray.firstObject;
    SCPayViewController *payMoney = [[SCPayViewController alloc] init];
    payMoney.payfeeStr = [NSString stringWithFormat:@"%@", orderM.ordermoney];
    
    NSString *balancemoney = [NSString stringWithFormat:@"%@", self.orderModel.balancemoney];
    if (!IsNilOrNull(balancemoney) && [balancemoney doubleValue] > 0) {
        //补差价
        payMoney.money = balancemoney;
    }else{
        //实付款
        payMoney.money = [NSString stringWithFormat:@"%@", orderM.money];
    }
    
    payMoney.orderid = orderM.Id;
    NSString *orderNo = [NSString stringWithFormat:@"%@", orderM.no];
    if ([orderNo hasPrefix:@"ckdlb"]) {
        payMoney.isdlbitem = @"1";
    }
    [self.navigationController pushViewController:payMoney animated:YES];
}

#pragma mark - 删除订单
-(void)deleteOrder {
    NSDictionary *pramaDic = @{@"orderids": self.orderid};
    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, DelOrderUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:loveItemUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dic = json;
        NSString * status = [dic valueForKey:@"code"];
        if ([status intValue] != 200) {
            [self showNoticeView:[dic valueForKey:@"msg"]];
            return ;
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self showNoticeView:@"删除成功"];
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
-(void)contactCS {
    [[SobotManager shareInstance] startSobotCustomerService];
}

#pragma mark - 确认收货
-(void)clickConfirmReceiveGoods {
    _deleteAlertView = [[XWAlterVeiw alloc] init];
    _deleteAlertView.delegate = self;
    _deleteAlertView.titleLable.text = @"确定已经收到货物？";
    _deleteAlertView.type = @"确认收货";
    [_deleteAlertView show];
}

-(void)subuttonClicked {
    
    if ([_deleteAlertView.type isEqualToString:@"确认收货"]) {
        [self confirmReceiveGoods];
    }else if ([_deleteAlertView.type isEqualToString:@"取消订单"]) {
        [self confirmCancelOrder];
    }else if ([_deleteAlertView.type isEqualToString:@"删除订单"]) {
        [self deleteOrder];
    }
}

-(void)confirmCancelOrder {
    NSDictionary *pramaDic = @{@"orderid": self.orderid};
    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, CancelOrderUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:loveItemUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dic = json;
        NSString * status = [dic valueForKey:@"code"];
        if ([status intValue] != 200) {
            [self showNoticeView:[dic valueForKey:@"msg"]];
            return ;
        }
        [self showNoticeView:@"取消成功"];
        //取消成功后更新优惠券缓存
        [[SCCouponTools shareInstance] resquestValidCouponsData];
        
        NSString *predict = [NSString stringWithFormat:@"orderId = '%@'", self.orderid];
        RLMResults *result = [SCMyOrderModel objectsWhere:predict];
        RLMRealm *realm = [RLMRealm defaultRealm];
        if (result.count > 0) {
            [realm beginWriteTransaction];
            [realm deleteObject:result.firstObject];
            [realm commitWriteTransaction];
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

-(void)confirmReceiveGoods {
    
    [KUserdefaults setObject:@"ConfirmReceiveGoods" forKey:@"ConfirmReceiveGoods"];
    
    NSDictionary *pramaDic = @{@"orderid": self.orderid};
    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, ConfirmReceiveUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:loveItemUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dic = json;
        NSString * status = [dic valueForKey:@"code"];
        if ([status intValue] != 200) {
            [self showNoticeView:[dic valueForKey:@"msg"]];
            return ;
        }
        
        [self requestOrderDetailData];
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

-(BOOL)navigationShouldPopOnBackButton {
    if ([self.fromVC isEqualToString:@"PaySuccess"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

@end
