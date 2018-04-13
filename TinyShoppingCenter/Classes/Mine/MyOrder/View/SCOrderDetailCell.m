//
//  SCOrderDetailCell.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2018/1/24.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "SCOrderDetailCell.h"
#import "SCOrderDetailViewController.h"
#import "ChangeMyAddressViewController.h"
#import "AddressModel.h"
#import "SCMyOrderModel.h"
#import "ReturnGoodsViewController.h"
#import "SCCommentOrderViewController.h"

@implementation SCOrderDetailCell

-(void)fillData:(id)data {
    
}

-(void)callWithParameter:(id)parameter {
    
}

+(CGFloat)computeHeight:(id)data {
    return 0;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


#pragma mark - 物流信息
@implementation CKLogisticsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    bankView.backgroundColor = [UIColor tt_redMoneyColor];
    bankView.layer.cornerRadius = 5;
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.bottom.mas_offset(0);
    }];
    
    _leftImgageView = [[UIImageView alloc] init];
    [bankView addSubview:_leftImgageView];
    [_leftImgageView setImage:[UIImage imageNamed:@"logist"]];
    [_leftImgageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.left.mas_offset(30);
        make.size.mas_offset(CGSizeMake(48, 40));
    }];
    
    _logistLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_logistLable];
    _logistLable.numberOfLines = 0;
    _logistLable.text = @"       ";
    [_logistLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftImgageView.mas_top).offset(2);
        make.right.mas_offset(-10);
        make.left.equalTo(_leftImgageView.mas_right).offset(16);
    }];
}

-(void)fillData:(id)data {
    
    NSDictionary *dict = data;
    NSDictionary *orderDict = [dict objectForKey:@"data"];
    NSString *orderstatus = [NSString stringWithFormat:@"%@", [orderDict objectForKey:@"orderstatus"]];
    NSString *lastlogisticsmsg = [NSString stringWithFormat:@"%@", [orderDict objectForKey:@"lastlogisticsmsg"]];
    
    if ([orderstatus isEqualToString:@"待付款"] || [orderstatus isEqualToString:@"支付中"]) {
        _logistLable.text = @"等待买家付款";
    }else if ([orderstatus isEqualToString:@"待发货"] || [orderstatus isEqualToString:@"已付款"]) {
        _logistLable.text = @"等待商家发货";
    }else if ([orderstatus isEqualToString:@"已发货"] || [orderstatus isEqualToString:@"正在退货"] || [orderstatus isEqualToString:@"已收货"]) {
        if (IsNilOrNull(lastlogisticsmsg)) {
            _logistLable.text = @"暂无物流信息！";
            
        }else{
            _logistLable.text = lastlogisticsmsg;
        }
    }else if ([orderstatus isEqualToString:@"已取消"]){
        _logistLable.text = @"交易关闭";
    }else{
        _logistLable.text = @"交易成功";
    }
    [_logistLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftImgageView.mas_top).offset(10);
    }];
    [_leftImgageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-20);
    }];
}

@end

#pragma mark - 收件人信息
@implementation CKOrderGetterCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    
    _bankView = [[UIView alloc] init];
    _bankView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bankView];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.bottom.mas_offset(0);
        make.right.mas_offset(0);
    }];
    //收货人
    _getterLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_BODYTITLE_FONT];
    _getterLable.font = [UIFont boldSystemFontOfSize:16];
    _getterLable.text = @"收货人:";
    [_bankView addSubview:_getterLable];
    [_getterLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(30);
        make.bottom.mas_offset(-10);
    }];
    
    //联系电话
    _telPhoneLable = [UILabel configureLabelWithTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentRight font:MAIN_BODYTITLE_FONT];
    _telPhoneLable.font = [UIFont boldSystemFontOfSize:16];
    _telPhoneLable.text = @" ";
    [_bankView addSubview:_telPhoneLable];
    [_telPhoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_getterLable.mas_top);
        make.left.equalTo(_getterLable.mas_right).offset(15);
        make.right.mas_offset(-15);
        make.bottom.mas_offset(-10);
    }];
}

-(void)fillData:(id)data {
    if (data == nil) {
        return;
    }
    NSDictionary *dict = data;
    
    NSDictionary *detailDict = [dict objectForKey:@"data"];
    NSString *gettername = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"gettername"]];
    NSString *gettermobile = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"gettermobile"]];
    
    if (IsNilOrNull(gettername)) {
        gettername = @"";
    }
    _getterLable.text = [NSString stringWithFormat:@"收货人:%@",gettername];
    
    if (IsNilOrNull(gettermobile)) {
        gettermobile = @"";
    }
    _telPhoneLable.text = gettermobile;
}

@end

#pragma mark - 收获地址信息
@implementation CKOrderAddressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _bankView = [[UIView alloc] init];
    _bankView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bankView];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.bottom.mas_offset(0);
        make.right.mas_offset(0);
    }];
    //地址图标
    _addressImageView = [[UIImageView alloc] init];
    [_bankView addSubview:_addressImageView];
    UIImage *headimage = [UIImage imageNamed:@"location"];
    _addressImageView.image = [headimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //详细地址
    _addressDetailLable = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    _addressDetailLable.text = @" ";
    _addressDetailLable.numberOfLines = 0;
    [_bankView addSubview:_addressDetailLable];
    
    //定位图片
    [_addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bankView.mas_centerY);
        make.left.mas_offset(AdaptedWidth(10));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(14), AdaptedHeight(17)));
    }];
    
    //详细地址
    [_addressDetailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bankView.mas_centerY);
        make.left.mas_offset(AdaptedWidth(31));
        make.right.mas_offset(AdaptedWidth(-10));
        make.height.mas_equalTo(AdaptedWidth(44));
    }];
}

