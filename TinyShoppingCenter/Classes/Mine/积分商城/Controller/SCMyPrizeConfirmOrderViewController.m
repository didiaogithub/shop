//
//  SCMyPrizeConfirmOrderViewController.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/14.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCMyPrizeConfirmOrderViewController.h"
#import "AddressModel.h"
#import "SCPrizeConfirmOrderCell.h"
#import "MoneyCountView.h"  //底部合计与立即购买按钮
#import "ChangeMyAddressViewController.h"
#import "SCPayViewController.h"
#import "AddAddressTableViewCell.h"
#import "XWAlterVeiw.h"
#import "SCConfirmOrderAddressCell.h"

@interface SCMyPrizeConfirmOrderViewController ()<UITableViewDelegate, UITableViewDataSource, MoneyCountViewDelegate, AddAddressTableViewCellDelegate>

@property (nonatomic, strong) MoneyCountView *moneyCountView;
@property (nonatomic, strong) UITableView *sureOrderTableView;
@property (nonatomic, strong) AddressModel *addressModel;
@property (nonatomic, strong) NSString *oidStr;
@property (nonatomic, strong) NSString *payfeeStr;

@end

@implementation SCMyPrizeConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单确认";
    
    [self createTableView];
    [self refreshAllPayMoney];
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:USER_DefaultAddress];
    AddressModel *addressModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (addressModel == nil) {
        [self requestDefaultAddress];
    }else{
        _addressModel = addressModel;
    }
}

-(void)refreshAllPayMoney{
    _moneyCountView.allMoneyLable.text = [NSString stringWithFormat:@"%@",self.allMoneyString];
}

-(void)createTableView{
    _moneyCountView = [[MoneyCountView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    _moneyCountView.delegate = self;
    _moneyCountView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_moneyCountView];
    
    _sureOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,5+64, SCREEN_WIDTH, SCREEN_HEIGHT-64-55) style:UITableViewStyleGrouped];
    [self.view addSubview:_sureOrderTableView];
    _sureOrderTableView.backgroundColor = [UIColor tt_grayBgColor];
    
    self.sureOrderTableView.rowHeight = UITableViewAutomaticDimension;
    self.sureOrderTableView.estimatedRowHeight = 44;
    self.sureOrderTableView.estimatedSectionFooterHeight = 0;
    self.sureOrderTableView.estimatedSectionHeaderHeight = 0;
    _sureOrderTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _sureOrderTableView.delegate = self;
    _sureOrderTableView.dataSource = self;
    
}

