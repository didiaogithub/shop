//
//  SetUpViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/15.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "SetUpViewController.h"
#import "XWAlterVeiw.h"
#import "UpdateAlertView.h"
#import "SCLoginViewController.h"
#import "RootNavigationController.h"
#import "RCloudManager.h"
#import "CommonLoginViewController.h"
#import "CKCUpdateAlertView.h"

@interface SetUpViewController ()<XWAlterVeiwDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *updateView;
@property (nonatomic, strong) UILabel *versionLable;
@property (nonatomic, strong) UIButton *versionButton;
@property (nonatomic, strong) UIButton *clearCacheBtn;
@property (nonatomic, copy)   NSString *ckidString;
@property (nonatomic, copy)   NSString *localversionStr;
@property (nonatomic, copy)   NSString *severVersionStr; //服务器返回版本
@property (nonatomic, copy)   NSString *localBuildStr;
@property (nonatomic, copy)   NSString *downLoadUrl;
@property (nonatomic, copy)   NSString *status;
@property (nonatomic, assign) BOOL isCheckVersion;
@property (nonatomic, assign) BOOL isLogOut;
@property (nonatomic, strong) XWAlterVeiw *alertView;

@end

@implementation SetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";

    [self getIsIosCheckData];
    //获取项目版本号
    _localversionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //获取build版本号
    _localBuildStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [self createViews];
}

-(void)getIsIosCheckData{
    
    NSString *isIosCheckUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, IsIosCheck_Url];
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *params = @{@"ver": currentVersion};
    
    [HttpTool getWithUrl:isIosCheckUrl params:params success:^(id json) {
        NSDictionary *dic = json;
        if([dic[@"code"] integerValue] != 200){
            return;
        }
        _checkStatus = [NSString stringWithFormat:@"%@",dic[@"code"]];
        if ([_checkStatus isEqualToString:CheckSuccessCode]){ //审核通过
            _updateView.hidden = NO;
            _versionButton.hidden = NO;
             [_versionButton setTitle:@"检查更新" forState:UIControlStateNormal];
            [_updateView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_topView.mas_bottom).offset(AdaptedHeight(10));
                make.height.mas_offset(AdaptedHeight(50));
            }];
        }else{ //审核中
            _updateView.hidden = YES;
            [_updateView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(AdaptedHeight(0));
            }];
            _versionButton.hidden = YES;
            [_versionButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(AdaptedHeight(0));
            }];
        }
    } failure:^(NSError *error) {
        NSLog(@"网络请求超时,请刷新重试");
    }];
    
}
-(void)createViews{
    
    //logo图  及版本号
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0,AdaptedHeight(10)+64+NaviAddHeight, SCREEN_WIDTH,AdaptedHeight(260))];
    [self.view addSubview:_topView];
    _topView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    [_topView addSubview:logoImageView];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    logoImageView.image = [UIImage imageNamed:@"YDSC_Logo"];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(40));
        make.left.mas_offset(SCREEN_WIDTH/2-AdaptedWidth(63.5));
        make.width.mas_offset(AdaptedWidth(127));
        make.height.mas_offset(119);
    }];
    
    float topH,bottomH = 0;
    if (iphone4) {
        topH = AdaptedHeight(10);
        bottomH = AdaptedHeight(15);
    }else if (iphone5){
        topH = AdaptedHeight(20);
        bottomH = AdaptedHeight(20);
    }else{
        topH = AdaptedHeight(40);
        bottomH = AdaptedHeight(50);
    }
    
    _versionLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [_topView addSubview:_versionLable];
    [_versionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImageView.mas_bottom).offset(topH);
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-bottomH);
        
    }];
    
    //检查更新
    _updateView = [[UIView alloc] init];
    [self.view addSubview:_updateView];
    [_updateView setBackgroundColor:[UIColor whiteColor]];
    [_updateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_offset(0);
    }];
    //检查更新按钮  是否更新
    _versionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_updateView addSubview:_versionButton];
    [_versionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_updateView);
    }];
    
    _versionButton.hidden = YES;
    [_versionButton setTitle:@"检查更新" forState:UIControlStateNormal];

    _versionButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_versionButton setTitleColor:TitleColor forState:UIControlStateNormal];
    [_versionButton addTarget:self action:@selector(clickVersionButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *leaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:leaveButton];
    [leaveButton setBackgroundColor:[UIColor tt_bigRedBgColor]];
    [leaveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
    }];
    leaveButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leaveButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [leaveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leaveButton addTarget:self action:@selector(clickLeaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [self refreshVersionLable];

}

-(void)refreshVersionLable{
    NSLog(@"%@",self.checkStatus);
   _versionLable.text = [NSString stringWithFormat:@"当前版本：V%@", _localversionStr];
}

/**点击检查版本更新*/
-(void)clickVersionButton:(UIButton *)button{
    
    button.userInteractionEnabled = NO;
    _isCheckVersion = YES;
    _isLogOut = NO;
   
    //如果本地 的和服务器的 比较
    [[UpdateAlertView shareInstance] hiddenCancelBtn:NO];
    [UpdateAlertView shareInstance].isDealInBlock = YES;
   
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, PayMethodUrl];
    
    [HttpTool getWithUrl:requestUrl params:nil success:^(id json) {
        button.userInteractionEnabled = YES;
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            return ;
        }
        [self updateDomain:dict];
        
        
        //是否显示消息中心
        NSString *appmallmsg = [dict objectForKey:@"appmallmsg"];
        if (!IsNilOrNull(appmallmsg)) {
            [KUserdefaults setObject:appmallmsg forKey:@"YDSC_msgShow"];
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
        
        NSString *ckappdownloadmsg = [dict objectForKey:@"ckappdownloadmsg"];
        if (!IsNilOrNull(ckappdownloadmsg)) {
            [KUserdefaults setObject:ckappdownloadmsg forKey:@"BecomeCKMsg"];
        }
        
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        _localBuildStr = currentVersion;
        _severVersionStr = [NSString stringWithFormat:@"%@", [dict objectForKey:@"malliosversion"]];
        
        NSString *ckappiosver = [dict objectForKey:@"malliosversion"];
        if (!IsNilOrNull(ckappiosver)) {
            [KUserdefaults setObject:ckappiosver forKey:ServerVersion];
        }
        
        NSString *ckappiosforce = [dict objectForKey:@"malliosforce"];
        if (!IsNilOrNull(ckappiosforce)) {
            [KUserdefaults setObject:ckappiosforce forKey:Forceupdate];
        }
        
        NSString *downLoadUrl = [NSString stringWithFormat:@"%@",dict[@"malldownloadurl"]];
        if (IsNilOrNull(downLoadUrl)) {
            downLoadUrl = @"https://itunes.apple.com/cn/app/id1164737320";
        }
        [KUserdefaults setObject:downLoadUrl forKey:AppStoreUrl];
        [KUserdefaults synchronize];
        _downLoadUrl = downLoadUrl;
    
        if ([currentVersion isEqualToString:_severVersionStr]) {
            UpdateAlertView *updateAlert = [UpdateAlertView shareInstance];
            //如果本地 的和服务器的 比较
            NSString *content = @"当前已经是最新版本";
            [updateAlert hiddenCancelBtn:YES];
            [updateAlert showCommonAlert:content btnClick:^{
                [self goloUpadate];
            }];
        }else if([currentVersion compare:_severVersionStr] == NSOrderedAscending){
            if (!IsNilOrNull(ckappiosforce) && [ckappiosforce isEqualToString:@"1"]) {
                [[CKCUpdateAlertView shareInstance] showUpdateAlert:appmallverinfo forceUpdate:YES];
            }else{
                [[CKCUpdateAlertView shareInstance] showUpdateAlert:appmallverinfo forceUpdate:NO];
            }
        }else{
            UpdateAlertView *updateAlert = [UpdateAlertView shareInstance];
            //如果本地 的和服务器的 比较
            NSString *content = @"当前已经是最新版本";
            [updateAlert hiddenCancelBtn:YES];
            [updateAlert showCommonAlert:content btnClick:^{
                [self goloUpadate];
            }];
        }
        
        
    } failure:^(NSError *error) {
        button.userInteractionEnabled = YES;
    }];
}

