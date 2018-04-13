//
//  SCMineInfoViewController.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCMineInfoViewController.h"
#import "WYGenderPickerView.h"
#import "WYBirthdayPickerView.h"
//#import <JrmfWalletKit/JrmfWalletKit.h>


@interface SCMineInfoViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIView *bankView;
@property (nonatomic, strong) UITextField *nickNameTextfield;
@property (nonatomic, strong) UITextField *nameTextfield;
@property (nonatomic, strong) UITextField *phoneTextfield;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIImageView *headImgV;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong) UITableView *infoTableView;
@property (nonatomic, strong) UILabel *birthDayLabel;
@property (nonatomic, strong) UILabel *sexLabel;

@end

@implementation SCMineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    [self createUI];
}

-(void)createUI{
    
    _bankView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+5+NaviAddHeight,  SCREEN_WIDTH, 320)];
    [_bankView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_bankView];
    float h = 0;
    NSArray * titleArr = @[@"  头像",@"  昵称",@"  姓名",@"  手机号码",@"  生日",@"  性别"];
    for (int i = 0; i<titleArr.count;i++){
        float height = 0;
        if (i == 0) {
            height = 75;
            _headImgV = [UIImageView new];
            [_bankView addSubview:_headImgV];
            _headImgV.layer.cornerRadius = 60/2;
            _headImgV.clipsToBounds = YES;
            NSString *headPath = self.userInfoM.head;
            [_headImgV sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:[UIImage imageNamed:@"name"]];
            _headImgV.frame = CGRectMake(SCREEN_WIDTH - 75, 7.5, 60, 60);
        }else{
            height = 50;
        }
        UILabel *leftLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
        [_bankView addSubview:leftLable];
        leftLable.frame = CGRectMake(10,h,SCREEN_WIDTH*0.5, height);
        leftLable.text = titleArr[i];
        
        //中间的分割线
        UILabel *lineL = [UILabel creatLineLable];
        lineL.frame = CGRectMake(10,CGRectGetMaxY(leftLable.frame), SCREEN_WIDTH-20, 1);
        [_bankView addSubview:lineL];
        
        if (i == 1) {
            _nickNameTextfield = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.5, leftLable.frame.origin.y, SCREEN_WIDTH*0.5 - 10, height)];
            _nickNameTextfield.delegate = self;
            _nickNameTextfield.textColor = TitleColor;
            _nickNameTextfield.font = MAIN_TITLE_FONT;
            _nickNameTextfield.textAlignment = NSTextAlignmentRight;
            [_bankView addSubview:_nickNameTextfield];
            _nickNameTextfield.placeholder = @"未填写";
            NSString *smallName = [NSString stringWithFormat:@"%@", self.userInfoM.smallname];
            if (!IsNilOrNull(smallName)) {
                _nickNameTextfield.text = smallName;
            }
        }
        
        if (i == 2) {
            _nameTextfield = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.5, leftLable.frame.origin.y, SCREEN_WIDTH*0.5 - 10, height)];
            _nameTextfield.delegate = self;
            _nameTextfield.textColor = TitleColor;
            _nameTextfield.font = MAIN_TITLE_FONT;
            _nameTextfield.textAlignment = NSTextAlignmentRight;
            [_bankView addSubview:_nameTextfield];
            _nickNameTextfield.placeholder = @"未填写";
            NSString *realname = [NSString stringWithFormat:@"%@", self.userInfoM.realname];
            if (!IsNilOrNull(realname)) {
                _nameTextfield.text = realname;
            }
        }
        if (i == 3) {
            _phoneTextfield = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.5, leftLable.frame.origin.y, SCREEN_WIDTH*0.5 - 10, height)];
            _phoneTextfield.delegate = self;
            _phoneTextfield.textColor = TitleColor;
            _phoneTextfield.font = MAIN_TITLE_FONT;
            _phoneTextfield.textAlignment = NSTextAlignmentRight;
            [_bankView addSubview:_phoneTextfield];
            _phoneTextfield.placeholder = @"未填写";
            NSString *mobile = [NSString stringWithFormat:@"%@", self.userInfoM.mobile];
            if (!IsNilOrNull(mobile)) {
                _phoneTextfield.text = mobile;
                _phoneTextfield.enabled = NO;
            }else{
                _phoneTextfield.enabled = YES;
            }
            
        }
        
        if (i == 4) {
            _birthDayLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
            
            NSString *birthdate = [NSString stringWithFormat:@"%@", self.userInfoM.birthdate];
            if (!IsNilOrNull(birthdate)) {
                _birthDayLabel.text = birthdate;
            }else{
                _birthDayLabel.text = @"请选择";
            }
            _birthDayLabel.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseBirthDay)];
            _birthDayLabel.frame = CGRectMake(SCREEN_WIDTH*0.5, h, SCREEN_WIDTH*0.5 - 10, height);
            [_bankView addSubview:_birthDayLabel];
            [_birthDayLabel addGestureRecognizer:tap];
        }
        if (i == 5) {
            _sexLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
            NSString *sex = [NSString stringWithFormat:@"%@", self.userInfoM.sex];
            if (!IsNilOrNull(sex)) {
                _sexLabel.text = sex;
            }else{
                _sexLabel.text = @"请选择";
            }
            _sexLabel.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseSex)];
            _sexLabel.frame = CGRectMake(SCREEN_WIDTH*0.5, h, SCREEN_WIDTH*0.5 - 10, height);
            [_bankView addSubview:_sexLabel];
            [_sexLabel addGestureRecognizer:tap];
        }
        h+=height;
    }
    
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_saveButton];
    _saveButton.layer.cornerRadius = 5;
    _saveButton.clipsToBounds = YES;
    _saveButton.titleLabel.font = MAIN_TITLE_FONT;
    _saveButton.backgroundColor = [UIColor tt_redMoneyColor];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-10-BOTTOM_BAR_HEIGHT);
        make.left.mas_offset(5);
        make.right.mas_offset(-5);
        make.height.mas_offset(50);
    }];
    [_saveButton addTarget:self action:@selector(clickAddressButton) forControlEvents:UIControlEventTouchUpInside];
    
    //进入融云我的钱包
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:btn];
//    [btn setTitle:@"我的钱包" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(rcWallet) forControlEvents:UIControlEventTouchUpInside];
//    btn.frame = CGRectMake(0, 100, SCREEN_WIDTH*0.5 - 10, 30);

}