-(void)fillData:(id)data {
    if (data == nil) {
        return;
    }
    NSDictionary *dict = data;
    
    NSString *type = [dict objectForKey:@"type"];
    if ([type isEqualToString:@"default"]) {
        NSDictionary *detailDict = [dict objectForKey:@"data"];
        NSString *getteraddress = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"getteraddress"]];
        _addressDetailLable.text = getteraddress;
    }else if([type isEqualToString:@"changed"]){
        _addressDetailLable.text = [dict objectForKey:@"data"];;
    }
}

@end

#pragma mark - 更改地址
@implementation CKOrderChangeAddressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    _bankView = [[UIView alloc] init];
    _bankView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bankView];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(-0.5);
        make.left.mas_offset(0);
        make.bottom.mas_offset(0);
        make.right.mas_offset(0);
    }];
    //修改地址按钮
    _changeAdrrBtn = [UIButton new];
    _changeAdrrBtn.hidden = NO;
    _changeAdrrBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [_changeAdrrBtn setTitle:@"修改地址" forState:UIControlStateNormal];
    [_changeAdrrBtn setTitleColor:TitleColor forState:UIControlStateNormal];
    _changeAdrrBtn.layer.borderWidth = 0.5f;
    _changeAdrrBtn.layer.borderColor = TitleColor.CGColor;
    _changeAdrrBtn.layer.cornerRadius = 5.0f;
    _changeAdrrBtn.layer.masksToBounds = YES;
    [_changeAdrrBtn addTarget:self action:@selector(changeAdrress) forControlEvents:UIControlEventTouchUpInside];
    [_bankView addSubview:_changeAdrrBtn];
    
    [_changeAdrrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(1);
        make.bottom.mas_offset(-10);
        make.right.mas_offset(-10);
        make.width.mas_equalTo(80);
    }];
}

-(void)fillData:(id)data {
    if (data == nil) {
        return;
    }
    NSDictionary *dict = data[@"data"];
    _oidStr = [NSString stringWithFormat:@"%@", [dict objectForKey:@"oid"]];
    _orderStatus = [NSString stringWithFormat:@"%@", [dict objectForKey:@"orderStatus"]];
    self.orderNo = [NSString stringWithFormat:@"%@", [data objectForKey:@"orderid"]];
    //是否需要实名认证
    self.isNeedRealName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"isoversea"]];
    NSDictionary *dataDict = dict[@"data"];
    _paytime = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"paytime"]];
    _ordertime = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"ordertime"]];
    self.limitTime = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"limittime"]];
    
    self.systime = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"systime"]];
    
    self.gettername = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"gettername"]];
    self.gettermobile = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"gettermobile"]];
    
    NSString *getteraddress = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"getteraddress"]];
    NSArray *arr = [getteraddress componentsSeparatedByString:@" "];
    self.area = arr.firstObject;
    self.address = arr.lastObject;
}

-(void)changeAdrress {
    
    NSInteger limitTime = [self.limitTime integerValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";

    NSDate *payDate;
    if (!IsNilOrNull(self.paytime)) {
        payDate = [dateFormatter dateFromString:self.paytime];
    }else{
        payDate = [dateFormatter dateFromString:self.ordertime];
    }
    NSTimeInterval pay = [payDate timeIntervalSince1970];

    NSTimeInterval value = [self.systime longLongValue] - pay;
    CGFloat second = [[NSString stringWithFormat:@"%.2f",value] floatValue];//秒
    NSLog(@"间隔------%f秒",second);

    SCOrderDetailViewController *checkOrderVC;
    UIResponder *next = self.nextResponder;
    do {
        //判断响应者是否为视图控制器
        if ([next isKindOfClass:[SCOrderDetailViewController class]]) {
            checkOrderVC = (SCOrderDetailViewController*)next;
        }
        next = next.nextResponder;
    } while (next != nil);

    if (value > limitTime*60 && [_orderStatus isEqualToString:@"已付款"]) {
        [checkOrderVC hiddenChangeAddressBtn];
    }else{

        ChangeMyAddressViewController *address = [[ChangeMyAddressViewController alloc] init];
        [address setAddressBlock:^(AddressModel *addressModel) {
            NSLog(@"%@", addressModel);
            [checkOrderVC reloadOrderWithNewAdress:addressModel];
        }];
        address.pushString = @"CKOrderDetail";
        address.orderid = self.orderNo;
        address.isOversea = self.isNeedRealName;
        [checkOrderVC.navigationController pushViewController:address animated:YES];
    }
}

@end

#pragma mark - 分隔彩线
@implementation CKOrderSpaImageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    _bankView = [[UIView alloc] init];
    [self.contentView addSubview:_bankView];
    _bankView.backgroundColor = [UIColor whiteColor];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.bottom.mas_offset(0);
        make.right.mas_offset(0);
    }];
    //底边
    _bottomImageView = [[UIImageView alloc] init];
    [_bankView addSubview:_bottomImageView];
    [_bottomImageView setImage:[UIImage imageNamed:@"separateColorLine"]];
    [_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_offset(0);
        make.height.mas_offset(3);
    }];
}

@end

@interface CKGoodDetailCell ()

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, copy)   NSString *orderid;
@property (nonatomic, copy)   NSString *orderStatus;
@property (nonatomic, strong) SCOrderDetailGoodsModel *orderDetailGoodsM;

@property (nonatomic, strong) UIImageView *iconImageView;
/**名称*/
@property (nonatomic, strong) UILabel *nameLable;
/**购买数量*/
@property (nonatomic, strong) UILabel *numberLable;

@property (nonatomic, strong) UILabel *priceLable;

@property (nonatomic, strong) UILabel *specLabel;

@property (nonatomic, strong) UILabel *returnLabel;

@property (nonatomic, strong) UILabel *bottomLine;

@end

@implementation CKGoodDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createTopViews];
    }
    return self;
}

