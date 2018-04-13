//
//  YSPointCell.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/5/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "YSPointCell.h"
#import "YSMemberPointCell.h"
#import "UITableView+PlaceHolder.h"
#import "SCIntegraModel.h"


@interface YSPointCell ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NodataLableView *nodataLableView;
@property (nonatomic, strong) NSArray *pointArr;
@property (nonatomic, copy)   NSString *type;


@end

@implementation YSPointCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initComponents];
    }
    return self;
}

-(NodataLableView *)nodataLableView {
    if(_nodataLableView == nil) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT - 64-49-50)];
        _nodataLableView.nodataLabel.text = @"暂无积分信息";
    }
    return _nodataLableView;
}

- (void)initComponents {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}

-(void)refreshList:(NSArray *)integraArr type:(NSString*)type {

    _type = type;
    _pointArr = integraArr;
    if (self.pointArr.count == 0) {
        _nodataLableView.hidden = NO;
        [self.tableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.pointArr.count];
    }else{
        _nodataLableView.hidden = YES;
    }
    [_tableView reloadData];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pointArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSMemberPointCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectionCell"];
    if (cell == nil) {
        cell = [[YSMemberPointCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"collectionCell"];
        
    }
    [cell refreshPointWithPointModel:self.pointArr[indexPath.row] type:self.type];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SCIntegraModel *pointM = self.pointArr[indexPath.row];
    NSString *path = [NSString stringWithFormat:@"%@", pointM.path];
    if (IsNilOrNull(path)) {
        return 50;
    }else{
        return 80;
    }
    
}


@end
