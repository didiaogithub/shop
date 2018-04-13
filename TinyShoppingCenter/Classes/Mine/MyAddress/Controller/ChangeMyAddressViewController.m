//
//  ChangeMyAddressViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/17.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "ChangeMyAddressViewController.h"
#import "MyAddressTableViewCell.h"
#import "AddAddressViewController.h"
#import "XWAlterVeiw.h"
#import "CKRealnameIdentifyView.h"
@interface ChangeMyAddressViewController ()<UITableViewDelegate, UITableViewDataSource, MyAddressTableViewCellDelegate, XWAlterVeiwDelegate>
{
    NSInteger _deleteIndex;
}
@property(nonatomic,strong)XWAlterVeiw *deletAlerView;
@property(nonatomic,strong)UITableView *addressTableView;
@property(nonatomic,strong)NSMutableArray *myAddressArray;
@end

@implementation ChangeMyAddressViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.myAddressArray removeAllObjects];

    [self getMyAddressData];
}

-(NSMutableArray *)myAddressArray{
    if (_myAddressArray == nil) {
        _myAddressArray = [NSMutableArray array];
     }
    return _myAddressArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的地址";
    
    [self createAddressView];
}
#pragma mark-请求收货地址
-(void)getMyAddressData {
    [self.myAddressArray removeAllObjects];
    
    NSDictionary *pramaDic = @{@"openid": USER_OPENID};
    NSString *addressListUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetAddrListUrl];
    
    [HttpTool getWithUrl:addressListUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue]!=200) {
            [self showNoticeView:dict[@"msg"]];
            return ;
        }
        NSArray *addressArr = dict[@"addresslist"];
        if (addressArr.count == 0) {
            return;
        }
        [self.myAddressArray removeAllObjects];
        for (NSDictionary *addressDic in addressArr) {
            _addressModel = [[AddressModel alloc] init];
            [_addressModel setValuesForKeysWithDictionary:addressDic];
            [self.myAddressArray addObject:_addressModel];
            
            
            NSString *isdefault = [NSString stringWithFormat:@"%@", addressDic[@"isdefault"]];
            
            if ([isdefault isEqualToString:@"1"] || [isdefault isEqualToString:@"true"]) {
                NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
                NSString *filePath = [path stringByAppendingPathComponent:USER_DefaultAddress];
                [NSKeyedArchiver archiveRootObject:self.addressModel toFile:filePath];
            }
        }
        [self.addressTableView reloadData];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

-(void)setAddressBlock:(TransBlockaddress)addressBlock{
    _addressBlock = addressBlock;
}

