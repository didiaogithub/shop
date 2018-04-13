//
//  SCUseCouponViewController.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/12/15.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCUseCouponViewController.h"
#import "FFAlertView.h"
#import "SCCouponCanUseCell.h"
#import "SCCouponDetailViewController.h"
#import "SCCouponModel.h"
#import "SCCouponCannotUseCell.h"

@interface SCUseCouponViewController ()<UITableViewDelegate, UITableViewDataSource, SCCouponCanUseDelegate, SCCouponCannotUseDelegate>

@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) UIButton *canUseBtn;
@property (nonatomic, strong) UIButton *canNotUseBtn;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UITableView *couponTable;
@property (nonatomic, strong) NSMutableArray *useArray;
@property (nonatomic, strong) NSMutableArray *uselessArray;
@property (nonatomic, copy)   NSString *couponType;
@property (nonatomic, strong) UIImageView *noData;
@property (nonatomic, strong) UILabel *noDataLabel;

@end

@implementation SCUseCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"使用优惠券";
    
    self.couponType = @"1";
    
    [self initComponents];
    
//    if (self.useabelCouponArray.count > 0) {
//        self.useArray = [NSMutableArray array];
//        for (NSDictionary *couponDic in self.useabelCouponArray) {
//            SCCouponModel *couponM = [[SCCouponModel alloc] init];
//            couponM.isExpand = NO;
//            [couponM setValuesForKeysWithDictionary:couponDic];
//            [self.useArray addObject:couponM];
//        }
//        [self.couponTable reloadData];
//    }else{
//        [self resquestCouponData];
//    }
    [self bindData];
}

-(void)bindData {
    
    self.useArray = [NSMutableArray array];
    for (NSDictionary *couponDic in self.useabelCouponArray) {
        SCCouponModel *couponM = [[SCCouponModel alloc] init];
        couponM.isExpand = NO;
        [couponM setValuesForKeysWithDictionary:couponDic];
        [self.useArray addObject:couponM];
    }
    
    self.uselessArray = [NSMutableArray array];
    for (NSDictionary *couponDic in self.unuseabelCouponArray) {
        SCCouponModel *couponM = [[SCCouponModel alloc] init];
        couponM.isExpand = NO;
        [couponM setValuesForKeysWithDictionary:couponDic];
        [self.uselessArray addObject:couponM];
    }
    
    if ([self.couponType isEqualToString:@"1"]) {
        _noData.hidden = (self.useArray.count > 0) ? YES : NO;
        _noDataLabel.hidden = (self.useArray.count > 0) ? YES : NO;
        _confirmBtn.hidden = (self.useArray.count > 0) ? NO : YES;
    }
    
    [self.couponTable reloadData];
}

