//
//  ReturnContentTableViewCell.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "ReturnContentTableViewCell.h"
#import "SCRefundReasonModel.h"

@interface ReturnContentTableViewCell()<UIActionSheetDelegate>

@property (nonatomic, copy) NSString *reasonType;

@end

@implementation ReturnContentTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    self.reasonType = @"1";
    
    UILabel *topLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:topLable];
    topLable.text = @"退货原因";
    [topLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(5);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    UIView *scalView = [[UIView alloc] init];
    [self.contentView addSubview:scalView];
    scalView.layer.cornerRadius = 5;
    scalView.layer.borderColor = SubTitleColor.CGColor;
    scalView.layer.borderWidth = 1;
    [scalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLable.mas_bottom).offset(5);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_offset(40);
    }];
    
    _contentLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [scalView addSubview:_contentLable];
    _contentLable.text = @"收到商品破损";
    [_contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(10);
    }];
    
    UIButton *scalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scalView addSubview:scalButton];
    [scalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scalView);
    }];
    [scalButton addTarget:self action:@selector(clickScalBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //退货理由
    UILabel *becauseLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:becauseLable];
    becauseLable.text = @"退货理由";
    [becauseLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scalView.mas_bottom).offset(5);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_equalTo(30);
    }];

    self.jsTexView = [[JSTextView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.jsTexView];
    self.jsTexView.layer.cornerRadius = 5;
    self.jsTexView.backgroundColor = [UIColor tt_grayBgColor];
    self.jsTexView.myPlaceholder = @"请输入退货理由";
    [self.jsTexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(becauseLable.mas_bottom).offset(5);
        make.left.equalTo(becauseLable);
        make.right.mas_offset(-10);
        make.height.mas_offset(100);
    }];

    
    UILabel *nameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:nameLable];
    nameLable.text = @"退货人姓名";
    [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_jsTexView.mas_bottom).offset(15);
        make.left.equalTo(topLable.mas_left);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(80);
    }];
    
    _nameTxtField = [[UITextField alloc] init];
    [self.contentView addSubview:_nameTxtField];
    _nameTxtField.backgroundColor = [UIColor tt_grayBgColor];
    [_nameTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLable.mas_centerY);
        make.right.mas_offset(-10);
        make.left.equalTo(nameLable.mas_right).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *phoneLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:phoneLable];
     phoneLable.text = @"退货人电话";
    [phoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLable.mas_bottom).offset(10);
        make.left.equalTo(topLable.mas_left);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(80);
    }];
    
    _phoneTextField = [[UITextField alloc] init];
    [self.contentView addSubview:_phoneTextField];
    _phoneTextField.backgroundColor = [UIColor tt_grayBgColor];
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneLable.mas_centerY);
        make.right.mas_offset(-10);
        make.left.equalTo(nameLable.mas_right).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *bottomLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [self.contentView addSubview:bottomLable];
    bottomLable.numberOfLines = 0;
    bottomLable.text = @"待商家确认后,货款便可退还给您的账户,请注意确认,谢谢";
    [bottomLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLable.mas_bottom).offset(10);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_equalTo(40);
    }];

    _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_commitButton];
    _commitButton.backgroundColor = [UIColor tt_redMoneyColor];
    _commitButton.titleLabel.font = MAIN_TITLE_FONT;
    [_commitButton setTitle:@"提交申请" forState:UIControlStateNormal];
    [_commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLable.mas_bottom).offset(20);
        make.left.mas_offset(5);
        make.right.mas_offset(-5);
        make.height.mas_offset(45);
    }];
    [_commitButton addTarget:self action:@selector(clickCommitBtn) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickCommitBtn {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(returnGoodsRequest:reason:name:phone:)]) {
        
        [self.delegate returnGoodsRequest:self.reasonType reason:self.jsTexView.text name:self.nameTxtField.text phone:self.phoneTextField.text];
    }
}

-(void)clickScalBtn{
   NSLog(@"展开");

    //获取需要展示的数据
//    [self loadData];
//    
//    // 初始化pickerView
//    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.5, SCREEN_WIDTH, 200)];
//    [self addSubview:self.pickerView];
//    self.pickerView.backgroundColor = [UIColor whiteColor];
//    //指定数据源和委托
//    self.pickerView.delegate = self;
//    self.pickerView.dataSource = self;
//    [self addSubview:_comfirmBtn];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择退货原因" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (SCRefundReasonModel *reasonM in self.reasonArray) {
        NSString *name = [NSString stringWithFormat:@"%@", reasonM.name];
        UIAlertAction *action = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"选择了%@", name);
            _reasonType = [NSString stringWithFormat:@"%@", reasonM.reasonId];
            _contentLable.text = name;
        }];
        [alert addAction:action];
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    
    UIViewController * vc = [[UIApplication sharedApplication].keyWindow rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}

//-(UIButton *)comfirmBtn {
//    
//    if (!_comfirmBtn) {
//        
//        _comfirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44 - 20, SCREEN_HEIGHT*0.5, 44, 20)];
//        _comfirmBtn.backgroundColor = [UIColor clearColor];
//        
//        [_comfirmBtn setTitle:@"完成" forState:(UIControlStateNormal)];
//        _comfirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [_comfirmBtn setTitleColor:[UIColor colorWithRed:195 / 255.0 green:195 / 255.0 blue:195 / 255.0 alpha:1] forState:(UIControlStateNormal)];
//        
//        [_comfirmBtn addTarget:self action:@selector(confirmButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    }
//    
//    return _comfirmBtn;
//}
//
//-(void)confirmButtonAction:(UIButton *)button {
//    
//    [self.pickerView removeFromSuperview];
//    [self.comfirmBtn removeFromSuperview];
//}
//
//
//#pragma mark 加载数据
//-(void)loadData {
//    //需要展示的数据以数组的形式保存
//    self.letter = @[@"aaa",@"bbb",@"ccc",@"ddd"];
//    self.number = @[@"111",@"222",@"333",@"444"];
//}
//
//#pragma mark UIPickerView DataSource Method 数据源方法
//
////指定pickerview有几个表盘
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    return 2;//第一个展示字母、第二个展示数字
//}
//
////指定每个表盘上有几行数据
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    NSInteger result = 0;
//    switch (component) {
//        case 0:
//            result = self.letter.count;//根据数组的元素个数返回几行数据
//            break;
//        case 1:
//            result = self.number.count;
//            break;
//            
//        default:
//            break;
//    }
//    
//    return result;
//}
//
//#pragma mark UIPickerView Delegate Method 代理方法
//
////指定每行如何展示数据（此处和tableview类似）
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    NSString * title = nil;
//    switch (component) {
//        case 0:
//            title = self.letter[row];
//            break;
//        case 1:
//            title = self.number[row];
//            break;
//        default:
//            break;
//    }
//    
//    return title;
//}
//
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    NSLog(@"%@-%@", self.letter[row], self.number[row]);
//}

@end
