//
//  SCGoodsDetailCell.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/14.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCGoodsDetailCell.h"
#import "SDCycleScrollView.h"
#import "SCGoodsDetailModel.h"

@implementation SCGoodsDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fillData:(id)data {
    
}

-(void)callWithParameter:(id)parameter {
    
}

+(CGFloat)computeHeight:(id)data {
    return 0;
}

@end

@interface SCgoodsDetailImageCell()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *imageArray;


@end

@implementation SCgoodsDetailImageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_WIDTH)];
    
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    _myScrollView.showsVerticalScrollIndicator = NO;
    _myScrollView.showsHorizontalScrollIndicator = NO;
    [headView addSubview:_myScrollView];
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"waitbanner"]];
    
    self.cycleScrollView.backgroundColor = [UIColor whiteColor];
    self.cycleScrollView.currentPageDotColor = [UIColor redColor];
    self.cycleScrollView.pageDotColor = [UIColor lightGrayColor];
    //    self.cycleScrollView.imageURLStringsGroup = _imageArray;
    [self.myScrollView addSubview:self.cycleScrollView];
    headView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:headView];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showBigGoodsImage:)]) {
        [self.delegate showBigGoodsImage:index];
    }    
}

-(void)fillData:(id)data {
    
    self.cycleScrollView.imageURLStringsGroup = data;
    self.myScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    self.cycleScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
}

@end


@interface SCGoodsDetailCommentCell()
/**评论数*/
@property (nonatomic, strong) UILabel *commentnunLabel;
/**好评率*/
@property (nonatomic, strong) UILabel *commentBateLabel;
/**评论头像*/
@property (nonatomic, strong) UIImageView *headImageView;
/**昵称*/
@property (nonatomic, strong) UILabel *nickNameLable;
/**评论内容*/
@property (nonatomic, strong) UILabel *commentLable;
/**评论时间*/
@property (nonatomic, strong) UILabel *timeLable;

@end

@implementation SCGoodsDetailCommentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    bankView.backgroundColor = [UIColor whiteColor];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    _commentnunLabel = [UILabel configureLabelWithTextColor:[UIColor tt_bodyTitleColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:15]];
    [bankView addSubview:_commentnunLabel];
    _commentnunLabel.tag = 62;
    _commentnunLabel.text = @"评论";
    [_commentnunLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(10);
        make.width.mas_offset(SCREEN_WIDTH/2);
        make.height.mas_offset(40*SCREEN_HEIGHT_SCALE);
    }];
    
    _commentBateLabel = [UILabel configureLabelWithTextColor:[UIColor tt_bodyTitleColor] textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:15]];
    [bankView addSubview:_commentBateLabel];
    _commentBateLabel.tag = 62;
    _commentBateLabel.text = @"好评度100% ";
    [_commentBateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.right.mas_offset(-AdaptedWidth(10));
        make.width.mas_offset(SCREEN_WIDTH/2);
        make.height.mas_offset(40*SCREEN_HEIGHT_SCALE);
    }];
    
    //按钮下面的线
    UILabel *line = [UILabel creatLineLable];
    [bankView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_commentnunLabel.mas_bottom);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-20, 1));
    }];
    
    //头像
    _headImageView = [[UIImageView alloc] init];
    [bankView addSubview:_headImageView];
    _headImageView.image = [UIImage imageNamed:@"name"];
    _headImageView.layer.cornerRadius = 15;
    _headImageView.clipsToBounds = YES;
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    
    //昵称
    _nickNameLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_nickNameLable];
    _nickNameLable.text = @"匿名用户";
    [_nickNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headImageView.mas_centerY);
        make.left.equalTo(_headImageView.mas_right).offset(8);
    }];
    
    //时间
    _timeLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_timeLable];
    _timeLable.text = @"2017-09-27 18:35:28";
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nickNameLable.mas_bottom);
        make.left.equalTo(_headImageView.mas_right).offset(8);
    }];
    //内容
    _commentLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_commentLable];
    _commentLable.numberOfLines = 0;
    _commentLable.text = @"内容";
    [_commentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLable.mas_bottom).offset(8);
        make.left.equalTo(_nickNameLable.mas_left);
        make.right.equalTo(_timeLable.mas_right);
        make.bottom.mas_offset(-15);
    }];
}