#pragma mark-点击确定  去更新
-(void)goloUpadate{
    
    if ([_localBuildStr isEqualToString:_severVersionStr]) {

    }else if([_localBuildStr compare:_severVersionStr] == NSOrderedAscending){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_downLoadUrl]];
    }else{

    }
}

#pragma mark - 点击退出按钮
-(void)clickLeaveButton:(UIButton *)button{
    
    _alertView = [[XWAlterVeiw alloc]init];
    _alertView.delegate = self;
    _alertView.titleLable.text = @"确定退出登录？";
    [_alertView show];

}

-(void)subuttonClicked {
    [self gotoLogOut];
}

#pragma mark-退出登录
-(void)gotoLogOut{
    //断开与融云服务器的连接，并不再接收远程推送
    [[RCloudManager manager] logout];
    [KUserdefaults setObject:@"NO" forKey:@"SC_ConnectRCloudStatus"];
    [KUserdefaults removeObjectForKey:Kmobile];
    [KUserdefaults removeObjectForKey:KopenID];
    [KUserdefaults removeObjectForKey:Kunionid];
    [KUserdefaults removeObjectForKey:kheamImageurl];
    [KUserdefaults removeObjectForKey:@"YDSC_USER_MOBILE"];
    [KUserdefaults removeObjectForKey:KloginStatus];
    [KUserdefaults removeObjectForKey:KnickName];
    [KUserdefaults removeObjectForKey:@"SC_RCToken"];
    [KUserdefaults removeObjectForKey:@"USER_OPENID"];
    [KUserdefaults removeObjectForKey:@"YDSC_USER_HEAD"];

    [JPUSHService setTags:0 alias:@"0" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"\n[退出后设置JPush别名]---[%@]",iAlias);
    }];
    
    //退出登录移除默认地址缓存
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:USER_DefaultAddress];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
    
    NSString *isCheck = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:@"loginWithCheckPhone"]];
    if (!IsNilOrNull(isCheck)) {
        [KUserdefaults removeObjectForKey:@"loginWithCheckPhone"];
        [self goCheckLogin];
    }else{
        [KUserdefaults removeObjectForKey:KloginStatus];
        [self goWelcom];
    }
}

-(void)goCheckLogin {
    CommonLoginViewController *login = [[CommonLoginViewController alloc] init];
    RootNavigationController *loginNavi = [[RootNavigationController alloc] initWithRootViewController:login];
//    [UIApplication sharedApplication].keyWindow.rootViewController = loginNavi;
//    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    
    AppDelegate *app = [AppDelegate shareAppDelegate];
    app.window.rootViewController = loginNavi;
    [app.window makeKeyAndVisible];
}

-(void)goWelcom{
    SCLoginViewController *welcome =[[SCLoginViewController alloc] init];
    RootNavigationController *welcomeNav = [[RootNavigationController alloc] initWithRootViewController:welcome];
//    [UIApplication sharedApplication].keyWindow.rootViewController = welcomeNav;
//    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    AppDelegate *app = [AppDelegate shareAppDelegate];
    app.window.rootViewController = welcomeNav;
    [app.window makeKeyAndVisible];
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


@end
