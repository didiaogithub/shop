//
//  WebDetailViewController.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/24.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "WebDetailViewController.h"

@interface WebDetailViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *detailWkWebView;

@end

@implementation WebDetailViewController


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.loadingView stopAnimation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([self.type isEqualToString:@"help"]){
        self.navigationItem.title = @"帮助";
    }else if ([self.type isEqualToString:@"our"]){
        self.navigationItem.title = @"关于我们";
    }else{
        self.navigationItem.title = @"详情";
    }
    [self createWebView];
    
}

-(void)createWebView {
    
    self.detailWkWebView = [[WKWebView alloc] init];
    if (@available(iOS 11.0, *)) {
        self.detailWkWebView.frame = CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-65-NaviAddHeight-BOTTOM_BAR_HEIGHT);
    }else{
        self.detailWkWebView.frame = CGRectMake(0, 1, SCREEN_WIDTH, SCREEN_HEIGHT-1);
    }
    
    self.detailWkWebView.navigationDelegate = self;
    self.detailWkWebView.UIDelegate = self;
    self.detailWkWebView.backgroundColor = [UIColor tt_grayBgColor];
    NSURL *url = [NSURL URLWithString:self.detailUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.detailWkWebView loadRequest:request];
    [self.view addSubview:self.detailWkWebView];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"开始加载");
    self.viewNetError.position = JGProgressHUDPositionCenter;
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [self.loadingView.blackBt addTarget:self action:@selector(hiddenAnim:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)hiddenAnim:(UIButton*)sender {
    [self.loadingView stopAnimation];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"出错了webview");
    [self.loadingView stopAnimation];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"webview提交数据");
    [self.loadingView stopAnimation];
}

#pragma mark-重写返回按钮
-(void)backClick:(id)sender{

    if ([self.detailWkWebView canGoBack]) {
        [self.detailWkWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}
-(void)dealloc{
    [self.loadingView stopAnimation];
}



@end
