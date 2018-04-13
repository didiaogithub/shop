//
//  CKCLogisticsDetailVC.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2018/1/31.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKCLogisticsDetailVC.h"
#import "CKCLogisticsModel.h"
#import "SCLogisticsDetailCell.h"

@interface CKCLogisticsDetailVC ()<UITableViewDelegate,  UITableViewDataSource>

@property (nonatomic, strong) CKCLogisticsModel *logisticsM;
@property (nonatomic, strong) UITableView *logistTableView;

@end


@implementation CKCLogisticsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"物流信息";
    [self createTableView];
    [self requestLogisticsData];
}

#pragma mark - 请求物流信息
- (void)requestLogisticsData {

    NSString *orderDetailUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Wxmall/Order/getLogisticsList"];
    
    NSString *oidstr = [NSString stringWithFormat:@"%@", self.oidString];
    if (IsNilOrNull(oidstr)){
        return;
    }
    NSDictionary *pramaDic = @{@"orderid":oidstr};
    [HttpTool getWithUrl:orderDetailUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            return ;
        }
        
        self.logisticsM = [[CKCLogisticsModel alloc] init];
        [self.logisticsM setValuesForKeysWithDictionary:dict];
        self.logisticsM.infoArray = [NSMutableArray array];
        for (NSDictionary *infoDic in dict[@"list"]) {
            CKCLogistInfoModel *infoModel = [[CKCLogistInfoModel alloc] init];
            [infoModel setValuesForKeysWithDictionary:infoDic];
            [self.logisticsM.infoArray addObject:infoModel];
        }
        
        [self.logistTableView reloadData];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

- (void)createTableView {
    
    _logistTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 69 + NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-69-NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
    _logistTableView.delegate  = self;
    _logistTableView.dataSource = self;
    self.logistTableView.backgroundColor = [UIColor tt_grayBgColor];
    _logistTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.logistTableView.rowHeight = UITableViewAutomaticDimension;
    self.logistTableView.estimatedRowHeight = 44;
    [self.view addSubview:_logistTableView];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    if(section == 1){
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
        [headerView addSubview:titleLable];
        titleLable.text = @"物流追踪";
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(15);
            make.left.mas_offset(15);
        }];
        UILabel *lineLable = [UILabel creatLineLable];
        [headerView addSubview:lineLable];
        [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLable.mas_bottom).offset(15);
            make.left.right.mas_offset(0);
            make.height.mas_offset(1);
        }];
        return headerView;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1){
        return 40;
    }else{
        return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.logisticsM.infoArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SCLogisticsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCLogisticsDetailCell"];
        if (cell == nil) {
            cell = [[SCLogisticsDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCLogisticsDetailCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshLogistWithModel:self.logisticsM];
        return cell;
    }else{
        SCLogisticsDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"SCLogisticsDetailInfoCell%ld", indexPath.row]];
        if (cell == nil) {
            cell = [[SCLogisticsDetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"SCLogisticsDetailInfoCell%ld", indexPath.row]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row == 0){
            [cell.verticalLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(20);
            }];
            [cell.imageViewR mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.verticalLable.mas_top);
                make.left.mas_offset(20.5);
                make.size.mas_offset(CGSizeMake(20, 20));
            }];
            [cell.imageViewR setImage:[UIImage imageNamed:@"logist_green"]];
        }else{
            [cell.verticalLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(0);
            }];
            [cell.imageViewR mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.verticalLable.mas_top).offset(20);
                make.left.mas_offset(25);
                make.size.mas_offset(CGSizeMake(10, 10));
            }];
            [cell.imageViewR setImage:[UIImage imageNamed:@"logist_grey"]];
        }
        
        NSInteger count = self.logisticsM.infoArray.count;
        if(count-1 == indexPath.row){
            [cell.verticalLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(cell.imageViewR.mas_top);
            }];
            cell.bottomLable.hidden = YES;
        }else{
            [cell.verticalLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_offset(0);
            }];
            cell.bottomLable.hidden = NO;
        }
        if ([self.logisticsM.infoArray count]) {
            CKCLogistInfoModel *infoModel = self.logisticsM.infoArray[indexPath.row];
            [cell refreshWithLogistMsg:infoModel];
        }
        return cell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