- (void)createTopViews {
    
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
    _iconImageView.layer.borderColor = [UIColor tt_grayBgColor].CGColor;
    _iconImageView.layer.borderWidth = 1;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(80, 80));
    }];
    
    _nameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_nameLable];
    _nameLable.numberOfLines = 2;
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_top);
        make.left.equalTo(_iconImageView.mas_right).offset(5);
        make.right.mas_offset(-100);
        make.height.mas_equalTo(40);
    }];
    
    //价格
    _priceLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_priceLable];
    _priceLable.text = @"¥5.00";
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLable.mas_top);
        make.right.mas_offset(-5);
        make.height.equalTo(@(20));
    }];
    
    //规格
    _specLabel = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    _specLabel.text = @"规格：";
    [self.contentView addSubview:_specLabel];
    [_specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20));
        make.left.equalTo(_iconImageView.mas_right).offset(5);
        make.bottom.equalTo(_iconImageView.mas_bottom);
    }];
    //数量
    _numberLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    _numberLable.text = @"数量";
    [self.contentView addSubview:_numberLable];
    [_numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20));
        make.right.mas_offset(-5);
        make.bottom.equalTo(_iconImageView.mas_bottom);
    }];
    
    
    //退货信息
    _returnLabel = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    _returnLabel.text = @" ";
    [self.contentView addSubview:_returnLabel];
    [_returnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
        make.left.equalTo(_iconImageView.mas_right).offset(5);
        make.bottom.equalTo(_iconImageView.mas_bottom);
    }];
    
    _rightBtn = [UIButton configureButtonWithTitle:@"去评价" titleColor:[UIColor whiteColor] bankGroundColor:[UIColor tt_redMoneyColor] cornerRadius:5 font:MAIN_SUBTITLE_FONT borderWidth:0 borderColor:[UIColor clearColor] target:self action:@selector(clickDetailBtn:)];
    _rightBtn.tag = 521;
    [self.contentView addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(10);
        make.right.mas_offset(-5);
        make.width.mas_offset(80);
        make.height.mas_offset(25);
    }];
    
    _leftBtn = [UIButton configureButtonWithTitle:@"我要退货" titleColor:TitleColor bankGroundColor:[UIColor whiteColor] cornerRadius:5 font:MAIN_SUBTITLE_FONT borderWidth:1 borderColor:SubTitleColor target:self action:@selector(clickDetailBtn:)];
    [self.contentView addSubview:_leftBtn];
    _leftBtn.tag = 520;
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.height.equalTo(_rightBtn);
        make.right.equalTo(_rightBtn.mas_left).offset(-10);
    }];
    
    _bottomLine = [UILabel creatLineLable];
    [self.contentView addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_offset(1);
    }];
}

-(void)clickDetailBtn:(UIButton *)button{
    NSInteger buttonTag = button.tag - 520;
    if (buttonTag == 0) {
        ReturnGoodsViewController *returnVc = [[ReturnGoodsViewController alloc] init];
        returnVc.detailModel = _orderDetailGoodsM;
        returnVc.orderid = self.orderid;
        [[UIViewController currentVC].navigationController pushViewController:returnVc animated:YES];
    }else{
        SCCommentOrderViewController *releaseComment = [[SCCommentOrderViewController alloc] init];
        releaseComment.goodsM = _orderDetailGoodsM;
        releaseComment.orderid = self.orderid;
        [[UIViewController currentVC].navigationController pushViewController:releaseComment animated:YES];
    }
}

