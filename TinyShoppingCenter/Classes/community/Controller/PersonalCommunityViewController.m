//
//  PersonalCommunityViewController.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/3/4.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "PersonalCommunityViewController.h"
#import "PersonalUserInfoTableViewCell.h"
#import "CommunityShowGoodsTableViewCell.h"
#import "BrowsePictureTableViewCell.h"
#import "CommentFooterView.h"
#import "MineHeaderView.h"
#define HeaderHeight AdaptedHeight(120)
@interface PersonalCommunityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UILabel *nameLable;
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UITableView *personalTableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)CommentFooterView *footerView;
@property(nonatomic,strong)MineHeaderView *mineHeaderView;
@end

@implementation PersonalCommunityViewController
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"个人帖子";
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
           
            return ;
        }
        [self analysisDatas:dic];
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)analysisDatas:(NSDictionary *)dic
{
    NSArray *bannerArray = dic[@"banner_data"];
    for (NSDictionary *bannerDic in bannerArray) {
        NSString *path = bannerDic[@"path"];
        NSString *imagestr = [BaseImagestr_Url stringByAppendingString:path];
        [self.dataArray addObject:imagestr];
    }
    [self.personalTableView reloadData];
}

/**创建tableView*/
-(void)createTableView{
    self.personalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:self.personalTableView];
    self.personalTableView.rowHeight = UITableViewAutomaticDimension;
    self.personalTableView.estimatedRowHeight = 44;
    self.personalTableView.delegate = self;
    self.personalTableView.dataSource = self;
    self.personalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _mineHeaderView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, HeaderHeight)];
    _mineHeaderView.backgroundColor = [UIColor clearColor];
    self.personalTableView.tableHeaderView = _mineHeaderView;

}
/**点击返回按钮*/
-(void)clickBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count+2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = self.dataArray.count +1;
    
    if (indexPath.row == 0) {
        PersonalUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalUserInfoTableViewCell"];
        if (cell == nil) {
            cell = [[PersonalUserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonalUserInfoTableViewCell"];
        }
        cell.backgroundColor = [UIColor tt_grayBgColor];
//        [cell cellRefreshWithArray:self.picArray];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == row){  //最后一行
       
        BrowsePictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrowsePictureTableViewCell"];
        if (cell == nil) {
            cell = [[BrowsePictureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BrowsePictureTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor tt_grayBgColor];
        cell.imageArray = self.dataArray;
        [cell cellRefreshWithPersonalPicArray:self.dataArray];
        return cell;
    
    }else{  //中间返回商品
        CommunityShowGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityShowGoodsTableViewCell"];
        if (cell == nil) {
            cell = [[CommunityShowGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommunityShowGoodsTableViewCell"];
        }
        cell.typeString = @"1";
        cell.backgroundColor = [UIColor tt_grayBgColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    _footerView = [[CommentFooterView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-10,AdaptedHeight(30))];
    _footerView.typeStr = @"2";
    return _footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return AdaptedHeight(30);
}

/**footerView点击代理方法*/
-(void)clikCellWithLikesButton:(UIButton *)likesButton{
    NSInteger tag = likesButton.tag - 153;
    if (tag == 0){  //分享
        NSLog(@"点击分享");
    }else if (tag == 1){//评论
        NSLog(@"点击评论");
    }else{  //点赞
        NSLog(@"点击点赞");
        
    }
    
}

@end
