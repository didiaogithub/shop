//
//  MyIntegralMallViewController.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/24.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "MyIntegralMallViewController.h"
#import "HeaderCollectionReusableView.h"
#import "ScrollCollectionViewCell.h"
#import "MallCollectionViewCell.h"
#import "SCGoodsDetailViewController.h"
#import "SCIntegralGoodsModel.h"

#import "SCUserInfoModel.h"
#import "SCConfirmOrderVC.h"

static NSString *scrollCell = @"ScrollCollectionViewCell";
static NSString *mallCell = @"MallCollectionViewCell";
static NSString *headerIdentifier = @"MallCollectionHeaderView";

@interface MyIntegralMallViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, IntegralMallBuyDelegate>

@property (nonatomic, strong) UICollectionView *mallCollection;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) HeaderCollectionReusableView *reusableview;
@property (nonatomic, strong) SCUserInfoModel *userInfoM;
//@property (nonatomic, copy)   NSString *expiringintegral;
//@property (nonatomic, copy)   NSString *expiringtime;

@end

@implementation MyIntegralMallViewController

-(HeaderCollectionReusableView *)reusableview{
    if (_reusableview == nil) {
        _reusableview = [[HeaderCollectionReusableView alloc] init];
    }
    return _reusableview;
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(NSMutableArray *)imageArray{
    if (_imageArray == nil) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"积分商城";
    [self createCellctionView];
    [self.imageArray addObject:@"http://pic32.nipic.com/20130813/9422601_092741863000_2.jpg"];
    [self.imageArray addObject:@"http://pic32.nipic.com/20130813/9422601_085617054000_2.jpg"];
    
    [self getIntegralGoodsListData];
    
    [self getMeInfo];

}

-(void)getMeInfo {
    
    NSDictionary *params = @{@"openid":USER_OPENID};
    NSString *signUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetMeInfoUrl];
    
    [HttpTool getWithUrl:signUrl params:params success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] intValue] != 200) {
            [self.loadingView showNoticeView:dict[@"msg"]];
            return ;
        }
        
        self.userInfoM = [[SCUserInfoModel alloc] init];
        [self.userInfoM setValuesForKeysWithDictionary:dict];
        
//        _expiringtime = [NSString stringWithFormat:@"%@", dict[@"expiringtime"]];
//        if (IsNilOrNull(_expiringtime)) {
//            _expiringtime = @"";
//        }
//        _expiringintegral = [NSString stringWithFormat:@"%@", dict[@"expiringintegral"]];
//        if (IsNilOrNull(_expiringintegral)) {
//            _expiringintegral = @"";
//        }
        
        NSString *smallname = [NSString stringWithFormat:@"%@", dict[@"smallname"]];
        NSString *mobile = [NSString stringWithFormat:@"%@", dict[@"mobile"]];
        NSString *headPath = [NSString stringWithFormat:@"%@", dict[@"head"]];
        if (!IsNilOrNull(smallname)) {
            [KUserdefaults setObject:smallname forKey:@"YDSC_USER_SMALLNAME"];
        }
        if (!IsNilOrNull(headPath)) {
            [KUserdefaults setObject:headPath forKey:@"YDSC_USER_HEAD"];
        }
        if (!IsNilOrNull(mobile)) {
            [KUserdefaults setObject:mobile forKey:@"YDSC_USER_MOBILE"];
        }
        
        [self.mallCollection reloadData];
    } failure:^(NSError *error) {

    }];
    
}

#pragma mark-请求积分商城数据
-(void)getIntegralGoodsListData {
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI,  GetIntegralGoodsList];
    [HttpTool getWithUrl:requestUrl params:nil success:^(id json) {
        NSDictionary *itemDic = json;
        
        if ([itemDic[@"code"] integerValue] == 200) {
            NSArray *itemArr = itemDic[@"goodlist"];
            for (NSDictionary *goodsDic in itemArr) {
                SCIntegralGoodsModel *goodsM = [[SCIntegralGoodsModel alloc] init];
                [goodsM setValuesForKeysWithDictionary:goodsDic];
                [self.dataArray addObject:goodsM];
            }
            [self.mallCollection reloadData];
        }
    } failure:^(NSError *error) {

    }];
}

