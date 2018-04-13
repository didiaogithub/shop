//
#import "MessageAlert.h"

#import "CommonLoginViewController.h"
#import "SCLoginViewController.h"
#import "RootNavigationController.h"


@interface MessageAlert ()

@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *sureBut;


@end

@implementation MessageAlert

// 此处实现单利初始化构造方法 此方法会保证MessageAlert 这个类只会被初始化 一次
+ (instancetype)shareInstance {
    static MessageAlert *alert = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alert = [[MessageAlert alloc] init];
        [alert creatUI];
    });
    return alert;
}

- (void)creatUI {
    self.frame = [UIScreen mainScreen].bounds;
    //最外层view
    
    self.bigView = [[UIView alloc]init];
    [self addSubview:self.bigView];
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(50*SCREEN_WIDTH_SCALE);
        make.right.mas_offset(-50*SCREEN_WIDTH_SCALE);
        make.center.mas_equalTo(self);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    [self.bigView addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bigView.mas_left).offset(10);
        make.top.equalTo(self.bigView.mas_top).offset(15);
        make.right.equalTo(self.bigView.mas_right).offset(-10);
        make.height.mas_equalTo(70);
    }];
    

    UILabel *horizalLable = [UILabel creatLineLable];
    [_bigView addSubview:horizalLable];
    [horizalLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.mas_offset(0);
        make.width.equalTo(_bigView.mas_width);
        make.height.mas_offset(1);
    }];
    
    _sureBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bigView addSubview:_sureBut];
    [_sureBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizalLable.mas_bottom);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
        make.height.mas_offset(45);
    }];
    
    // 设置控件属性
    [_sureBut setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];
    [_sureBut addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
    [_sureBut setTitle:@"确定" forState:UIControlStateNormal];
      
    _bigView.transform = CGAffineTransformMakeScale(0, 0);
    
    self.bigView.layer.cornerRadius = 5;
    self.bigView.backgroundColor = [UIColor whiteColor];
    
    //背景效果
    self.bigView.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
    self.bigView.layer.shadowOffset = CGSizeMake(3,3);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.bigView.layer.shadowOpacity = 1;//阴影透明度，默认0
    self.bigView.layer.shadowRadius = 10;//阴影半径，默认3
}

- (void)showAlert:(NSString *)title {
    _titleLabel.text = title;
    [self.bigView layoutIfNeeded];

    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        self.alpha = 1;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _bigView.transform = CGAffineTransformIdentity;
        _titleLabel.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

/**点击确定按钮*/
- (void)sureButton {
    [self dissmiss];
    
    
    NSString *iosCheckCode = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"IOS_CheckCode"]];
    if ([iosCheckCode isEqualToString:@"200"]) {
        SCLoginViewController *welcome =[[SCLoginViewController alloc] init];
        RootNavigationController *welcomeNav = [[RootNavigationController alloc] initWithRootViewController:welcome];
        AppDelegate *app = [AppDelegate shareAppDelegate];
        app.window.rootViewController = welcomeNav;
        [app.window makeKeyAndVisible];
    }else{
        CommonLoginViewController *login = [[CommonLoginViewController alloc] init];
        RootNavigationController *loginNavi = [[RootNavigationController alloc] initWithRootViewController:login];
        AppDelegate *app = [AppDelegate shareAppDelegate];
        app.window.rootViewController = loginNavi;
        [app.window makeKeyAndVisible];
    }
    
}

- (void)dissmiss {
    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

@end
