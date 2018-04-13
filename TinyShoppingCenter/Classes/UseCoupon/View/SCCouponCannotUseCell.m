//
//  SCCouponCannotUseCell.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/12/15.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCCouponCannotUseCell.h"
#import "DashLineView.h"

@interface SCCouponCannotUseCell()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *moneyLable;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *validDate;
@property (nonatomic, strong) UILabel *detailLable;
@property (nonatomic, strong) UILabel *detailContent;
@property (nonatomic, strong) SCCouponModel *couponM;
@property (nonatomic, strong) UIButton *expandArrow;
@property (nonatomic, strong) UILabel *dashLine;

@end

@implementation SCCouponCannotUseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    
    self.imgView = [UIImageView new];
    self.imgView.image = [SCCommon imageWithColor:[UIColor colorWithHexString:@"#AAAAAA"] rect:CGRectMake(1, 1, 1, 1)];
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(85);
    }];
    
    self.moneyLable = [UILabel new];
    self.moneyLable.text = @"¥0.00";
    self.moneyLable.backgroundColor = [UIColor clearColor];
    self.moneyLable.textColor = [UIColor whiteColor];
    self.moneyLable.textAlignment = NSTextAlignmentCenter;
    self.moneyLable.font = [UIFont systemFontOfSize:22];
    [self.contentView addSubview:self.moneyLable];
    [self.moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.mas_offset(0);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(100);
    }];
    
    self.nameLable = [UILabel new];
    self.nameLable.text = @" ";
    self.nameLable.backgroundColor = [UIColor clearColor];
    self.nameLable.textColor = [UIColor whiteColor];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.font = [UIFont systemFontOfSize:12];
    self.nameLable.numberOfLines = 0;
    [self.contentView addSubview:self.nameLable];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLable.mas_bottom).offset(0);
        make.width.mas_equalTo(100);
        make.left.mas_offset(0);
        make.height.mas_equalTo(30);
    }];
    
    
    self.typeLabel = [UILabel new];
    self.typeLabel.text = @" ";
    self.typeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.typeLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.right.mas_offset(-10);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    self.validDate = [UILabel new];
    self.validDate.text = @" ";
    self.validDate.textColor = [UIColor colorWithHexString:@"#999999"];
    if ([UIScreen mainScreen].bounds.size.height < 667) {
        self.validDate.font = [UIFont systemFontOfSize:10];
    }else{
        self.validDate.font = [UIFont systemFontOfSize:12];
    }
    [self.contentView addSubview:self.validDate];
    [self.validDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLabel.mas_bottom);
        make.right.mas_offset(-10);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.height.mas_equalTo(30);
    }];
    
//    DashLineView *dashLine = [[DashLineView alloc] initWithFrame:CGRectMake(110, 60, SCREEN_WIDTH-110-10, 1) lineDashPattern:@[@3, @3] endOffset:0.495];
//    dashLine.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
//    [self.contentView addSubview:dashLine];
    self.dashLine = [UILabel creatLineLable];
    self.dashLine.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    [self.contentView addSubview:self.dashLine];
    [self.dashLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.validDate.mas_bottom);
        make.right.mas_offset(-10);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    self.detailLable = [UILabel new];
    self.detailLable.text = @"详细信息";
    self.detailLable.font = [UIFont systemFontOfSize:12.0];
    self.detailLable.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:self.detailLable];
    [self.detailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.validDate.mas_bottom).offset(1);
        make.width.mas_equalTo(50);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.height.mas_equalTo(24);
    }];
    
    self.expandArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.expandArrow setImage:[UIImage imageNamed:@"bottomarrow"] forState:UIControlStateNormal];
    [self.expandArrow setTitle:@"0" forState:UIControlStateNormal];
    [self.expandArrow setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    self.expandArrow.selected = NO;
    [self.contentView addSubview:self.expandArrow];
    [self.expandArrow addTarget:self action:@selector(expandOrNot:) forControlEvents:UIControlEventTouchUpInside];
    [self.expandArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.detailLable.mas_centerY);
        make.width.mas_equalTo(20);
        make.right.mas_offset(-10);
        make.height.mas_equalTo(12);
    }];
    
    self.detailContent = [UILabel new];
    self.detailContent.numberOfLines = 0;
    self.detailContent.font = [UIFont systemFontOfSize:13];
    self.detailContent.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:self.detailContent];
    [self.detailContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.top.equalTo(self.detailLable.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    
    UIImageView *uselessView = [UIImageView new];
    uselessView.image = [UIImage imageNamed:@"uselessMask"];
    uselessView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:uselessView];
    [uselessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_equalTo(48);
        make.width.mas_equalTo(64);
    }];
    
}

-(void)expandOrNot:(UIButton*)btn {
    
    if ([btn.titleLabel.text isEqualToString:@"0"]) {
        [btn setImage:[UIImage imageNamed:@"upArrow"] forState:UIControlStateNormal];
        [btn setTitle:@"1" forState:UIControlStateNormal];

        if (self.delegate && [self.delegate respondsToSelector:@selector(expandCannotUserDetailContent:)]) {
            [self.delegate expandCannotUserDetailContent:self];
        }
    }else{
        [btn setImage:[UIImage imageNamed:@"bottomarrow"] forState:UIControlStateNormal];
        [btn setTitle:@"0" forState:UIControlStateNormal];

        if (self.delegate && [self.delegate respondsToSelector:@selector(closeCannotUserDetailContent:)]) {
            [self.delegate closeCannotUserDetailContent:self];
        }
    }
}

-(void)refreshCouponWithCouponModel:(SCCouponModel*)couponM {
    self.couponM = couponM;
    
    NSString *details = [NSString stringWithFormat:@"%@", couponM.details];
    if (IsNilOrNull(details)) {
        NSString *content = [NSString stringWithFormat:@"%@", couponM.content];
        if (!IsNilOrNull(content)) {
            details = content;
        }
    }
    
    if (IsNilOrNull(details)) {
        self.dashLine.hidden = YES;
        _expandArrow.hidden = YES;
        self.detailLable.hidden = YES;
    }
    
    CGFloat h = [details boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil].size.height+20;
    if (couponM.isExpand) {
        [self.detailContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.right.mas_offset(-10);
            make.top.equalTo(self.imgView.mas_bottom);
            make.height.mas_equalTo(h);
        }];
    }else{
        [self.detailContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.right.mas_offset(-10);
            make.top.equalTo(self.imgView.mas_bottom);
            make.height.mas_equalTo(0);
        }];
    }
    
    self.detailContent.text = details;
    
    NSString *money = [NSString stringWithFormat:@"%@", couponM.money];
    if (IsNilOrNull(money)) {
        money = @"0.00";
    }
    if ([money doubleValue] >= 1000.0) {
        self.moneyLable.font = [UIFont systemFontOfSize:20];
    }
    self.moneyLable.text = [NSString stringWithFormat:@"¥%.2f", [money doubleValue]];
    
    NSString *userange = [NSString stringWithFormat:@"%@", couponM.userange];
    if (IsNilOrNull(userange)) {
        userange = @"";
    }
    self.typeLabel.text = userange;
    
    NSString *name = [NSString stringWithFormat:@"%@", couponM.name];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    self.nameLable.text = name;
    
    NSString *timelimit = [NSString stringWithFormat:@"%@", couponM.timelimit];
    if (IsNilOrNull(timelimit)) {
        timelimit = [NSString stringWithFormat:@"%@-%@", couponM.starttime, couponM.endtime];
        if (IsNilOrNull(timelimit)){
            timelimit = @"0000.00.00-0000.00.00";
        }
    }
    self.validDate.text = timelimit;
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
