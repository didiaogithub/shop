//
//  UserTableViewCell.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/2/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserTableViewCellDelegate <NSObject>
@optional
-(void)clikCellWithLikesButton:(UIButton *)likesButton;
@end


@interface UserTableViewCell : UITableViewCell
@property(nonatomic,weak)id<UserTableViewCellDelegate>delegate;
/**头像*/
@property(nonatomic,strong)UIImageView *headImageView;
/**昵称*/
@property(nonatomic,strong)UILabel *nickNameLable;
/**时间*/
@property(nonatomic,strong)UILabel *timeLable;
/**点赞人数*/
@property(nonatomic,strong)UILabel *likesLable;
/**点赞图标*/
@property(nonatomic,strong)UIImageView *likeImageView;



@property(nonatomic,strong)UIButton *shareButton;
@property(nonatomic,strong)UIButton *likesButton;
/**评价内容*/
@property(nonatomic,strong)UILabel *contentLable;
@end
