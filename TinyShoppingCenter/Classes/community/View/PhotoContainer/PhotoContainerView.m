
//  PhotoContainerView.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/2/17.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "PhotoContainerView.h"

@interface PhotoContainerView ()

@property (nonatomic, strong) NSArray *imageViewsArray;
@property (nonatomic, assign) CGFloat width;
@end

@implementation PhotoContainerView

- (instancetype)initWithWidth:(CGFloat)width{
    if (self = [super init]) {
        NSAssert(width>0, @"请设置图片容器的宽度");
        self.width = width;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        [temp addObject:imageView];
    }
    self.imageViewsArray = [temp copy];
}
- (CGFloat)setupPicUrlArray:(NSArray *)picUrlArray{
    _picUrlArray = picUrlArray;
    for (long i = _picUrlArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_picUrlArray.count == 0) {
        return 0;
    }
    CGFloat itemW = [self itemWidthForPicPathArray:_picUrlArray];
    CGFloat itemH = itemW;
    //每行显示 几个item
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picUrlArray];
    CGFloat margin = 5;
    
    for (int i = 0; i< _picUrlArray.count; i++) {
        NSURL *obj     =  _picUrlArray[i];
        long columnIndex = i % perRowItemCount;
        long rowIndex    = i / perRowItemCount;
        
        UIImageView *imageView = self.imageViewsArray[i];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.hidden = NO;
        [imageView sd_setImageWithURL:obj placeholderImage:[UIImage imageNamed:@"defaultover"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image.size.width < itemW || image.size.height < itemW) {
                imageView.contentMode = UIViewContentModeScaleAspectFit;
            }
            
        }
         ];
        
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
    }
    int columnCount = ceilf(_picUrlArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    
    return h;
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    if (array.count == 1) {
        return 120;
    } else {
        CGFloat itemW = (self.width -10) /3 ;
        return itemW;
    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    if (array.count < 3) {
        return array.count;
    } else if (array.count == 4) {
        return 2;
    } else {
        return 3;
    }
}


@end
