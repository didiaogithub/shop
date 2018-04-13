//
//  ckc_CustomProgressView.m
//  Thinkcoo_2.0
//
//  Created by 庞宏侠 on 16/6/30.
//  Copyright © 2016年 link. All rights reserved.
//

#import "CKC_CustomProgressView.h"
#import "UIImage+GIF.h"

@interface CKC_CustomProgressView()


@end

@implementation CKC_CustomProgressView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        //蒙版按钮  防止重复点击
        _blackBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _blackBt.backgroundColor = [UIColor clearColor];
        [self addSubview:_blackBt];
        [_blackBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [_blackBt addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
        
        //中间loading
        _progressView = [[UIImageView alloc] init];
        [self addSubview:_progressView];
        _progressView.contentMode = UIViewContentModeScaleAspectFit;
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.mas_offset(SCREEN_WIDTH/2-22);
            make.top.mas_offset((SCREEN_HEIGHT-64-49)/2-22);
            make.width.mas_offset(44);
            make.height.mas_offset(44);
        }];
        
        NSMutableArray *imageArray = [NSMutableArray array];
        for (NSInteger i = 1; i < 12; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.png", i]];
            if (image) {
                [imageArray addObject:image];
            }
        }
        
        _progressView.animationImages = imageArray;
        _progressView.animationDuration = 0.5; // in seconds
        [self setHidden:YES];
    }
    return self;
}

- (void)clicked {
    NSLog(@"点我...");
}

/**
 *  开始动画
 */
- (void)startAnimation
{
    [self setHidden:NO];
    [_progressView startAnimating]; // starts animating
}
/**
 * 结束动画
 */
- (void)stopAnimation {
    [self setHidden:YES];
    [_progressView stopAnimating]; // starts animating
    [self removeFromSuperview];
}

- (void)showNoticeView:(NSString*)title {
    if (IsNilOrNull(title)){
        title = @"";
    }
    [self createNoticeView];
    if (self.viewNetError && !self.viewNetError.visible && title.length > 0) {
        self.viewNetError.textLabel.text = title;
        [self.viewNetError showInView:[UIApplication sharedApplication].keyWindow];
        [self.viewNetError dismissAfterDelay:1.5f];
    }
}

-(void)createNoticeView {
    // 增加网络错误时提示
    self.viewNetError = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.viewNetError.indicatorView = nil;
    self.viewNetError.userInteractionEnabled = NO;
    self.viewNetError.position = JGProgressHUDPositionBottomCenter;
    self.viewNetError.marginInsets = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
}

@end
