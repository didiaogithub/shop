//
//  PersonalPictureTableViewCell.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/3/4.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BrowsePictureTableViewCell.h"
#import "XLImageViewer.h"

@interface BrowsePictureTableViewCell()<UIScrollViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic, strong) UILabel *pageLable;

@end

@implementation BrowsePictureTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    self.sdScrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, AdaptedHeight(137)) delegate:self placeholderImage:[UIImage imageNamed:@"waitbanner"]];
    [self.contentView addSubview:self.sdScrollview];
    [self.sdScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.right.bottom.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(137));
    }];
    
    self.sdScrollview.backgroundColor = [UIColor whiteColor];
    self.sdScrollview.currentPageDotColor = [UIColor redColor];
    self.sdScrollview.pageDotColor = [UIColor lightGrayColor];
    self.sdScrollview.imageURLStringsGroup = self.imageArray;
    //设置不是自滚动
    self.sdScrollview.autoScroll = NO;
    self.sdScrollview.showPageControl = NO;
    
    
    //控制页数
    _pageLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_pageLable];
    _pageLable.layer.cornerRadius = 8;
    _pageLable.backgroundColor = [UIColor blackColor];
    _pageLable.clipsToBounds = YES;
    _pageLable.alpha = 0.5;
    
    [_pageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-AdaptedWidth(12));
        make.bottom.equalTo(self.sdScrollview.mas_bottom).offset(-AdaptedHeight(10));
        make.width.mas_offset(AdaptedWidth(40));
        make.height.mas_offset(AdaptedHeight(15));
    }];
}
/**刷新 数据*/
-(void)cellRefreshWithPersonalPicArray:(NSMutableArray *)picArray{
    self.imageArray = picArray;
    self.sdScrollview.imageURLStringsGroup = self.imageArray;
    for (int i = 0; i<picArray.count; i++) {
        UIImageView *imageViews= (UIImageView *)[self.contentView viewWithTag:700+i];
        NSString *url = picArray[i];
        [imageViews sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultover"] options:SDWebImageRefreshCached];
    }

     _pageLable.text = [NSString stringWithFormat:@"%zd/%zd",1,self.imageArray.count];
    __weak typeof(self) weakSelf = self;
    self.sdScrollview.itemDidScrollOperationBlock = ^(NSInteger currentIndex){
        weakSelf.pageLable.text = [NSString stringWithFormat:@"%zd/%zd",currentIndex+1,weakSelf.imageArray.count];
    };
    
    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    /**支持下拉 和左右滑动*/
    [[XLImageViewer shareInstanse] showNetImages:self.imageArray index:index from:_sdScrollview];
}



@end