-(void)initComponents {
    [self setUpRightItem];
    
    _noData = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 347*0.5, 339*0.5)];
    _noData.center = self.view.center;
    _noData.image = [UIImage imageNamed:@"noCoupons"];
    [self.view addSubview:_noData];
    _noData.hidden = YES;
    _noDataLabel = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"#333333"] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:14]];
    _noDataLabel.frame = CGRectMake(0, CGRectGetMaxY(_noData.frame), SCREEN_WIDTH, 30);
    [self.view addSubview:_noDataLabel];
    _noDataLabel.hidden = YES;
    _noDataLabel.text = @"暂无此类优惠券哦~";
    
    self.tagView = [UIView new];
    self.tagView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.view.mas_top).offset(NaviAddHeight+64);
        make.height.mas_equalTo(46);
    }];
    
    self.canUseBtn = [[UIButton alloc] init];
    [self.canUseBtn setTitle:@"可用优惠券" forState:UIControlStateNormal];
    [self.canUseBtn setTitleColor:[UIColor colorWithHexString:@"#E2231A"] forState:UIControlStateNormal];
    self.canUseBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.canUseBtn addTarget:self action:@selector(clickTagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.tagView addSubview:self.canUseBtn];
    self.canUseBtn.tag = 44;
    [self.canUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.bottom.mas_offset(-2);
        make.width.mas_equalTo(SCREEN_WIDTH*0.5);
    }];
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = [UIColor colorWithHexString:@"#E2231A"];
    self.lineLabel.frame = CGRectMake((SCREEN_WIDTH*0.5-100)*0.5, 44, 100, 2);
    [self.tagView addSubview:self.lineLabel];
    
    self.canNotUseBtn = [[UIButton alloc] init];
    [self.canNotUseBtn setTitle:@"不可用优惠券" forState:UIControlStateNormal];
    [self.canNotUseBtn setTitleColor:TitleColor forState:UIControlStateNormal];
    self.canNotUseBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.canNotUseBtn addTarget:self action:@selector(clickTagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.tagView addSubview:self.canNotUseBtn];
    self.canNotUseBtn.tag = 45;
    [self.canNotUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.bottom.mas_offset(-2);
        make.width.mas_equalTo(SCREEN_WIDTH*0.5);
    }];
    
    self.confirmBtn = [[UIButton alloc] init];
    [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#FF2A2A"];
    [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(confirmSelectedCoupon) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.bottom.mas_offset(-20-BOTTOM_BAR_HEIGHT);
        make.height.mas_equalTo(44);
    }];
    
    self.couponTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.couponTable.delegate = self;
    self.couponTable.dataSource = self;
    self.couponTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.couponTable.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        self.couponTable.estimatedSectionHeaderHeight = 10;
        self.couponTable.estimatedSectionFooterHeight = 0.1;
    }
    [self.view addSubview:self.couponTable];
    [self.couponTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.tagView.mas_bottom).offset(0);
        make.bottom.equalTo(self.confirmBtn.mas_top).offset(-10);
    }];
}

-(void)clickTagBtn:(UIButton*)btn {
    NSLog(@"%@", btn.titleLabel.text);
    
    if (btn.tag == 44) {
        [self.canNotUseBtn setTitleColor:TitleColor forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            [self.canUseBtn setTitleColor:[UIColor colorWithHexString:@"#E2231A"] forState:UIControlStateNormal];
           self.lineLabel.frame = CGRectMake((SCREEN_WIDTH*0.5-100)*0.5, 44, 100, 2);
        }];
        self.couponType = @"1";
        
        _noData.hidden = (self.useArray.count > 0) ? YES : NO;
        _noDataLabel.hidden = (self.useArray.count > 0) ? YES : NO;
        _confirmBtn.hidden = (self.useArray.count > 0) ? NO : YES;
        [self.couponTable reloadData];
        
        [self.couponTable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.confirmBtn.mas_top).offset(-10);
        }];
        
        [self.couponTable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.top.equalTo(self.tagView.mas_bottom).offset(0);
            make.bottom.equalTo(self.confirmBtn.mas_top).offset(-10);
        }];
        
        return;
        if (self.useArray.count > 0) {
            _noData.hidden = (self.useArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.useArray.count > 0) ? YES : NO;
            _confirmBtn.hidden = (self.useArray.count > 0) ? NO : YES;
            [self.couponTable reloadData];
        }else{
            //如果有值切换时不再请求
            [self resquestCouponData];
        }
    }else{
        [self.canUseBtn setTitleColor:TitleColor forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            [self.canNotUseBtn setTitleColor:[UIColor colorWithHexString:@"#E2231A"] forState:UIControlStateNormal];
            self.lineLabel.frame = CGRectMake(SCREEN_WIDTH*0.5+(SCREEN_WIDTH*0.5-100)*0.5, 44, 100, 2);
        }];
        self.couponType = @"2";
        
        _noData.hidden = (self.uselessArray.count > 0) ? YES : NO;
        _noDataLabel.hidden = (self.uselessArray.count > 0) ? YES : NO;
        _confirmBtn.hidden = YES;
        [self.couponTable reloadData];
        
        [self.couponTable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.top.equalTo(self.tagView.mas_bottom).offset(0);
            make.bottom.mas_offset(0);
        }];
        
        return;
        if (self.uselessArray.count > 0) {
            _noData.hidden = (self.uselessArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.uselessArray.count > 0) ? YES : NO;
            _confirmBtn.hidden = YES;
            [self.couponTable reloadData];
        }else{
            NSArray *unuseableArray = [[SCCouponTools shareInstance] showCoupons:self.goodsIdArray orderMoney:self.orderMoney canUse:NO];
            if ([unuseableArray count] > 0) {
                self.uselessArray = [NSMutableArray array];
                for (NSDictionary *couponDic in unuseableArray) {
                    SCCouponModel *couponM = [[SCCouponModel alloc] init];
                    couponM.isExpand = NO;
                    [couponM setValuesForKeysWithDictionary:couponDic];
                    [self.uselessArray addObject:couponM];
                }
                [self.couponTable reloadData];
            }else{
                //如果有值切换时不再请求
//                [self resquestCouponData];
            }
        }
    }
}