//- (void)rcWallet {
//
//    [JrmfWalletSDK openWallet];
//}

-(void)chooseBirthDay {
    
    [_nickNameTextfield resignFirstResponder];
    [_nameTextfield resignFirstResponder];
    [_phoneTextfield resignFirstResponder];
    
    
    NSString *birthDay = nil;
    if (IsNilOrNull(self.userInfoM.birthdate)) {
        birthDay = self.userInfoM.birthdate;
    }
    WYBirthdayPickerView *birthdayPickerView = [[WYBirthdayPickerView alloc] initWithInitialDate:birthDay];
    birthdayPickerView.confirmBlock = ^(NSString *selectedDate) {
        _birthDayLabel.text = selectedDate;
    };
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[WYBirthdayPickerView class]]) {
            [view removeFromSuperview];
        }
    }
    [self.view addSubview:birthdayPickerView];
}

-(void)chooseSex {
    
    [_nickNameTextfield resignFirstResponder];
    [_nameTextfield resignFirstResponder];
    [_phoneTextfield resignFirstResponder];
    
    NSString *sex = @"保密";
    if ([self.userInfoM.sex isEqualToString:@"请选择"] || IsNilOrNull(self.userInfoM.sex)) {
        sex = @"保密";
    }else{
        sex = self.userInfoM.sex;
    }
    
    WYGenderPickerView *genderPickerView = [[WYGenderPickerView alloc] initWithInitialGender:sex];
    genderPickerView.confirmBlock = ^(NSString *selectedGender) {
        _sexLabel.text = selectedGender;
    };
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[WYGenderPickerView class]]) {
            [view removeFromSuperview];
        }
    }
    [self.view addSubview:genderPickerView];
}

-(void)clickAddressButton{    
    NSString *updateMeInfoUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI,UpdateMeInfoUrl];
    NSData *data = UIImageJPEGRepresentation(self.img, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *pramaDic = [NSMutableDictionary dictionary];
    [pramaDic setValue:USER_OPENID forKey:@"openid"];
    if (self.img != nil) {
        [pramaDic setValue:encodedImageStr forKey:@"head"];
    }
    if (!IsNilOrNull(_nickNameTextfield.text)) {
        [pramaDic setValue:_nickNameTextfield.text forKey:@"smallname"];
    }
    if (!IsNilOrNull(_nameTextfield.text)) {
        [pramaDic setValue:_nameTextfield.text forKey:@"realname"];
    }
    if (!IsNilOrNull(_phoneTextfield.text)) {
        [pramaDic setValue:_phoneTextfield.text forKey:@"mobile"];
    }
    if (!IsNilOrNull(_birthDayLabel.text) && ![_birthDayLabel.text isEqualToString:@"请选择生日"]) {
        [pramaDic setValue:_birthDayLabel.text forKey:@"birthdate"];
    }
    if (!IsNilOrNull(_sexLabel.text) && ![_sexLabel.text isEqualToString:@"请选择性别"]) {
        [pramaDic setValue:_sexLabel.text forKey:@"sex"];
    }
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:updateMeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"msg"]];
            return ;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeHeadIconSuccessNotification" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