#pragma mrak-创建collectionView
- (void)createCellctionView{
    
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 8;
    
    //2.初始化collectionView
    self.mallCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT - 64) collectionViewLayout:layout];
    
    self.mallCollection.showsVerticalScrollIndicator = NO;
    self.mallCollection.showsHorizontalScrollIndicator = NO;
    self.mallCollection.backgroundColor = [UIColor whiteColor];
    
    //3.注册collectionViewCell
    [self.mallCollection registerClass:[ScrollCollectionViewCell class] forCellWithReuseIdentifier:scrollCell];
    
     [self.mallCollection registerClass:[MallCollectionViewCell class] forCellWithReuseIdentifier:mallCell];
    //头部视图
    [self.mallCollection registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    //4.设置代理
    self.mallCollection.delegate = self;
    self.mallCollection.dataSource = self;
    [self.view addSubview:self.mallCollection];
    self.mallCollection.backgroundColor = [UIColor tt_grayBgColor];
    
}

#pragma mark collectionView代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
/**每个section的item个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(section == 0){
      return 1;
    }else{
       return 5;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ScrollCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:scrollCell forIndexPath:indexPath];
        if([self.imageArray count]){
            [cell refreshCellData:self.imageArray userModel:self.userInfoM];
        }
        return cell;
    }else{
        MallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:mallCell forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        if([self.dataArray count]){
            SCIntegralGoodsModel *goodsM = self.dataArray[indexPath.row];
            [cell cellRefreshWithModel: goodsM];
        }
        cell.buyButton.tag = indexPath.row;
        cell.delegate = self;
        return cell;
    
    }
}
/**设置每个item的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = (SCREEN_WIDTH-24)/2;
    if (indexPath.section == 0) {
      return CGSizeMake(SCREEN_WIDTH,AdaptedHeight(177)+70);
    }else{
      return CGSizeMake(width,width+120);
    }
   
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(section == 1){
      return CGSizeMake(SCREEN_WIDTH,45);
    }else{
       return CGSizeZero;
    }
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        self.reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        [self.reusableview reusableViewHearderTitle:@"总有你想要的低价"];
        return self.reusableview;
    }else{
        return nil;
    }
}
/**设置每个item的UIEdgeInsets*/
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 1) {
         return UIEdgeInsetsMake(8, 8, 8,8);
    }else{
        return UIEdgeInsetsMake(0,0,0,0);
    }
   
}
/**设置每个item水平间距*/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

#pragma mark - 点击collectioncell进入详情
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 1){
        SCGoodsDetailViewController *detailVC = [[SCGoodsDetailViewController alloc] init];
        SCIntegralGoodsModel *goodsM = [[SCIntegralGoodsModel alloc] init];
        if (self.dataArray.count > 0) {
            goodsM = self.dataArray[indexPath.row];
        }        
        detailVC.goodsId = [NSString stringWithFormat:@"%@", goodsM.itemid];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - 立即购买
-(void)integralMallBuy:(NSInteger)index {
    
    NSLog(@"%ld", index);
    SCConfirmOrderVC *confirmOrder = [[SCConfirmOrderVC alloc] init];
    SCIntegralGoodsModel *goodsM = [[SCIntegralGoodsModel alloc] init];
    if (self.dataArray.count > 0) {
        goodsM = self.dataArray[index];
    }
    
    NSDictionary *goodsDict = [goodsM mj_keyValues];
    confirmOrder.goodsDict = goodsDict;
    [self.navigationController pushViewController:confirmOrder animated:YES];
}

@end
