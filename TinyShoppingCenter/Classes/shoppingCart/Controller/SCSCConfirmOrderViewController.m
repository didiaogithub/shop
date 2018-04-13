//
//  SCSCConfirmOrderViewController.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/28.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCSCConfirmOrderViewController.h"
#import "AddressModel.h"
#import "SCShoppingCarConfirmOrderCell.h"
#import "MoneyCountView.h"  //底部合计与立即购买按钮
#import "ChangeMyAddressViewController.h"
#import "SCPayViewController.h"
#import "AddAddressTableViewCell.h"
#import "XWAlterVeiw.h"
#import "SCConfirmOrderAddressCell.h"
#import "SCUseCouponViewController.h"
#import "TopTipView.h"
#import "CKRealnameIdentifyView.h"

@interface SCSCConfirmOrderViewController ()<UITableViewDelegate, UITableViewDataSource, MoneyCountViewDelegate, AddAddressTableViewCellDelegate, SCConfirmOrderChooseCouponDelegate, TopTipViewDelegate>

@property (nonatomic, strong) MoneyCountView *moneyCountView;
@property (nonatomic, strong) UITableView *sureOrderTableView;
@property (nonatomic, strong) AddressModel *addressModel;
@property (nonatomic, copy)   NSString *oidStr;
@property (nonatomic, copy)   NSString *payfeeStr;

@property (nonatomic, copy)   NSString *coupontMoney;
@property (nonatomic, copy)   NSString *coupontId;
@property (nonatomic, copy)   NSString *coupontUsablecount;
@property (nonatomic, strong) TopTipView *tipView;
@property (nonatomic, strong) NSMutableArray *useableCouponArray;
@property (nonatomic, strong) NSMutableArray *unuseableCouponArray;

@end

@implementation SCSCConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单确认";
    
    [self createTableView];
    [self refreshAllPayMoney];
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:USER_DefaultAddress];
    AddressModel *addressModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (addressModel == nil) {
        [self requestDefaultAddress];
    }else{
        _addressModel = addressModel;
    }
    
    //请求可用的优惠券
    //[self requestCouponCanUse];
}

-(void)refreshAllPayMoney{
    _moneyCountView.allMoneyLable.text = [NSString stringWithFormat:@"%@", self.allMoneyString];
    
    //获取可用优惠券张数
    [self showUseableCouponCount:[NSString stringWithFormat:@"%@", self.allMoneyString]];
}

#pragma mark - TopTipViewDelegate
- (void)topTipView:(TopTipView *)topView closeTip:(UIButton *)btn {
    [self.tipView removeFromSuperview];
    [self.sureOrderTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(5+64+NaviAddHeight);
    }];
}

-(void)createTableView{
    NSString *payalertmsg = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"payalertmsg"]];
    CGSize s = [payalertmsg boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 87, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    _tipView = [[TopTipView alloc] initWithFrame:CGRectMake(0, 5+64+NaviAddHeight, SCREEN_WIDTH, s.height>=30 ? 14+s.height : 44)];
    _tipView.delegate = self;
    [self.view addSubview:_tipView];
    
    
    _moneyCountView = [[MoneyCountView alloc] init];
    _moneyCountView.delegate = self;
    _moneyCountView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_moneyCountView];
    [_moneyCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(50);
    }];
    
    _sureOrderTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_sureOrderTableView];
    _sureOrderTableView.backgroundColor = [UIColor tt_grayBgColor];
    
    self.sureOrderTableView.rowHeight = UITableViewAutomaticDimension;
    self.sureOrderTableView.estimatedRowHeight = 44;
    self.sureOrderTableView.estimatedSectionFooterHeight = 0;
    self.sureOrderTableView.estimatedSectionHeaderHeight = 0;
    _sureOrderTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _sureOrderTableView.delegate = self;
    _sureOrderTableView.dataSource = self;
    [self.sureOrderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(CGRectGetMaxY(_tipView.frame));
        make.left.right.mas_offset(0);
        make.bottom.equalTo(_moneyCountView.mas_top);
    }];
    
    if (IsNilOrNull(payalertmsg)) {
        [self.tipView removeFromSuperview];
        [self.sureOrderTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(5+64+NaviAddHeight);
        }];
    }else{
        self.tipView.tipLabel.text = payalertmsg;
        [self.sureOrderTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(CGRectGetMaxY(_tipView.frame));
        }];
    }
}

