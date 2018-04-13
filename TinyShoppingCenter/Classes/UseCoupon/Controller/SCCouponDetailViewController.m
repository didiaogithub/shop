//
//  SCCouponDetailViewController.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/12/15.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCCouponDetailViewController.h"
#import "SCCouponDetailCell.h"

@interface SCCouponDetailViewController ()<UITableViewDelegate, UITableViewDataSource, SCCouponDetailDelegate>

@property (nonatomic, strong) UITableView *couponDetailTable;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy)   NSString *coupontype;

@end

@implementation SCCouponDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"优惠券来源";
    
    [self initComponent];
    
    [self resquestCouponDetailData];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.couponM = nil;
}

- (void)initComponent {
    self.couponDetailTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.couponDetailTable.delegate = self;
    self.couponDetailTable.dataSource = self;
    self.couponDetailTable.backgroundColor = [UIColor clearColor];
    self.couponDetailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        self.couponDetailTable.estimatedSectionHeaderHeight = 10;
        self.couponDetailTable.estimatedSectionFooterHeight = 0.1;
    }
    [self.view addSubview:self.couponDetailTable];
    [self.couponDetailTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight);
        }else{
            make.top.equalTo(self.view.mas_top).offset(0);
        }
        make.bottom.mas_offset(-20-BOTTOM_BAR_HEIGHT);
    }];
}

-(void)resquestCouponDetailData {
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetCouponInfoById];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:USER_OPENID forKey:@"openid"];
    [parameters setObject:self.couponM.couponid forKey:@"id"];

    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool getWithUrl:requestUrl params:parameters success:^(id json) {
        
        NSDictionary *itemDic = json;
        if ([itemDic[@"code"] integerValue] != 200) {
            [self.loadingView stopAnimation];
            [self.loadingView showNoticeView:itemDic[@"msg"]];
            return;
        }
        
        self.dataArray = [NSMutableArray array];
        NSArray *orderlistArr = itemDic[@"orderlist"];
        for (NSDictionary *orderDic in orderlistArr) {
            SCCouponDetailModel *couponDetailM = [[SCCouponDetailModel alloc] init];
            [couponDetailM setValuesForKeysWithDictionary:orderDic];
            [self.dataArray addObject:couponDetailM];
        }
        
        self.coupontype = [NSString stringWithFormat:@"%@", itemDic[@"coupontype"]];
        
        [self.couponDetailTable reloadData];
        [self.loadingView stopAnimation];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
    }];
    
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2+self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SCCouponDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponDetailCell"];
        if (!cell) {
            cell = [[SCCouponDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCCouponDetailCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell refreshCouponWithCouponModel:self.couponM];
        return cell;
    }else if(indexPath.section == 1){
        SCCouponDetailTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponDetailTypeCell"];
        if (!cell) {
            cell = [[SCCouponDetailTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCCouponDetailTypeCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!IsNilOrNull(self.coupontype)) {
            cell.typeLabel.text = [NSString stringWithFormat:@"类型:%@", self.coupontype];
        }
        
        return cell;
    }else{
        SCCouponDetailOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponDetailOrderCell"];
        if (!cell) {
            cell = [[SCCouponDetailOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCCouponDetailOrderCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        SCCouponDetailModel *couponDetailM = [[SCCouponDetailModel alloc] init];
        couponDetailM = self.dataArray[indexPath.section - 2];
        [cell refreshCouponOrder:couponDetailM];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat h = [self.couponM.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil].size.height+20;
    
    if (indexPath.section == 0) {
        if (self.couponM.isExpand == YES) {
            return 85+h;
        }else{
            return 85;
        }
    }else if (indexPath.section == 1){
        return 35;
    }
    return 140;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 0.1;
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

-(void)couponDetailExpand:(SCCouponDetailCell *)cell {
    self.couponM.isExpand = YES;
    [self.couponDetailTable reloadData];
}

-(void)couponDetailClose:(SCCouponDetailCell *)cell {
    self.couponM.isExpand = NO;
    [self.couponDetailTable reloadData];
}

@end
