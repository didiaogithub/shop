//
//  SCConfirmOrderVC.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCConfirmOrderVC.h"
#import "AddressModel.h"
#import "MoneyCountView.h"  //底部合计与立即购买按钮
#import "AddAddressViewController.h"
#import "ChangeMyAddressViewController.h"
#import "SCPayViewController.h"
#import "AddAddressTableViewCell.h"
#import "SCGoodsDetailConfirmOrderCell.h"
#import "SCShoppingCarConfirmOrderCell.h"
#import "SCConfirmOrderAddressCell.h"
#import "SCUseCouponViewController.h"
#import "TopTipView.h"
#import "CKRealnameIdentifyView.h"
@interface SCConfirmOrderVC ()<UITableViewDelegate,UITableViewDataSource,MoneyCountViewDelegate,AddAddressTableViewCellDelegate, GDConfirmOrderChooseCouponDelegate, TopTipViewDelegate>

@property (nonatomic, strong) MoneyCountView *moneyCountView;
@property (nonatomic, strong) UITableView *sureOrderTableView;
@property (nonatomic, strong) AddressModel *addressModel;
@property (nonatomic, strong) UIButton *selectedAddressButton;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, copy)   NSString *oidStr;
@property (nonatomic, copy)   NSString *buyCount;
@property (nonatomic, copy)   NSString *coupontMoney;
@property (nonatomic, copy)   NSString *coupontId;
@property (nonatomic, copy)   NSString *coupontUsablecount;
@property (nonatomic, strong) NSMutableArray *useableCouponArray;
@property (nonatomic, strong) NSMutableArray *unuseableCouponArray;
@property (nonatomic, strong) TopTipView *tipView;

@property (nonatomic, assign) BOOL exitPay;


@end

@implementation SCConfirmOrderVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.exitPay) {
        self.coupontMoney = @"";
        self.coupontId = @"";
        [self refreshAllPayMoney];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单确认";
    self.buyCount = @"1";
    self.exitPay = NO;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTotalMoney:) name:@"GDConfrimOrderChangeBuyCount" object:nil];
}

#pragma mark - 点击加减号
-(void)changeTotalMoney:(NSNotification*)userInfo {
    NSDictionary *buyCountDic = userInfo.userInfo;
    NSString *count = [NSString stringWithFormat:@"%@", buyCountDic[@"BuyCount"]];
    self.buyCount = count;
    NSString *money = [NSString stringWithFormat:@"%@", self.goodsDict[@"salesprice"]];
    if (IsNilOrNull(money)) {
        money = @"0";
    }
    
    double totalMoney = [money doubleValue] * [count integerValue];
    _moneyCountView.allMoneyLable.text = [NSString stringWithFormat:@"合计:¥%.2f", totalMoney];
    
    //获取可用优惠券张数
    [self showUseableCouponCount:[NSString stringWithFormat:@"%.2f", totalMoney]];
    
}

-(void)refreshAllPayMoney {
    
    NSString *salePrice = [NSString stringWithFormat:@"%@", self.goodsDict[@"salesprice"]];
    if (IsNilOrNull(salePrice)) {
        salePrice = @"0.00";
    }
    if (!IsNilOrNull(self.coupontMoney)) {
        salePrice = [NSString stringWithFormat:@"%.2f", [salePrice doubleValue] - [self.coupontMoney doubleValue]];
    }
    _moneyCountView.allMoneyLable.text = [NSString stringWithFormat:@"合计:¥%@", salePrice];
    
    //获取可用优惠券张数
    [self showUseableCouponCount:salePrice];
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
    
    _sureOrderTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_sureOrderTableView];
    _sureOrderTableView.backgroundColor = [UIColor tt_grayBgColor];
    _sureOrderTableView.estimatedRowHeight = 44;
    _sureOrderTableView.estimatedSectionHeaderHeight = 0;
    _sureOrderTableView.estimatedSectionFooterHeight = 0;
    _sureOrderTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _sureOrderTableView.delegate  = self;
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

#pragma mark - TopTipViewDelegate
- (void)topTipView:(TopTipView *)topView closeTip:(UIButton *)btn {
    [self.tipView removeFromSuperview];
    [self.sureOrderTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(5+64+NaviAddHeight);
    }];
}