#pragma mark - 请求默认地址数据
-(void)requestDefaultAddress {
    
    NSString *getDefaultAddressUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetDefaultAddrUrl];
    NSDictionary *pramaDic = @{@"openid": USER_OPENID};
    [HttpTool getWithUrl:getDefaultAddressUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"msg"]];
            return ;
        }
        
        NSString *addrId = [NSString stringWithFormat:@"%@", dict[@"id"]];
        if (!IsNilOrNull(addrId)) {
            self.addressModel = [[AddressModel alloc] init];
            [self.addressModel setValuesForKeysWithDictionary:dict];
            [self.sureOrderTableView reloadData];
            
            NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
            NSString *filePath = [path stringByAppendingPathComponent:USER_DefaultAddress];
            [NSKeyedArchiver archiveRootObject:self.addressModel toFile:filePath];
        }
    } failure:^(NSError *error) {
        [self showNoticeView:@"网络出错了"];
    }];
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 2) {
        return 1;
    }else{
        return self.dataArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){//地址选择
        if (self.addressModel != nil) {
            SCConfirmOrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCConfirmOrderAddressCell"];
            if (cell  == nil) {
                cell = [[SCConfirmOrderAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCConfirmOrderAddressCell"];
            }
            [cell refreshWithAddressModel:self.addressModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor tt_grayBgColor];
            return cell;
        }else{
            AddAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddAddressTableViewCell"];
            if (cell  == nil) {
                cell = [[AddAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddAddressTableViewCell"];
            }
            cell.delegate = self;
            return cell;
        }
    }else if(indexPath.section == 1){//商品 名称  数量  价格
        SCShoppingCarConfirmOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCShoppingCarConfirmOrderCell"];
        if (cell == nil) {
            cell = [[SCShoppingCarConfirmOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCShoppingCarConfirmOrderCell"];
        }
        if ([self.dataArray count]) {
            self.goodOrderModel = [self.dataArray objectAtIndex:indexPath.row];
            [cell setModel:self.goodOrderModel];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        
        SCShoppingCarConfirmOrderOtherMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCShoppingCarConfirmOrderOtherMsgCell"];
        if (cell == nil) {
            cell = [[SCShoppingCarConfirmOrderOtherMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCShoppingCarConfirmOrderOtherMsgCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        [cell refreshCouponAndMoney:self.coupontMoney usablecount:self.coupontUsablecount];

        NSString *realMoney = [self.allMoneyString copy];
        //选择了优惠券要重新计算合计的金额
        if (IsNilOrNull(self.coupontMoney)) {
            realMoney = [self.allMoneyString copy];
        }else{
            //合计:¥xxx.xx
            NSArray *mArray = [realMoney componentsSeparatedByString:@"¥"];
            realMoney = [NSString stringWithFormat:@"%@¥%.2f", mArray.firstObject, [mArray.lastObject doubleValue] - [self.coupontMoney doubleValue]];
        }
        
        _moneyCountView.allMoneyLable.text = [NSString stringWithFormat:@"%@", realMoney];
        
        
        NSMutableArray *temp = [NSMutableArray array];
        for (GoodModel *goodModel in self.dataArray) {
            [temp addObject:[NSString stringWithFormat:@"%@", goodModel.count]];
        }
        NSInteger sum = 0;
        for (NSString *count in temp) {
            sum += [count integerValue];
        }
        
        [cell refreshCellWithCount:sum money:realMoney];
        
        //[cell refreshCouponAndMoney:self.coupontMoney usablecount:self.coupontUsablecount];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        ChangeMyAddressViewController *address = [[ChangeMyAddressViewController alloc] init];
        [address setAddressBlock:^(AddressModel *addressModel) {
            self.addressModel = addressModel;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.sureOrderTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        address.pushString = @"1";  //从确认订单跳过去
        [self.navigationController pushViewController:address animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

/**没有默认地址时点击跳转*/
-(void)clickToAddressVC{
    ChangeMyAddressViewController *address = [[ChangeMyAddressViewController alloc] init];
    [address setAddressBlock:^(AddressModel *addressModel) {
        self.addressModel = addressModel;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.sureOrderTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    address.pushString = @"1";  //从确认订单跳过去
    [self.navigationController pushViewController:address animated:YES];
}

/**点击立即购买 跳转按钮*/
-(void)moneyCountViewButtonClicked{
    
    if (IsNilOrNull(self.addressModel.ID)) {
        [self showNoticeView:@"请添加收货地址"];
        self.moneyCountView.nowToBuyButton.enabled = YES;
        return;
    }

    BOOL isNeedRealName = NO;
    for (GoodModel *goodModel in self.dataArray) {
        if ([goodModel.isoversea isEqualToString:@"1"]) {
            isNeedRealName = YES;
            break;
        }
    }
    
    if (isNeedRealName) {
        [self realNameIdentify];
    }else{
        [self prepareSubmitOrder];
    }
  
}


#pragma mark - 检测当前收货人是否实名认证（海外购的需要）
- (void)realNameIdentify {
    
    NSString *gettername = [NSString stringWithFormat:@"%@", self.addressModel.name];
    NSString *addressID = [NSString stringWithFormat:@"%@",self.addressModel.ID];
    NSDictionary *params = @{@"addressid":addressID};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI,GetRealName];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:requestUrl params:params success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:dict[@"codeinfo"]];
            [self.loadingView stopAnimation];
            return ;
        }
        
        CKRealnameIdentifyView *real = [[CKRealnameIdentifyView alloc] init];
        //如已实名认证，则返回idcardno，未实名认证返回空
        NSString *idcardno = [NSString stringWithFormat:@"%@", dict[@"idcardno"]];
        if (IsNilOrNull(idcardno)) {
            idcardno = @"";
            real.operationName = @"提交";
        }else{
            if (idcardno.length > 4) {
                if (![idcardno containsString:@"******"]) {
                    [KUserdefaults setObject:idcardno forKey:@"idcardno"];
                    [KUserdefaults synchronize];
                }
                NSString *prefixStr = [idcardno substringToIndex:3];
                NSString *subStr = [idcardno substringFromIndex:idcardno.length - 4];
                NSString *finalStr = [NSString stringWithFormat:@"%@***********%@", prefixStr, subStr];
                idcardno = finalStr;
                
            }
            real.operationName = @"确认";
        }
        
        __weak typeof(self) weakSelf = self;
        [real showAlert:gettername idNo:idcardno textFieldText:^(NSString *name, NSString *idNo) {
            NSLog(@"%@---%@", name, idNo);
            
            if (![idNo containsString:@"******"]) {
                [KUserdefaults setObject:idNo forKey:@"idcardno"];
                [KUserdefaults synchronize];
            }
            if (IsNilOrNull(name)) {
                [weakSelf showNoticeView:@"请输入收件人姓名"];
                return;
            }
            
            if (IsNilOrNull(idNo)) {
                [weakSelf showNoticeView:@"请输入收件人身份证号码"];
                return;
            }
            if ([idNo containsString:@"******"]) {
                idNo  =  [KUserdefaults objectForKey:@"idcardno"];
            }
            
            
            [weakSelf submitRealnameIdentify:name idcardNO:idNo addressID:addressID];
        }];
        

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

#pragma mark - 提交实名认证
- (void)submitRealnameIdentify:(NSString*)realName idcardNO:(NSString*)idcardno  addressID:(NSString *)addressid{
    NSDictionary *params = @{@"openid":USER_OPENID, @"realname":realName, @"idcardno":idcardno,@"addressid":addressid};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, AddRealName];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:requestUrl params:params success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:dict[@"codeinfo"]];
            [self.loadingView stopAnimation];
            return ;
        }
        
        _addressModel.name = realName;
        [self.sureOrderTableView reloadData];
        //认证成功后再提交订单
        [self.loadingView startAnimation];
        [self prepareSubmitOrder];
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *filePath = [path stringByAppendingPathComponent:USER_DefaultAddress];
        [NSKeyedArchiver archiveRootObject:self.addressModel toFile:filePath];
        
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

- (void)prepareSubmitOrder{
    NSString *addressId = nil;
    
    NSString *defaultAddressId = [NSString stringWithFormat:@"%@",self.addressModel.ID];
    
    addressId = defaultAddressId;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:USER_OPENID forKey:@"openid"];
    [parameters setObject:addressId forKey:@"addressid"];
    if (!IsNilOrNull(self.coupontId)) {
        [parameters setObject:self.coupontId forKey:@"couponsid"];//优惠券id
    }
    
    NSString *itemCarOrderUrl =  [NSString stringWithFormat:@"%@%@", WebServiceAPI, ShoppingCarAddOrderUrl];
    
    [self canPayGoodsRequestWithUrl:itemCarOrderUrl pramaDic:parameters];
    [self.loadingView stopAnimation];
}



#pragma mark - 选择好可以支付的商品 先生成订单  再去支付
-(void)canPayGoodsRequestWithUrl:(NSString *)orderUrl pramaDic:(NSDictionary *)pramaDic{
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    self.moneyCountView.nowToBuyButton.enabled = NO;
    NSDate *startDate = [NSDate date];
    
    [HttpTool postWithUrl:orderUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSTimeInterval interval =  [[NSDate date] timeIntervalSinceDate:startDate];
        [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:interval];//防止重复点击
        
        NSDictionary *dict = json;
        if ([dict[@"code"] intValue] != 200) {
            [self showNoticeView:dict[@"msg"]];
            return ;
        }
        
        self.oidStr = [NSString stringWithFormat:@"%@",dict[@"orderid"]];
        
        if (IsNilOrNull(self.oidStr)){
            self.oidStr = @"";
        }
        
        RLMResults *result = [GoodModel allObjects];
        RLMRealm *realm = [RLMRealm defaultRealm];
        if (result.count > 0) {
            [realm beginWriteTransaction];
            [realm deleteObjects:result];
            [realm commitWriteTransaction];
        }
        
        
        [KUserdefaults setObject:@"ConfirmOrderRefreshShoppingCar" forKey:@"CKYS_RefreshCar"];
        
        [[SCCouponTools shareInstance] deleteUsedCoupon:self.coupontId];
        
        SCPayViewController *payMoney = [[SCPayViewController alloc] init];
        payMoney.payfeeStr = [self.moneyCountView.allMoneyLable.text componentsSeparatedByString:@"¥"].lastObject;
        payMoney.orderid = self.oidStr;
        payMoney.enterType = @"shoppingCar";
        [self.navigationController pushViewController:payMoney animated:YES];
        
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        NSTimeInterval interval =  [[NSDate date] timeIntervalSinceDate:startDate];
        [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:interval];//防止重复点击
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

-(void)changeButtonStatus{
    self.moneyCountView.nowToBuyButton.enabled =YES;
}

#pragma mark - 优惠券相关
-(void)shoppingCarConfirmOrderChooseCoupon {
    SCUseCouponViewController *useCoupon = [[SCUseCouponViewController alloc] init];
    __weak typeof(self) wSelf = self;
    [useCoupon setCouponBlock:^(NSString *price, NSString *couponId) {
        NSLog(@"price:%@, couponId:%@", price, couponId);
        wSelf.coupontMoney = price;
        wSelf.coupontId = couponId;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        [wSelf.sureOrderTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    NSMutableArray *goodsIdArray = [NSMutableArray array];
    for (GoodModel *goodsM in self.dataArray) {
        [goodsIdArray addObject:[NSString stringWithFormat:@"%@", goodsM.itemid]];
    }
    useCoupon.goodsIdArray = goodsIdArray;
    useCoupon.orderMoney = [_moneyCountView.allMoneyLable.text componentsSeparatedByString:@"¥"].lastObject;
    //将当前请求的优惠券数据传到列表页面，如果没有则请求
    useCoupon.params = [self createCouponParametersWithType:@"1"];
    useCoupon.useabelCouponArray = [NSMutableArray arrayWithArray:self.useableCouponArray];
    useCoupon.unuseabelCouponArray = [NSMutableArray arrayWithArray:self.unuseableCouponArray];
    useCoupon.couponId = self.coupontId;
    useCoupon.coupontMoney = self.coupontMoney;
    [self.navigationController pushViewController:useCoupon animated:YES];
}

-(NSMutableDictionary*)createCouponParametersWithType:(NSString*)type {
    
    NSMutableArray *orderinfo = [NSMutableArray array];
    for (GoodModel *goodsM in self.dataArray) {
        NSDictionary *dic = @{@"id":goodsM.itemid, @"num":goodsM.count};
        [orderinfo addObject:dic];
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:USER_OPENID forKey:@"openid"];
    [parameters setObject:[orderinfo mj_JSONString] forKey:@"item"];
    [parameters setObject:type forKey:@"type"];//类型：1.可用优惠券，2.不可用优惠券；默认为1
    return parameters;
}

- (void)showUseableCouponCount:(NSString *)orderMoney {
    NSArray *myCoupons = [[XNArchiverManager shareInstance] xnUnarchiverObject:KMyCouponList];
    if (myCoupons.count > 0) {
        NSMutableArray *goodsIdArray = [NSMutableArray array];
        for (GoodModel *goodsM in self.dataArray) {
            [goodsIdArray addObject:[NSString stringWithFormat:@"%@", goodsM.itemid]];
        }
        NSArray *canUseArray = [[SCCouponTools shareInstance] showCoupons:goodsIdArray orderMoney:orderMoney canUse:YES];
        self.useableCouponArray = [NSMutableArray arrayWithArray:canUseArray];
        self.coupontUsablecount = [NSString stringWithFormat:@"%ld", canUseArray.count];

        NSArray *canNotUseArray = [[SCCouponTools shareInstance] showCoupons:goodsIdArray orderMoney:orderMoney canUse:NO];
        self.unuseableCouponArray = [NSMutableArray arrayWithArray:canNotUseArray];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        [self.sureOrderTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        //请求可用的优惠券
//        [self requestCouponCanUse];
    }
}


//- (void)requestCouponCanUse {
//
//    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetCanUseCoupons];
//
//    [HttpTool postWithUrl:requestUrl params:[self createCouponParametersWithType:@"1"] success:^(id json) {
//        NSDictionary *dict = json;
//        if ([dict[@"code"] integerValue] != 200) {
//            [self showNoticeView:dict[@"msg"]];
//            return ;
//        }
//        NSArray *list = dict[@"list"];
//        self.useableCouponArray = [NSMutableArray arrayWithArray:list];
//
//        self.coupontUsablecount = [NSString stringWithFormat:@"%@", dict[@"usablecount"]];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
//        [self.sureOrderTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    } failure:^(NSError *error) {
//
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
