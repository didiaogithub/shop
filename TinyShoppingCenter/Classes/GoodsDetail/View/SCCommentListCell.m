//
//  SCCommentListCell.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/9/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCCommentListCell.h"
#import "XLImageViewer.h"

@interface SCCommentListCell()

@property (nonatomic, strong) NSMutableArray *tempArr;
@property (nonatomic, strong) UIView *bankView;
@property (nonatomic, strong) SCCommentModel *commentModel;
@property (nonatomic, strong) NSMutableArray *imageArr;


@end

@implementation SCCommentListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(NSMutableArray *)tempArr {
    if (_tempArr == nil) {
        _tempArr = [NSMutableArray array];
    }
    return _tempArr;
}

-(void)createUI{
    
    _bankView = [[UIView alloc] init];
    [self.contentView addSubview:_bankView];
    _bankView.backgroundColor = [UIColor whiteColor];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(-5);
    }];
    
    //头像
    _headImageView = [[UIImageView alloc] init];
    [_bankView addSubview:_headImageView];
    _headImageView.image = [UIImage imageNamed:@"name"];
    _headImageView.layer.cornerRadius = 20;
    _headImageView.clipsToBounds = YES;
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(15);
        make.size.mas_offset(CGSizeMake(40, 40));
    }];
    
    //昵称
    _nickNameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_bankView addSubview:_nickNameLable];
    _nickNameLable.text = @"匿名用户";
    [_nickNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView.mas_top).offset(2);
        make.left.equalTo(_headImageView.mas_right).offset(8);
        make.width.mas_equalTo(SCREEN_WIDTH *0.5);
        
    }];
    
    //时间
    _timeLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_bankView addSubview:_timeLable];
    _timeLable.text = @"2017-09-27 18:35:28";
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nickNameLable.mas_bottom).offset(5);
        make.left.equalTo(_nickNameLable.mas_left);
    }];
    //内容
    _commentLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_bankView addSubview:_commentLable];
    _commentLable.numberOfLines = 0;
    _commentLable.text = @"真心不错的商品";
    [_commentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLable.mas_bottom).offset(8);
        make.left.equalTo(_timeLable.mas_left);
        make.right.mas_offset(-10);
        make.bottom.mas_offset(-15);
    }];
    
}

-(void)refreshCellWithModel:(SCCommentModel*)commontModel index:(NSInteger)index {
    
    _commentModel = commontModel;
    
    NSString *name = [NSString stringWithFormat:@"%@", commontModel.smallname];
    if (IsNilOrNull(name)) {
        name = @"匿名用户";
    }
    _nickNameLable.text = name;
    
    NSString *time = [NSString stringWithFormat:@"%@", commontModel.time];
    if (IsNilOrNull(time)) {
        time = @"";
    }
    _timeLable.text = time;
    
    NSString *content = [NSString stringWithFormat:@"%@", commontModel.content];
    if (IsNilOrNull(content)) {
        time = @"";
    }
    _commentLable.text = content;
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:commontModel.head] placeholderImage:[UIImage imageNamed:@"name"]];
    
    StarEvaluateView *showStarView = [[StarEvaluateView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2/3,15, SCREEN_WIDTH/3, 20) starIndex:[commontModel.score integerValue] starWidth:20 space:1.f defaultImage:[[UIImage imageNamed:@"smallstargray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] lightImage:[UIImage imageNamed:@"smallstarred"] isCanTap:NO];
    
    if (commontModel != nil) {
        if (![self.tempArr containsObject:commontModel]) {
            [self.tempArr addObject:commontModel];
            [_bankView addSubview:showStarView];
        }
    }
    
    if (commontModel.imgPathArray.count > 0) {
        [_commentLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_timeLable.mas_bottom).offset(8);
            make.left.equalTo(_timeLable.mas_left);
            make.right.mas_offset(-10);
        }];
    }else{
        [_commentLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_timeLable.mas_bottom).offset(8);
            make.left.equalTo(_timeLable.mas_left);
            make.right.mas_offset(-10);
            make.bottom.mas_offset(-15);
        }];
    }
    
    _imageArr = [NSMutableArray array];
    for (NSInteger i = 0; i < commontModel.imgPathArray.count; i++) {
        SCCommentImgModel *imgM = commontModel.imgPathArray[i];
        NSString *path = [NSString stringWithFormat:@"%@", imgM.path];
        [_imageArr addObject:path];
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.userInteractionEnabled = YES;
        imageV.tag = 1314+i;
        [imageV sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"defaultover"]];
        [_bankView addSubview:imageV];
        
        float x = (SCREEN_WIDTH - 58) / 3;
        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_commentLable.mas_bottom).offset(5);
            make.left.mas_offset(58 + i*x);
            make.bottom.mas_offset(-8);
            make.height.mas_equalTo(x-20);
            make.width.mas_equalTo(x-20);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigImage:)];
        [imageV addGestureRecognizer:tap];
    }
}

-(void)bigImage:(UITapGestureRecognizer*)tap {
    [[XLImageViewer shareInstanse] showNetImages:_imageArr index:tap.view.tag-1314 from:[UIViewController currentVC].view];
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
