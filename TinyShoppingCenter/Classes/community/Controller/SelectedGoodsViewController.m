//
//  SelectedGoodsViewController.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/3/1.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SelectedGoodsViewController.h"
#import "ShopManagerTableViewCell.h"

@interface SelectedGoodsViewController ()<ShopManagerTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIView *_topView;
    UIButton *_hasShopButton;
    UIButton *_noShopButton;
    UIButton *_allSelectedButton;
    UIButton *_functionButton;
    
}
@property(nonatomic,strong)GoodModel *goodModel;
@property(nonatomic,strong)NSMutableArray *selectedArray;
@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,strong)UITableView *shopManagerTableView;
@end

@implementation SelectedGoodsViewController
-(NSMutableArray *)selectedArray{
    if (_selectedArray == nil) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    return _selectedArray;
}
-(NSMutableArray *)dataSourceArray{
    if (_dataSourceArray == nil) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加商品";
    [self createTableView];
    [self creteBottomView];
    [self getAddGoodsData];
    
}
-(void)createTableView{
    _shopManagerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64-50) style:UITableViewStylePlain];
    _shopManagerTableView.delegate  = self;
    _shopManagerTableView.dataSource = self;
    self.shopManagerTableView.rowHeight = UITableViewAutomaticDimension;
    self.shopManagerTableView.estimatedRowHeight = 44;
    _shopManagerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_shopManagerTableView];
}

/**获取添加商品列表*/
-(void)getAddGoodsData{
//    [self.dataSourceArray removeAllObjects];
//    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebOfflineServiceAPI,getGoodsList_Url];
//  
//    NSDictionary *pramaDic = @{@"ckid":@"50"};
//    [self.view addSubview:self.loadingView];
//    [self.loadingView startAnimation];
//    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
//        [self.loadingView stopAnimation];
//        NSDictionary *dict = json;
//        if([dict[@"code"] integerValue] != 200){
//            [self showNoticeView:dict[@"msg"]];
//            return ;
//        }
//        NSArray *onsaleArr = dict[@"items"];
//        for (NSDictionary *saleDic in onsaleArr) {
//            _goodModel = [[GoodModel alloc] init];
//            [_goodModel setValuesForKeysWithDictionary:saleDic];
//            [self.dataSourceArray addObject:_goodModel];
//        }
//        [self.shopManagerTableView reloadData];
//        
//    } failure:^(NSError *error) {
//        [self.loadingView stopAnimation];
//        [self showNoticeView:@"网络出错了"];
//    }];
    
    
}

#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopManagerTableViewCell"];
    if (cell == nil) {
        cell = [[ShopManagerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopManagerTableViewCell" andTypeStr:@"3"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if ([self.dataSourceArray count]) {
        _goodModel = [self.dataSourceArray objectAtIndex:indexPath.row];
        [cell setModel:_goodModel];
    }
    return cell;
}
#pragma mark-点击cell事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
}
#pragma mark-点击单选按钮 代理方法
-(void)singleClick:(GoodModel *)goodModel anRow:(NSInteger)indexRow andSection:(NSInteger)section{
    _goodModel = goodModel;
//    NSMutableArray *array =  [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0;i<self.dataSourceArray.count;i++) {
        goodModel  = self.dataSourceArray[i];
//        if (goodModel.isSelect){
//            [array addObject:goodModel];
//            if (array.count == self.dataSourceArray.count) {
//                _allSelectedButton.selected = YES;
//            }
//        }else{
//            _allSelectedButton.selected = NO;
//        }
    }
    //一个cell刷新
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexRow inSection:section]; //刷新第0段第2行
    [self.shopManagerTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}
/**创建底部view*/
-(void)creteBottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    bottomView.backgroundColor = CKYS_Color(255, 255, 255);
    [self.view addSubview:bottomView];
    
    UILabel *line = [UILabel creatLineLable];
    [bottomView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    _allSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:_allSelectedButton];
    
    UIImage * nomalImage = [UIImage imageNamed:@"selectedgray"];
    UIImage * selectedImage = [UIImage imageNamed:@"selectedred"];
    [_allSelectedButton setImage:nomalImage forState:UIControlStateNormal];
    [_allSelectedButton setImage:selectedImage forState:UIControlStateSelected];
    [_allSelectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(10);
        make.left.equalTo(bottomView.mas_left).offset(15);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    [_allSelectedButton addTarget:self action:@selector(clickAllSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *textLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_BODYTITLE_FONT];
    [bottomView addSubview:textLable];
    textLable.text = @"全选";
    [textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_allSelectedButton.mas_top);
        make.left.equalTo(_allSelectedButton.mas_right).offset(5);
        make.size.mas_offset(CGSizeMake(50, 30));
    }];
    
    
    //上架 或者 下架按钮
    _functionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:_functionButton];
    [_functionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.right.mas_offset(0);
        make.size.mas_offset(CGSizeMake(130*SCREEN_WIDTH_SCALE, 50));
    }];
    _functionButton.backgroundColor = [UIColor tt_redMoneyColor];
    [_functionButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_functionButton addTarget:self action:@selector(nextButton) forControlEvents:UIControlEventTouchUpInside];
    
}
/**点击下一步*/
-(void)nextButton{
    [self.selectedArray removeAllObjects];
    for (int i = 0;i<self.dataSourceArray.count;i++) {
        self.goodModel = [self.dataSourceArray objectAtIndex:i];
//        if (self.goodModel.isSelect) {//选中
//            [self.selectedArray addObject:self.goodModel];
//        }
    }
    if (![self.selectedArray count]) {
        [self showNoticeView:@"请先选择商品"];
        return;
    }
    if(self.selectedArray.count > 5){
        [self showNoticeView:@"最多可选5件商品"];
        return;
    }
    if (self.releaseBlock) {
        self.releaseBlock(self.selectedArray,self.goodModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setReleaseBlock:(releaseBlock)releaseBlock{
    _releaseBlock = releaseBlock;
}
#pragma mark-点击全选按钮
-(void)clickAllSelectedButton:(UIButton *)button{
    button.selected = !button.selected;
//    BOOL btselected = button.selected;
    for (int i =0; i<self.dataSourceArray.count; i++) {
        _goodModel = (GoodModel *)[self.dataSourceArray objectAtIndex:i];
//        if (btselected){
//            _goodModel.isSelect = YES;
//        }else{
//            _goodModel.isSelect = NO;
//        }
    }
    [self.shopManagerTableView reloadData];
}



@end