-(void)createAddressView{
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:addButton];
    [addButton setBackgroundColor:[UIColor tt_bigRedBgColor]];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton setTitle:@"+添加收货地址" forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(clickAddButton) forControlEvents:UIControlEventTouchUpInside];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
        make.height.mas_offset(44);
    }];
    
    _addressTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _addressTableView.delegate  = self;
    _addressTableView.dataSource = self;
    _addressTableView.backgroundColor = [UIColor tt_grayBgColor];
    _addressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.addressTableView.rowHeight = UITableViewAutomaticDimension;
    self.addressTableView.estimatedRowHeight = 44;
    [self.view addSubview:_addressTableView];
    [self.addressTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.view.mas_top).offset(65.5+NaviAddHeight);
        make.bottom.equalTo(addButton.mas_top);
    }];
}
/**跳转进更换地址页面*/
-(void)clickAddButton{
    AddAddressViewController *addAddress = [[AddAddressViewController alloc] init];
    addAddress.actionName = @"Add";
    [self.navigationController pushViewController:addAddress animated:YES];
}
#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myAddressArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAddressTableViewCell"];
    if (cell == nil) {
        cell = [[MyAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyAddressTableViewCell"];
    }
    cell.delegate = self;
    cell.row = indexPath.row;
    cell.backgroundColor = [UIColor tt_grayBgColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.myAddressArray count]) {
         [cell refreshWithModel:self.myAddressArray[indexPath.row] andIndex:indexPath.row];
    }
    return cell;
 
}
#pragma mark-点击cell事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.myAddressArray count]) {
        _addressModel = self.myAddressArray[indexPath.row];
    }
    
    if([self.pushString isEqualToString:@"1"]){ //是从确认订单跳过去的
        if (_addressBlock) {
            _addressBlock(_addressModel);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([self.pushString isEqualToString:@"CKOrderDetail"]){ //是从订单详情修改地址过来的
        if ([self.isOversea isEqualToString:@"1"]) {
            //海外购的需要实名认证
            [self realNameIdentify];
        }else{
            [self updateOrderAddress];
        }
    }
}



#pragma mark - 检测当前收货人是否实名认证（海外购的需要）
- (void)realNameIdentify {
    
    NSString *gettername = [NSString stringWithFormat:@"%@", self.addressModel.name];
    NSString *addressID = [NSString stringWithFormat:@"%@",self.addressModel.ID];
    NSDictionary *params = @{@"addressid":addressID};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetRealName];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:requestUrl params:params success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:dict[@"codeinfo"]];
            [self.loadingView stopAnimation];
            return ;
        }
        
        CKRealnameIdentifyView *real = [[CKRealnameIdentifyView alloc] init];
        //如已实名认证，则返回idcardno，未实名认证返回空
        NSString *idcardno = [NSString stringWithFormat:@"%@", dict[@"idcardno"]];
        if (IsNilOrNull(idcardno)) {
            idcardno = @"";
            real.operationName = @"提交";
        }else{
            if (idcardno.length > 4) {
                if (![idcardno containsString:@"******"]) {
                    [KUserdefaults setObject:idcardno forKey:@"idcardno"];
                    [KUserdefaults synchronize];
                }
                NSString *prefixStr = [idcardno substringToIndex:3];
                NSString *subStr = [idcardno substringFromIndex:idcardno.length - 4];
                NSString *finalStr = [NSString stringWithFormat:@"%@***********%@", prefixStr, subStr];
                idcardno = finalStr;
                
            }
            real.operationName = @"确认";
        }
        
        __weak typeof(self) weakSelf = self;
        [real showAlert:gettername idNo:idcardno textFieldText:^(NSString *name, NSString *idNo) {
            NSLog(@"%@---%@", name, idNo);
            
            if (![idNo containsString:@"******"]) {
                [KUserdefaults setObject:idNo forKey:@"idcardno"];
                [KUserdefaults synchronize];
            }
            if (IsNilOrNull(name)) {
                [weakSelf showNoticeView:@"请输入收件人姓名"];
                return;
            }
            
            if (IsNilOrNull(idNo)) {
                [weakSelf showNoticeView:@"请输入收件人身份证号码"];
                return;
            }
            if ([idNo containsString:@"******"]) {
                idNo  =  [KUserdefaults objectForKey:@"idcardno"];
            }
            
            
            [weakSelf submitRealnameIdentify:name idcardNO:idNo addressID:addressID];
        }];
        
        
        [self.loadingView stopAnimation];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        [self.loadingView stopAnimation];
    }];
}

#pragma mark - 提交实名认证
- (void)submitRealnameIdentify:(NSString*)realName idcardNO:(NSString*)idcardno  addressID:(NSString *)addressid{
    NSString *openid = [NSString stringWithFormat:@"%@",USER_OPENID];
    NSDictionary *params = @{@"openid":openid, @"realname":realName, @"idcardno":idcardno,@"addressid":addressid};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, AddRealName];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:requestUrl params:params success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:dict[@"codeinfo"]];
            [self.loadingView stopAnimation];
            return ;
        }
        
        _addressModel.name = realName;
        [self.addressTableView reloadData];
        //认证成功后再更新地址
        [self updateOrderAddress];
        
        [self.loadingView stopAnimation];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        [self.loadingView stopAnimation];
    }];
}
#pragma mark - 提交更改地址后的订单
- (void)updateOrderAddress {
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", WebServiceAPI, updateOrderAddress_Url];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.orderid forKey:@"orderid"];
    [params setObject:_addressModel.name forKey:@"gettername"];
    [params setObject:_addressModel.mobile forKey:@"gettermobile"];
    
    NSString *getteraddress = [NSString stringWithFormat:@"%@ %@", _addressModel.area, _addressModel.address];
    [params setObject:getteraddress forKey:@"getteraddress"];
    
    [HttpTool postWithUrl:url params:params success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] intValue] != 200) {
            [self showNoticeView:dict[@"msg"]];
            [CKCNotificationCenter postNotificationName:@"OrderUpdateAddrFailNoti" object:nil];
        }else{
            if (_addressBlock) {
                _addressBlock(_addressModel);
            }
        }
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

