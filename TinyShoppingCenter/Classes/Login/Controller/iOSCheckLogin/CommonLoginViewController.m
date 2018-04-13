//
//  CommonLoginViewController.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 16/10/25.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "CommonLoginViewController.h"
#import "RegistViewController.h"
#import "CheckUserModel.h"


@interface CommonLoginViewController ()

@property (nonatomic, strong) UIImageView *userNameImageView;
@property (nonatomic, strong) UIImageView *passwordImageView;
@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@end

@implementation CommonLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    [CKCNotificationCenter addObserver:self selector:@selector(getLoginData) name:@"loginDatafail" object:nil];
    [self createViews];
}

#pragma makr-登录失败再调用一次
-(void)getLoginData{
    [self clickLoginButton];
}

-(void)createViews{
    
    UIView *bankView = [[UIView alloc] init];
    [self.view addSubview:bankView];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(64+20);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 400));
    }];
    
    _userNameImageView = [[UIImageView alloc] init];
    UIImage *telImage = [UIImage imageNamed:@"手机"];
    [_userNameImageView setImage:[telImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    _userNameImageView.frame = CGRectMake(10, 0, 34, 21);
    _userNameImageView.contentMode= UIViewContentModeCenter;
    
    
    _userNameTextField = [[UITextField alloc] init];
    [bankView  addSubview:_userNameTextField];
    [_userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(15);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH - 30, 50));
    }];
    _userNameTextField.placeholder = @"请输入用户名";
    _userNameTextField.leftView = _userNameImageView;
    _userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    //密码图标
    _passwordImageView = [[UIImageView alloc] init];
    UIImage *codeImage = [UIImage imageNamed:@"锁子"];
    [_passwordImageView setImage:[codeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    _passwordImageView.frame = CGRectMake(10, 0, 35, 21);
    _passwordImageView.contentMode= UIViewContentModeCenter;
    
    //验证码textfiled
    _passwordTextField = [[UITextField alloc] init];
    [bankView addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameTextField.mas_bottom).offset(15);
        make.left.equalTo(_userNameTextField.mas_left);
        make.size.mas_offset(CGSizeMake((SCREEN_WIDTH - 30), 50));
    }];
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.leftView = _passwordImageView;
    _passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    _passwordTextField.secureTextEntry  = YES;
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:loginButton];
    loginButton.layer.cornerRadius = 5;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.mas_bottom).offset(40);
        make.left.equalTo(_passwordTextField.mas_left);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH - 30, 50));
    }];
    loginButton.backgroundColor = [UIColor tt_redMoneyColor];
    [loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:UIControlEventTouchUpInside];
    UIButton * gotoRegist = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:gotoRegist];
    gotoRegist.titleLabel.textAlignment = NSTextAlignmentRight;
    [gotoRegist setTitle:@"立即注册?" forState:UIControlStateNormal];
    [gotoRegist setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gotoRegist mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.mas_bottom).offset(20);
        make.right.mas_offset(-15);
        make.size.mas_offset(CGSizeMake(100, 20));
    }];
    [gotoRegist addTarget:self action:@selector(clickRegistButton) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 点击登录
-(void)clickLoginButton {
    [self resignTextFieldFirstresponder];
    if (IsNilOrNull(_userNameTextField.text)){
        [self showNoticeView:@"请输入用户名"];
        return;
    }
    if (IsNilOrNull(_passwordTextField.text)) {
        [self showNoticeView:@"请输入密码"];
        return;
    }
    
    NSString *pw = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:_userNameTextField.text]];
    if ([pw isEqualToString:_passwordTextField.text]) {
        [KUserdefaults setObject:@"loginWithCheckPhone" forKey:@"loginWithCheckPhone"];
        
        NSString *key = [NSString stringWithFormat:@"user%@", _userNameTextField.text];
        NSString *appopenid = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:key]];
        [KUserdefaults setObject:appopenid forKey:@"USER_OPENID"];
        
        [self enterFirstPage];
    }else{
        [self showNoticeView:@"请输入正确的用户名密码"];
    }
}

-(void)enterFirstPage {
    RootTabBarController *rootVC = [[RootTabBarController alloc]init];
//    [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
//    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    AppDelegate *app = [AppDelegate shareAppDelegate];
    app.window.rootViewController = rootVC;
    [app.window makeKeyAndVisible];
}

/**点击注册按钮*/
-(void)clickRegistButton{
    [self resignTextFieldFirstresponder];
    RegistViewController *regist = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:regist animated:YES];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignTextFieldFirstresponder];
}
-(void)resignTextFieldFirstresponder{
    [_userNameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];

}

@end
