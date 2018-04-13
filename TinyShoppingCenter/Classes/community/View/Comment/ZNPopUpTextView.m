//
//  ZNPopUpTextView.m
//  beautyreception
//
//  Created by 开发_赵楠 on 15/6/13.
//  Copyright (c) 2015年 iOSMax. All rights reserved.
//

#import "ZNPopUpTextView.h"
//设置颜色
#define Color(Ra,Ga,Ba,Al)  [UIColor colorWithRed:Ra/255.0 green:Ga/255.0 blue:Ba/255.0 alpha:Al]

@implementation ZNPopUpTextView

- (instancetype)initWithTitle:(NSString *)title CluesStr:(NSString *)cluesStr{
    if (self = [super init]) {
        self.m_title = title;
        self.m_cluesStr = cluesStr;
    }
    return self;
}

- (void)initView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    label.text = self.m_title;
    label.textColor = Color(100, 100, 100, 1);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:19];
    [topView addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 60, 50)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [topView addSubview:btn];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setFrame:CGRectMake(SCREEN_WIDTH-60, 0, 60, 50)];
    [okBtn setTitle:@"发送" forState:UIControlStateNormal];
    [okBtn setTitleColor:Color(255, 114, 45, 1) forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(noteEntry) forControlEvents:UIControlEventTouchUpInside];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [topView addSubview:okBtn];
    
    self.m_textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 60, SCREEN_WIDTH-30, 80)];
    self.m_textView.delegate        = self;
    self.m_textView.returnKeyType   = UIReturnKeyNext;
    self.m_textView.layer.borderWidth   = 1;
    self.m_textView.layer.borderColor   = [Color(230, 230, 230, 1) CGColor];
    self.m_textView.layer.cornerRadius  = 6;
    self.m_textView.clipsToBounds   = YES;
    self.m_textView.font            = [UIFont systemFontOfSize:15];
    self.m_textView.text            = self.m_noteStr;
    [self.m_textView becomeFirstResponder];
    [self addSubview:self.m_textView];
    
    if (self.placeholder.length > 0) {
        self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 0, 200, 35)];
        self.placeholderLabel.text = self.placeholder;
        self.placeholderLabel.textColor = Color(200, 200, 200, 1);
        self.placeholderLabel.textAlignment = NSTextAlignmentLeft;
        [self.m_textView addSubview:self.placeholderLabel];
    }
    
    if (SCREEN_WIDTH == 320) {
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 400);
    }else if (SCREEN_WIDTH == 375){
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 450);
    }else{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 500);
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.placeholderLabel.hidden = YES;
    }else{
        self.placeholderLabel.hidden = NO;
    }
}

#pragma mark - Action
/** 展现 */
- (void)show{
    [self initView];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:true];
    UIViewController *topVC = [self appRootViewController];
    [topVC.view addSubview:self];
}

/** 输入完毕 */
- (void)noteEntry{
    
    if (self.m_getNoteStr)
        self.m_getNoteStr (self.m_textView.text);
    if (self.m_textView.text.length>0) {
        [self close];
    }
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


@end