#pragma mark - 刷新model数据
-(void)fillData:(id)data {
    if (data == nil) {
        return;
    }
    
    SCOrderDetailGoodsModel *detailGoodsM = [data objectForKey:@"data"];
    _orderDetailGoodsM = detailGoodsM;
    self.orderid = [NSString stringWithFormat:@"%@", [data objectForKey:@"orderid"]];

    NSString *imageString = [NSString stringWithFormat:@"%@", detailGoodsM.path];
    if (![imageString hasPrefix:@"http"]) {
        imageString = [BaseImagestr_Url stringByAppendingString:imageString];
    }
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"defaultover"]];
    
    NSString *name = [NSString stringWithFormat:@"%@", detailGoodsM.name];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    _nameLable.text = name;
    
    NSString *price = [NSString stringWithFormat:@"%@", detailGoodsM.price];
    if (IsNilOrNull(price)) {
        price = @"";
    }else{
        price = [NSString stringWithFormat:@"¥%@", price];
    }
    _priceLable.text = price;
    
    
    NSString *spec = [NSString stringWithFormat:@"%@", detailGoodsM.spec];
    if (IsNilOrNull(spec)) {
        spec = @"";
    }else{
        spec = [NSString stringWithFormat:@"规格:%@", spec];
    }
    _specLabel.text = spec;
    
    NSString *number = [NSString stringWithFormat:@"%@", detailGoodsM.count];
    if (IsNilOrNull(number)) {
        number = @"";
    }else{
        number = [NSString stringWithFormat:@"x%@", detailGoodsM.count];
    }
    _numberLable.text = number;
    
    
    NSString *iscomment = [NSString stringWithFormat:@"%@", detailGoodsM.iscomment];
    
    NSString *itemStatus = [NSString stringWithFormat:@"%@", detailGoodsM.status];
    
    
    [_specLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20));
        make.left.equalTo(_iconImageView.mas_right).offset(5);
        make.bottom.equalTo(_iconImageView.mas_bottom);
    }];
    
    [_numberLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20));
        make.right.mas_offset(-5);
        make.bottom.equalTo(_iconImageView.mas_bottom);
    }];
    
    [_returnLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
        make.left.equalTo(_iconImageView.mas_right).offset(5);
        make.bottom.equalTo(_iconImageView.mas_bottom);
    }];
    
    
    [_rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(10);
        make.right.mas_offset(-5);
        make.width.mas_offset(80);
        make.height.mas_offset(25);
    }];
    [_leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.height.equalTo(_rightBtn);
        make.right.equalTo(_rightBtn.mas_left).offset(-10);
    }];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_offset(1);
    }];
    
    //商品item订单状态（0：已取消 1：待付款；2：已付款，3：已收货；4:正在退货 5：退货成功，6：已完成，7：已发货 ）
    if ([itemStatus isEqualToString:@"1"] || [itemStatus isEqualToString:@"2"] || [itemStatus isEqualToString:@"0"] || [itemStatus isEqualToString:@"7"]) {
        _leftBtn.hidden = YES;
        _rightBtn.hidden = YES;
        
        [_leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0);
        }];
        
        [_rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0);
        }];
        
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_iconImageView.mas_bottom).offset(10);
            make.left.right.bottom.mas_offset(0);
            make.height.mas_offset(1);
        }];
        
        
    }else if ([itemStatus isEqualToString:@"3"]) {
        _leftBtn.hidden = NO;
        [_leftBtn setTitle:@"我要退货" forState:UIControlStateNormal];
        if ([iscomment isEqualToString:@"0"] || [iscomment isEqualToString:@"false"]) {
            _rightBtn.hidden = NO;
            [_rightBtn setTitle:@"去评价" forState:UIControlStateNormal];
        }else{
            _rightBtn.hidden = YES;
            
            [_leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_iconImageView.mas_bottom).offset(10);
                make.right.mas_offset(-5);
                make.width.mas_offset(80);
                make.height.mas_offset(25);
            }];
        }
        
    }else if ([itemStatus isEqualToString:@"4"] || [itemStatus isEqualToString:@"5"]) {
        
        [_returnLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.left.equalTo(_iconImageView.mas_right).offset(5);
            make.bottom.equalTo(_iconImageView.mas_bottom);
        }];
        
        [_specLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLable.mas_bottom);
            make.left.equalTo(_iconImageView.mas_right).offset(5);
            make.bottom.equalTo(_returnLabel.mas_top).offset(-3);
        }];
        
        [_numberLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLable.mas_bottom);
            make.right.mas_offset(-5);
            make.bottom.equalTo(_returnLabel.mas_top).offset(-3);
        }];
        
        
        
        if ([itemStatus isEqualToString:@"4"]) {
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@" 正在退货中"];
            // 添加表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            // 表情图片
            attch.image = [UIImage imageNamed:@"orderReturn"];
            // 设置图片大小
            attch.bounds = CGRectMake(0, -5, 21, 20);
            
            // 创建带有图片的富文本
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri insertAttributedString:string atIndex:0];
            _returnLabel.attributedText = attri;
        }else if ([itemStatus isEqualToString:@"5"]){
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@" 退货完成"];
            // 添加表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            // 表情图片
            attch.image = [UIImage imageNamed:@"orderReturn"];
            // 设置图片大小
            attch.bounds = CGRectMake(0, -5, 21, 20);
            
            // 创建带有图片的富文本
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri insertAttributedString:string atIndex:0];
            _returnLabel.attributedText = attri;
        }
        _leftBtn.hidden = YES;
        if ([iscomment isEqualToString:@"0"] || [iscomment isEqualToString:@"false"]) {
            _rightBtn.hidden = NO;
            [_rightBtn setTitle:@"去评价" forState:UIControlStateNormal];
        }else{
            _rightBtn.hidden = YES;
            [_leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(0);
            }];
            
            [_rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(0);
            }];
            
            [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_iconImageView.mas_bottom).offset(10);
                make.left.right.bottom.mas_offset(0);
                make.height.mas_offset(1);
            }];
        }
    }else if ([itemStatus isEqualToString:@"6"]) {
        _leftBtn.hidden = YES;
        if ([iscomment isEqualToString:@"0"] || [iscomment isEqualToString:@"false"]) {
            _rightBtn.hidden = NO;
            [_rightBtn setTitle:@"去评价" forState:UIControlStateNormal];
        }else{
            _rightBtn.hidden = YES;
            [_leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(0);
            }];
            
            [_rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(0);
            }];
            
            [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_iconImageView.mas_bottom).offset(10);
                make.left.right.bottom.mas_offset(0);
                make.height.mas_offset(1);
            }];
        }
    }else if ([itemStatus isEqualToString:@"8"]) {
        _leftBtn.hidden = YES;
        _rightBtn.hidden = YES;
        [_leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0);
        }];
        
        [_rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0);
        }];
    }
}

+(CGFloat)computeHeight:(id)data {
    
    SCOrderDetailGoodsModel *detailGoodsM = data;
    NSString *iscomment = [NSString stringWithFormat:@"%@", detailGoodsM.iscomment];
    NSString *itemStatus = [NSString stringWithFormat:@"%@", detailGoodsM.status];
    
    
    if ([itemStatus isEqualToString:@"1"] || [itemStatus isEqualToString:@"2"] || [itemStatus isEqualToString:@"0"] || [itemStatus isEqualToString:@"7"]) {
        return 110;
    }else if ([itemStatus isEqualToString:@"3"]) {
        return 140;
    }else if ([itemStatus isEqualToString:@"4"] || [itemStatus isEqualToString:@"5"]) {
        
        
        if ([iscomment isEqualToString:@"0"] || [iscomment isEqualToString:@"false"]) {
            return 140;
        }else{
            return 110;
        }
    }else if ([itemStatus isEqualToString:@"6"]) {
        if ([iscomment isEqualToString:@"0"] || [iscomment isEqualToString:@"false"]) {
            return 140;
        }else{
            return 110;
        }
    }
    
    return 110;
}

@end


#pragma mark - 订单金额与付款
@interface CKOrderPaymentCell ()

