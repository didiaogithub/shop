//
//  DetailLogisticsViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/21.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "DetailLogisticsViewController.h"
#import "LogistModel.h"
#import "DetailLogistTableViewCell.h"
#import "LogistFirstTableViewCell.h"

@interface DetailLogisticsViewController ()<UITableViewDelegate,  UITableViewDataSource>

@property (nonatomic, strong) LogistModel *logistModel;
@property (nonatomic, strong) UITableView *logistTableView;
@property (nonatomic, strong) NSMutableArray *logistArray;

@end

@implementation DetailLogisticsViewController

-(NSMutableArray *)logistArray{
    if (_logistArray == nil) {
        _logistArray = [[NSMutableArray alloc] init];
    }
    return _logistArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"物流信息";
    [self createTableView];
    [self createLogistData];
}

#pragma mark-请求物流信息
-(void)createLogistData{
//    NSString *orderDetailUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getLogisticsInfo_Url];
    NSString *orderDetailUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Wxmall/Order/getLogisticsList"];

    NSString *oidstr = [NSString stringWithFormat:@"%@", self.oidString];
    if (IsNilOrNull(oidstr)){
        self.oidString = @"";
    }
    NSDictionary *pramaDic = @{@"orderid":oidstr};
    [HttpTool getWithUrl:orderDetailUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            return ;
        }
        
        _logistModel = [[LogistModel alloc] init];
        [_logistModel setValuesForKeysWithDictionary:dict];

        NSString *transmsg = [NSString stringWithFormat:@"%@", dict[@"transmsg"]];
        if (!IsNilOrNull(transmsg)) {
//            self.logistArray = [NSMutableArray arrayWithArray:[transmsg componentsSeparatedByString:@"#"]];
            
            NSArray *a = [transmsg componentsSeparatedByString:@"#"];
            NSMutableArray *infoArray = [NSMutableArray array];
            NSMutableArray *timeArray = [NSMutableArray array];
            
            NSString *number = @"^[1-9]\\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])\\s+(20|21|22|23|[0-1]\\d):[0-5]\\d:[0-5]\\d$";
            NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
            
            for (NSString *str in a) {
                NSString *a = [str substringToIndex:19];
                NSLog(@"%@", str);
                if ([numberPre evaluateWithObject:a]) {
                    [timeArray addObject:a];
                    [infoArray addObject:[str substringFromIndex:19]];
                }else{
                    [infoArray addObject:str];
                }
            }
            
            self.logistArray = [NSMutableArray array];
            if (infoArray.count >= timeArray.count) {
                for (NSInteger i = 0; i<infoArray.count ; i++) {
                    NSString *infoStr = infoArray[i];
                    NSString *timeStr = @"";
                    if (i == timeArray.count) {
                        timeStr = @"";
                    }else{
                        timeStr = timeArray[i];
                    }
                    NSString *transMsg = [NSString stringWithFormat:@"%@\n%@", infoStr, timeStr];
                    [self.logistArray addObject:transMsg];
                }
            }else{
                for (NSInteger i = 0; i<timeArray.count ; i++) {
                    NSString *infoStr = @"";
                    if (i == timeArray.count) {
                        infoStr = @"";
                    }else{
                        infoStr = infoArray[i];
                    }
                    NSString *timeStr = timeArray[i];
                    
                    NSString *transMsg = [NSString stringWithFormat:@"%@\n%@", infoStr, timeStr];
                    [self.logistArray addObject:transMsg];
                }
            }
        }else{
//            self.logistArray = [NSMutableArray arrayWithArray:@[@"【陕西西安电子城公司】的派件员【杨顺卫】正在派件",@"2016-03-11 08:32:22快件已到达【陕西西安电子城公司】", @"2016-03-11 07:35:15由【陕西西安中转部】发往【陕西西安电子城公司】", @"2016-03-11 03:58:19由【陕西西安航空部】发往【陕西西安航空部】", @"2016-03-11 01:07:20【陕西西安航空部】正在进行【发包】扫描",@"2016-03-11 01:07:20【陕西西安锦业路营业部】的收件员【高锋】已收件"]];
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

-(void)createTableView{

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
       return self.logistArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        LogistFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogistFirstTableViewCell"];
        if (cell == nil) {
            cell = [[LogistFirstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LogistFirstTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshLogistWithModel:_logistModel];
        return cell;
    }else{
        DetailLogistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailLogistTableViewCell"];
        if (cell == nil) {
            cell = [[DetailLogistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailLogistTableViewCell"];
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
        
        NSInteger count = self.logistArray.count;
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
        if ([self.logistArray count]) {
            NSString *msg = self.logistArray[indexPath.row];
            [cell refreshWithLogistMsg:msg];
        }
        return cell;
    }
}

@end
