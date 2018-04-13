//
//  SCPayViewController.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCPayViewController.h"
#import "SCPaymentTableCell.h"
#import "SCPayMoneyTableCell.h"
#import "WXApi.h" //微信SDK头文件
#import <AlipaySDK/AlipaySDK.h> //支付宝头文件
#import "UPPaymentControl.h"
#import "UIViewController+BackButtonHandler.h"
#import "XWAlterVeiw.h"
#import "PaySuccessViewController.h"
#import "TopTipView.h"
#import "JDPAuthSDK.h" //京东支付
#import "FFWarnAlertView.h"

/**京东支付~*/
#define JionPay_JD @"pay/appmall_pay/jdpay/action/app.php"

@interface SCPayViewController ()<UITableViewDelegate, UITableViewDataSource, XWAlterVeiwDelegate, TopTipViewDelegate>


@property (nonatomic, copy) NSString *ckAllPayMoney;
@property (nonatomic, copy) NSString *fxAllPayMoney;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *moneystring;
@property (nonatomic, copy) NSString *selectedType;
@property (nonatomic, strong) NSIndexPath *selIndex;//单选，当前选中的行
@property (nonatomic, strong) UITableView *paymentTableView;
@property (nonatomic, strong) NSMutableArray *payMethodArr;
@property (nonatomic, strong) NSMutableArray *summaryItems;
@property (nonatomic, strong) NSMutableArray *shippingMethods;
@property (nonatomic, strong) XWAlterVeiw *alertView;
@property (nonatomic, strong) TopTipView *tipView;


@end

@implementation SCPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeComponent];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.loadingView stopAnimation];
}

-(void)initializeComponent {
    
    self.navigationItem.title = @"支付订单";
    
    // 注册微信支付结果通知
    [CKCNotificationCenter addObserver:self selector:@selector(weixinPayCallBack:) name:WeiXinPay_CallBack object:nil];
    // 注册支付宝支付结果通知
    [CKCNotificationCenter addObserver:self selector:@selector(aliPayCallBack:) name:Alipay_CallBack object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(UUPay:) name:UnionPay_CallBack object:nil];
    
    if (!IsNilOrNull(self.money)) {
        self.payfeeStr = self.money;
    }
    
    
    [self createTableView];
    
    
    /**获取加盟需要支付的总金额和可用的支付方式*/
    [self getPayMethod];
    
    
}


-(void)getPayMethod {
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, PayMethodUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:requestUrl params:nil success:^(id json) {
        [self.loadingView stopAnimation];
        
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:dict[@"codeinfo"]];
            [_payMethodArr removeAllObjects];
            _payMethodArr = [NSMutableArray arrayWithArray:[[DefaultValue shareInstance] getAvailablePaymentMethod]];
            [self.paymentTableView reloadData];
            return ;
        }
        
        NSString *coupontime = [NSString stringWithFormat:@"%@", dict[@"coupontime"]];
        if (IsNilOrNull(coupontime)) {
            coupontime = @"600";
        }
        [KUserdefaults setObject:coupontime forKey:@"YDSC_coupontime"];
        
        NSString *couponbgurl = [NSString stringWithFormat:@"%@", dict[@"couponbgurl"]];
        if (IsNilOrNull(couponbgurl)) {
            couponbgurl = @"";
        }
        [KUserdefaults setObject:couponbgurl forKey:@"YDSC_couponbgurl"];
        
        
        
        NSString *payalertmsg = [NSString stringWithFormat:@"%@", dict[@"payalertmsg"]];
        if (IsNilOrNull(payalertmsg)) {
            payalertmsg = @"";
        }
        [KUserdefaults setObject:payalertmsg forKey:@"payalertmsg"];
        
        NSString *appmallverinfo = [dict objectForKey:@"appmallverinfo"];
        if (!IsNilOrNull(appmallverinfo)) {
            [KUserdefaults setObject:appmallverinfo forKey:@"YDSC_updateInfo"];
        }
        
        //是否显示积分商城
        NSString *mallintegralshow = [dict objectForKey:@"mallintegralshow"];
        if (!IsNilOrNull(mallintegralshow)) {
            [KUserdefaults setObject:mallintegralshow forKey:MallintegralShowOrNot];
        }
        
        //是否显示消息中心
        NSString *appmallmsg = [dict objectForKey:@"appmallmsg"];
        if (!IsNilOrNull(appmallmsg)) {
            [KUserdefaults setObject:appmallmsg forKey:@"YDSC_msgShow"];
        }
        
        NSString *ckappdownloadmsg = [dict objectForKey:@"ckappdownloadmsg"];
        if (!IsNilOrNull(ckappdownloadmsg)) {
            [KUserdefaults setObject:ckappdownloadmsg forKey:@"BecomeCKMsg"];
        }
        [KUserdefaults synchronize];
        
        [self updatePaymentMethod:dict];
        [_payMethodArr removeAllObjects];
        _payMethodArr = [NSMutableArray arrayWithArray:[[DefaultValue shareInstance] getAvailablePaymentMethod]];
        [self.paymentTableView reloadData];
        
        [self updateDomain:dict];
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        [_payMethodArr removeAllObjects];
        _payMethodArr = [NSMutableArray arrayWithArray:[[DefaultValue shareInstance] getAvailablePaymentMethod]];
        [self.paymentTableView reloadData];
    }];
}

