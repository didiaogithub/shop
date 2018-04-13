//
//  SCPhoneLoginViewController.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCPhoneLoginViewController.h"
#import "STCountDownButton.h"
#import "WXApi.h"
#import "SCAdImageView.h"
#import "GoodModel.h"
#import "SCMyOrderModel.h"
#import "SCCategoryGoodsModel.h"

@interface SCPhoneLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *idcodeTF;
@property (nonatomic, strong) STCountDownButton *countDownCode;
@property (nonatomic, copy) NSString *valitedStr;

@end

@implementation SCPhoneLoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.bindString isEqualToString:@"needBindPhone"]) {
        self.navigationItem.title = @"设置手机号";
    }else{
        self.navigationItem.title = @"登录";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
}

-(void)initUI {
    
    [CKCNotificationCenter addObserver:self selector:@selector(loginWithPhoneAndOpenid) name:WeiXinAuthSuccess object:nil];
    
    UILabel *title = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:14]];
    if ([self.bindString isEqualToString:@"needBindPhone"]) {
        title.text = @"";
    }else{
        title.text = @"验证手机号码登录";
    }
    title.frame = CGRectMake(0, 74+NaviAddHeight, SCREEN_WIDTH, 30);
    [self.view addSubview:title];
    
    _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 114+NaviAddHeight, SCREEN_WIDTH - 20, 44)];
    _phoneTF.keyboardType = UIKeyboardTypePhonePad;
    _phoneTF.delegate = self;
    [self.view addSubview:_phoneTF];
    _phoneTF.placeholder = @"请输入手机号码";
    UILabel *phoneLine = [UILabel creatLineLable];
    phoneLine.frame = CGRectMake(10, 158+NaviAddHeight, SCREEN_WIDTH - 20, 1);
    [self.view addSubview:phoneLine];
    
    NSString *tipStr = @"*非大陆手机用户请在手机号码前输入国际电话区号。例如香港手机用户：0852手机号码";
    CGFloat h = [tipStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} context:nil].size.height + 1;
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 159+NaviAddHeight, SCREEN_WIDTH - 20, h)];
    tipLabel.text = tipStr;
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = [UIColor tt_monthGrayColor];
    tipLabel.font = [UIFont systemFontOfSize:12.0];
    [self.view addSubview:tipLabel];
    
    
    
    _idcodeTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 168 + h+5+NaviAddHeight, SCREEN_WIDTH - 140, 44)];
    _idcodeTF.keyboardType = UIKeyboardTypePhonePad;
    _idcodeTF.delegate = self;
    [self.view addSubview:_idcodeTF];
    _idcodeTF.placeholder = @"请输入验证码";
    
    //发送验证码
    _countDownCode = [[STCountDownButton alloc]init];
    [self.view addSubview:_countDownCode];
    [_countDownCode mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_idcodeTF.mas_top).offset(2);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
    }];
    //设置背景颜色
    _countDownCode.backgroundColor = [UIColor clearColor];
    _countDownCode.layer.borderWidth = 1;
    _countDownCode.layer.cornerRadius = 2;
    _countDownCode.layer.masksToBounds = YES;
    _countDownCode.layer.borderColor = [UIColor tt_lineBgColor].CGColor;
    //设置倒计时时长
    [_countDownCode setSecond:60];
    //设置字体大小
    if(iphone4){
        _countDownCode.titleLabel.font = CHINESE_SYSTEM(AdaptedWidth(10));
    }else{
        _countDownCode.titleLabel.font = MAIN_TITLE_FONT;
    }
    
    //设置字体颜色
    [_countDownCode setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];
    [_countDownCode addTarget:self
                       action:@selector(startCountDown:)
             forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *line = [UILabel creatLineLable];
    line.frame = CGRectMake(10, 208 + h+5+NaviAddHeight, SCREEN_WIDTH - 150, 1);
    [self.view addSubview:line];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = [UIColor tt_redMoneyColor];
    if ([self.bindString isEqualToString:@"needBindPhone"]) {
        [loginBtn setTitle:@"设置" forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(loginWithPhoneAndOpenid) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(phoneLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    loginBtn.layer.cornerRadius = 3.0;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.frame = CGRectMake(10, 250 + h+5+NaviAddHeight, SCREEN_WIDTH - 20, 44);
    
}

/**点击获取验证码*/
-(void)startCountDown:(STCountDownButton *)button{
    //点击获取验证码 后开始倒计时
    [self getVertifyCodeWithButton:button];
}

#pragma mark - 获取验证码
-(void)getVertifyCodeWithButton:(STCountDownButton*)button {
    if (IsNilOrNull(_phoneTF.text)){
        [self showNoticeView:@"请输入手机号码"];
        return;
    }
    
    if ([_phoneTF.text hasPrefix:@"1"]) {
        //1开头的默认为大陆号码，增加验证
        if(![NSString isMobile:_phoneTF.text]){
            [self showNoticeView:@"请输入正确的手机号码"];
            return;
        }
    }
    
    [button start];
    
    NSDictionary *pramdDic = @{@"telNo":_phoneTF.text, @"param":@"1"};
    NSString *codeUrl = [NSString stringWithFormat:@"%@%@", MsgApi, @"Msg/Sms/getValidCodeA"];
    [HttpTool postWithUrl:codeUrl params:pramdDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        _valitedStr = [NSString stringWithFormat:@"%@", dict[@"validStr"]];
        
        NSLog(@"验证码%@", _valitedStr);
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

/**点击登录按钮*/
-(void)phoneLogin{
    
    if (IsNilOrNull(_phoneTF.text)){
        [self showNoticeView:@"请输入手机号码"];
        return;
    }
    
    if ([_phoneTF.text hasPrefix:@"1"]) {
        //1开头的默认为大陆号码，增加验证
        if(![NSString isMobile:_phoneTF.text]){
            [self showNoticeView:@"请输入正确的手机号码"];
            return;
        }
    }
    
    
    if (IsNilOrNull(_idcodeTF.text)){
        [self showNoticeView:@"请输入验证码"];
        return;
    }
    
    NSString *codeUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, PhoneLoginUrl];
    NSDictionary *pramdDic = @{@"mobile":_phoneTF.text, @"code": _idcodeTF.text};
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool postWithUrl:codeUrl params:pramdDic success:^(id json) {
        [self.loadingView stopAnimation];
        
        NSDictionary *dict = json;
        
        if ([dict[@"code"] integerValue] == 200) {
            
            NSString *uk = [NSString stringWithFormat:@"%@",dict[@"uk"]];
            if (!IsNilOrNull(uk)) {
                [KUserdefaults setObject:uk forKey:@"YDSC_uk"];
            }
            
            NSString *appopenid = [NSString stringWithFormat:@"%@",dict[@"appopenid"]];
            
            [KUserdefaults setObject:appopenid forKey:@"USER_OPENID"];
            
            [KUserdefaults removeObjectForKey:@"loginWithCheckPhone"];
            
            //清除优惠券缓存
            [KUserdefaults removeObjectForKey:@"CouponCacheDate"];
            [[XNArchiverManager shareInstance] xnDeleteObject:KMyCouponList];
            
            //删除订单购物车缓存
            RLMResults *result = [GoodModel allObjects];
            RLMRealm *realm = [RLMRealm defaultRealm];
            if (result.count > 0) {
                [realm beginWriteTransaction];
                [realm deleteObjects:result];
                [realm commitWriteTransaction];
            }
            RLMResults *result1 = [SCMyOrderModel allObjects];
            if (result1.count > 0) {
                [realm beginWriteTransaction];
                [realm deleteObjects:result1];
                [realm commitWriteTransaction];
            }
            RLMResults *result2 = [SCMyOrderGoodsModel allObjects];
            if (result2.count > 0) {
                [realm beginWriteTransaction];
                [realm deleteObjects:result2];
                [realm commitWriteTransaction];
            }
            
            //            RLMResults *result3 = [SCCategoryGoodsModel allObjects];
            //            if (result2.count > 0) {
            //                [realm beginWriteTransaction];
            //                [realm deleteObjects:result3];
            //                [realm commitWriteTransaction];
            //            }
            
            
            if (!IsNilOrNull(_phoneTF.text)) {
                [KUserdefaults setObject:_phoneTF.text forKey:Kmobile];
            }
            
            [KUserdefaults setObject:@"loginWithPhoneAndWxSucc" forKey:KloginStatus];
            [KUserdefaults synchronize];
            [self goFirstPage];
            
        }else if([dict[@"code"] integerValue] == 300) {
            NSString *type = [NSString stringWithFormat:@"%@",dict[@"type"]];
            if ([type isEqualToString:@"wx"]) {
                
                if (!IsNilOrNull(_phoneTF.text)) {
                    [KUserdefaults setObject:_phoneTF.text forKey:Kmobile];
                }
                //微信授权
                [self toWeiXinAuth];
            }
        }else{
            [self showNoticeView:dict[@"codeinfo"]];
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

-(void)goFirstPage {
    RootTabBarController *rootVC = [[RootTabBarController alloc]init];
//    [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
    AppDelegate *app = [AppDelegate shareAppDelegate];
    app.window.rootViewController = rootVC;
    [app.window makeKeyAndVisible];
}

-(void)toWeiXinAuth {
    if(![WXApi isWXAppInstalled]){
        //从欢迎页进入app 未登录 并且没有授权
        [self shownotice];
    }else{
        //点击最后一页直接去授权
        SendAuthReq* req =[[SendAuthReq alloc ] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"login123";
        [WXApi sendReq:req];
    }
}

-(void)shownotice{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)loginWithPhoneAndOpenid {
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    NSString *codeUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, PhoneLoginUrl];
    NSString *openid = [KUserdefaults objectForKey:KopenID];
    NSString *unionid = [KUserdefaults objectForKey:Kunionid];
    NSString *head = [KUserdefaults objectForKey:kheamImageurl];
    NSString *smallname = [KUserdefaults objectForKey:KnickName];
    
    NSString *phone = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:Kmobile]];
    if (IsNilOrNull(phone)) {
        phone = _phoneTF.text;
    }
    
    NSDictionary *pramdDic = @{@"mobile":phone, @"code": _idcodeTF.text, @"openid":openid, @"unionid":unionid, @"head":head, @"smallname":smallname};
    
    [HttpTool postWithUrl:codeUrl params:pramdDic success:^(id json) {
        
        
        NSDictionary *dict = json;
        
        if ([dict[@"code"] integerValue] == 200) {
            
            NSString *uk = [NSString stringWithFormat:@"%@",dict[@"uk"]];
            if (!IsNilOrNull(uk)) {
                [KUserdefaults setObject:uk forKey:@"YDSC_uk"];
            }
            
            NSString *appopenid = [NSString stringWithFormat:@"%@",dict[@"appopenid"]];
            
            [KUserdefaults setObject:appopenid forKey:@"USER_OPENID"];
            
            [KUserdefaults removeObjectForKey:@"loginWithCheckPhone"];
            
            //清除优惠券缓存
            [KUserdefaults removeObjectForKey:@"CouponCacheDate"];
            [[XNArchiverManager shareInstance] xnDeleteObject:KMyCouponList];
            
            //删除订单购物车缓存
            RLMResults *result = [GoodModel allObjects];
            RLMRealm *realm = [RLMRealm defaultRealm];
            if (result.count > 0) {
                [realm beginWriteTransaction];
                [realm deleteObjects:result];
                [realm commitWriteTransaction];
            }
            RLMResults *result1 = [SCMyOrderModel allObjects];
            if (result1.count > 0) {
                [realm beginWriteTransaction];
                [realm deleteObjects:result1];
                [realm commitWriteTransaction];
            }
            RLMResults *result2 = [SCMyOrderGoodsModel allObjects];
            if (result2.count > 0) {
                [realm beginWriteTransaction];
                [realm deleteObjects:result2];
                [realm commitWriteTransaction];
            }
            //            RLMResults *result3 = [SCCategoryGoodsModel allObjects];
            //            if (result2.count > 0) {
            //                [realm beginWriteTransaction];
            //                [realm deleteObjects:result3];
            //                [realm commitWriteTransaction];
            //            }
            
            if (!IsNilOrNull(_phoneTF.text)) {
                [KUserdefaults setObject:_phoneTF.text forKey:Kmobile];
            }
            
            [KUserdefaults setObject:@"loginWithPhoneAndWxSucc" forKey:KloginStatus];
            [KUserdefaults synchronize];
            [self goFirstPage];
        }else if([dict[@"code"] integerValue] == 300) {
            NSString *type = [NSString stringWithFormat:@"%@",dict[@"type"]];
            if ([type isEqualToString:@"wx"]) {
                
                if (!IsNilOrNull(_phoneTF.text)) {
                    [KUserdefaults setObject:_phoneTF.text forKey:Kmobile];
                }
                //微信授权
                [self toWeiXinAuth];
            }
        }else{
            [self showNoticeView:dict[@"codeinfo"]];
        }
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

#pragma mark-限制手机号输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.phoneTF) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }else if (self.phoneTF.text.length >= 20){
            self.phoneTF.text = [textField.text substringToIndex:20];
            return NO;
        }
    }
    if (textField == self.idcodeTF) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }else if (self.idcodeTF.text.length >= 6){
            self.idcodeTF.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
