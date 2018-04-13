//
//  SCMyPrizeViewController.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/9.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCMyPrizeViewController.h"
#import "OrderBottomView.h"
#import "SCMyPrizeCell.h"
#import "SCConfirmOrderVC.h"
#import "SCMyPrizeModel.h"

@interface SCMyPrizeViewController ()<UITableViewDelegate, UITableViewDataSource, OrderBottomViewDelegate, SCPrizeCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *prizeTable;
@property (nonatomic, strong) OrderBottomView *bottomView;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableArray *selectedRowArr;
@property (nonatomic, strong) SCMyPrizeModel *prizeModel;

@end

@implementation SCMyPrizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"我的奖品";
    
    [self createTableView];

}

-(NSMutableArray *)selectedArray{
    if (_selectedArray == nil) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    return _selectedArray;
}

-(NSMutableArray *)selectedRowArr {
    if (_selectedRowArr == nil) {
        _selectedRowArr = [NSMutableArray array];
    }
    return _selectedRowArr;
}

-(void)createTableView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bottomView = [[OrderBottomView alloc] initWithFrame:CGRectZero andType:@"yes"];
    _bottomView.delegate = self;
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    self.prizeTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.prizeTable.delegate  = self;
    self.prizeTable.dataSource = self;
    self.prizeTable.rowHeight = UITableViewAutomaticDimension;
    self.prizeTable.estimatedRowHeight = 44;
    self.prizeTable.estimatedSectionHeaderHeight = 0.1;
    self.prizeTable.estimatedSectionFooterHeight = 0.1;
    self.prizeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.prizeTable];
    
    [self.prizeTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCMyPrizeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCMyPrizeCell"];
    if (cell == nil) {
        cell = [[SCMyPrizeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCMyPrizeCell"];
    }
    
    [cell refreshCellWithModel:self.prizeModel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *orderNOLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 22)];
    orderNOLabel.backgroundColor = [UIColor whiteColor];
    orderNOLabel.text = @"订单编号:wx123456789";
    
    UILabel *orderTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, SCREEN_WIDTH - 40, 22)];
    orderTimeLabel.textAlignment = NSTextAlignmentRight;
    orderTimeLabel.backgroundColor = [UIColor whiteColor];
    orderTimeLabel.text = @"下单时间:2017-10-09 10:59:58";
    
    [view addSubview:orderNOLabel];
    [view addSubview:orderTimeLabel];
    
    return view;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

-(void)singleClick:(SCMyPrizeModel *)prizeModel anRow:(NSInteger)indexRow andSection:(NSInteger)section {
    
}

#pragma mark-点击bottomView代理方法全选788  点击立即购买 789
-(void)bottomViewButtonClicked:(UIButton *)button{
    NSInteger buttonTag = button.tag -788;
    if (buttonTag == 0){
        button.selected = !button.selected;
        BOOL btselected = button.selected;
        for (int i =0; i<5; i++) {

            SCMyPrizeModel *prizeModel = [[SCMyPrizeModel alloc] init];
            
//            if (btselected){
//                prizeModel.selected = YES;
//                
//            }else{
//                prizeModel.selected = NO;
//                
//            }
            
            [self.prizeTable reloadData];
        }
    }else{
        SCConfirmOrderVC *confirmOrder = [[SCConfirmOrderVC alloc] init];
        [self.navigationController pushViewController:confirmOrder animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