#pragma mark-点击设置默认地址  编辑   删除按钮的代理方法
-(void)addressButtonClicked:(UIButton *)button andRow:(NSInteger)row{
    switch (button.tag - 10000) {
        case 0: //设置默认地址
        {
            [self setMyDefaultAddressDataWithRow:row andButton:button];
        
        }
            break;
        case 1: //编辑地址
        {
            if([self.myAddressArray count]){
                _addressModel = self.myAddressArray[row];
            }
            AddAddressViewController *modifyAddress = [[AddAddressViewController alloc] init];
            modifyAddress.addressModel = _addressModel;
            [self.navigationController pushViewController:modifyAddress animated:YES];
            
        }
            break;
        case 2:  //删除地址地址
        {
            
            if([self.myAddressArray count]){
                _addressModel = self.myAddressArray[row];
            }
            NSString *isdefault = [NSString stringWithFormat:@"%@",_addressModel.isdefault];
            if ([isdefault isEqualToString:@"1"]) {
                [self showNoticeView:@"默认地址，不能删除！"];
                return;
            }
            [self deleteMyAddressWithRow:row];
            
            
            
        }
            break;
            
        default:
            break;
    }
    
}
/**设置默认地址*/
-(void)setMyDefaultAddressDataWithRow:(NSInteger)row andButton:(UIButton *)button{
    if([self.myAddressArray count]){
        _addressModel = self.myAddressArray[row];
    }
    NSString *isdefault = [NSString stringWithFormat:@"%@",_addressModel.isdefault];
    if (IsNilOrNull(isdefault)){
        isdefault = @"0";
    }
    
    NSString *setDefaultUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, UpdateAddrUrl];
    NSDictionary *pramaDic = @{@"openid":USER_OPENID, @"id":_addressModel.ID, @"isdefault":@"1"};
    //如果是默认地址不请求
    if (![isdefault isEqualToString:@"1"]){
        [HttpTool postWithUrl:setDefaultUrl params:pramaDic success:^(id json) {
            [self.loadingView stopAnimation];
            
            NSDictionary *dict = json;
            if ([dict[@"code"] integerValue] != 200) {
                [self showNoticeView:dict[@"msg"]];
                return ;
            }
            
            [self getMyAddressData];
            
        } failure:^(NSError *error) {
            [self.loadingView stopAnimation];
            if (error.code == -1009) {
                [self showNoticeView:NetWorkNotReachable];
            }else{
                [self showNoticeView:NetWorkTimeout];
            }
        }];
    }else{
       [self showNoticeView:@"该地址已经是默认地址,不能重复设置!"];
    }
}
-(void)setDeleteAddressIdWithBlock:(AddressBackBlock)deleteBlock{
    _backBlock = deleteBlock;
}


#pragma mark-删除的点击的方法
-(void)deleteMyAddressWithRow:(NSInteger)row{
    
    _deletAlerView = [[XWAlterVeiw alloc] init];
    _deletAlerView.titleLable.text = @"确定要删除该地址？";
    _deletAlerView.delegate = self;
    [_deletAlerView show];
    _deleteIndex = row;
}
#pragma mark-删除的代理方法
-(void)subuttonClicked{
    
    if([self.myAddressArray count]){
        _addressModel = self.myAddressArray[_deleteIndex];
    }
    if (IsNilOrNull(_addressModel.ID)){
        _addressModel.ID = @"";
    }
    NSDictionary * pramaDic = @{@"openid":USER_OPENID,@"id":_addressModel.ID};
    NSString *deleteMeAddressUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,DeleAddrUrl];
    [HttpTool postWithUrl:deleteMeAddressUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"msg"]];
            return;
        }
        //删除成功之后删除数组数据

        if (_backBlock){
            _backBlock(_addressModel.ID);
        }
        if ([self.myAddressArray count]) {
            
            [self.myAddressArray removeObjectAtIndex:_deleteIndex];
            [self.addressTableView reloadData];
        }
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
     }];
    
}
@end