-(void)fillData:(id)data {
    
    SCGoodsDetailModel *goodsDetailModel = data;
    
    if (goodsDetailModel == nil) {
        return;
    }
    
    NSString *commontCount = [NSString stringWithFormat:@"%@", goodsDetailModel.commentnum];
    if (IsNilOrNull(commontCount)) {
        commontCount = @"0";
    }
    
    NSString *count = [NSString stringWithFormat:@" 评论（%@）", commontCount];
    // 创建一个富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:count];
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"gdComment"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, -5, 28, 23);
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    //    [attri appendAttributedString:string];
    // 用label的attributedText属性来使用富文本
    self.commentnunLabel.attributedText = attri;
    
    NSString *fine = [NSString stringWithFormat:@"%@", goodsDetailModel.fine];
    if (IsNilOrNull(fine)) {
        fine = @"100%";
    }
    NSString *str = [NSString stringWithFormat:@"好评度%@ ", fine];
    // 创建一个富文本
    NSMutableAttributedString *attri1 = [[NSMutableAttributedString alloc] initWithString:str];
    // 添加表情
    NSTextAttachment *attch1 = [[NSTextAttachment alloc] init];
    // 表情图片
    attch1.image = [UIImage imageNamed:@"rightgray"];
    // 设置图片大小
    attch1.bounds = CGRectMake(0, -5, 10, 20);
    
    // 创建带有图片的富文本
    NSAttributedString *string1 = [NSAttributedString attributedStringWithAttachment:attch1];
    [attri1 appendAttributedString:string1];
    // 用label的attributedText属性来使用富文本
    self.commentBateLabel.attributedText = attri1;
    
    if ([commontCount integerValue] != 0) {
        
        NSString *name = [NSString stringWithFormat:@"%@", goodsDetailModel.commentM.smallname];
        if (!IsNilOrNull(name)) {
            _nickNameLable.text = name;
        }
        
        NSString *time = [NSString stringWithFormat:@"%@", goodsDetailModel.commentM.time];
        if (IsNilOrNull(time)) {
            time = [self getCurrentTime];
        }
        _timeLable.text = time;
        _commentLable.text = [NSString stringWithFormat:@"%@", goodsDetailModel.commentM.content];
        NSString *headUrl = [NSString stringWithFormat:@"%@", goodsDetailModel.commentM.head];
        
        if (![headUrl hasPrefix:@"http"]){
            headUrl = [BaseImagestr_Url stringByAppendingString:headUrl];
        }
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"name"]];
        
        
        _headImageView.hidden = NO;
        _nickNameLable.hidden = NO;
        _timeLable.hidden = NO;
        [_commentLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_timeLable.mas_bottom).offset(8);
            make.left.equalTo(_nickNameLable.mas_left);
            make.right.equalTo(self.mas_right).offset(-10);
            make.bottom.mas_offset(-15);
        }];
        
    }else{
        _headImageView.hidden = YES;
        _nickNameLable.hidden = YES;
        _timeLable.hidden = YES;
        
        _commentLable.text = [NSString stringWithFormat:@"%@", goodsDetailModel.commentM.content];
        [_commentLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(self);
            make.left.mas_equalTo(10);
        }];
    }
}

//获取当地时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

@end

@implementation SCGoodsDetailTipCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"继续拖动，查看图文详情";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = [UIColor blackColor];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

@end

@interface SCGoodsDetailInfoCell()

/**名称*/
@property (nonatomic, strong) UILabel *goodNameLable;
/**价格*/
@property (nonatomic, strong) UILabel *pricceLable;
/**原价*/
@property (nonatomic, strong) UILabel *originalPriceLable;
/**规格*/
@property (nonatomic, strong) TTAttibuteLabel *specLable;
/**收藏*/
@property (nonatomic, strong) UIButton *collectedButton;

@property (nonatomic, strong) SCGoodsDetailModel *goodsDetailModel;


@end

@implementation SCGoodsDetailInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI {
    
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    bankView.backgroundColor = [UIColor whiteColor];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    _goodNameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_goodNameLable];
    _goodNameLable.numberOfLines = 0;
    _goodNameLable.text = @"商品名称";
    [_goodNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(10);
        make.right.mas_offset(-60);
    }];
    
    _collectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:_collectedButton];
    _collectedButton.tag = 60;
    [_collectedButton setImage:[UIImage imageNamed:@"collectedgray"] forState:UIControlStateNormal];
    [_collectedButton setImage:[UIImage imageNamed:@"collectedred"] forState:UIControlStateSelected];
    [_collectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.right.mas_offset(-10);
        make.size.mas_offset(CGSizeMake(35, 35));
    }];
    
    [_collectedButton addTarget:self action:@selector(clickDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //价格
    _pricceLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:16.0f]];
    [bankView addSubview:_pricceLable];
    _pricceLable.text = @"¥";
    [_pricceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodNameLable.mas_bottom).offset(10);
        make.left.equalTo(_goodNameLable.mas_left);
        make.height.mas_offset(17);
    }];
    //原价
    _originalPriceLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [bankView addSubview:_originalPriceLable];
    _originalPriceLable.text = @"(原价)";
    [_originalPriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pricceLable.mas_top).offset(2);
        make.left.equalTo(_pricceLable.mas_right).offset(5);
        make.height.mas_offset(13);
    }];
    
    //原价上的线
    UILabel *horizalLine = [[UILabel alloc] init];
    horizalLine.backgroundColor = SubTitleColor;
    [bankView addSubview:horizalLine];
    [horizalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_originalPriceLable.mas_top).offset(6.5);
        make.left.equalTo(_originalPriceLable.mas_left);
        make.right.equalTo(_originalPriceLable.mas_right);
        make.height.mas_offset(1);
    }];
    //规格
    _specLable = [[TTAttibuteLabel alloc] init];
    [_specLable setTextLeft:@"规格：" right:@"保湿补水"];
    _specLable.textColor = [UIColor tt_monthGrayColor];
    _specLable.font = MAIN_SUBTITLE_FONT;
    [bankView addSubview:_specLable];
    [_specLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pricceLable.mas_bottom).offset(8);
        make.left.equalTo(_pricceLable.mas_left);
        make.bottom.mas_offset(-10);
        make.height.mas_offset(18);
    }];
    
}

