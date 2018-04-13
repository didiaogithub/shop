//
//  CKOfficialAlert.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/31.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKOfficialAlert.h"

#define AlertH SCREEN_HEIGHT/5 + 150

@interface CKOfficialAlert ()<TTTAttributedLabelDelegate>

@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CKOfficialAlert

// 此处实现单利初始化构造方法 此方法会保证MessageAlert 这个类只会被初始化 一次
+ (instancetype)shareInstance {
    static CKOfficialAlert *alert = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alert = [[CKOfficialAlert alloc] init];
        [alert creatUI];
    });
    return alert;
}

- (void)creatUI {
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    //最外层view
    
    self.bigView = [[UIView alloc]init];
    [self addSubview:self.bigView];
    self.bigView.backgroundColor = [UIColor whiteColor];
    self.bigView.layer.cornerRadius = 5;
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(30);
        make.right.mas_offset(-30);
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(AlertH);
    }];
    
    self.titleLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:15.0f]];
    [self.bigView addSubview:self.titleLabel];
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.bigView addSubview:self.contentScrollView];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(self.mas_right).offset(-30);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.bigView.mas_bottom).offset(-10);
    }];
    
    
    self.contentLabel = [[TTTAttributedLabel alloc] init];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.delegate = self;
    self.contentLabel.lineSpacing = 8;
    self.contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber;
    [self.contentScrollView addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScrollView.mas_top);
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
    }];
    
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.deleteButton];
    [self.deleteButton setImage:[UIImage imageNamed:@"activeClose"] forState:UIControlStateNormal];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bigView.mas_bottom).offset(20);
        make.left.mas_offset(SCREEN_WIDTH/2-30);
        make.size.mas_offset(CGSizeMake(60, 60));
    }];
    
    [self.deleteButton addTarget:self action:@selector(closeAlertView) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)showAlert:(NSString *)title content:(NSString*)content {
    
    _titleLabel.text = title;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [content length])];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle};
    CGSize s = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2*(40), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    self.contentScrollView.contentSize = CGSizeMake(0, s.height);
    
    self.contentLabel.text = content;
    
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

#pragma mark - 关闭弹窗
- (void)closeAlertView {
    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"linkClick");
    [[UIApplication sharedApplication] openURL:url];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    NSLog(@"phoneClick");
    
    [self closeAlertView];
    
    NSString *number = [[NSString alloc]initWithFormat:@"telprompt://%@", phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
}


@end
