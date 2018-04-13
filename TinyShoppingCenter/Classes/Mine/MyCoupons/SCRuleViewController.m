//
//  SCRuleViewController.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2018/1/11.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "SCRuleViewController.h"

@interface SCRuleViewController ()<WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) WKWebView *tipDetailWebView;

@end

@implementation SCRuleViewController

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"奖励规则";
    
    [self initView];
}

- (void)initView {
    
    self.tipDetailWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
    if (@available(iOS 11.0, *)) {
        self.tipDetailWebView.frame = CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-NaviAddHeight-BOTTOM_BAR_HEIGHT);
    }else{
        self.tipDetailWebView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviAddHeight-BOTTOM_BAR_HEIGHT);
    }
    
    [self.tipDetailWebView setBackgroundColor:[UIColor tt_grayBgColor]];
    self.tipDetailWebView.opaque = NO;
    self.tipDetailWebView.navigationDelegate = self;
    self.tipDetailWebView.UIDelegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.tipDetailWebView loadRequest:request];
    [self.view addSubview:self.tipDetailWebView];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSLog(@"开始加载");
    self.viewNetError.position = JGProgressHUDPositionCenter;
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"webview提交数据");
    [self.loadingView stopAnimation];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@", error);
    [self.loadingView stopAnimation];
}

//-(BOOL)navigationShouldPopOnBackButton {
//    
//    if ([self.tipDetailWebView canGoBack]) {
//        [self.tipDetailWebView goBack];
//        return NO;
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//        return YES;
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
