//
//  CommentFooterView.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/2/18.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentFooterView : UIView

@property(nonatomic,copy)NSString *typeStr;

@property(nonatomic,strong)UIView *bankView;


@property(nonatomic,strong)UILabel *commentLable;
/**评论按钮*/
@property(nonatomic,strong)UIButton *commentButton;

@property(nonatomic,strong)UILabel *likesLable;
/**点赞按钮*/
@property(nonatomic,strong)UIButton *likesButton;

@end