-(void)updatePaymentMethod:(NSDictionary*)dict {
    
    NSString *alipay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"alipay"]];
    if (!IsNilOrNull(alipay)) {
        [[DefaultValue shareInstance] paymentAvaliable:alipay forKey:@"alipay"];
    }
    NSString *wxpay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"wxpay"]];
    if (!IsNilOrNull(wxpay)) {
        [[DefaultValue shareInstance] paymentAvaliable:wxpay forKey:@"wxpay"];
    }
    NSString *unionpay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"unionpay"]];
    if (!IsNilOrNull(unionpay)) {
        [[DefaultValue shareInstance] paymentAvaliable:unionpay forKey:@"unionpay"];
    }
    NSString *applepay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"applepay"]];
    if (!IsNilOrNull(applepay)) {
        [[DefaultValue shareInstance] paymentAvaliable:applepay forKey:@"applepay"];
    }
    
    NSString *jdpay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"jdpay"]];
    if (!IsNilOrNull(jdpay)) {
        [[DefaultValue shareInstance] paymentAvaliable:jdpay forKey:@"jdpay"];
    }
}

-(void)createTableView{
    //创建底部的支付按钮
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:payButton];
    [payButton setTitle:@"去支付" forState:UIControlStateNormal];
    payButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payButton.backgroundColor = [UIColor tt_redMoneyColor];
    payButton.layer.cornerRadius = 3.0;
    payButton.layer.masksToBounds = YES;
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.bottom.mas_offset(-10-BOTTOM_BAR_HEIGHT);
        make.height.mas_offset(44);
    }];
    
    [payButton addTarget:self action:@selector(clickPayButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSString *payalertmsg = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"payalertmsg"]];
    CGSize s = [payalertmsg boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 87, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    _tipView = [[TopTipView alloc] initWithFrame:CGRectMake(0, 5+64+NaviAddHeight, SCREEN_WIDTH, s.height>=30 ? 14+s.height : 44)];    _tipView.delegate = self;
    [self.view addSubview:_tipView];
    
    _paymentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];//CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-NaviAddHeight-BOTTOM_BAR_HEIGHT)
    _paymentTableView.delegate  = self;
    _paymentTableView.dataSource = self;
    _paymentTableView.backgroundColor = [UIColor whiteColor];
    _paymentTableView.rowHeight = UITableViewAutomaticDimension;
    _paymentTableView.estimatedRowHeight = 44;
    if (@available(iOS 11.0, *)) {
        _paymentTableView.estimatedSectionFooterHeight = 0.001;
        _paymentTableView.estimatedSectionHeaderHeight = 0.001;
    }
    _paymentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_paymentTableView];
    [_paymentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(CGRectGetMaxY(_tipView.frame));
        make.left.right.mas_offset(0);
        make.bottom.equalTo(payButton.mas_top);
    }];
    
    if (IsNilOrNull(payalertmsg)) {
        [self.tipView removeFromSuperview];
        [_paymentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight);
        }];
    }else{
        self.tipView.tipLabel.text = payalertmsg;
        [_paymentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(CGRectGetMaxY(_tipView.frame));
        }];
    }
    
    NSIndexPath *defaultIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    if (_payMethodArr.count > 0) {
        [self tableView:self.paymentTableView didSelectRowAtIndexPath:defaultIndexPath];
    }
}