/**创客 or 消费者*/
@property (nonatomic, copy)   NSString *typeString;
@property (nonatomic, strong) UILabel *orderPriceLable;
@property (nonatomic, strong) UILabel *orderPriceText;
@property (nonatomic, strong) UILabel *textTransfree;
@property (nonatomic, strong) UILabel *transfeeNumberLable;
@property (nonatomic, strong) UILabel *realMoneyText;
@property (nonatomic, strong) UILabel *realMoneyLable;
@property (nonatomic, strong) UILabel *orderDicountL;
@property (nonatomic, strong) UILabel *orderDicoutLabel;
@property (nonatomic, strong) UIView *bankView;
@end

@implementation CKOrderPaymentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    self.bankView = [[UIView alloc] init];
    [self.contentView addSubview:self.bankView];
    [self.bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    //运费
    self.textTransfree = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.bankView addSubview:self.textTransfree];
    self.textTransfree.text = @"运费:";
    [self.textTransfree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(10);
        make.height.mas_equalTo(20);
    }];
    
    _transfeeNumberLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [self.bankView addSubview:_transfeeNumberLable];
    _transfeeNumberLable.text = @"¥0.00";
    [_transfeeNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textTransfree.mas_centerY);
        make.right.mas_offset(-10);
    }];
    
    //订单总额
    self.orderPriceText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.bankView addSubview:self.orderPriceText];
    self.orderPriceText.text = @"订单总额:";
    [self.orderPriceText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textTransfree.mas_bottom).offset(8);
        make.left.mas_offset(10);
        make.height.mas_equalTo(20);
    }];
    //订单总价
    _orderPriceLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [self.bankView addSubview:_orderPriceLable];
    _orderPriceLable.text = @"¥0.00";
    [_orderPriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.orderPriceText.mas_centerY);
        make.right.mas_offset(-10);
    }];
    
    //商品优惠
    self.orderDicoutLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.bankView addSubview:self.orderDicoutLabel];
    self.orderDicoutLabel.text = @"商品优惠:";
    self.orderDicoutLabel.hidden = YES;
    [self.orderDicoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderPriceText.mas_bottom).offset(8);
        make.left.mas_offset(10);
        make.height.mas_offset(20);
    }];
    
    _orderDicountL = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [self.bankView addSubview:_orderDicountL];
    _orderDicountL.text = @"¥0.00";
    self.orderDicountL.hidden = YES;
    [_orderDicountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.orderDicoutLabel.mas_centerY);
        make.right.mas_offset(-10);
    }];
    
    
    //实际付款
    self.realMoneyText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.bankView addSubview:self.realMoneyText];
    self.realMoneyText.text = @"实际付款:";
    [self.realMoneyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderPriceText.mas_bottom).offset(8);
        make.left.mas_offset(10);
        make.height.mas_offset(20);
    }];
    
    _realMoneyLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentRight font:MAIN_BODYTITLE_FONT];
    [self.bankView addSubview:_realMoneyLable];
    _realMoneyLable.text = @"¥0.00";
    [_realMoneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.realMoneyText.mas_centerY);
        make.right.mas_offset(-10);
    }];
    
    //分割线
    UILabel *middleLine = [UILabel creatLineLable];
    [self.bankView addSubview:middleLine];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
}

+(CGFloat)computeHeight:(id)data {
    if (data == nil) {
        return 28*3+20;
    }
    
    NSDictionary *dict = data;
    NSString *favormoney = [dict objectForKey:@"favormoney"];
    if (IsNilOrNull(favormoney) || [favormoney isEqualToString:@"0"] || [favormoney isEqualToString:@"0.00"]) {//没有使用优惠券
        return 28*3+20;
    }else{
        return 28*4+20;
    }
}

-(void)fillData:(id)data {
    
    if (data == nil) {
        return;
    }
    
    NSDictionary *dict = data;

    NSDictionary *detailDict = [dict objectForKey:@"data"];

    NSString *favormoney = [dict objectForKey:@"favormoney"];
    NSString *orderStatus = [dict objectForKey:@"orderStatus"];
    NSString *money = [dict objectForKey:@"money"];
    NSString *orderMoney = [dict objectForKey:@"orderMoney"];


    if (IsNilOrNull(favormoney) || [favormoney isEqualToString:@"0"] || [favormoney isEqualToString:@"0.00"]) {//没有使用优惠券
        _orderDicoutLabel.hidden = YES;
        _orderDicountL.hidden = YES;
        [self.realMoneyText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.orderPriceText.mas_bottom).offset(8);
            make.left.mas_offset(10);
            make.height.mas_offset(20);
        }];
    }else{//有使用优惠券
        _orderDicountL.text = [NSString stringWithFormat:@"-¥%.2f", [favormoney doubleValue]];
        _orderDicoutLabel.hidden = NO;
        _orderDicountL.hidden = NO;
        [self.realMoneyText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.orderDicoutLabel.mas_bottom).offset(8);
            make.left.mas_offset(10);
            make.height.mas_offset(20);
        }];
    }


    SCOrderDetailModel *infoModel = [[SCOrderDetailModel alloc] init];
    [infoModel setValuesForKeysWithDictionary:detailDict];

    //运费
    NSString *tranfee = [NSString stringWithFormat:@"%@", infoModel.transfee];
    if (IsNilOrNull(tranfee)) {
        tranfee = @"0.00";
    }
    _transfeeNumberLable.text = [NSString stringWithFormat:@"¥%.2f", [tranfee doubleValue]];

    //订单总价
    if (IsNilOrNull(orderMoney)) {
        orderMoney = @"0.00";
    }
    _orderPriceLable.text = [NSString stringWithFormat:@"¥%.2f", [orderMoney doubleValue]];

    //实际价格
    if (IsNilOrNull(money)) {
        money = @"0.00";
    }
    _realMoneyLable.text =[NSString stringWithFormat:@"¥%.2f", [money doubleValue]];
    if ([orderStatus isEqualToString:@"待付款"] || [orderStatus isEqualToString:@"已取消"]) {//未付款
        self.realMoneyText.text = @"应付款:";
    }else{
        self.realMoneyText.text = @"实际付款:";
    }
}

