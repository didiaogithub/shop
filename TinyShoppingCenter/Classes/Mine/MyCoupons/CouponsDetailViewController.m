//
//  CouponsDetailViewController.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/21.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CouponsDetailViewController.h"
#import "MyCouposTableViewCell.h"
#import "CouponsOrderCell.h"
#import "CouponsView.h"
@interface CouponsDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)UITableView *couponsDeatlTableView;
@property(nonatomic,strong)UILabel *numberLable;
@property(nonatomic,strong)UILabel *statusLable;
@property(nonatomic,strong)UILabel *timeLable;
@property(nonatomic,strong)CouponsView *couponsView;
@end

@implementation CouponsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
}
- (void)createTableView{
    _couponsView = [[CouponsView alloc] initWithFrame:CGRectZero andType:@"0"];
    [self.view addSubview:_couponsView];
//    _couponsView.delegate = self;
    [_couponsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(65);
        make.left.right.mas_offset(0);

    }];
    
    _couponsDeatlTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_couponsDeatlTableView];
    [_couponsDeatlTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_couponsView.mas_bottom);
        make.left.right.equalTo(_couponsView);
        make.bottom.mas_equalTo(0);
    }];
    _couponsDeatlTableView.backgroundColor = [UIColor tt_grayBgColor];
    _couponsDeatlTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _couponsDeatlTableView.rowHeight = UITableViewAutomaticDimension;
    _couponsDeatlTableView.estimatedRowHeight = 44;
    _couponsDeatlTableView.delegate = self;
    _couponsDeatlTableView.dataSource = self;
    

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CouponsOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"CouponsOrderCell%ld", indexPath.row]];
    if (cell == nil) {
        cell = [[CouponsOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"CouponsOrderCell%ld", indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor tt_grayBgColor];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor tt_grayBgColor]];
    
    UIView *topView = [[UIView alloc] init];
    [headerView addSubview:topView];
    [topView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *bottomView = [[UIView alloc] init];
    [headerView addSubview:bottomView];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    if(section == 0){
       
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(7);
            make.left.right.mas_offset(0);
            make.height.mas_offset(40);
        }];
        UILabel *topLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
        [topView addSubview:topLable];
        topLable.text = @"获取类型:分享店铺链接,好友下单获得";
        [topLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_offset(0);
            make.left.mas_offset(10);
        }];
    
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom).offset(7);
            make.left.right.bottom.mas_offset(0);
            make.height.mas_offset(40);
        }];
    }else{
    
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(7);
            make.left.right.bottom.mas_offset(0);
            make.height.mas_offset(40);
        }];
    }
    
    
    _numberLable = [UILabel configureLabelWithTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bottomView addSubview:_numberLable];
    _numberLable.text = @"订单编号：";
    
    [_numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(AdaptedWidth(10));
        make.width.mas_offset(SCREEN_WIDTH*2/3);
    }];
    
    
    _statusLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentRight font:CHINESE_SYSTEM(15)];
    [bottomView addSubview:_statusLable];
    [_statusLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_numberLable);
        make.right.mas_offset(-AdaptedWidth(10));
    }];
    
    _statusLable.text = @"收件人：";
    return headerView;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
      return 87;
    }else{
      return 47;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc] init];
    [footerView setBackgroundColor:[UIColor whiteColor]];
    
    _timeLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:CHINESE_SYSTEM(15)];
    [footerView addSubview:_timeLable];
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.right.mas_offset(-AdaptedWidth(10));
    }];
    _timeLable.text = @"下单时间:2012.10.18 19:20:20";
    return footerView;
   

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
 
    return AdaptedHeight(30);
 

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