#pragma mark - 使用说明
-(void)setUpRightItem {
    
    if (@available(iOS 11.0, *)) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"使用说明" style:UIBarButtonItemStylePlain target:self action:@selector(showCouponInstruction)];
        right.tintColor = [UIColor colorWithHexString:@"#333333"];
        self.navigationItem.rightBarButtonItem = right;
    }else{
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"使用说明 " style:UIBarButtonItemStylePlain target:self action:@selector(showCouponInstruction)];
        right.tintColor = [UIColor colorWithHexString:@"#333333"];
        self.navigationItem.rightBarButtonItem = right;
    }
}

-(void)showCouponInstruction {
    [[FFAlertView shareInstance] showAlert:@"优惠券使用说明" content:@"(1) 一笔订单只能使用一张优惠券；\n(2) 优惠券只能抵扣订单金额，优惠金额超出订单金额部分不能再次使用，不能兑换现金；\n(3) 并非所有商品均能使用优惠券，根据优惠券使用范围而定；\n(4) 超过有效期优惠券不能被使用；\n(5) 使用优惠券的订单发生退货，退货金额=退货商品价格—优惠券金额；\n(6) 使用优惠券订单退回后，则优惠券不能再次被使用；\n在法律范围内保留对优惠券使用细则的最终解释权。"];
}

-(void)setCouponBlock:(CouponBlock)couponBlock {
    _couponBlock = couponBlock;
}

