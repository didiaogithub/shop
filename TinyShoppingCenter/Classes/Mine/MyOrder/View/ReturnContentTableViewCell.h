//
//  ReturnContentTableViewCell.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSTextView.h"

@protocol ReturnGoodsDelegate <NSObject>

-(void)returnGoodsRequest:(NSString*)reasonType reason:(NSString*)reason name:(NSString*)name phone:(NSString*)phone;

@end


@interface ReturnContentTableViewCell : UITableViewCell

@property(nonatomic,strong)JSTextView *jsTexView;
@property(nonatomic,strong)UITextField *nameTxtField;
@property(nonatomic,strong)UITextField *phoneTextField;
@property(nonatomic,strong)UIButton *commitButton;
@property(nonatomic,strong)UILabel *contentLable;

@property(nonatomic,strong) NSArray *reasonArray;


@property (nonatomic, weak) id<ReturnGoodsDelegate>delegate;


@end