#pragma mark - 请求默认地址数据
-(void)requestDefaultAddress {
    
    NSString *getDefaultAddressUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetDefaultAddrUrl];
    NSDictionary *pramaDic = @{@"openid": USER_OPENID};
    [HttpTool getWithUrl:getDefaultAddressUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"msg"]];
            return ;
        }
        
        NSString *addrId = [NSString stringWithFormat:@"%@", dict[@"id"]];
        if (!IsNilOrNull(addrId)) {
            self.addressModel = [[AddressModel alloc] init];
            [self.addressModel setValuesForKeysWithDictionary:dict];
            [self.sureOrderTableView reloadData];
            
            NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
            NSString *filePath = [path stringByAppendingPathComponent:USER_DefaultAddress];
            [NSKeyedArchiver archiveRootObject:self.addressModel toFile:filePath];
        }
    } failure:^(NSError *error) {
        [self showNoticeView:@"网络出错了"];
    }];
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 2) {
        return 1;
    }else{
        return self.dataArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){//地址选择
        if (self.addressModel != nil) {
            SCConfirmOrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCConfirmOrderAddressCell"];
            if (cell  == nil) {
                cell = [[SCConfirmOrderAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCConfirmOrderAddressCell"];
            }
            [cell refreshWithAddressModel:self.addressModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor tt_grayBgColor];
            return cell;
        }else{
            AddAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddAddressTableViewCell"];
            if (cell  == nil) {
                cell = [[AddAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddAddressTableViewCell"];
            }
            cell.delegate = self;
            return cell;
        }
    }else if(indexPath.section == 1){//商品 名称  数量  价格
        SCPrizeConfirmOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCPrizeConfirmOrderCell"];
        if (cell == nil) {
            cell = [[SCPrizeConfirmOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCPrizeConfirmOrderCell"];
        }
        if ([self.dataArray count]) {
            self.prizeModel = [self.dataArray objectAtIndex:indexPath.row];
            [cell setModel:self.prizeModel];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        
        SCPrizeConfirmOrderOtherMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCPrizeConfirmOrderOtherMsgCell"];
        if (cell == nil) {
            cell = [[SCPrizeConfirmOrderOtherMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCPrizeConfirmOrderOtherMsgCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableArray *temp = [NSMutableArray array];
        
        for (SCMyPrizeModel *goodModel in self.dataArray) {
            [temp addObject:[NSString stringWithFormat:@"%@", goodModel.num]];
        }
        NSInteger sum = 0;
        for (NSString *count in temp) {
            sum += [count integerValue];
        }
        
        [cell refreshCellWithCount:sum money:self.allMoneyString];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        ChangeMyAddressViewController *address = [[ChangeMyAddressViewController alloc] init];
        [address setAddressBlock:^(AddressModel *addressModel) {
            self.addressModel = addressModel;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.sureOrderTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        address.pushString = @"1";  //从确认订单跳过去
        [self.navigationController pushViewController:address animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

/**没有默认地址时点击跳转*/
-(void)clickToAddressVC{
    ChangeMyAddressViewController *address = [[ChangeMyAddressViewController alloc] init];
    [address setAddressBlock:^(AddressModel *addressModel) {
        self.addressModel = addressModel;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.sureOrderTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    address.pushString = @"1";  //从确认订单跳过去
    [self.navigationController pushViewController:address animated:YES];
}

/**点击立即购买 跳转按钮*/
-(void)moneyCountViewButtonClicked{
    NSString *addressId = nil;
    
    NSString *defaultAddressId = [NSString stringWithFormat:@"%@",self.addressModel.ID];
    if (IsNilOrNull(defaultAddressId)) {
        defaultAddressId = @"";
    }
    addressId = defaultAddressId;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:USER_OPENID forKey:@"openid"];
    [parameters setObject:self.itemid forKey:@"itemids"];
    [parameters setObject:addressId forKey:@"addressid"];
    [parameters setObject:@"0" forKey:@"couponsid"];//优惠券id
    
    NSString *requestUrl =  [NSString stringWithFormat:@"%@%@", WebServiceAPI, MyPrizeGoodsAddOrderUrl];
    [self canPayGoodsRequestWithUrl:requestUrl pramaDic:parameters];
    
}

#pragma mark - 选择好可以支付的商品 先生成订单  再去支付
-(void)canPayGoodsRequestWithUrl:(NSString *)orderUrl pramaDic:(NSDictionary *)pramaDic{
    
    NSLog(@"提交订单111");
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    self.moneyCountView.nowToBuyButton.enabled = NO;
    NSDate *startDate = [NSDate date];
    
    [HttpTool postWithUrl:orderUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSTimeInterval interval =  [[NSDate date] timeIntervalSinceDate:startDate];
        [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:interval];//防止重复点击
        NSDictionary *dict = json;
        if ([dict[@"code"] intValue] != 200) {
            [self showNoticeView:dict[@"msg"]];
            return ;
        }
        
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"亲，您已下单成功！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }];
        
        [alertVC addAction:action];
        UIViewController * vc = [[UIApplication sharedApplication].keyWindow rootViewController];
        [vc presentViewController:alertVC animated:YES completion:nil];
        
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:startDate];
        [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:interval];//防止重复点击
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

-(void)changeButtonStatus{
    self.moneyCountView.nowToBuyButton.enabled =YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
