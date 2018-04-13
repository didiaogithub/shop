//
//  SCCommentListHeaderView.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarEvaluateView.h"

@interface SCCommentListHeaderView : UIView

@property (nonatomic, strong) StarEvaluateView *starView;
/**分数*/
@property (nonatomic, strong) UILabel *scoreLable;
/**综合评分*/
@property (nonatomic, copy)   NSString *synthesispf;

-(void)realoadView:(NSString*)commentScore;

@end
