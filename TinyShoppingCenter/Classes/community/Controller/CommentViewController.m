//
//  CommentViewController.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/3/4.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CommentViewController.h"
#import "CommunityComentTableViewCell.h"
#import "CommentModel.h"
#import "ZNPopUpTextView.h" //评论弹框
@interface CommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIButton *commentButton;
@property(nonatomic,strong)CommentModel *commentModel;
@property(nonatomic,strong)UITableView *commentTableView;
@property(nonatomic,strong)NSMutableArray *commentArray;
@end

@implementation CommentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评论";
    [self createTableView];
    [self createBottomView];
}
/**创建tableView*/
-(void)createTableView{
    
    _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5+64, SCREEN_WIDTH, SCREEN_HEIGHT - 69-50) style:UITableViewStyleGrouped];
    [self.view addSubview:_commentTableView];
    self.commentTableView.rowHeight = UITableViewAutomaticDimension;
    self.commentTableView.estimatedRowHeight = 44;
    self.commentTableView.backgroundColor = [UIColor whiteColor];
    self.commentTableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.commentTableView.estimatedSectionHeaderHeight = 44;
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
//    return self.commentArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        CommunityComentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        if (cell == nil) {
            cell = [[CommunityComentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
}
/**点击点赞按钮 152*/
-(void)clikCellWithLikesButton:(UIButton *)likesButton{
   
    
    

}
#pragma mark-创建底部view
-(void)createBottomView{
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomView];
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:_commentButton];
    _commentButton.frame = CGRectMake(5, 5, SCREEN_WIDTH*3/4, 40);
    _commentButton.layer.cornerRadius = 5;
    _commentButton.backgroundColor = [UIColor tt_lineBgColor];
    [_commentButton addTarget:self action:@selector(clickBottomButton) forControlEvents:UIControlEventTouchUpInside];
    
    
}
#pragma mark-点击底部发表评论
-(void)clickBottomButton{
    ZNPopUpTextView *textView = [[ZNPopUpTextView alloc] init];
    textView.m_title = @"评论标题";//评论的标题
    textView.m_noteStr = @"";//备注
    textView.placeholder = @"写评论";//提示语
    textView.m_getNoteStr = ^(NSString *noteStr){
        NSLog(@"评论内容：%@",noteStr);
    };
    [textView show];

}
@end