@end

#pragma mark - 支付方式物流单号等信息
@interface CKOrderInfoCell ()

@property (nonatomic, strong) UILabel *orderMessageLable;

@end

@implementation CKOrderInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    _orderMessageLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_orderMessageLable];
    _orderMessageLable.text = @" ";
    //mark 富文本
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_orderMessageLable.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_orderMessageLable.text length])];
    _orderMessageLable.attributedText = attributedString;
    _orderMessageLable.numberOfLines = 0;
    
    [_orderMessageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.bottom.mas_offset(-10);
    }];
}

-(void)fillData:(id)data {
    
    if (data == nil) {
        return;
    }
    
    NSDictionary *dict = data;

    NSDictionary *detailDict = [dict objectForKey:@"data"];

    SCOrderDetailModel *infoModel = [[SCOrderDetailModel alloc] init];
    [infoModel setValuesForKeysWithDictionary:detailDict];

    NSString *orderNo = [NSString stringWithFormat:@"%@",  infoModel.no];    
    NSString *transNo = [NSString stringWithFormat:@"%@",  infoModel.transno];
    NSString *tranName = [NSString stringWithFormat:@"%@", infoModel.transname];
    NSString *ordertime = [NSString stringWithFormat:@"%@", infoModel.ordertime];
    NSString *paytime = [NSString stringWithFormat:@"%@",infoModel.paytime];
    NSString *paytimeold = [NSString stringWithFormat:@"%@", infoModel.paytimeold];
    NSString *payno = [NSString stringWithFormat:@"%@", infoModel.payno];
    NSString *paynoold = [NSString stringWithFormat:@"%@", infoModel.paynoold];
    NSString *paymethod = [NSString stringWithFormat:@"%@", infoModel.paymethod];
    NSString *paymethodold = [NSString stringWithFormat:@"%@", infoModel.paymethodold];
    
    if (IsNilOrNull(orderNo)) {
        orderNo = @"";
    }
    if (IsNilOrNull(transNo)) {
        transNo = @"";
    }
    if (IsNilOrNull(tranName)) {
        tranName = @"";
    }
    if (IsNilOrNull(ordertime)) {
        ordertime = @"";
    }
    if (IsNilOrNull(paytime)) {
        paytime = @"";
    }
    if (IsNilOrNull(paytimeold)) {
        paytimeold = @"";
    }
    if (IsNilOrNull(paymethod)) {
        paymethod = @"";
    }
    if (IsNilOrNull(paymethodold)) {
        paymethodold = @"";
    }
    if (IsNilOrNull(payno)) {
        payno = @"";
    }
    if (IsNilOrNull(paynoold)) {
        paynoold = @"";
    }

    NSString *orderfrom = [NSString stringWithFormat:@"%@", dict[@"orderfrom"]];
    NSString *balancemoney = [NSString stringWithFormat:@"%@", dict[@"balancemoney"]];
    if ([orderfrom isEqualToString:@"3"]) {
        //显示原始订单信息
        //需要补差价的 [balancemoney doubleValue] > 0
        if ([balancemoney doubleValue] > 0) {
            _orderMessageLable.text = [NSString stringWithFormat:@"订单号:%@\n物流公司:%@\n物流单号:%@\n下单日期:%@\n原订单支付方式:%@\n原订单支付流水号:%@\n原订单支付日期:%@\n新订单支付方式:%@\n新订单支付流水号:%@\n新订单支付日期:%@", orderNo, tranName, transNo, ordertime, paymethodold, paynoold, paytimeold, paymethod, payno, paytime];

        }else{
            _orderMessageLable.text = [NSString stringWithFormat:@"订单号:%@\n物流公司:%@\n物流单号:%@\n下单日期:%@\n支付方式:%@\n支付流水号:%@\n支付日期:%@", orderNo, tranName, transNo, ordertime, paymethodold, paynoold, paytimeold];
        }
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_orderMessageLable.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:10];//调整行间距
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_orderMessageLable.text length])];
        _orderMessageLable.attributedText = attributedString;
        _orderMessageLable.numberOfLines = 0;
    }else{
        if ([infoModel.orderstatus isEqualToString:@"待付款"] || [infoModel.orderstatus isEqualToString:@"已取消"]) {
             _orderMessageLable.text = [NSString stringWithFormat:@"订单号:%@\n下单日期:%@", orderNo, ordertime];
        }else if ([infoModel.orderstatus isEqualToString:@"已付款"]) {
            _orderMessageLable.text = [NSString stringWithFormat:@"订单号:%@\n下单日期:%@\n支付方式:%@\n支付流水号:%@\n支付日期:%@", orderNo, ordertime, paymethod, payno, paytime];
        }else{
            _orderMessageLable.text = [NSString stringWithFormat:@"订单号:%@\n物流公司:%@\n物流单号:%@\n下单日期:%@\n支付方式:%@\n支付流水号:%@\n支付日期:%@", orderNo, tranName, transNo, ordertime, paymethod, payno, paytime];
        }
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_orderMessageLable.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:10];//调整行间距
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_orderMessageLable.text length])];
        _orderMessageLable.attributedText = attributedString;
        _orderMessageLable.numberOfLines = 0;
    }
}

