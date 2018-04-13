//
//  LikesViewController.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "LikesViewController.h"
#import "LikesTableViewCell.h"
static NSString *likeIdentifier = @"likesCell";
@interface LikesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *likeTableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation LikesViewController
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"点赞";
    [self createTableView];
}
/**创建tableView*/
-(void)createTableView{
    self.likeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.likeTableView];
    self.likeTableView.rowHeight = UITableViewAutomaticDimension;
    self.likeTableView.estimatedRowHeight = 44;
    self.likeTableView.delegate = self;
    self.likeTableView.dataSource = self;
    self.likeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.likeTableView registerClass:[LikesTableViewCell class] forCellReuseIdentifier:likeIdentifier];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LikesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:likeIdentifier];
    return cell;

}




@end