-(void)fillData:(id)data {
    
    _goodsDetailModel = data;
    
    if (_goodsDetailModel == nil) {
        return;
    }
    
    NSString *isCollect = [NSString stringWithFormat:@"%@", _goodsDetailModel.iscollection];
    if ([isCollect isEqualToString:@"true"] || [isCollect isEqualToString:@"1"]) {
        _collectedButton.selected = YES;
        [_collectedButton setImage:[UIImage imageNamed:@"collectedred"] forState:UIControlStateNormal];
    }else{
        _collectedButton.selected = NO;
        [_collectedButton setImage:[UIImage imageNamed:@"collectedgray"] forState:UIControlStateNormal];
    }
    
    NSString *goodsName = [NSString stringWithFormat:@"%@", _goodsDetailModel.name];
    if (IsNilOrNull(goodsName)) {
        goodsName = @"";
    }
    _goodNameLable.text = goodsName;
    _goodNameLable.numberOfLines = 0;
    
    CGFloat nameH = [goodsName boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size.height;
    [_goodNameLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(10);
        make.right.mas_offset(-60);
        make.height.mas_equalTo(nameH);
    }];
    
    NSString *isVip = [NSString stringWithFormat:@"%@", _goodsDetailModel.isvip];
    if ([isVip isEqualToString:@"0"] || [isVip isEqualToString:@"false"]) {
        
        NSString *salesprice = [NSString stringWithFormat:@"%@", _goodsDetailModel.salesprice];
        if (IsNilOrNull(salesprice)) {
            salesprice = @"";
        }else{
            salesprice = [NSString stringWithFormat:@"¥%@", _goodsDetailModel.salesprice];
        }
        _pricceLable.text = salesprice;
        
        NSString *costprice = [NSString stringWithFormat:@"%@", _goodsDetailModel.costprice];
        if (IsNilOrNull(costprice)) {
            costprice = @"";
        }else{
            costprice = [NSString stringWithFormat:@"VIP%@", _goodsDetailModel.costprice];
        }
        _originalPriceLable.text = costprice;
    }else{
        NSString *salesprice = [NSString stringWithFormat:@"%@", _goodsDetailModel.salesprice];
        if (IsNilOrNull(salesprice)) {
            salesprice = @"";
        }else{
            salesprice = [NSString stringWithFormat:@"¥%@", _goodsDetailModel.salesprice];
        }
        _pricceLable.text = salesprice;
        
        NSString *costprice = [NSString stringWithFormat:@"%@", _goodsDetailModel.costprice];
        if (IsNilOrNull(costprice)) {
            costprice = @"";
        }else{
            costprice = [NSString stringWithFormat:@"原价%@", _goodsDetailModel.costprice];
        }
        _originalPriceLable.text = costprice;
    }
    
    NSString *spec = [NSString stringWithFormat:@"%@", _goodsDetailModel.spec];
    if (IsNilOrNull(spec)) {
        spec = @"";
    }else{
        spec = [NSString stringWithFormat:@"规格:%@", _goodsDetailModel.spec];
    }
    _specLable.text = spec;
}

+(CGFloat)computeHeight:(id)data {
    
    SCGoodsDetailModel *goodsDetailModel = data;
    NSString *goodsName = [NSString stringWithFormat:@"%@", goodsDetailModel.name];
    if (IsNilOrNull(goodsName)) {
        goodsName = @"";
    }
    CGFloat nameH = [goodsName boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size.height;
   
    return 10 + nameH + 10 + 17 + 18  +20;
}

-(void)clickDetailButton:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsDetailCollection:)]) {
        [self.delegate goodsDetailCollection:button];
    }
}

@end
