//
//  CommentFooterView.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/2/18.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CommentFooterView.h"
#import "CommentViewController.h"
#import "CommunityDetailViewController.h"
#import "CommunityViewController.h"
#import "PersonalCommunityViewController.h"
@implementation CommentFooterView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self createUIView];
    }
    return self;
}
-(void)createUIView{
    self.backgroundColor = [UIColor tt_grayBgColor];
    _bankView = [[UIView alloc] init];
    [self addSubview:_bankView];
    _bankView.backgroundColor = [UIColor whiteColor];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.bottom.mas_offset(-5);
    }];
    
    
    _likesLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [_bankView addSubview:_likesLable];
    [_likesLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.right.mas_offset(-AdaptedWidth(10));
    }];
    
    UIImageView *likeImageView = [[UIImageView alloc] init];
    [_bankView addSubview:likeImageView];
    likeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [likeImageView setImage:[UIImage imageNamed:@"likes"]];
    [likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(6);
        make.height.mas_offset(20);
        make.right.equalTo(_likesLable.mas_left).offset(-AdaptedWidth(5));
        make.width.mas_offset(AdaptedWidth(25));
    }];
    
    _likesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bankView addSubview:_likesButton];
    _likesButton.tag = 155;
    [_likesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_offset(0);
        make.left.equalTo(likeImageView.mas_left);
    }];
    
    _commentLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [_bankView addSubview:_commentLable];
    [_commentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_likesLable);
        make.right.equalTo(likeImageView.mas_left).offset(-AdaptedWidth(10));
    }];
    
    UIImageView *commentImageView = [[UIImageView alloc] init];
    [_bankView addSubview:commentImageView];
    commentImageView.contentMode = UIViewContentModeScaleAspectFit;
    [commentImageView setImage:[UIImage imageNamed:@"comment"]];
    [commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(likeImageView);
        make.right.equalTo(_commentLable.mas_left).offset(-AdaptedWidth(5));
    }];

    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bankView addSubview:_commentButton];
    _commentButton.tag = 154;

    _likesLable.text = @"0";
    _commentLable.text = @"0";
    [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(_likesButton);
        make.right.equalTo(_likesButton.mas_left);
    }];

    [_commentButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_likesButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clickButton:(UIButton*)button{
    NSInteger tag = button.tag - 154;
    
    if (tag == 0){
        if([self.typeStr isEqualToString:@"0"]){
            CommunityViewController *detailVC;
            UIResponder *next = self.nextResponder;
            do {
                //判断响应者是否为视图控制器
                if ([next isKindOfClass:[CommunityViewController class]]) {
                    detailVC = (CommunityViewController*)next;
                }
                next = next.nextResponder;
            } while (next != nil);
            CommentViewController *comment = [[CommentViewController alloc] init];
            [detailVC.navigationController pushViewController:comment animated:YES];
        }else if([self.typeStr isEqualToString:@"1"]){
            CommunityDetailViewController *detailVC;
            UIResponder *next = self.nextResponder;
            do {
                //判断响应者是否为视图控制器
                if ([next isKindOfClass:[CommunityDetailViewController class]]) {
                    detailVC = (CommunityDetailViewController*)next;
                }
                next = next.nextResponder;
            } while (next != nil);
            CommentViewController *comment = [[CommentViewController alloc] init];
            [detailVC.navigationController pushViewController:comment animated:YES];
        }else{
            PersonalCommunityViewController *detailVC;
            UIResponder *next = self.nextResponder;
            do {
                //判断响应者是否为视图控制器
                if ([next isKindOfClass:[PersonalCommunityViewController class]]) {
                    detailVC = (PersonalCommunityViewController*)next;
                }
                next = next.nextResponder;
            } while (next != nil);
            CommentViewController *comment = [[CommentViewController alloc] init];
            [detailVC.navigationController pushViewController:comment animated:YES];
        }
    }else{ //收藏
        
       

    
    }
    
}


@end