#pragma mark - TopTipViewDelegate
- (void)topTipView:(TopTipView *)topView closeTip:(UIButton *)btn {
    [self.tipView removeFromSuperview];
    [self.paymentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight);
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return _payMethodArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SCPayMoneyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCPayMoneyTableCell"];
        if (cell == nil) {
            cell = [[SCPayMoneyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCPayMoneyTableCell"];
        }
        cell.backgroundColor = [UIColor tt_grayBgColor];
        cell.moneyLable.text = [NSString stringWithFormat:@"¥%.2f", [self.payfeeStr doubleValue]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        SCPaymentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCPaymentTableCell"];
        if (cell==nil) {
            cell = [[SCPaymentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCPaymentTableCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor tt_grayBgColor]];
        
        NSString *paymentType = _payMethodArr[indexPath.row];
        if([paymentType isEqualToString:@"alipay"]){  //支付宝
            cell.leftIamgeView.image = [UIImage imageNamed:@"alipay"];
        }else if ([paymentType isEqualToString:@"wxpay"]){  //微信
            cell.leftIamgeView.image = [UIImage imageNamed:@"weixinpay"];
        }else if ([paymentType isEqualToString:@"unionpay"]){  //银联
            cell.leftIamgeView.image = [UIImage imageNamed:@"uupay"];
        }else if ([paymentType isEqualToString:@"applepay"]){  //applePay
            cell.leftIamgeView.image = [UIImage imageNamed:@"Apple-Pay"];
        }else if ([paymentType isEqualToString:@"jdpay"]){  //jdpay
            cell.leftIamgeView.image = [UIImage imageNamed:@"jdpay"];
        }
        
        NSInteger row = [indexPath row];
        NSInteger oldRow = [_selIndex row];
        if (row == oldRow && self.selIndex != nil){
            cell.rightButton.selected = YES;
        }else{
            cell.rightButton.selected = NO;
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger newRow = [indexPath row];
    NSInteger oldRow = (self.selIndex != nil) ? (self.selIndex.row) : -1;
    if(indexPath.section == 1){  //只有选择支付方式时才进入此判断，否则会crash
        if (newRow != oldRow){
            SCPaymentTableCell *cell = (SCPaymentTableCell *)[tableView cellForRowAtIndexPath:indexPath];
            
            cell.rightButton.selected = YES;
            SCPaymentTableCell *oldCell = (SCPaymentTableCell *)[tableView cellForRowAtIndexPath:self.selIndex];
            oldCell.rightButton.selected = NO;
            self.selIndex = indexPath;
        }
        
        _selectedType = [NSString stringWithFormat:@"%@", _payMethodArr[indexPath.row]];
        NSLog(@"选择的行:%zd---类型:%@", newRow, _selectedType);
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section == 1){
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *textLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
        [headerView addSubview:textLable];
        [textLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
            make.left.mas_offset(15);
        }];
        textLable.text = @"选择支付方式:";
        return headerView;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return AdaptedHeight(40);
    }else{
        return 0.0001;
    }
}

#pragma mark - 点击去支付
-(void)clickPayButton{
    if([_selectedType isEqualToString:@"alipay"]){  //支付宝
        [self clickAlipay];
    }else if ([_selectedType isEqualToString:@"wxpay"]){  //微信
        [self wxPayClick];
    }else if ([_selectedType isEqualToString:@"unionpay"]){  //银联
        [self UPPayClick];
    }else if ([_selectedType isEqualToString:@"applepay"]){  //applePay
        //        [self applePayClick];
    }else if ([_selectedType isEqualToString:@"jdpay"]){  //京东支付
        [self jdPayClick];
    }else{
        [self showNoticeView:@"请选择支付方式"];
    }
    NSLog(@"支付方式%@ ", _selectedType);
}

#pragma mark - 支付宝支付处理
-(void)clickAlipay{
    self.paymentType = 2;
    self.appDelegate.paymentType = self.paymentType;
    
    NSString *alipayUrl= [NSString stringWithFormat:@"%@%@", WebServicePayAPI, payForJoinByAli_Url];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *pramaDic = @{@"orderId":self.orderid,@"ver":app_Version};
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:alipayUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@", dict[@"code"]];
        NSString *codeinfo = [NSString stringWithFormat:@"%@",dict[@"codeinfo"]];
        if (![code isEqualToString:@"200"]){
            if(codeinfo && codeinfo.length > 0){
                FFWarnAlertView *alertV = [[FFWarnAlertView alloc] init];
                alertV.titleLable.text = codeinfo;
                [alertV showFFWarnAlertView];
            }
            return;
        }
        
        NSString *payorderString = dict[@"res"];
        NSString *appScheme = @"AlipayCkys";
        
        [[AlipaySDK defaultService] payOrder:payorderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            /**
             *  支付结果回调，支付宝会返回支付结果信息，一般是走这个方法。
             */
            NSLog(@"reslut = %@",resultDic);
            
            NSDictionary *userInfo = resultDic;
            NSInteger errCode = [[userInfo objectForKey:@"resultStatus"]integerValue];
            if (errCode == 9000) {
                PaySuccessViewController *paySucc = [[PaySuccessViewController alloc] init];
                paySucc.paymentType = self.paymentType;
                paySucc.payfeeStr = self.payfeeStr;
                paySucc.orderid = self.orderid;
                paySucc.isdlbitem = self.isdlbitem;
                [self.navigationController pushViewController:paySucc animated:YES];
            }else if(errCode == 6001){
                [self showNoticeView:@"用户中途取消"];
            }else if(errCode == 8000){
                [self showNoticeView:@"正在处理中，支付结果未知"];
            }else if(errCode == 4000){
                [self showNoticeView:@"订单支付失败"];
            }else if(errCode == 5000){
                [self showNoticeView:@"重复请求"];
            }else if(errCode == 6002){
                [self showNoticeView:@"网络连接出错"];
            }else if(errCode == 6004){
                [self showNoticeView:@"支付结果未知"];
            }else{
                [self showNoticeView:@"其他错误"];
            }
            
        }];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        NSLog(@"支付宝错误===%@",error.localizedDescription);
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 监听支付宝支付完成跳转页面
- (void)aliPayCallBack:(NSNotification *)notification{
    
    self.paymentType = 2;
    self.appDelegate.paymentType = self.paymentType;
    NSDictionary *userInfo = notification.userInfo;
    NSInteger errCode = [[userInfo objectForKey:@"resultStatus"]integerValue];
    if (errCode == 9000) {
        PaySuccessViewController *paySucc = [[PaySuccessViewController alloc] init];
        paySucc.paymentType = self.paymentType;
        paySucc.payfeeStr = self.payfeeStr;
        paySucc.orderid = self.orderid;
        paySucc.isdlbitem = self.isdlbitem;
        [self.navigationController pushViewController:paySucc animated:YES];
    }else if(errCode == 6001){
        [self showNoticeView:@"用户中途取消"];
    }else if(errCode == 8000){
        [self showNoticeView:@"正在处理中，支付结果未知"];
    }else if(errCode == 4000){
        [self showNoticeView:@"订单支付失败"];
    }else if(errCode == 5000){
        [self showNoticeView:@"重复请求"];
    }else if(errCode == 6002){
        [self showNoticeView:@"网络连接出错"];
    }else if(errCode == 6004){
        [self showNoticeView:@"支付结果未知"];
    }else{
        [self showNoticeView:@"其他错误"];
    }
}

#pragma mark - 微信支付处理
- (void)wxPayClick {
    self.paymentType = 1;
    self.appDelegate.paymentType = self.paymentType;
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    NSString *WeixinUrl = [NSString stringWithFormat:@"%@%@", WebServicePayAPI, payForJoinByWX_Url];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *pramaDic = @{@"orderId":self.orderid,@"ver":app_Version};
    
    [HttpTool postWithUrl:WeixinUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@", dict[@"code"]];
        NSString *codeinfo = [NSString stringWithFormat:@"%@",dict[@"codeinfo"]];
        if (![code isEqualToString:@"200"]){
            if(codeinfo && codeinfo.length > 0){
                FFWarnAlertView *alertV = [[FFWarnAlertView alloc] init];
                alertV.titleLable.text = codeinfo;
                [alertV showFFWarnAlertView];
            }
            return;
        }
        
        NSLog(@"json===%@",json);
        NSString *nonce_str = [json objectForKey:@"noncestr"];
        NSString *prepayId = [json objectForKey:@"prepayid"];
        NSString *sign = [json objectForKey:@"sign"];
        NSString *timestamp = [json objectForKey:@"timestamp"];
        NSString *package = [json objectForKey:@"package"];
        
        PayReq* req             = [[PayReq alloc]init];
        req.partnerId           = WXCommercialTenantId; //微信商户ID
        req.prepayId            = prepayId;
        req.nonceStr            = nonce_str;
        req.timeStamp           = timestamp.intValue;
        req.package             = package;
        req.sign                = sign;
        [WXApi sendReq:req];
        NSLog(@"partid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign);
        
    } failure:^(NSError *error){
        [self.loadingView stopAnimation];
        NSLog(@"微信错误===%@",error.localizedDescription);
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 监听微信支付完成跳转页面
- (void)weixinPayCallBack:(NSNotification *)notification{
    self.paymentType = 1;
    self.appDelegate.paymentType = self.paymentType;
    NSString *object= [NSString stringWithFormat:@"%@",notification.object];
    if ([object isEqualToString:@"0"]) { //成功之后
        PaySuccessViewController *paySucc = [[PaySuccessViewController alloc] init];
        paySucc.paymentType = self.paymentType;
        paySucc.payfeeStr = self.payfeeStr;
        paySucc.orderid = self.orderid;
        paySucc.isdlbitem = self.isdlbitem;
        [self.navigationController pushViewController:paySucc animated:YES];
    }else if ([object isEqualToString:@"-1"]){
        [self showNoticeView:@"支付失败"];
    }else if ([object isEqualToString:@"-2"]){
        [self showNoticeView:@"用户中途取消"];
    }else if ([object isEqualToString:@"-3"]){
        [self showNoticeView:@"发送失败"];
    }else if ([object isEqualToString:@"-4"]){
        [self showNoticeView:@"授权失败"];
    }else if ([object isEqualToString:@"-5"]){
        [self showNoticeView:@"微信不支持"];
    }else{
        [self showNoticeView:@"其他错误"];
    }
}

#pragma mark - 银联支付
-(void)UPPayClick {
    NSLog(@"银联支付");
    self.paymentType = 3;
    self.appDelegate.paymentType = self.paymentType;
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    NSString *upPayUrl= [NSString stringWithFormat:@"%@%@", WebServiceUnitPayAPI, Uionpay_Url];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *pramaDic = @{@"orderId":self.orderid,@"ver":app_Version};
    
    [HttpTool getWithUrl:upPayUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSLog(@"json===%@",json);
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        NSString *codeinfo = [NSString stringWithFormat:@"%@",dict[@"codeinfo"]];
        if (IsNilOrNull(codeinfo)){
            codeinfo = @"";
        }
        if (![code isEqualToString:@"200"]){
            if(codeinfo && codeinfo.length > 0){
                FFWarnAlertView *alertV = [[FFWarnAlertView alloc] init];
                alertV.titleLable.text = codeinfo;
                [alertV showFFWarnAlertView];
//                [self showNoticeView:codeinfo];
            }
            return ;
        }
        NSString *tn = [NSString stringWithFormat:@"%@",dict[@"tn"]];
        
        [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"UPPayCkys" mode:UnionPayEnvironment viewController:self];
        
    } failure:^(NSError *error){
        NSLog(@"错误===%@",error.localizedDescription);
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 银联支付回调
-(void)UUPay:(NSNotification *)notice{
    
    NSString *code = [NSString stringWithFormat:@"%@",notice.object];
    if([code isEqualToString:@"success"]){
        PaySuccessViewController *paySucc = [[PaySuccessViewController alloc] init];
        paySucc.paymentType = self.paymentType;
        paySucc.payfeeStr = self.payfeeStr;
        paySucc.orderid = self.orderid;
        paySucc.isdlbitem = self.isdlbitem;
        [self.navigationController pushViewController:paySucc animated:YES];
    }else if([code isEqualToString:@"fail"]) { //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成
        [self showNoticeView:@"银联支付失败"];
    }else if([code isEqualToString:@"cancel"]) {
        [self showNoticeView:@"用户已取消"];
    }
}

#pragma mark - 京东支付
-(void)jdPayClick {
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    NSString *jdpayUrl = [NSString stringWithFormat:@"%@%@", WebServicePayAPI, JionPay_JD];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *uuid = IsNilOrNull(DeviceId_UUID_Value) ? @"" : DeviceId_UUID_Value;
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:self.orderid forKey:@"orderId"];
    [paramDict setValue:app_Version forKey:@"ver"];
    [paramDict setValue:uuid forKey:@"deviceid"];
    [paramDict setValue:@"2" forKey:@"devtype"];
    [paramDict setValue:@"1" forKey:@"apptype"];
    
    [HttpTool postWithUrl:jdpayUrl params:paramDict success:^(id json) {
        NSLog(@"json===%@",json);
        [self.loadingView stopAnimation];
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        NSString *codeinfo = dict[@"codeinfo"];
        
        if (![code isEqualToString:@"200"]){
            FFWarnAlertView *alertV = [[FFWarnAlertView alloc] init];
            alertV.titleLable.text = codeinfo;
            [alertV showFFWarnAlertView];
//            [self.loadingView showNoticeView:codeinfo];
        }else{
            NSDictionary *res = dict[@"res"];
            NSString *signdata = [NSString stringWithFormat:@"%@", res[@"signdata"]];
            NSString *orderId = [NSString stringWithFormat:@"%@", res[@"orderId"]];
            [[JDPAuthSDK sharedJDPay] payWithViewController:self orderId:orderId signData:signdata completion:^(NSDictionary *resultDict) {
                NSLog(@"resultDict:%@", resultDict);
                
                NSString *payStatus = [NSString stringWithFormat:@"%@", resultDict[@"payStatus"]];
                if ([payStatus isEqualToString:@"JDP_PAY_SUCCESS"]) { //成功之后
                    PaySuccessViewController *paySucc = [[PaySuccessViewController alloc] init];
                    paySucc.paymentType = self.paymentType;
                    paySucc.payfeeStr = self.payfeeStr;
                    paySucc.orderid = self.orderid;
                    paySucc.isdlbitem = self.isdlbitem;
                    [self.navigationController pushViewController:paySucc animated:YES];
                }else {
                    if ([payStatus isEqualToString:@"JDP_PAY_FAIL"]) {
                        [self showNoticeView:@"支付失败"];
                    }else if ([payStatus isEqualToString:@"JDP_PAY_CANCEL"]) {
                        [self showNoticeView:@"取消支付"];
                    }else{
                        [self showNoticeView:payStatus];
                    }
                }
            }];
        }
    } failure:^(NSError *error) {
        NSLog(@"错误===%@",error.localizedDescription);
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - Apple Pay支付
//-(void)applePayClick {
//
//    NSLog(@"苹果支付");
//
//    [self nullValueProcess];
//
//    NSDictionary *pramaDic = [self generalPayParams];
//    if (pramaDic == nil) {
//        [self showNoticeView:@"账户信息异常，请退出账号重新登录或注册。"];
//        return;
//    }
//
//    [self.view addSubview:self.loadingView];
//    [self.loadingView startAnimation];
//
//    NSString *upPayUrl= [NSString stringWithFormat:@"%@%@", WebServiceUnitPayAPI, Uionpay_Url];
//
//    [HttpTool postWithUrl:upPayUrl params:pramaDic success:^(id json) {
//        [self.loadingView stopAnimation];
//        NSLog(@"json===%@",json);
//        NSDictionary *dict = json;
//        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
//        NSString *codeinfo = [NSString stringWithFormat:@"%@",dict[@"codeinfo"]];
//        if (IsNilOrNull(codeinfo)){
//            codeinfo = @"";
//        }
//        if (![code isEqualToString:@"200"]){
//            if(codeinfo && codeinfo.length > 0){
//                [self showNoticeView:codeinfo];
//            }
//            return ;
//        }
//        NSString *tn = [NSString stringWithFormat:@"%@",dict[@"tn"]];
//        [UPAPayPlugin startPay:tn mode:UnionPayEnvironment viewController:self delegate:self andAPMechantID:@"merchant.com.ckc.CKYSPlatform"];
//
//    } failure:^(NSError *error){
//        NSLog(@"错误===%@",error.localizedDescription);
//        [self.loadingView stopAnimation];
//        if (error.code == -1009) {
//            [self showNoticeView:NetWorkNotReachable];
//        }else{
//            [self showNoticeView:NetWorkTimeout];
//        }
//    }];
//}

#pragma mark - Apple Pay支付结果回调
//-(void)UPAPayPluginResult:(UPPayResult *)payResult {
//
//    NSInteger status = payResult.paymentResultStatus;
//
//    if(status == UPPaymentResultStatusSuccess){//支付成功
//        [self showNoticeView:@"支付成功"];
//        //跳转原来列表
//        [self dismissViewControllerAnimated:YES completion:^{
//
//        }];
//    }else if(status == UPPaymentResultStatusFailure) { //支付失败
//        [self showNoticeView:@"支付失败"];
//    }else if(status == UPPaymentResultStatusCancel) { //支付取消
//        [self showNoticeView:@"支付取消"];
//    }else if(status == UPPaymentResultStatusUnknownCancel) { //支付取消，交易已发起，状态不确定，商户需查询商户后台确认支付状态
//        [self showNoticeView:@"支付取消"];
//    }
//
//    [KUserdefaults setObject:@"minelogin" forKey:KMineLoginStatus];
//    [KUserdefaults setObject:@"homelogin" forKey:KHomeLoginStatus];
//}

-(BOOL)navigationShouldPopOnBackButton {
    //    if(needsShowConfirmation) {
    //        // Show confirmation alert
    //        // ...
    //        return NO; // Ignore 'Back' button this time
    //    }
    //    return YES; // Process 'Back' button click and Pop view controler
    
    _alertView = [[XWAlterVeiw alloc] init];
    _alertView.delegate = self;
    _alertView.titleLable.text = @"订单还未支付，确定退出？";
    [_alertView show];
    return NO;
}

-(void)subuttonClicked {
    if ([self.enterType isEqualToString:@"shoppingCar"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - 更新域名
-(void)updateDomain:(NSDictionary*)dict {
    
    NSString *domainImgRegetUrl = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainImgRegetUrl"]];
    if (!IsNilOrNull(domainImgRegetUrl)) {
        if (![domainImgRegetUrl hasSuffix:@"/"]) {
            domainImgRegetUrl = [domainImgRegetUrl stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainImgRegetUrl forKey:@"domainImgRegetUrl"];
    }
    
    NSString *domainNameRes = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainNameRes"]];
    if (!IsNilOrNull(domainNameRes)) {
        if (![domainNameRes hasSuffix:@"/"]) {
            domainNameRes = [domainNameRes stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainNameRes forKey:@"domainNameRes"];
    }
    
    NSString *domainNamePay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainNamePay"]];
    if (!IsNilOrNull(domainNamePay)) {
        if (![domainNamePay hasSuffix:@"/"]) {
            domainNamePay = [domainNamePay stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainNamePay forKey:@"domainNamePay"];
    }
    
    NSString *domainSmsMessage = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainSmsMessage"]];
    if (!IsNilOrNull(domainSmsMessage)) {
        if (![domainSmsMessage hasSuffix:@"/"]) {
            domainSmsMessage = [domainSmsMessage stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainSmsMessage forKey:@"domainSmsMessage"];
    }
    
    NSString *domainNameUnionPay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainUnionPay"]];
    if (!IsNilOrNull(domainNameUnionPay)) {
        if (![domainNameUnionPay hasSuffix:@"/"]) {
            domainNameUnionPay = [domainNameUnionPay stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainNameUnionPay forKey:@"domainNameUnionPay"];
    }
}

-(void)dealloc{
    [CKCNotificationCenter removeObserver:self name:WeiXinPay_CallBack object:nil];
    [CKCNotificationCenter removeObserver:self name:Alipay_CallBack object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
