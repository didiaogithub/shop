//
//  AllLikesHeadTableViewCell.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/2/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllLikesHeadTableViewCell : UITableViewCell
/**喜欢头像*/
@property(nonatomic,strong)UIImageView *headImageView;
/**多少人喜欢*/
@property(nonatomic,strong)UILabel *likesLable;
/**右边箭头*/
@property(nonatomic,strong)UIImageView *rightImageView;
@end