+ (CGFloat)computeHeight:(id)data {
    if (!data) {
        return 300;
    }
    NSDictionary *dict = data;
    
    NSDictionary *detailDict = [dict objectForKey:@"data"];
    
    SCOrderDetailModel *infoModel = [[SCOrderDetailModel alloc] init];
    [infoModel setValuesForKeysWithDictionary:detailDict];
    
    NSString *orderfrom = [NSString stringWithFormat:@"%@", dict[@"orderfrom"]];
    NSString *balancemoney = [NSString stringWithFormat:@"%@", dict[@"balancemoney"]];
    
    if ([orderfrom isEqualToString:@"3"] && ([balancemoney doubleValue] > 0)) {
        return 300;
    }else{
        if ([infoModel.orderstatus isEqualToString:@"待付款"]|| [infoModel.orderstatus isEqualToString:@"已取消"]) {
            return 70;
        }else if ([infoModel.orderstatus isEqualToString:@"已付款"]) {
            return 170;
        }else{
            return 220;
        }
    }
}

@end

#pragma mark - 返积分
@interface SCReturnIntegralCell()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *jfBtn;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation SCReturnIntegralCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI {
    self.backgroundColor = [UIColor tt_grayBgColor];
    _bgView = [UIView new];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    _jfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _jfBtn.layer.cornerRadius = 3.0;
    _jfBtn.layer.masksToBounds = YES;
    _jfBtn.layer.borderWidth = 1.0;
    _jfBtn.layer.borderColor = [UIColor tt_redMoneyColor].CGColor;
    [_jfBtn setTitle:@"积分" forState:UIControlStateNormal];
    [_jfBtn setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];
    [_bgView addSubview:_jfBtn];
    [_jfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_offset(10);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(30);
        
    }];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.text = @"返点积分2点";
    _tipLabel.textColor = TitleColor;
    [_bgView addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_jfBtn.mas_centerY);
        make.left.mas_offset(60);
        make.right.mas_offset(0);
        make.height.equalTo(@30);
    }];
}

- (void)fillData:(id)data {
    if (!data) {
        return;
    }
    
    NSString *point = data[@"integralnum"];
    NSString *str = [NSString stringWithFormat:@"返点积分%@点", point];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = [str rangeOfString:@"返点积分"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor tt_redMoneyColor] range:NSMakeRange(range.length, point.length)];
    _tipLabel.attributedText = attributedString;
}


@end

#pragma mark - 原订单信息
@interface CKOriginalOrderInfoCell ()

@property (nonatomic, strong) UIImageView *markImgView;
@property (nonatomic, strong) UILabel *orderNoLable;
@property (nonatomic, strong) UILabel *orderMoneyLabel;
@property (nonatomic, strong) UIButton *rightArrowBtn;

@end

@implementation CKOriginalOrderInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    
    UILabel *line = [UILabel creatLineLable];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_offset(0);
        make.left.mas_offset(30);
        make.height.mas_equalTo(1);
    }];
    
    self.markImgView = [UIImageView new];
    self.markImgView.image = [UIImage imageNamed:@"originOrder"];
    [self.contentView addSubview:self.markImgView];
    [self.markImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.orderNoLable = [UILabel new];
    self.orderNoLable.text = @" ";
    self.orderNoLable.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.orderNoLable];
    [self.orderNoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(30);
        make.height.mas_equalTo(30);
    }];
    
    self.rightArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightArrowBtn setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
    [self.rightArrowBtn addTarget:self action:@selector(showDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.rightArrowBtn];
    [self.rightArrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.right.mas_offset(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    self.orderMoneyLabel = [UILabel new];
    self.orderMoneyLabel.text = @" ";
    self.orderMoneyLabel.font = [UIFont systemFontOfSize:13];
    self.orderMoneyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.orderMoneyLabel];
    [self.orderMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.height.mas_equalTo(30);
        make.right.equalTo(self.rightArrowBtn.mas_left).offset(-5);
        make.left.equalTo(self.orderNoLable.mas_right);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetail)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)fillData:(id)data {
    
    NSString *tag = data[@"tag"];
    NSArray *array = data[@"data"];
    NSInteger i = [tag integerValue];

    if (0 == i) {
        self.markImgView.hidden = NO;
        self.orderNoLable.textColor = [UIColor colorWithHexString:@"#333333"];
        self.orderMoneyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }else{
        self.markImgView.hidden = YES;
        self.orderNoLable.textColor = [UIColor colorWithHexString:@"#666666"];
        self.orderMoneyLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }

    CKOldDetailModel *oldDetailM = array[i];
    self.orderNoLable.text = oldDetailM.orderno;
    self.orderMoneyLabel.text = oldDetailM.ordermoney;

    self.rightArrowBtn.tag = 6666+i;
}

- (void)showDetail {
    
    NSLog(@"self.rightArrowBtn:%@", self.rightArrowBtn);
    self.rightArrowBtn.selected = !self.rightArrowBtn.selected;
    if (self.rightArrowBtn.selected) {
        [self.rightArrowBtn setImage:[UIImage imageNamed:@"bottomarrow"] forState:UIControlStateNormal];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(showOriginalOrderDetail:index:)]) {
            [self.delegate showOriginalOrderDetail:self index:self.rightArrowBtn.tag-6666];
        }
        
    }else{
        [self.rightArrowBtn setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(closeOriginalOrderDetail:index:)]) {
            [self.delegate closeOriginalOrderDetail:self index:self.rightArrowBtn.tag-6666];
        }
    }
}

@end


//原订单商品信息
@interface CKOriginalOrderGoodsCell ()

@property (nonatomic, strong) UILabel *goodsNameLabel;
@property (nonatomic, strong) UILabel *buyCountLable;

@end

@implementation CKOriginalOrderGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    self.buyCountLable = [UILabel new];
    self.buyCountLable.text = @"x1";
    self.buyCountLable.textAlignment = NSTextAlignmentRight;
    self.buyCountLable.textColor = [UIColor colorWithHexString:@"#777777"];
    self.buyCountLable.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.buyCountLable];
    [self.buyCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.right.mas_offset(-10);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(60);
    }];
    
    self.goodsNameLabel = [UILabel new];
    self.goodsNameLabel.text = @" ";
    self.goodsNameLabel.textColor = [UIColor colorWithHexString:@"#777777"];
    self.goodsNameLabel.font = [UIFont systemFontOfSize:13];
    self.goodsNameLabel.numberOfLines = 0;
    [self.contentView addSubview:self.goodsNameLabel];
    [self.goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(30);
        make.right.equalTo(self.buyCountLable.mas_left).offset(-15);
        make.bottom.mas_offset(0);
    }];
}

