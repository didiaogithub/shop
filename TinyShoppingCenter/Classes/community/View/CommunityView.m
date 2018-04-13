//
//  SDAdScrollView.m
//  SDAdScrollView
//
//  Created by DHsong on 16/4/20.
//  Copyright © 2016年 DHsong. All rights reserved.
//

#import "CommunityView.h"

@interface CommunityView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@end


@implementation CommunityView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _currentImageView = [[UIImageView alloc]init];
        [self.scrollView addSubview:_currentImageView];
        
        _leftImageView = [[UIImageView alloc]init];
        [self.scrollView addSubview:_leftImageView];
        
        _rightImageView = [[UIImageView alloc]init];
        [self.scrollView addSubview:_rightImageView];
        
        _pageLable = [UILabel configureLabelWithTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
        [self addSubview:_pageLable];
        
        _pageLable.layer.cornerRadius = 5;
        _pageLable.backgroundColor = [UIColor greenColor];
        _pageLable.clipsToBounds = YES;
        _pageLable.alpha = 0.5;
        _pageLable.textColor = [UIColor whiteColor];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onGesture:)];
        [self.scrollView addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _leftImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    _currentImageView.frame = CGRectOffset(_leftImageView.frame, CGRectGetWidth(_leftImageView.frame), 0);
    
    _rightImageView.frame = CGRectOffset(_currentImageView.frame, CGRectGetWidth(_currentImageView.frame), 0);
    
    _pageLable.frame = CGRectMake(SCREEN_WIDTH-AdaptedWidth(52),AdaptedWidth(300-25), AdaptedWidth(40), AdaptedHeight(15));
   
}

#pragma mark - Action
-(void)onGesture:(UITapGestureRecognizer*)tapGesture
{
    if (self.tapActionBlock) {
        self.tapActionBlock(self);
    }
}

#pragma mark - setter

-(void)setAdList:(NSArray *)adList
{
    _adList = adList;
    _currentPage = 0;
     NSLog(@"setAdList当前页%ld",_currentPage);
     _pageLable.text = [NSString stringWithFormat:@"%zd/%zd",_currentPage+1,self.adList.count];
    
    if (_adList.count <= 1) {
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), 0);
    }else{
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds)*3, 0);
    }
    
    [self refreshImageView];
}


//根据当前的index，重置当前显示的图片，并且使currentImageView永远保持在中间
-(void)refreshImageView
{
    NSInteger index = _currentPage;
     _pageLable.text = [NSString stringWithFormat:@"%zd/%zd",_currentPage+1,self.adList.count];
     NSLog(@"refreshImageView当前页%ld",_currentPage);
    
    [self formatImageView:_currentImageView imageData:self.adList[index]];
    
    if (self.adList.count > 1) {
        index = _currentPage-1<0?self.adList.count-1:_currentPage-1;
        [self formatImageView:_leftImageView imageData:self.adList[index]];
        
        index = _currentPage+1>=self.adList.count?0:_currentPage+1;
        [self formatImageView:_rightImageView imageData:self.adList[index]];
    }else{
        [self formatImageView:_leftImageView imageData:self.adList[index]];
    }
    
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
}

//根据数组中类型判断如何展示图片
-(void)formatImageView:(UIImageView*)imageView imageData:(id)data
{
    if ([data isKindOfClass:[UIImage class]]) {
        imageView.image = (UIImage*)data;
    }else if ([data isKindOfClass:[NSString class]]) {
        NSString *imageName = (NSString*)data;
        if ([imageName hasPrefix:@"http"]||[imageName hasPrefix:@"https"]) {
            //网络图片
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"banner2"]];
        }else{
            //本地图片
            imageView.image = [UIImage imageNamed:imageName];
        }
    }
}


-(void)refreshCurrentPage
{
    if (self.scrollView.contentOffset.x >= CGRectGetWidth(self.bounds)*1.5) {
        
        _currentPage ++;
        
        if (_currentPage > self.adList.count-1) {
            _currentPage = 0;
        }
    }else if (self.scrollView.contentOffset.x <= CGRectGetWidth(self.bounds)/2) {
        _currentPage--;
        
        if (_currentPage < 0) {
            _currentPage = self.adList.count-1;
        }
    }
     _pageLable.text = [NSString stringWithFormat:@"%zd/%zd",_currentPage+1,self.adList.count];
}

-(UIScrollView*)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds)*3, 0);
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self refreshCurrentPage];

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentPage = scrollView.contentOffset.x/SCREEN_WIDTH;
    if (currentPage == self.adList.count){
        [scrollView setContentOffset:CGPointZero animated:NO];
    }else{
    
    
    }
    if (currentPage == 0) {
        currentPage = 1;
    }
    _pageLable.text = [NSString stringWithFormat:@"%zd/%zd",currentPage,self.adList.count];
    NSLog(@"Decelerating当前页%d",currentPage);
    
}

@end
