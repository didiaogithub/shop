//
//  BKGuidePageCell.m
//  bestkeep
//
//  Created by yons on 16/11/16.
//  Copyright © 2016年 utouu. All rights reserved.
//

#import "BKGuidePageCell.h"
#import "BKGuidePageController.h"
#define  BKKeyWindow [UIApplication sharedApplication].keyWindow
@interface BKGuidePageCell ()
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation BKGuidePageCell

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        UIImageView *imageV = [[UIImageView alloc] init];
        _imageView = imageV;
        [self.contentView addSubview:imageV];
    }
    return _imageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}



@end
