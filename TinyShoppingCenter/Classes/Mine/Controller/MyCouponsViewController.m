//
//  MyCouponsViewController.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/20.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "MyCouponsViewController.h"
#import "MyCouposTableViewCell.h"
#import "MyCouposModel.h"
#import "CouponsDetailViewController.h"
@interface MyCouponsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *buttonArray;
@property(nonatomic,strong)UIButton *topButton;
@property(nonatomic,strong)UILabel *redLine;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)MyCouposModel *couponsModel;

@end

@implementation MyCouponsViewController
-(NSMutableArray *)dataArray{
    if (_dataArray == nil){
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的优惠券";
    [self createTopButton];
    [self createTableView];
    [self getMyListData];
    
   
}
-(void)getMyListData{
    
    NSDictionary *pramaDic = @{@"ckid":@"50",@"pagesize":@"20",@"id":@"0",@"deviceid":@""};

    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebOfflineServiceAPI,getMyTeamCkList_Url];
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        NSArray *listArr = dict[@"members"];
        for (NSDictionary *customerDic in listArr) {
            self.couponsModel = [[MyCouposModel alloc] init];
            [self.couponsModel setValuesForKeysWithDictionary:customerDic];
            self.couponsModel.isOpen = NO;
            [self.dataArray addObject:self.couponsModel];
        }
        [self.couponsTableView reloadData];

    } failure:^(NSError *error) {
        
    }];
  
}

- (void)createTableView{
    
    _couponsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,65+AdaptedHeight(45), SCREEN_WIDTH, SCREEN_HEIGHT - 5-AdaptedHeight(45)) style:UITableViewStylePlain];
    _couponsTableView.backgroundColor = [UIColor tt_grayBgColor];
    _couponsTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _couponsTableView.rowHeight = UITableViewAutomaticDimension;
    _couponsTableView.estimatedRowHeight = 44;
    _couponsTableView.delegate = self;
    _couponsTableView.dataSource = self;
    [self.view addSubview:_couponsTableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        MyCouposTableViewCell *couposCell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"MyCouposTableViewCell%ld", indexPath.row]];
        if (couposCell == nil) {
            couposCell = [[MyCouposTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"MyCouposTableViewCell%ld", indexPath.row]];
        }
        couposCell.selectionStyle = UITableViewCellSelectionStyleNone;
        couposCell.index = indexPath.row;
        couposCell.backgroundColor = [UIColor tt_grayBgColor];
        if ([self.dataArray count]) {
            self.couponsModel = self.dataArray[indexPath.row];
            couposCell.couponsModel = self.couponsModel;
           [couposCell refreshWithListModel:self.couponsModel];
        }

        //自定义cell的回调，获取要展开/收起的cell。刷新点击的行
        couposCell.showMoreTextBlock = ^(MyCouposModel *couponsModel){
            
            NSInteger index = [self.dataArray indexOfObject:couponsModel];
            couponsModel.isOpen = !couponsModel.isOpen;
            [self.dataArray replaceObjectAtIndex:index withObject:couponsModel];
        
            //一个cell刷新
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.couponsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        return couposCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CouponsDetailViewController *detailVC = [[CouponsDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];

}

/**创建订单状态按钮*/
-(void)createTopButton{
    _buttonArray = [NSMutableArray array];
    
    UIView *bankView = [[UIView alloc] init];
    bankView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bankView];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(65);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, AdaptedHeight(45)));
    }];
    NSArray *titleArr = @[@"未使用",@"已使用",@"已过期"];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        _topButton = [UIButton configureButtonWithTitle:titleArr[i] titleColor:TitleColor bankGroundColor:[UIColor clearColor] cornerRadius:0 font:MAIN_TITLE_FONT borderWidth:0 borderColor:[UIColor clearColor] target:self action:@selector(updateBtnSelectedState:)];
        [bankView addSubview:_topButton];
        _topButton.tag = i;
        [_buttonArray addObject:_topButton];
        _topButton.frame = CGRectMake(i*(SCREEN_WIDTH/3), 0,SCREEN_WIDTH/3,AdaptedHeight(45));
        if (i == 0) {
            _topButton.selected = YES;
        }
    
    }
    _redLine = [[UILabel alloc] initWithFrame:CGRectMake(0, AdaptedHeight(43.5), SCREEN_WIDTH/3, 1.5)];
    _redLine.backgroundColor = [UIColor tt_redMoneyColor];
    [bankView addSubview:_redLine];
    
}
-(void)updateBtnSelectedState:(UIButton*)button {
    UIButton *currentBtn = [_buttonArray objectAtIndex:button.tag];
    //开启动画，移动下划线
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = _redLine.frame;
        frame.origin.x = currentBtn.frame.origin.x;
        _redLine.frame = frame;
    }];
    
    for (UIButton *oneBtn in _buttonArray) {
        if (oneBtn.tag == button.tag) {
            oneBtn.selected = YES;
            oneBtn.userInteractionEnabled = NO;
        }else{
            oneBtn.userInteractionEnabled = YES;
            oneBtn.selected = NO;
        }
    }

}


@end