#pragma mark - 请求默认地址数据
-(void)requestDefaultAddress {

    NSString *getDefaultAddressUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetDefaultAddrUrl];
    NSDictionary *pramaDic = @{@"openid": USER_OPENID};
    [HttpTool getWithUrl:getDefaultAddressUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"msg"]];
            return;
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
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark-tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        SCGoodsDetailConfirmOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCGoodsDetailConfirmOrderCell"];
        if (cell == nil) {
            cell = [[SCGoodsDetailConfirmOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCGoodsDetailConfirmOrderCell"];
        }
        
        [cell refreshCellWithGoodsDict:self.goodsDict limitnum:self.limitnum];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else{
        SCConfirmOrderOtherMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCConfirmOrderOtherMsgCell"];
        if (cell == nil) {
            cell = [[SCConfirmOrderOtherMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCConfirmOrderOtherMsgCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        //选择优惠券后显示优惠金额
        [cell refreshCouponAndMoney:self.coupontMoney usablecount:self.coupontUsablecount];
        
        NSString *money = [NSString stringWithFormat:@"%@", self.goodsDict[@"salesprice"]];
        if (IsNilOrNull(money)) {
            money = @"0.00";
        }else{
            money = [NSString stringWithFormat:@"%.2f", [money doubleValue]*[self.buyCount integerValue]];
        }
        
        //选择了优惠券要重新计算合计的金额
        if (!IsNilOrNull(self.coupontMoney)) {
            money = [NSString stringWithFormat:@"%.2f", [money doubleValue] - [self.coupontMoney doubleValue]];
        }
        
        cell.goodsDict = self.goodsDict;
        [cell setDict:self.goodsDict];
        [cell refreshCellWithCount:[self.buyCount integerValue] money:money];
        
        _moneyCountView.allMoneyLable.text = [NSString stringWithFormat:@"合计:¥%@", money];
        
        NSString *isIntegral = [NSString stringWithFormat:@"%@", self.goodsDict[@"isIntegral"]];
        if ([isIntegral isEqualToString:@"1"] || [isIntegral isEqualToString:@"true"]) {
            NSString *integral = [NSString stringWithFormat:@"%@", self.goodsDict[@"integral"]];
            if (IsNilOrNull(integral)) {
                money = @"0";
            }
            [cell refreshIntegralCellWithIntegral:integral];
        }
        
        
        
        return cell;
    }
}

#pragma mark - 请求默认地址
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

#pragma mark - 点击提交订单
-(void)moneyCountViewButtonClicked {
    if(self.addressModel == nil){
        [self showNoticeView:@"请选择收货地址"];
        self.moneyCountView.nowToBuyButton.enabled = YES;
        return;
    }
    // 判断是不是海外商品
    NSString *isoversea = [NSString stringWithFormat:@"%@",self.goodsDict[@"isoversea"]];
    if (!IsNilOrNull(isoversea)) {
        if ([isoversea isEqualToString:@"1"]) {
            [self realNameIdentify];
        }else{
            [self prepareSubmitOrder];
        }
    }
}


- (void)prepareSubmitOrder{
    NSString *itemid = [NSString stringWithFormat:@"%@", self.goodsDict[@"itemid"]];
    NSString *addressId = nil;
    NSString *defaultAddressId = [NSString stringWithFormat:@"%@",self.addressModel.ID];
    addressId = defaultAddressId;
    if (!IsNilOrNull(self.activeId)) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:USER_OPENID forKey:@"openid"];
        [parameters setObject:addressId forKey:@"addressid"];
        [parameters setObject:itemid forKey:@"itemid"];
        [parameters setObject:self.buyCount forKey:@"buynum"];
        [parameters setObject:self.activeId forKey:@"activityid"];
        
        NSString *itemCarOrderUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, AddActiveOrderUrl];
        [self canPayGoodsRequestWithUrl:itemCarOrderUrl pramaDic:parameters];
        
    }else{
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:USER_OPENID forKey:@"openid"];
        [parameters setObject:addressId forKey:@"addressid"];
        [parameters setObject:itemid forKey:@"itemids"];
        [parameters setObject:self.buyCount forKey:@"buynum"];
        
        
        NSString *itemCarOrderUrl = @"";
        
        NSString *isIntegral = [NSString stringWithFormat:@"%@", self.goodsDict[@"isIntegral"]];
        if ([isIntegral isEqualToString:@"1"] || [isIntegral isEqualToString:@"true"]) {
            itemCarOrderUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, IntegralGoodsAddOrderUrl];
        }else{
            if (IsNilOrNull(self.coupontId)) {
                self.coupontId = @"0";
            }
            [parameters setObject:self.coupontId forKey:@"couponsid"];
            itemCarOrderUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, AddOrderUrl];
        }
        [self canPayGoodsRequestWithUrl:itemCarOrderUrl pramaDic:parameters];
    }
}

#pragma mark - 检测当前收货人是否实名认证（海外购的需要）
- (void)realNameIdentify {
    
    NSString *gettername = [NSString stringWithFormat:@"%@", self.addressModel.name];
    NSString *addressID = [NSString stringWithFormat:@"%@",self.addressModel.ID];
    NSDictionary *params = @{@"addressid":addressID};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetRealName];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    self.moneyCountView.nowToBuyButton.enabled = YES;
    
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
        
        self.addressModel.name = realName;
        [self.sureOrderTableView reloadData];
        
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *filePath = [path stringByAppendingPathComponent:USER_DefaultAddress];
        [NSKeyedArchiver archiveRootObject:self.addressModel toFile:filePath];
        //认证成功后再提交订单
        [self prepareSubmitOrder];
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

