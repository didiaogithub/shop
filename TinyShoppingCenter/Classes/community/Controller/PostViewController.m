//
//  PostViewController.m
//  发贴
//
//  Created by 庞宏侠 on 17/2/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PostViewController.h"
#import "TableViewTopCell.h"
#import "TableViewItemCell.h"
#import "TableViewAddCell.h"
#import "SelectedGoodsViewController.h"
#import "GoodModel.h"
#import "CommunityShowGoodsTableViewCell.h"

@interface PostViewController ()<UITableViewDelegate,UITableViewDataSource,TableViewAddCellDelegate>
@property(nonatomic,strong)GoodModel *goodModel;

@property (nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation PostViewController

static NSString *const item_identifier = @"cell_item";
static NSString *const top_identifier = @"cell_top";
static NSString *const add_identifier = @"cell_add";

static CGFloat const numberOfSection = 3;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发帖";
    [self creatTableView];
}

- (void)creatTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,SCREEN_WIDTH, SCREEN_HEIGHT-69) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册cell
    [self.tableView registerClass:[CommunityShowGoodsTableViewCell class] forCellReuseIdentifier:item_identifier];
    [self.tableView registerClass:[TableViewTopCell class] forCellReuseIdentifier:top_identifier];
    [self.tableView registerClass:[TableViewAddCell class] forCellReuseIdentifier:add_identifier];
}


#pragma mark tableView dataSource  
/**分为3段*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return numberOfSection;
}
/**返回行数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.dataArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){//添加照片cell
        // id model = self.dataArray[indexPath.row];
        TableViewTopCell *cell = [tableView dequeueReusableCellWithIdentifier:top_identifier forIndexPath:indexPath];
//        cell.TopCellBlock = ^(NSArray *images,NSString *text,BOOL isUpdate) {
//            
//            NSLog(@"------最后提交的图片数组%@",images);
//            
//            if (isUpdate) {
//                [tableView reloadData];
//            }
//        };
//        [cell setCellInfo:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1){ //添加商品cell
        CommunityShowGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:item_identifier forIndexPath:indexPath];
        self.goodModel = self.dataArray[indexPath.row];
        cell.typeString = @"2";
        cell.indexRow = indexPath.row;
        [cell refreshCellWithModel:self.goodModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{  //添加商品的按钮
        TableViewAddCell *cell = [tableView dequeueReusableCellWithIdentifier:add_identifier forIndexPath:indexPath];
        
//        cell.DidAddItemBlock = ^(id obj) {
//            [self.dataArray addObject:obj];
//            [tableView reloadData];
//        };
        cell.delegate = self;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
/**点击添加商品的代理方法*/
-(void)comeToAddGoods{
    SelectedGoodsViewController *selectedVC = [[SelectedGoodsViewController alloc] init];
    [selectedVC setReleaseBlock:^(NSMutableArray *selectedArray, GoodModel *goodModel) {
        NSLog(@"传过来的商品数组%@",self.dataArray);
        self.dataArray = selectedArray;
        self.goodModel = goodModel;
        [self.tableView reloadData];
    }];
    [self.navigationController pushViewController:selectedVC animated:YES];
}
#pragma mark-删除选中的商品
-(void)dealWithIndex:(NSInteger)indexRow{
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"确定要删除该商品？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消来了");
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([self.dataArray count]){
            [self.dataArray removeObjectAtIndex:indexRow];
            [self.tableView reloadData];
        }
    }];
    [alerController addAction:cancelAction];
    [alerController addAction:sureAction];
    [self presentViewController:alerController animated:YES completion:^{}];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    } else {
        return 0.1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 2){
        return AdaptedHeight(50);
    }else{
        return 0.1;
    
    }
}
#pragma mark 显示间距调整
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *footerView = [[UIView alloc] init];
        UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [footerView addSubview:releaseButton];
        releaseButton.layer.cornerRadius = 5;
        [releaseButton setBackgroundColor:[UIColor tt_redMoneyColor]];
        [releaseButton setTitle:@"发布" forState:UIControlStateNormal];
        [releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [releaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(10);
            make.left.mas_offset(5);
            make.right.mas_offset(-5);
            make.bottom.mas_offset(0);
        }];
        [releaseButton addTarget:self action:@selector(clickReleaseButton) forControlEvents:UIControlEventTouchUpInside];
        
        return footerView;
    }else {
        return [UIView new];
    }
}
/**点击发布按钮*/
-(void)clickReleaseButton{
    NSLog(@"发布");
 
}
@end
