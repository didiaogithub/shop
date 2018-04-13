//
//  PaySuccessViewController.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "PaySuccessView.h"
#import "UIViewController+BackButtonHandler.h"
#import "XWAlterVeiw.h"
#import "SCDownloadCKAPPWebVC.h"

@interface PaySuccessViewController ()<XWAlterVeiwDelegate>

@property(nonatomic,strong)PaySuccessView *successView;

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单完成";
    [self createUI];
}

-(void)createUI{
    _successView = [[PaySuccessView alloc] initWithFrame:CGRectZero paymentType:self.paymentType payfeeStr:self.payfeeStr orderid:self.orderid];
    [self.view addSubview:_successView];
    [_successView setBackgroundColor:[UIColor whiteColor]];
    [_successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(74+NaviAddHeight);
        make.left.right.mas_offset(0);
        make.height.mas_offset(200);
    }];
    
    if ([self.isdlbitem isEqualToString:@"true"] || [self.isdlbitem isEqualToString:@"1"]) {
        //跳转到下载下载创客app页面
        XWAlterVeiw *alert = [[XWAlterVeiw alloc] init];
        alert.delegate = self;
        
        NSString *tip = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"BecomeCKMsg"]];
        alert.titleLable.text = tip;
        [alert show];
    }
}

-(void)subuttonClicked {
    SCDownloadCKAPPWebVC *downVC = [[SCDownloadCKAPPWebVC alloc] init];
    [self.navigationController pushViewController:downVC animated:YES];
}

-(BOOL)navigationShouldPopOnBackButton {
    [self.navigationController popToRootViewControllerAnimated:YES];
    return NO;
}

@end
