//
//  RegistViewController.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 16/10/25.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "RegistViewController.h"
#import "CheckUserModel.h"

@interface RegistViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *userNamephoneImageView;
@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UIImageView *passwordImageView;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIImageView *moreTimePassWordImageView;
@property (nonatomic, strong) UITextField *moreTimePasswordTextField;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    [self createViews];
}

-(void)createViews{
    
    UIView *bankView = [[UIView alloc] init];
    [self.view addSubview:bankView];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(64+20);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 400));
    }];
    
    
    _userNamephoneImageView = [[UIImageView alloc] init];
    UIImage *telImage = [UIImage imageNamed:@"手机"];
    [_userNamephoneImageView setImage:[telImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    _userNamephoneImageView.frame = CGRectMake(10, 0, 34, 21);
    _userNamephoneImageView.contentMode= UIViewContentModeCenter;
    
    
    _userNameTextField = [[UITextField alloc] init];
    [bankView  addSubview:_userNameTextField];
    _userNameTextField.delegate = self;
    [_userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(15);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH - 30, 50));
    }];
    _userNameTextField.placeholder = @"请输入用户名";
    _userNameTextField.leftView = _userNamephoneImageView;
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
    _passwordTextField.delegate = self;
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameTextField.mas_bottom).offset(15);
        make.left.equalTo(_userNameTextField.mas_left);
        make.size.mas_offset(CGSizeMake((SCREEN_WIDTH - 30), 50));
    }];
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.secureTextEntry  = YES;
    
    
    _passwordTextField.leftView = _passwordImageView;
    _passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    //再次输入密码
    _moreTimePassWordImageView = [[UIImageView alloc] init];
    [_moreTimePassWordImageView setImage:[codeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    _moreTimePassWordImageView.frame = CGRectMake(10, 0, 35, 21);
    _moreTimePassWordImageView.contentMode= UIViewContentModeCenter;
  
    
    _moreTimePasswordTextField = [[UITextField alloc] init];
    [bankView addSubview:_moreTimePasswordTextField];
    _moreTimePasswordTextField.delegate = self;
    _moreTimePasswordTextField.placeholder = @"请再次输入密码";
     _moreTimePasswordTextField.secureTextEntry  = YES;
    _moreTimePasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _moreTimePasswordTextField.leftView = _moreTimePassWordImageView;
    _moreTimePasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [_moreTimePasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.mas_bottom).offset(15);
        make.left.equalTo(_passwordTextField.mas_left);
        make.size.mas_offset(CGSizeMake((SCREEN_WIDTH - 30), 50));
    }];
    
    UIButton *registButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:registButton];
    registButton.layer.cornerRadius = 5;
    [registButton setTitle:@"注册" forState:UIControlStateNormal];
    [registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moreTimePasswordTextField.mas_bottom).offset(40);
        make.left.equalTo(_moreTimePasswordTextField.mas_left);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH - 30, 50));
    }];
    registButton.backgroundColor = [UIColor tt_redMoneyColor];
    [registButton addTarget:self action:@selector(clickRegistButton) forControlEvents:UIControlEventTouchUpInside];
}
/**点击注册按钮*/
-(void)clickRegistButton{
    [self resignTextFieldFirstresponder];

        if (IsNilOrNull(_userNameTextField.text)){
            [self showNoticeView:@"用户名不能为空"];
            return;
        }
        if (IsNilOrNull(_passwordTextField.text)){
            [self showNoticeView:@"密码不能为空"];
            return;
        }
        if (IsNilOrNull(_moreTimePasswordTextField.text)){
            [self showNoticeView:@"确认密码不能为空"];
            return;
        }
        if (![_passwordTextField.text isEqualToString:_moreTimePasswordTextField.text]) {
            [self showNoticeView:@"两次输入密码不一致"];
            return;
        }
    NSString *userName = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:_userNameTextField.text]];
    if (!IsNilOrNull(userName)) {
        [self resignTextFieldFirstresponder];
        [self showNoticeView:@"该帐号已存在"];
        return;
    }else{
        [KUserdefaults setObject:_passwordTextField.text forKey:_userNameTextField.text];
        [KUserdefaults setObject:@"loginWithCheckPhone" forKey:@"loginWithCheckPhone"];
        [self showNoticeView:@"注册成功"];
            
        NSString *key = [NSString stringWithFormat:@"user%@", _userNameTextField.text];
        [KUserdefaults setObject:OpenidForRegist forKey:key];
        [KUserdefaults setObject:OpenidForRegist forKey:@"USER_OPENID"];
        
        [self enterFirstPage];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _userNameTextField) {
        NSString *userName = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:_userNameTextField.text]];
        if (!IsNilOrNull(userName)) {
            [self resignTextFieldFirstresponder];
            [self showNoticeView:@"该帐号已存在"];
            return;
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignTextFieldFirstresponder];
}

-(void)resignTextFieldFirstresponder{
    [_userNameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_moreTimePasswordTextField resignFirstResponder];
}

-(void)enterFirstPage {
    RootTabBarController *rootVC = [[RootTabBarController alloc]init];
//    [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
//    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    AppDelegate *app = [AppDelegate shareAppDelegate];
    app.window.rootViewController = rootVC;
    [app.window makeKeyAndVisible];
}

@end
