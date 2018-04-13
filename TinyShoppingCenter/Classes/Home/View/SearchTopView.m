//
//  SearchTopView.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SearchTopView.h"


@implementation SearchTextField
//通过代码创建
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

//控制placeHolder的位置
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+18, bounds.origin.y+3, bounds.size.width-18, bounds.size.height);
    return inset;
}

@end


@interface SearchTopView()<UITextFieldDelegate>
@end
@implementation SearchTopView
-(instancetype)initWithFrame:(CGRect)frame andHeight:(CGFloat)height{
    if (self = [super initWithFrame:frame]) {
        [self createOtherViewsWithHeight:height];
    }
    return self;
}
/**创建搜索框*/
-(void)createOtherViewsWithHeight:(CGFloat)height{
    UIView *rightView = [[UIView alloc] init];
    rightView.size = CGSizeMake(70, height);
    
    
    UILabel *lineLable = [UILabel creatLineLable];
    lineLable.frame = CGRectMake(10,(height-30)/2, 1, 30);
    [rightView addSubview:lineLable];
    
    UIImageView *searchImageView = [[UIImageView alloc] init];
    searchImageView.size = CGSizeMake(20, 20);
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchButton.frame = CGRectMake(CGRectGetMaxX(lineLable.frame)+1,0,60, height);
    [_searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [_searchButton setUserInteractionEnabled:YES];
    
    [rightView addSubview:_searchButton];
    [_searchButton addTarget:self action:@selector(clickSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _searchTextField = [[SearchTextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,height)];
    _searchTextField.backgroundColor = [UIColor whiteColor];
    _searchTextField.layer.cornerRadius = 3;
    _searchTextField.placeholder = @"请输入您要搜索的商品";

    _searchTextField.returnKeyType = UIReturnKeySearch;
    [_searchTextField setValue:MAIN_SUBTITLE_FONT forKeyPath:@"_placeholderLabel.font"];
    _searchTextField.textAlignment = NSTextAlignmentLeft;
    _searchTextField.delegate = self;
    
    [self addSubview:_searchTextField];
    _searchTextField.leftView = searchImageView;
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _searchTextField.rightView = rightView;
    _searchTextField.rightViewMode = UITextFieldViewModeAlways;
}
-(void)clickSearchButton:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBtnSearch:)]){
        [self.delegate clickBtnSearch:button];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_searchTextField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardSearchWithString:)]) {
        [self.delegate keyboardSearchWithString:textField.text];
    }
    return YES;
}

@end
