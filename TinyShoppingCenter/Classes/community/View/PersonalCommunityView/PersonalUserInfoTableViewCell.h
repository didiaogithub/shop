//
//  PersonalUserInfoTableViewCell.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/3/4.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalUserInfoTableViewCell : UITableViewCell
/**头像*/
@property(nonatomic,strong)UIImageView *headImageView;
/**昵称*/
@property(nonatomic,strong)UILabel *nickNameLable;
/**时间*/
@property(nonatomic,strong)UILabel *timeLable;
/**评价内容*/
@property(nonatomic,strong)UILabel *contentLable;
@end
