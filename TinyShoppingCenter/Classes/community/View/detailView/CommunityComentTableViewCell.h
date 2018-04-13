//
//  CommunityComentTableViewCell.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/2/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommunityComentTableViewCell : UITableViewCell
/**评论头像*/
@property(nonatomic,strong)UIImageView *headImageView;
/**评论人的昵称*/
@property(nonatomic,strong)UILabel *nickNameLable;
/**时间*/
@property(nonatomic,strong)UILabel *timeLable;
/**评论内容*/
@property(nonatomic,strong)UILabel *commentLable;
/**点赞图标*/
@property(nonatomic,strong)UIButton  *likesButton;
-(void)cellrefreshWithCommentModel:(CommentModel *)commentModel;

@end
