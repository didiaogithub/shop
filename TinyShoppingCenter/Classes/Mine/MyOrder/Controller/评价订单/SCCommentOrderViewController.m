//
//  SCCommentOrderViewController.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/9/9.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCCommentOrderViewController.h"
#import "SCReleaseCommentCell.h"

@interface SCCommentOrderViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *commentTableView;

@property (nonatomic, strong) NSMutableArray *imgPathArr;
@property (nonatomic, copy)   NSString *content;
@property (nonatomic, copy)   NSString *score;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *uploadFailArray;
@property (nonatomic, strong) UIButton *releaseButton;

@end

@implementation SCCommentOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"订单评价";
    self.view.backgroundColor = [UIColor whiteColor];
    _imgPathArr = [NSMutableArray array];
    _imageArray = [NSMutableArray array];
    _uploadFailArray = [NSMutableArray array];

    [self initComponents];
}

-(void)initComponents {
    if (@available(iOS 11.0, *)) {
        _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64-NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
    }else{
        _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    }
    
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_commentTableView];
    
    [self createReleaseBtn];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *rid = [NSString stringWithFormat:@"SCReleaseCommentCell%ld", indexPath.row];
    SCReleaseCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[SCReleaseCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    }
    [cell refreshWithDetailModel:_goodsM];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textView.myPlaceholder = @"说点什么吧...";
    cell.textView.backgroundColor = [UIColor tt_grayBgColor];
    __weak typeof(self) wSelf = self;
    
    [cell returnCommentContent:^(NSString *text) {
        wSelf.content = text;
    }];
    
    [cell returnCommentImageBlock:^(NSArray<UIImage *> *images) {
        
        [_uploadFailArray removeAllObjects];
        [_imageArray removeAllObjects];
        [_imageArray addObjectsFromArray:images];
    }];
  
    cell.startView.starEvaluateBlock = ^(StarEvaluateView *starView, NSInteger starIndex){
        NSLog(@"%zd",starIndex);
        wSelf.score = [NSString stringWithFormat:@"%ld", starIndex];
    };
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 430+20+10;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 1;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.001;
//}

-(void)createReleaseBtn {
    _releaseButton = [UIButton configureButtonWithTitle:@"发布" titleColor:[UIColor whiteColor] bankGroundColor:[UIColor tt_redMoneyColor] cornerRadius:5 font:MAIN_TITLE_FONT borderWidth:0 borderColor:[UIColor clearColor] target:self action:@selector(clickReleaseButton)];
    [self.view addSubview:_releaseButton];
    [_releaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(44);
        make.left.mas_offset(5);
        make.right.mas_offset(-5);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10-BOTTOM_BAR_HEIGHT);
    }];
}

#pragma mark - 点击发布按钮
-(void)clickReleaseButton {
    
    NSLog(@"发布");

    if (IsNilOrNull(self.score)) {
        [self showNoticeView:@"请选择评分"];
    }

    if (IsNilOrNull(self.content)) {
        [self showNoticeView:@"请输入评论内容"];
        return;
    }
    
    
    if (_imageArray.count == 0) {
        [self commitComment];
    }else{
        _releaseButton.userInteractionEnabled = NO;
        if (_uploadFailArray.count == 0) {
            [_imgPathArr removeAllObjects];
            
            for (NSInteger i = 0; i<_imageArray.count; i++) {
                UIImage *image = _imageArray[i];
                [self uploadImage:image index:i];
            }
        }else{
            if (_uploadFailArray.count <= _imageArray.count) {
                for (NSInteger i = 0; i<_uploadFailArray.count; i++) {
                    UIImage *image = _uploadFailArray[i];
                    [self uploadImage:image index:i];
                }
            }else{
                [_imgPathArr removeAllObjects];
                for (NSInteger i = 0; i<_imageArray.count; i++) {
                    UIImage *image = _imageArray[i];
                    [self uploadImage:image index:i];
                }
            }
        }
    }
}

-(void)commitComment {
    
    NSString *commentUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI,AddCommentUrl];

    NSString *str = @"";
    if (_imgPathArr.count > 0) {
        str = [_imgPathArr componentsJoinedByString:@","];
    }

    NSString *itemid = [NSString stringWithFormat:@"%@", _goodsM.itemid];
    NSMutableArray *listArr = [NSMutableArray array];
    
    if (IsNilOrNull(itemid)) {
        itemid = @"";
    }
    if (IsNilOrNull(self.score)) {
        self.score = @"5";
    }
    if (IsNilOrNull(self.content)) {
        self.content = @"";
    }
    
    if (IsNilOrNull(str)) {
        NSDictionary *dict = @{@"itemid":itemid, @"score":self.score,@"content":self.content};
        [listArr addObject:dict];
    }else{
        NSDictionary *dict = @{@"itemid":itemid, @"score":self.score,@"content":self.content,@"paths":str};
        [listArr addObject:dict];
    }
    
    NSString *commentlist = [listArr mj_JSONString];
    
    NSDictionary *pramaDic = @{@"orderid": self.orderid, @"openid":USER_OPENID, @"commentlist":commentlist};
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool postWithUrl:commentUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"msg"]];
            return ;
        }
        
        [self showNoticeView:@"评论成功"];
        
        if ([self.fromVC isEqualToString:@"SCWaitReleaseCommentViewController"]) {
            [KUserdefaults setObject:self.goodsM.itemid forKey:@"ReleasedGoodsId"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

-(void)uploadImage:(UIImage *)selectedImge index:(NSInteger)index {
    
    NSString *dateStr = [NSDate dateNow];
    NSString *nameStr = [USER_OPENID stringByAppendingString:[NSString stringWithFormat:@"_%@",dateStr]];
    NSDictionary *pramaDic = @{@"name":nameStr,@"ckid":USER_OPENID,@"file":selectedImge};
    NSString *photoImageUrl = [NSString stringWithFormat:@"%@%@", UploadImageDomain, UploadImageUrl];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    //上传图片
    [HttpTool uploadWithUrl:photoImageUrl andImages:@[selectedImge] andPramaDic:pramaDic completion:^(NSString *url, NSError *error) {
        NSLog(@"正在上传%@-%@", url, error);
        
    } success:^(id responseObject) {
        [self.loadingView stopAnimation];
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"msg"]];
            return ;
        }
        NSLog(@"%@", dict);
        NSString *pathStr = [NSString stringWithFormat:@"%@",dict[@"path"]];
        
        if (![_imgPathArr containsObject:pathStr]) {
            [_imgPathArr addObject:pathStr];
            
            if (_imgPathArr.count == _imageArray.count) {
                [self commitComment:_imgPathArr];
            }else{
                _releaseButton.userInteractionEnabled = YES;
            }
        }
    } fail:^(NSError *error) {
        
        _releaseButton.userInteractionEnabled = YES;
        
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        
        [_uploadFailArray addObject:_imageArray[index]];
        
        [self.loadingView stopAnimation];
    }];
}

-(void)commitComment:(NSMutableArray*)pathArray {
    
    [self commitComment];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
