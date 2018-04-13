//
//  ZNPopUpTextView.h
//  beautyreception
//
//  Created by 开发_赵楠 on 15/6/13.
//  Copyright (c) 2015年 iOSMax. All rights reserved.
//
//  输入信息


#import "ZNPopUpView.h"

typedef void(^GetNoteStr)(NSString *noteStr);
@interface ZNPopUpTextView : ZNPopUpView<UITextViewDelegate>

/** 提示文本 */
@property (nonatomic, copy) NSString *m_cluesStr;

@property (nonatomic, strong) UIView *backImageView;
/** 消息输入 */
@property (nonatomic, strong) UITextView *m_textView;
/** 备注 */
@property (nonatomic, copy) NSString *m_noteStr;
/** 提示语label */
@property (nonatomic, strong)UILabel *placeholderLabel;
/** 提示语 */
@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, copy) GetNoteStr m_getNoteStr;

- (instancetype)initWithTitle:(NSString *)title CluesStr:(NSString *)cluesStr;


@end
