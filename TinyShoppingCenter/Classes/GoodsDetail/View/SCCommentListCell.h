//
//  SCCommentListCell.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarEvaluateView.h"
#import "SCCommentModel.h"

@interface SCCommentListCell : UITableViewCell

/**评论头像*/
@property(nonatomic,strong)UIImageView *headImageView;
/**昵称*/
@property(nonatomic,strong)UILabel *nickNameLable;
/**评论内容*/
@property(nonatomic,strong)UILabel *commentLable;
/**评论时间*/
@property(nonatomic,strong)UILabel *timeLable;

@property(nonatomic,strong)UIImageView *picImageView;

@property(nonatomic,strong)NSMutableArray *imageArray;

-(void)refreshCellWithModel:(SCCommentModel*)commontModel index:(NSInteger)index;

@end