-(void)resquestCouponData {
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetCanUseCoupons];
    [self.params setValue:self.couponType forKey:@"type"];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:requestUrl params:self.params success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"msg"]];
            return ;
        }
        
        NSArray *list = dict[@"list"];
        
        if ([self.couponType isEqualToString:@"1"]) {
            self.useArray = [NSMutableArray array];
            for (NSDictionary *couponDic in list) {
                SCCouponModel *couponM = [[SCCouponModel alloc] init];
                couponM.isExpand = NO;
                [couponM setValuesForKeysWithDictionary:couponDic];
                [self.useArray addObject:couponM];
            }
            _noData.hidden = (self.useArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.useArray.count > 0) ? YES : NO;
            _confirmBtn.hidden = (self.useArray.count > 0) ? NO : YES;
        }else{
            self.uselessArray = [NSMutableArray array];
            for (NSDictionary *couponDic in list) {
                SCCouponModel *couponM = [[SCCouponModel alloc] init];
                couponM.isExpand = NO;
                [couponM setValuesForKeysWithDictionary:couponDic];
                [self.uselessArray addObject:couponM];
            }
            _noData.hidden = (self.uselessArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.uselessArray.count > 0) ? YES : NO;
            _confirmBtn.hidden = YES;
        }
        
        [self.couponTable reloadData];
        [self.loadingView stopAnimation];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
    }];
    
    
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.couponType isEqualToString:@"1"]) {
        return self.useArray.count;
    }
    return self.uselessArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.couponType isEqualToString:@"1"]) {
        SCCouponCanUseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponCanUseCell"];
        if (!cell) {
            cell = [[SCCouponCanUseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCCouponCanUseCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        SCCouponModel *couponM = self.useArray[indexPath.section];
        if (!IsNilOrNull(self.couponId)) {
            if ([couponM.couponid isEqualToString:self.couponId]) {
                couponM.isSelected = YES;
            }
        }
        [cell refreshCouponWithCouponModel:couponM];
        
        return cell;
    }else{
        SCCouponCannotUseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponCannotUseCell"];
        if (!cell) {
            cell = [[SCCouponCannotUseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCCouponCannotUseCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        SCCouponModel *couponM = self.uselessArray[indexPath.section];
        [cell refreshCouponWithCouponModel:couponM];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SCCouponModel *couponM = [[SCCouponModel alloc] init];
    if ([self.couponType isEqualToString:@"1"]) {
        couponM = self.useArray[indexPath.section];
    }else{
        couponM = self.uselessArray[indexPath.section];
    }
    
    NSString *details = [NSString stringWithFormat:@"%@", couponM.details];
    if (IsNilOrNull(details)) {
        NSString *content = [NSString stringWithFormat:@"%@", couponM.content];
        if (!IsNilOrNull(content)) {
            details = content;
        }
    }
    
    CGFloat h = [details boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil].size.height+20;

    if ([self.couponType isEqualToString:@"1"]) {
        if (couponM.isExpand == YES){
            return 85+h;
        }
        return 85;
    }else{
        if (couponM.isExpand == YES){
            return 85+h;
        }
        return 85;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark - 确认选择优惠券
-(void)confirmSelectedCoupon {
    
    if (_couponBlock) {
        _couponBlock(self.coupontMoney, self.couponId);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
//    if (IsNilOrNull(self.couponId)) {
//        [self showNoticeView:@"请选择优惠券"];
//    }else{
//        if (_couponBlock) {
//            _couponBlock(self.coupontMoney, self.couponId);
//        }
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

#pragma mark - SCCouponCanUseDelegate
-(void)selectedCoupon:(UIButton*)btn couponM:(SCCouponModel *)couponM {
    
    if ([self.couponType isEqualToString:@"1"]) {
        for (NSInteger i = 0; i < self.useArray.count; i++) {
            SCCouponModel *couponModel = self.useArray[i];
            if ([couponModel.couponid isEqualToString:couponM.couponid]) {

//                couponModel.isSelected = YES;
            }else{
                couponModel.isSelected = NO;
            }
        }
    }
    
    [self.couponTable reloadData];
    
    if (couponM.isSelected) {
        self.couponId = couponM.couponid;
        self.coupontMoney = couponM.money;
    }else{
        self.couponId = @"";
        self.coupontMoney = @"";
    }
}

-(void)expandDetailContent:(SCCouponCanUseCell*)cell {
    
    NSIndexPath *indexPath = [self.couponTable indexPathForCell:cell];
    SCCouponModel *couponM = self.useArray[indexPath.section];
    couponM.isExpand = YES;
    [self.useArray replaceObjectAtIndex:indexPath.section withObject:couponM];
    [self.couponTable reloadData];
}

-(void)closeDetailContent:(SCCouponCanUseCell*)cell {
    NSIndexPath *indexPath = [self.couponTable indexPathForCell:cell];
    SCCouponModel *couponM = self.useArray[indexPath.section];
    couponM.isExpand = NO;
    [self.useArray replaceObjectAtIndex:indexPath.section withObject:couponM];
    [self.couponTable reloadData];
}

#pragma mark - SCCouponCannotUseDelegate
-(void)expandCannotUserDetailContent:(SCCouponCannotUseCell*)cell {
    
    NSIndexPath *indexPath = [self.couponTable indexPathForCell:cell];
    SCCouponModel *couponM = self.uselessArray[indexPath.section];
    couponM.isExpand = YES;
    [self.uselessArray replaceObjectAtIndex:indexPath.section withObject:couponM];
    [self.couponTable reloadData];
}

-(void)closeCannotUserDetailContent:(SCCouponCannotUseCell*)cell {
    NSIndexPath *indexPath = [self.couponTable indexPathForCell:cell];
    SCCouponModel *couponM = self.uselessArray[indexPath.section];
    couponM.isExpand = NO;
    [self.uselessArray replaceObjectAtIndex:indexPath.section withObject:couponM];
    [self.couponTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
