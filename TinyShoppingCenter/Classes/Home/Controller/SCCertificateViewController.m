//
//  SCCertificateViewController.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCCertificateViewController.h"

@interface SCCertificateViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *backGroundView;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation SCCertificateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    [self bigPhotoAndReducePhoto:self.honourString];
    
}

-(void)createUI{
    _backGroundView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backGroundView.delegate = self;
    _backGroundView.backgroundColor = [UIColor blackColor];
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _iconImageView.userInteractionEnabled = YES;
    _backGroundView.maximumZoomScale = 3.0;
    _backGroundView.minimumZoomScale = 1.0;
}
-(void)bigPhotoAndReducePhoto:(NSString *)urlString {//点击图片放大缩小
    
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@""]];
    [[UIApplication sharedApplication].keyWindow addSubview:_backGroundView];
    
    // 单击手势：
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTapIconImageAction:)];
    tapRecognize.numberOfTapsRequired = 1;
    [_backGroundView addGestureRecognizer:tapRecognize];
    // 双击手势：
    UITapGestureRecognizer *zoomTapRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoTapIconImageAction:)];
    zoomTapRecognize.numberOfTapsRequired = 2.0f;
    [_backGroundView addGestureRecognizer:zoomTapRecognize];
    [_backGroundView addSubview:_iconImageView];
    // 增加关联手势的响应顺序：
    [tapRecognize requireGestureRecognizerToFail:zoomTapRecognize];
}

#pragma mark 点击放大图片的代理方法：
// 返回需要缩放的View:
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _iconImageView;
}
// 开始缩放：
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat hight = CGRectGetHeight(scrollView.bounds);
    CGFloat contentWidth = scrollView.contentSize.width;
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat delta_x = width > contentWidth ? (width - contentWidth) / 2 : 0;
    CGFloat delta_y = hight > contentHeight ? (hight - contentHeight) / 2 : 0;
    _iconImageView.center = CGPointMake(contentWidth / 2 + delta_x, contentHeight / 2 + delta_y);
}
// 缩放结束之后：
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    view.transform = CGAffineTransformMakeScale(scale, scale);
}
// 点击图片单击的响应方法：
- (void)oneTapIconImageAction:(UITapGestureRecognizer *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
// 点击图片双击的响应方法：
- (void)twoTapIconImageAction:(UITapGestureRecognizer *)sender {
    _backGroundView.zoomScale += 0.8;
    if (_backGroundView.zoomScale >= 3.0) {
        _backGroundView.zoomScale = 1;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _backGroundView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
