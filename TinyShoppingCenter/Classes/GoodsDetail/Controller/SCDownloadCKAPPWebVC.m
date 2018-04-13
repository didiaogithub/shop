//
//  SCDownloadCKAPPWebVC.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/13.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCDownloadCKAPPWebVC.h"

@interface SCDownloadCKAPPWebVC()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *mallWeb;

@end

@implementation SCDownloadCKAPPWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"创客云商-轻创业平台";
    _mallWeb = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_mallWeb];
    NSString *urlStr = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"ckappdownloadurl"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    _mallWeb.delegate = self;
    
//    [self.view addSubview:self.loadingView];
//    [self.loadingView startAnimation];
    [_mallWeb loadRequest:request];
}

//-(void)webViewDidFinishLoad:(UIWebView *)webView {
//    if (!webView.isLoading) {
//        [self.loadingView stopAnimation];
//    }
//}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *str = request.URL.absoluteString;
    if ([str containsString:@"https://itunes.apple.com"]) {
        NSURL *appUrl = [NSURL URLWithString:str];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"打开App Store" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIViewController *vc = [[UIApplication sharedApplication].keyWindow rootViewController];
            [vc presentViewController:alertVC animated:YES completion:nil];
            [[UIApplication sharedApplication] openURL:appUrl];
        }];
        
        UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
            
        [alertVC addAction:action];
        [alertVC addAction:actionCancel];
        UIViewController *vc = [[UIApplication sharedApplication].keyWindow rootViewController];
        [vc presentViewController:alertVC animated:YES completion:nil];
    }

    return YES;
}

@end
