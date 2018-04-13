//
//  HeaderCollectionReusableView.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/24.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCollectionReusableView : UICollectionReusableView
@property(nonatomic,strong)UILabel *titleLable;

-(void)reusableViewHearderTitle:(NSString *)title;
@end