- (void)fillData:(id)data {
    
    CKGoodsDetailModel *goodsM = data[@"data"];
    self.goodsNameLabel.text = goodsM.name;
    self.buyCountLable.text = [NSString stringWithFormat:@"x%@", goodsM.count];
}

+ (CGFloat)computeHeight:(id)data {
    if (!data) {
        return 40;
    }
    CKGoodsDetailModel *goodsM = data;
    NSString *name = [NSString stringWithFormat:@"%@", goodsM.name];
    CGFloat h = [name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 115, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil].size.height;
    return h+15;
}

@end


#pragma mark - 换货订单信息
@interface CKChangeOrderInfoCell ()

@property (nonatomic, strong) UIImageView *markImgView;
@property (nonatomic, strong) UILabel *orderNoLable;
@property (nonatomic, strong) UILabel *orderMoneyLabel;
@property (nonatomic, strong) UIButton *rightArrowBtn;

@end

@implementation CKChangeOrderInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    
    UILabel *line = [UILabel creatLineLable];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_offset(0);
        make.left.mas_offset(30);
        make.height.mas_equalTo(1);
    }];
    
    self.markImgView = [UIImageView new];
    self.markImgView.image = [UIImage imageNamed:@"order_changeGoods"];
    [self.contentView addSubview:self.markImgView];
    [self.markImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.orderNoLable = [UILabel new];
    self.orderNoLable.text = @" ";
    self.orderNoLable.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.orderNoLable];
    [self.orderNoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(30);
        make.height.mas_equalTo(30);
    }];
    
    
    self.rightArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightArrowBtn setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
    [self.rightArrowBtn addTarget:self action:@selector(showDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.rightArrowBtn];
    [self.rightArrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.right.mas_offset(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    self.orderMoneyLabel = [UILabel new];
    self.orderMoneyLabel.text = @" ";
    self.orderMoneyLabel.font = [UIFont systemFontOfSize:13];
    self.orderMoneyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.orderMoneyLabel];
    [self.orderMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.height.mas_equalTo(30);
        make.right.equalTo(self.rightArrowBtn.mas_left).offset(-5);
        make.left.equalTo(self.orderNoLable.mas_right);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetail)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)fillData:(id)data {

    NSString *tag = data[@"tag"];
    NSArray *array = data[@"data"];
    NSInteger i = [tag integerValue];

    if (0 == i) {
        self.markImgView.hidden = NO;
        self.orderNoLable.textColor = [UIColor colorWithHexString:@"#333333"];
        self.orderMoneyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }else{
        self.markImgView.hidden = YES;
        self.orderNoLable.textColor = [UIColor colorWithHexString:@"#666666"];
        self.orderMoneyLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }

    CKOldDetailModel *oldDetailM = array[i];
    self.orderNoLable.text = oldDetailM.orderno;
    self.orderMoneyLabel.text = oldDetailM.ordermoney;

    self.rightArrowBtn.tag = 7777+i;
}

- (void)showDetail {
    
    NSLog(@"self.rightArrowBtn:%@", self.rightArrowBtn);
    self.rightArrowBtn.selected = !self.rightArrowBtn.selected;
    if (self.rightArrowBtn.selected) {
        [self.rightArrowBtn setImage:[UIImage imageNamed:@"bottomarrow"] forState:UIControlStateNormal];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(showChangeOrderDetail:index:)]) {
            [self.delegate showChangeOrderDetail:self index:self.rightArrowBtn.tag-7777];
        }
        
    }else{
        [self.rightArrowBtn setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(closeChangeOrderDetail:index:)]) {
            [self.delegate closeChangeOrderDetail:self index:self.rightArrowBtn.tag-7777];
        }
    }
}

@end

//换货订单商品信息
@interface CKChangOrderGoodsCell ()

@property (nonatomic, strong) UILabel *goodsNameLabel;
@property (nonatomic, strong) UILabel *buyCountLable;

@end

@implementation CKChangOrderGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    
    self.buyCountLable = [UILabel new];
    self.buyCountLable.text = @"x1";
    self.buyCountLable.textAlignment = NSTextAlignmentRight;
    self.buyCountLable.textColor = [UIColor colorWithHexString:@"#777777"];
    self.buyCountLable.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.buyCountLable];
    [self.buyCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.right.mas_offset(-10);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(60);
    }];
    
    self.goodsNameLabel = [UILabel new];
    self.goodsNameLabel.text = @" ";
    self.goodsNameLabel.textColor = [UIColor colorWithHexString:@"#777777"];
    self.goodsNameLabel.font = [UIFont systemFontOfSize:13];
    self.goodsNameLabel.numberOfLines = 0;
    [self.contentView addSubview:self.goodsNameLabel];
    [self.goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(30);
        make.right.equalTo(self.buyCountLable.mas_left).offset(-15);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)fillData:(id)data {
    
    CKGoodsDetailModel *goodsM = data[@"data"];
    self.goodsNameLabel.text = goodsM.name;
    self.buyCountLable.text = [NSString stringWithFormat:@"x%@", goodsM.count];
}

+ (CGFloat)computeHeight:(id)data {
    if (!data) {
        return 40;
    }
    CKGoodsDetailModel *goodsM = data;
    NSString *name = [NSString stringWithFormat:@"%@", goodsM.name];
    CGFloat h = [name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 115, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil].size.height;
    return h+15;
}

@end
