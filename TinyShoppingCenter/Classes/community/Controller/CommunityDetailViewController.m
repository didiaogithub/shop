//
//  CommunityDetailViewController.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/2/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CommunityDetailViewController.h"
#import "UserTableViewCell.h"
#import "CommunityShowGoodsTableViewCell.h"
#import "CommentFooterView.h"
#import "AllLikesHeadTableViewCell.h"
#import "CommunityComentTableViewCell.h"
#import "CommentViewController.h"
#import "SCGoodsDetailViewController.h"
#import "BrowsePictureTableViewCell.h"
#import "LikesViewController.h"


@interface CommunityDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UserTableViewCellDelegate>


@property(nonatomic,strong)UITableView *communityDetailTableView;
@property(nonatomic,strong)NSMutableArray *goodListArray;
@property(nonatomic,strong)NSMutableArray *picArray;
@property(nonatomic,strong)NSMutableArray *commentArray;
@property(nonatomic,strong)CommentFooterView *footerView;
@end

@implementation CommunityDetailViewController
-(NSMutableArray *)commentArray{
    if (_commentArray == nil) {
        _commentArray = [[NSMutableArray alloc] init];
    }
    return _commentArray;
}
-(NSMutableArray *)goodListArray{
    if (_goodListArray == nil) {
        _goodListArray = [[NSMutableArray alloc] init];
    }
    return _goodListArray;
}
-(NSMutableArray *)picArray{
    if (_picArray == nil) {
        _picArray = [[NSMutableArray alloc] init];
    }
    return _picArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"社区";
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
    [self.communityDetailTableView reloadData];

}


/**创建tableView*/
-(void)createTableView{
    _communityDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.view addSubview:_communityDetailTableView];
    self.communityDetailTableView.rowHeight = UITableViewAutomaticDimension;
    self.communityDetailTableView.estimatedRowHeight = 44;
    self.communityDetailTableView.delegate = self;
    self.communityDetailTableView.dataSource = self;
    self.communityDetailTableView.backgroundColor = [UIColor whiteColor];
    self.communityDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1 || section == 3) {
        return 1;
    }else{
       return 2;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        if (indexPath.section == 0){
            
            BrowsePictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrowsePictureTableViewCell"];
            if (cell == nil) {
                cell = [[BrowsePictureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BrowsePictureTableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor tt_grayBgColor];
            cell.imageArray = self.picArray;
            [cell cellRefreshWithPersonalPicArray:self.picArray];
            return cell;

        }else if(indexPath.section == 1){
                UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserTableViewCell"];
                if (cell == nil) {
                    cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserTableViewCell"];
                }
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
          
        }else if(indexPath.section == 2){
            
            CommunityShowGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityShowGoodsTableViewCell"];
            if (cell == nil) {
                cell = [[CommunityShowGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommunityShowGoodsTableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
           
        }else if(indexPath.section == 3){
            
            AllLikesHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllLikesHeadTableViewCell"];
            if (cell == nil) {
                cell = [[AllLikesHeadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AllLikesHeadTableViewCell"];
            }
            cell.backgroundColor = [UIColor tt_grayBgColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            CommunityComentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityComentTableViewCell"];
            if (cell == nil) {
                cell = [[CommunityComentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommunityComentTableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    if (section == 4) {
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [headerView addSubview:commentButton];
        [commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [commentButton setBackgroundColor:[UIColor whiteColor]];
        [commentButton setTitleColor:TitleColor forState:UIControlStateNormal];
        commentButton.titleLabel.font = MAIN_TITLE_FONT;
        [commentButton setTitle:@"评论(0)" forState:UIControlStateNormal];
        [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.top.mas_offset(0);
            make.left.mas_offset(15);
            make.height.mas_offset(AdaptedHeight(30));
        }];
        UILabel *commentTopLine = [UILabel creatLineLable];
        [headerView addSubview:commentTopLine];
        [commentTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(commentButton.mas_bottom);
            make.left.mas_offset(5);
            make.right.mas_offset(-5);
            make.height.mas_offset(1);
        }];
    }
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    [footerView setBackgroundColor:[UIColor whiteColor]];
 
    if (section == 4){
        UIButton *moreButton = [UIButton configureButtonWithTitle:@"查看全部" titleColor:SubTitleColor bankGroundColor:[UIColor whiteColor] cornerRadius:5 font:MAIN_TITLE_FONT borderWidth:1 borderColor:[UIColor tt_grayBgColor] target:self action:@selector(clickMoreButton)];
        [footerView addSubview:moreButton];
   
        [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.left.mas_offset(5);
            make.right.mas_offset(-5);
            make.height.mas_offset(AdaptedHeight(30));
        }];
        
        _footerView = [[CommentFooterView alloc] initWithFrame:CGRectZero];
        _footerView.typeStr = @"1";
        [footerView addSubview:_footerView];
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(moreButton.mas_bottom).offset(5);
            make.left.right.mas_offset(0);
            make.height.mas_offset(AdaptedHeight(30));
        }];
    }
    return footerView;
}
/**查看全部评论*/
-(void)clickMoreButton{
    CommentViewController *comment = [[CommentViewController alloc]init];
    [self.navigationController pushViewController:comment animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 4) {
        return AdaptedHeight(30);
    }else{
        return 0.1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 4) {
        return AdaptedHeight(60);
    }else{
        return 0.1;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2){
        SCGoodsDetailViewController *detailVC = [[SCGoodsDetailViewController alloc] init];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (indexPath.section == 3){
        LikesViewController *likesVC = [[LikesViewController alloc] init];
        [self.navigationController pushViewController:likesVC animated:YES];
    }

}
@end
