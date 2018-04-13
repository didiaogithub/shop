//
//  SCRecommendRewardVC.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2018/1/10.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "SCRecommendRewardVC.h"
#import "SCMyCouponViewController.h"
#import "SCFirstPageModel.h"
#import "CKShareManager.h"
#import "UIButton+XN.h"
#import "SCRuleViewController.h"

@interface SCRecommendRewardVC ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *checkCouponBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *ruleBtn;
@property (nonatomic, copy)   NSString *desc;

@end

@implementation SCRecommendRewardVC

//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
//-(void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"推荐有奖";
    self.navigationController.navigationBar.hidden = YES;
    [self initComponent];
    
//    [self requestData];
}

//-(void)requestData {
//
//    NSString *requestUrl = [NSString stringWithFormat:@"%@Wxmall/Index/getCouponImg", WebServiceAPI];
//    [self.view addSubview:self.loadingView];
//    [self.loadingView stopAnimation];
//    [HttpTool getWithUrl:requestUrl params:nil success:^(id json) {
//        NSDictionary *dict = json;
//        if ([dict[@"code"] integerValue] != 200) {
//            return ;
//        }
//        NSString *path = [NSString stringWithFormat:@"%@", dict[@"path"]];
//        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:path]];
//        self.desc = [NSString stringWithFormat:@"%@", dict[@"desc"]];
//
//    } failure:^(NSError *error) {
//
//    }];
//}

#pragma mark - 使用说明
-(void)setUpRightItem {
    
    self.ruleBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 100, 60, 30)];
    [self.ruleBtn setTitle:@"规则" forState:UIControlStateNormal];
    [self.ruleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.ruleBtn setImage:[UIImage imageNamed:@"WhiteRightArrow"] forState:UIControlStateNormal];
    self.ruleBtn.backgroundColor = [UIColor lightGrayColor];
    self.ruleBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [self.ruleBtn addTarget:self action:@selector(showCouponInstruction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ruleBtn];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.ruleBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.ruleBtn.bounds;
    maskLayer.path = path.CGPath;
    self.ruleBtn.layer.mask = maskLayer;
    self.ruleBtn.layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6].CGColor;
    [self.ruleBtn layoutButtonWithEdgeInsetsStyle:XNButtonEdgeInsetsStyleRight imageTitleSpace:2];
}

-(void)showCouponInstruction {
    
    NSString *couponhelpurl = [NSString stringWithFormat:@"%@front/rule/invitation.html", WebServiceAPI];
    SCRuleViewController *rule = [[SCRuleViewController alloc] init];
    rule.url = couponhelpurl;
    [self.navigationController pushViewController:rule animated:YES];
}

- (void)initComponent {
    
    NSString *couponbgurl = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_couponbgurl"]];
    if (IsNilOrNull(couponbgurl)) {
        couponbgurl = @"";
    }
    
    self.bgImageView = [UIImageView new];
    self.bgImageView.userInteractionEnabled = YES;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:couponbgurl]];
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.mas_offset(0);
    }];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20+NaviAddHeight-5, 30, 50)];
    [backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"WhiteBackArrow"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"WhiteBackArrow"] forState:UIControlStateSelected];
    [self.view addSubview:backBtn];
    
    
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareBtn setTitle:@"立即邀请" forState:UIControlStateNormal];
    [self.shareBtn setTitleColor:[UIColor colorWithHexString:@"#FFD998"] forState:UIControlStateNormal];
    self.shareBtn.backgroundColor = [UIColor colorWithHexString:@"#DA3A3A"];
    self.shareBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.shareBtn.layer.cornerRadius = 22.0;
    self.shareBtn.layer.masksToBounds = YES;
    [self.shareBtn addTarget:self action:@selector(shareCoupon) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shareBtn];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset (40);
        make.right.mas_offset(-40);
        make.height.mas_equalTo(44);
        make.bottom.mas_offset(-100-BOTTOM_BAR_HEIGHT);
    }];
    
    
    self.checkCouponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkCouponBtn setTitle:@"查看我的奖励" forState:UIControlStateNormal];
    [self.checkCouponBtn setTitleColor:[UIColor colorWithHexString:@"#C82B2A"] forState:UIControlStateNormal];
    self.checkCouponBtn.backgroundColor = [UIColor whiteColor];
    self.checkCouponBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.checkCouponBtn.layer.cornerRadius = 22.0;
    self.checkCouponBtn.layer.masksToBounds = YES;
    self.checkCouponBtn.layer.borderColor = [UIColor colorWithHexString:@"#C62928"].CGColor;
    self.checkCouponBtn.layer.borderWidth = 1.0;
    [self.checkCouponBtn addTarget:self action:@selector(checkMyCoupon) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.checkCouponBtn];
    [self.checkCouponBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset (40);
        make.right.mas_offset(-40);
        make.height.mas_equalTo(44);
        make.bottom.mas_offset(-30-BOTTOM_BAR_HEIGHT);
    }];
    
    [self setUpRightItem];
}

- (void)clickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkMyCoupon {
    SCMyCouponViewController *myCoupon = [[SCMyCouponViewController alloc] init];
    [self.navigationController pushViewController:myCoupon animated:YES];
}

- (void)shareCoupon {
    
    NSString *firstPageKey = @"1";
    NSString *predicate = [NSString stringWithFormat:@"firstPageKey = '%@'", firstPageKey];
    RLMResults *result =  [[SCFirstPageModel class] objectsWhere:predicate];
    
    SCFirstPageModel *firstPageM = result.firstObject;
    
    NSString *title = [NSString stringWithFormat:@"%@", firstPageM.ckInfoM.name];
    NSString *shareApi = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_mallshareurl"]];
    if (IsNilOrNull(shareApi)) {
        shareApi = [NSString stringWithFormat:@"%@Wapmall/WeChat/share", WebServiceAPI];
    }
    NSString *shareUrl = [NSString stringWithFormat:@"%@?type=index&openid=%@", shareApi, USER_OPENID];
    NSString *logoUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, ShareLogoUrl];
    [CKShareManager shareToFriendWithName:title andHeadImages:logoUrl andUrl:[NSURL URLWithString:shareUrl] andTitle:@"创客云商"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