#pragma mark - 选择好可以支付的商品 先生成订单  再去支付
-(void)canPayGoodsRequestWithUrl:(NSString *)orderUrl pramaDic:(NSDictionary *)pramaDic{
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    self.moneyCountView.nowToBuyButton.enabled = NO;
    NSDate *startDate = [NSDate date];
    
    //type-1:立即购买,type-2:购物车下单，如果从购物车下单
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
        
        NSString *payAmount = [self.moneyCountView.allMoneyLable.text componentsSeparatedByString:@"¥"].lastObject;
        //支付的金额大于0才跳转支付界面
        if ([payAmount doubleValue] > 0) {
            [[SCCouponTools shareInstance] deleteUsedCoupon:self.coupontId];
            
            self.exitPay = YES;
            //成功之后  生成 总金额 和订单 去支付
            SCPayViewController *payMoney = [[SCPayViewController alloc] init];
            payMoney.payfeeStr = [self.moneyCountView.allMoneyLable.text componentsSeparatedByString:@"¥"].lastObject;
            payMoney.orderid = self.oidStr;
            payMoney.isdlbitem = self.isdlbitem;
            [self.navigationController pushViewController:payMoney animated:YES];
        }else{
            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"亲，您已下单成功！" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alertVC addAction:action];
            UIViewController * vc = [[UIApplication sharedApplication].keyWindow rootViewController];
            [vc presentViewController:alertVC animated:YES completion:nil];
        }
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
    self.moneyCountView.nowToBuyButton.enabled = YES;
}

#pragma mark - 优惠券相关
#pragma mark - 使用优惠券delegate
- (void)goodsDetailConfirmOrderChooseCoupon {
    SCUseCouponViewController *useCoupon = [[SCUseCouponViewController alloc] init];
    __weak typeof(self) wSelf = self;
    [useCoupon setCouponBlock:^(NSString *price, NSString *couponId) {
        NSLog(@"price:%@, couponId:%@", price, couponId);
        wSelf.coupontMoney = price;
        wSelf.coupontId = couponId;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        [wSelf.sureOrderTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    self.exitPay = NO;
    
    NSString *itemid = [NSString stringWithFormat:@"%@", self.goodsDict[@"itemid"]];
    useCoupon.goodsIdArray = @[itemid];
    useCoupon.orderMoney = [_moneyCountView.allMoneyLable.text componentsSeparatedByString:@"¥"].lastObject;
    //将当前请求的优惠券数据传到列表页面，如果没有则请求
    useCoupon.params = [self createCouponParametersWithType:@"1"];
    useCoupon.useabelCouponArray = [NSMutableArray arrayWithArray:self.useableCouponArray];
    useCoupon.unuseabelCouponArray = [NSMutableArray arrayWithArray:self.unuseableCouponArray];
    useCoupon.couponId = self.coupontId;
    useCoupon.coupontMoney = self.coupontMoney;
    [self.navigationController pushViewController:useCoupon animated:YES];
}

- (NSMutableDictionary*)createCouponParametersWithType:(NSString*)type {
    
    NSString *itemid = [NSString stringWithFormat:@"%@", self.goodsDict[@"itemid"]];
    NSMutableArray *orderinfo = [NSMutableArray array];
    NSDictionary *dic = @{@"id":itemid, @"num":self.buyCount};
    [orderinfo addObject:dic];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:USER_OPENID forKey:@"openid"];
    [parameters setObject:[orderinfo mj_JSONString] forKey:@"item"];
    [parameters setObject:type forKey:@"type"];//类型：1.可用优惠券，2.不可用优惠券；默认为1
    return parameters;
}

- (void)showUseableCouponCount:(NSString *)orderMoney {
    NSArray *myCoupons = [[XNArchiverManager shareInstance] xnUnarchiverObject:KMyCouponList];
    if (myCoupons.count > 0) {
        NSString *itemid = [NSString stringWithFormat:@"%@", self.goodsDict[@"itemid"]];
        
        NSArray *canUseArray = [[SCCouponTools shareInstance] showCoupons:@[itemid] orderMoney:orderMoney canUse:YES];
        self.useableCouponArray = [NSMutableArray arrayWithArray:canUseArray];
        self.coupontUsablecount = [NSString stringWithFormat:@"%ld", canUseArray.count];
        
        NSArray *canNotUseArray = [[SCCouponTools shareInstance] showCoupons:@[itemid] orderMoney:orderMoney canUse:NO];
        self.unuseableCouponArray = [NSMutableArray arrayWithArray:canNotUseArray];
        
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        [self.sureOrderTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        //请求可用的优惠券
//        [self requestCouponCanUse];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        [self.sureOrderTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)requestCouponCanUse {
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetCanUseCoupons];
    
    [HttpTool postWithUrl:requestUrl params:[self createCouponParametersWithType:@"1"] success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"msg"]];
            return ;
        }
        NSArray *list = dict[@"list"];
        self.useableCouponArray = [NSMutableArray arrayWithArray:list];
        
        self.coupontUsablecount = [NSString stringWithFormat:@"%@", dict[@"usablecount"]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        [self.sureOrderTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSError *error) {
        
    }];
}




@end
