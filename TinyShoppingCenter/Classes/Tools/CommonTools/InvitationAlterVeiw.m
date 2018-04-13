

#import "InvitationAlterVeiw.h"
@interface InvitationAlterVeiw ()

@end

@implementation InvitationAlterVeiw
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        //最底下的view
        self.bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 80, 160)];
        _bigView.layer.cornerRadius = 5;
//        _bigView.layer.masksToBounds = YES;
        _bigView.backgroundColor = [UIColor whiteColor];
        _bigView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
        //背景效果
        _bigView.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
        _bigView.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
        _bigView.layer.shadowOpacity = 1;//阴影透明度，默认0
        _bigView.layer.shadowRadius = 10;//阴影半径，默认3
        [self addSubview:_bigView];
        _bigView.layer.cornerRadius = 3;
        _bigView.layer.masksToBounds = YES;

        float buttonWidth = _bigView.frame.size.width;
    
        //最上面放图片
        _noticeLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:15.0f]];
        _noticeLable.frame = CGRectMake(0, 0, buttonWidth, 35);
        _noticeLable.text = @"    店铺微信号：";
        _noticeLable.backgroundColor = [UIColor tt_grayBgColor];
        [_bigView addSubview:_noticeLable];
        
        UILabel *line = [UILabel creatLineLable];
        [_bigView didAddSubview:line];
        line.frame = CGRectMake(0, 20, SCREEN_WIDTH - 80, 1);
        

        //邀请码中间的信息
        _titleLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:15.0f]];
        _titleLable.numberOfLines = 2;
        _titleLable.frame = CGRectMake(10, CGRectGetMaxY(_noticeLable.frame)+20, buttonWidth-20, 50);
        [_bigView addSubview:_titleLable];

        
        UILabel *horizalLable = [UILabel creatLineLable];
        horizalLable.frame = CGRectMake(0, CGRectGetMaxY(_titleLable.frame)+20, _bigView.frame.size.width, 1);
        [_bigView addSubview:horizalLable];
        
        _sureBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBut.bounds = CGRectMake(0, 0, CGRectGetWidth(_bigView.frame)/ 2, 44);
        _sureBut.center = CGPointMake(CGRectGetWidth(_bigView.bounds)/4, CGRectGetHeight(_bigView.bounds) - 44 + 24);
        [_sureBut setTitleColor:CKYS_Color(149, 149, 149) forState:UIControlStateNormal];
        [_sureBut addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
 
        [_sureBut setTitle:@"关闭" forState:UIControlStateNormal];
        [_bigView addSubview:_sureBut];
        
        UILabel *verticalLable = [UILabel creatLineLable];
        verticalLable.frame = CGRectMake(CGRectGetMaxX(_sureBut.frame), CGRectGetMaxY(horizalLable.frame), 1,_sureBut.frame.size.height);
        [_bigView addSubview:verticalLable];
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.bounds = CGRectMake(0, 0, CGRectGetWidth(_bigView.frame)/ 2, 44);
        _cancelBtn.center = CGPointMake(3 * CGRectGetWidth(_bigView.bounds)/4, CGRectGetHeight(_bigView.bounds) - 44 + 24);
        [_cancelBtn setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"复制" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
        [_bigView addSubview:_cancelBtn];
        _bigView.transform = CGAffineTransformMakeScale(0, 0);
        _noticeLable.transform = CGAffineTransformMakeScale(0,0);
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
/**点击确定按钮*/
- (void)sureButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(copyInvitationCode)]) {
        [self dissmiss];
        [self.delegate copyInvitationCode];
    }
}

- (void)dissmiss {
    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_bigView removeFromSuperview];
        
    }];
}
/**点击取消按钮*/
- (void)clickCancelButton {
    [self dissmiss];
}

- (void)keyboardShow:(NSNotification *)no {
    CGRect recg = [no.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    if (recg.origin.y != SCREEN_HEIGHT) {
        if (recg.origin.y - _bigView.frame.origin.y < CGRectGetHeight(_bigView.frame) + 20) {
            [UIView animateWithDuration:0.25 animations:^{
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                _titleLable.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(_bigView.frame)/2);
                _bigView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(_bigView.frame)/2);
            }];
        }
    }
}

- (void)keyboardHide:(NSNotification *)no {
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _bigView.transform = CGAffineTransformIdentity;
        _titleLable.transform = CGAffineTransformIdentity;
        _noticeLable.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {

    }];
}


- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _bigView.transform = CGAffineTransformIdentity;
        _titleLable.transform = CGAffineTransformIdentity;
        _noticeLable.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [_titleLable becomeFirstResponder];
    }];
}

@end
