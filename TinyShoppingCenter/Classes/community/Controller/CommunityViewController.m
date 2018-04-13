//
//  CommunityViewController.m
//  MoveShoppingMall
//
//  Created by 庞宏侠 on 17/2/7.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CommunityViewController.h"
#import "CommunityTableViewCell.h"
#import "CommunityShowGoodsTableViewCell.h"
#import "CommentFooterView.h"
#import "CommunityDetailViewController.h"
#import "PostViewController.h"
#import "SCGoodsDetailViewController.h"
#import "PersonalCommunityViewController.h" //个人社区
#import "SelectedGoodsViewController.h"//选择已经购买过商品
#import "PhotoContainerView.h"
@interface CommunityViewController ()<UITableViewDelegate,UITableViewDataSource,CommunityTableViewCellDelagate>

@property(nonatomic,strong)UITableView *communityTableView;
@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,strong)NSMutableArray *goodListArray;
@property(nonatomic,strong)NSMutableArray *picArray;
@property(nonatomic,strong)CommentFooterView *footerView;
@end

@implementation CommunityViewController
-(NSMutableArray *)dataSourceArray{
    if (_dataSourceArray == nil) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}
-(NSMutableArray *)goodListArray{
    if (_goodListArray == nil) {
        _goodListArray = [[NSMutableArray alloc] init];
    }
    return _goodListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"社区";

    self.picArray = [[NSMutableArray alloc] initWithCapacity:0];

    [self createTableView];
    [self createHomeData];
}
/**请求首页数据*/
-(void)createHomeData{
    
    NSDictionary *pramaDic= @{@"openid":@"oX5Lut6UwPSrakY3aDE-JLSLAi0Q",@"smallname":@"演员",@"head":@"http://wx.qlogo.cn/mmopen/GQ7NPKaIgGCTUcgPsDYypNwZuVqRGVx5A7lsiaEBibXk2wBp2Nef4F4nRLVkynvRkDrFXHywp3e8QC7g6lfiau5eTuIWc5uGwNV/0",@"ckid":@"42579"};
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,Home_Url];
    [HttpTool postWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] !=  200) {
            [self showNoticeView:dic[@"codeinfo"]];
            return ;
        }
        [self analysisDatas:dic];
        
        
    } failure:^(NSError *error) {
        [self showNoticeView:@"网络出错了"];
    }];
    
}
- (void)analysisDatas:(NSDictionary *)dic
{
    
    NSArray *bannerArray = dic[@"banner_data"];
    for (NSDictionary *bannerDic in bannerArray) {
        NSString *path = bannerDic[@"path"];
        NSString *imagestr = [BaseImagestr_Url stringByAppendingString:path];
        
        [self.picArray addObject:imagestr];
    }
    [self.communityTableView reloadData];
}

-(void)clickReleaseButton{
    PostViewController *postVC = [[PostViewController alloc] init];
    [self.navigationController pushViewController:postVC animated:YES];

}
/**创建tableView*/
-(void)createTableView{
        
    _communityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,65, SCREEN_WIDTH, SCREEN_HEIGHT - 65-49) style:UITableViewStyleGrouped];
    [self.view addSubview:_communityTableView];
    self.communityTableView.rowHeight = UITableViewAutomaticDimension;
    self.communityTableView.estimatedRowHeight = 44;
    self.communityTableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.communityTableView.estimatedSectionHeaderHeight = 44;
    self.communityTableView.delegate = self;
    self.communityTableView.dataSource = self;
    _communityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *releasButton = [UIButton configureButtonWithTitle:@"我要发帖" titleColor:[UIColor whiteColor] bankGroundColor:[UIColor tt_redMoneyColor] cornerRadius:5 font:CHINESE_SYSTEM(AdaptedWidth(11)) borderWidth:0 borderColor:[UIColor clearColor] target:self action:@selector(clickReleaseButton)];
    [self.view addSubview:releasButton];
    releasButton.clipsToBounds = YES;
    [releasButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(5);
        make.bottom.mas_offset(0);
        make.right.mas_offset(-5);
        make.height.mas_offset(AdaptedHeight(30));
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        CommunityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityTableViewCell"];
        if (cell == nil) {
            cell = [[CommunityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommunityTableViewCell"];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.pictureArray = self.picArray;
        [cell cellRefreshWithArray:self.picArray];
        return cell;
    }else{
        CommunityShowGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityShowGoodsTableViewCell"];
        if (cell == nil) {
            cell = [[CommunityShowGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommunityShowGoodsTableViewCell"];
        }
        cell.typeString = @"1";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return AdaptedHeight(30);
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    _footerView = [[CommentFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AdaptedHeight(30))];
    _footerView.typeStr = @"0";

    return _footerView;
}
#pragma mark-点击社区列表的查看商品
-(void)dealWithIndex:(NSInteger)indexRow{
    SelectedGoodsViewController *selectedVc = [[SelectedGoodsViewController alloc] init];
    [self.navigationController pushViewController:selectedVc animated:YES];
}
/**点击用户头像去查看个人的社区秀*/
-(void)toSeePersonalCommunity{
    PersonalCommunityViewController *personalCommunity = [[PersonalCommunityViewController alloc] init];
    [self.navigationController pushViewController:personalCommunity animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] init];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        SCGoodsDetailViewController *homeDetail = [[SCGoodsDetailViewController alloc] init];
        [self.navigationController pushViewController:homeDetail animated:YES];
    }
}
@end
