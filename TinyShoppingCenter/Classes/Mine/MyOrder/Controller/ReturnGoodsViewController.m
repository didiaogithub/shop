//
//  ReturnGoodsViewController.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "ReturnGoodsViewController.h"
#import "ReturnContentTableViewCell.h"
#import "SCCommentGoodsCell.h"
#import "SCRefundReasonModel.h"


static NSString *top_Indentifier = @"returnGoodCell";
static NSString *content_Indentifier = @"contentGoodCell";

@interface ReturnGoodsViewController ()<UITableViewDelegate, UITableViewDataSource, ReturnGoodsDelegate>

@property (nonatomic, strong) UITableView *returnTableView;
@property (nonatomic, strong) NSMutableArray *reasonArr;

@end

@implementation ReturnGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我要退货";
    
    [self requestReturnReason];
    [self createTableView];
}

-(void)requestReturnReason {
    
    NSString *returnReasonUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, ReturnReasonUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:returnReasonUrl params:nil success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dic = json;
        NSString * status = [dic valueForKey:@"code"];
        if ([status intValue] != 200) {
            [self showNoticeView:[dic valueForKey:@"msg"]];
            return ;
        }
        NSArray *arr = dic[@"list"];
        _reasonArr = [NSMutableArray array];
        for (NSDictionary *dict in arr) {
            SCRefundReasonModel *reasonM = [[SCRefundReasonModel alloc] init];
            [reasonM setValuesForKeysWithDictionary:dict];
            [_reasonArr addObject:reasonM];
        }
        [self.returnTableView reloadData];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

- (void)createTableView {
    if (@available(iOS 11.0, *)) {
       self.returnTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStyleGrouped];
        self.returnTableView.estimatedSectionFooterHeight = 0;
        self.returnTableView.estimatedSectionHeaderHeight = 0;
    }else{
        self.returnTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    }
    
    [self.view addSubview:self.returnTableView];
    self.returnTableView.dataSource = self;
    self.returnTableView.delegate = self;
    self.returnTableView.rowHeight = UITableViewAutomaticDimension;
    self.returnTableView.estimatedRowHeight = 44;
    self.returnTableView.backgroundColor = [UIColor tt_grayBgColor];
    
    self.returnTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.returnTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册cell
    [self.returnTableView registerClass:[ReturnContentTableViewCell class] forCellReuseIdentifier:content_Indentifier];

}


#pragma mark tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
/**返回行数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){//商品
        SCCommentGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:top_Indentifier];
        if (cell == nil) {
            cell = [[SCCommentGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:top_Indentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshWithDetailModel:self.detailModel];
        return cell;
    }else{
        ReturnContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:content_Indentifier];
        cell.delegate = self;
        cell.reasonArray = self.reasonArr;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 110;
    }else{
        return SCREEN_HEIGHT - 110 - 64;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(void)returnGoodsRequest:(NSString *)reasonType reason:(NSString *)reason name:(NSString *)name phone:(NSString *)phone {
   
    if (IsNilOrNull(name)) {
        [self showNoticeView:@"请输入联系人姓名"];
        return;
    }
    if (IsNilOrNull(phone)) {
        [self showNoticeView:@"请输入联系电话"];
        return;
    }
    
    NSDictionary *pramaDic = @{@"orderid": self.orderid, @"itemid":self.detailModel.itemid, @"reasonType":reasonType, @"name":name, @"phone":phone, @"reason":reason};
    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, ReturnOrderUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:loveItemUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dic = json;
        NSString * status = [dic valueForKey:@"code"];
        if ([status intValue] != 200) {
            [self showNoticeView:[dic valueForKey:@"msg"]];
            return ;
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self showNoticeView:@"申请已提交"];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

-(BOOL)isMobile:(NSString *)mobile{
    NSString *number = @"^((13[0-9])|(15[^4])|(16[0-9])|(18[0-9])|(19[0-9])|(17[0-8])|(14[5,7]))\\d{8}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:mobile];
}


@end
