//
//  UserCenterController.m
//  callmec
//
//  Created by sam on 16/6/25.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "UserCenterController.h"
#import "CenterModel.h"
#import "BaseItemModel.h"

#import "UserInfoCell.h"
#import "CenterHeaderCell.h"
#import "CenterInputCell.h"
#import "CenterRadioCell.h"
#import "CenterFunctionCell.h"

#import "VerticalView.h"
#import "MessageController.h"
#import "WalletController.h"
#import "OrderListController.h"
#import "EditUserController.h"
#import "SearchAddressController.h"
#import "BrowerController.h"
#import "CMLocation.h"


@class VerticalView;

@interface UserCenterController()<UITableViewDataSource,UITableViewDelegate,TargetActionDelegate,SearchViewControllerDelegate>

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) UIButton *exitLogin;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger addressType;
@property (nonatomic,strong) BaseItemModel *md_commend_people;
@end

@implementation UserCenterController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self initData];
    
}

- (void) initView
{
    
    [self setTitle:@"我的"];
    [self.leftButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [self.leftButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.leftButton setContentMode:UIViewContentModeCenter];
    [self.leftButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
//    NSString *rightTitle = @"注销";
//    [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
//    [self.rightButton setTitleColor:RGBHex(g_red) forState:UIControlStateNormal];
//    [self.rightButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    _mTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.backgroundColor =RGBHex(g_gray);
    [_mTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:_mTableView];
    
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-64);
    }];
    
        _exitLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exitLogin setFrame:CGRectMake(0, 0, 0, 0)];
        [_exitLogin setBackgroundColor:RGBHex(g_blue)];
        [_exitLogin setTitle:@"退出登录" forState:UIControlStateNormal];
        [_exitLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _exitLogin.layer.cornerRadius = 5;
        [_exitLogin addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_exitLogin];
        [_exitLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_mTableView).offset(54);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.height.mas_equalTo(44);
        }];
}

- (void) initData
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    
    //个人资料管理
    CenterModel *header =[[CenterModel alloc] init];
    header.isShowHeader = NO;
    header.type=1;
    
    UserItemModel *user = [[UserItemModel alloc] init];
    user.title =@"个人资料";
    
    user.icons =[NSString stringWithFormat:@"%@getMHeadIcon?id=%@&token=%@",kserviceURL,
                 [GlobalData sharedInstance].user.userInfo.ids,
                 [GlobalData sharedInstance].user.session];
    user.hasMore = YES;
    user.index = 0;
    user.height = 80.0f;
    
    header.dataArray = [NSArray arrayWithObjects:user, nil];
    [_dataArray addObject:header];
    
    //订单管理
    CenterModel *header2 =[[CenterModel alloc] init];
    header2.isShowHeader = NO;
    header2.type=2;
    FunctionModel *mdl = [[FunctionModel alloc] init];
    FunctionItemModel *model1 = [[FunctionItemModel alloc] init];
    model1.title = @"我的订单";
    model1.icons = @"wodedingdan-3";
    model1.hasMore = NO;
    model1.index = 1;
    
    FunctionItemModel *model2 = [[FunctionItemModel alloc] init];
    model2.title = @"我的钱包";
    model2.icons = @"wodeqianbao";
    model2.hasMore = NO;
    model2.index = 2;
    
    FunctionItemModel *model3 = [[FunctionItemModel alloc] init];
    model3.title = @"我的消息";
    model3.icons = @"wodexiaoxi";
    model3.hasMore = NO;
    model3.index = 3;
    
    FunctionItemModel *model4 = [[FunctionItemModel alloc] init];
    model4.title = @"客服电话";
    model4.icons = @"kefudianhua";
    model4.hasMore = NO;
    model4.index = 4;
    mdl.dataArray = [NSArray arrayWithObjects:model1,model2,model3,model4,nil];
    header2.dataArray = [NSArray arrayWithObjects:mdl,nil];
    mdl.height = 70;
    [_dataArray addObject:header2];
    
    
    CenterModel *header7 =[[CenterModel alloc] init];
    header7.isShowHeader = NO;
    header7.type=7;
    _md_commend_people = [[BaseItemModel alloc] init];
    _md_commend_people.index = 5;
    _md_commend_people.title = @"推荐人:";
    _md_commend_people.hasMore = YES;
    _md_commend_people.placeHolder = @"请输入推荐人手机号";
    if ([GlobalData sharedInstance].user.userInfo.attribute1 && [[GlobalData sharedInstance].user.userInfo.attribute1 length]>0) {
        _md_commend_people.hasMore = NO;
        _md_commend_people.value = [GlobalData sharedInstance].user.userInfo.attribute1;
    }else{
        _md_commend_people.hasMore = YES;
    }
    header7.dataArray =[NSArray arrayWithObjects:_md_commend_people, nil];
    [_dataArray addObject:header7];
    
    //账号安全
    CenterModel *header3 = [[CenterModel alloc] init];
    header3.cata_title = @"账号与安全";
    header3.icons = @"user_account";
    header3.isShowHeader = YES;
    header3.type=3;
    
    BaseItemModel *md_account = [[BaseItemModel alloc] init];
    md_account.index = 5;
    md_account.title = @"绑定社交账号";
    md_account.hasMore = YES;
    header3.dataArray =[NSArray arrayWithObjects:md_account, nil];
//    [_dataArray addObject:header3];
    
    //地址管理
    CenterModel *header4 = [[CenterModel alloc] init];
    header4.cata_title = @"编辑常用地址";
    header4.icons = @"bianjidizhi";
    header4.isShowHeader = YES;
    header4.type=4;
    
    BaseItemModel *f_address = [[BaseItemModel alloc] init];
    f_address.index = 6;
    f_address.title = [NSString stringWithFormat:@"家庭地址:%@",[GlobalData sharedInstance].user.userInfo.address];
    f_address.hasMore = YES;
    BaseItemModel *c_address = [[BaseItemModel alloc] init];
    c_address.index = 7;
    c_address.title = [NSString stringWithFormat:@"单位地址:%@",[GlobalData sharedInstance].user.userInfo.company];
    c_address.hasMore = YES;
    
    
    header4.dataArray =[NSArray arrayWithObjects:f_address,c_address, nil];
    [_dataArray addObject:header4];

    
    //设置音效开关
    CenterModel *header5 = [[CenterModel alloc] init];
    header5.cata_title = @"账号与安全";
    header5.icons = @"user_speeker";
    header5.isShowHeader = NO;
    header5.type=5;
    
    SpeakerModel *speeker = [[SpeakerModel alloc] init];
    speeker.index = 8;
    speeker.title = @"设置音效开关";
    speeker.icons = @"yinxiao";

    
    NSLog(@" SandBoxHelper UISwitch:%d",[SandBoxHelper getVoiceStatus]);
    speeker.hasMore = [SandBoxHelper getVoiceStatus];
    header5.dataArray =[NSArray arrayWithObjects:speeker, nil];
    [_dataArray addObject:header5];
    
    //帮助信息
    CenterModel *header6 = [[CenterModel alloc] init];
    header6.cata_title = @"帮助信息";
    header6.icons = @"bangzhuxiaoxi";
    header6.isShowHeader = YES;
    header6.type=6;
    
    BaseItemModel *item1 = [[BaseItemModel alloc] init];
    item1.index = 9;
    item1.title = @"使用指南";
    item1.hasMore = YES;
    
    BaseItemModel *item2 = [[BaseItemModel alloc] init];
    item2.index = 10;
    item2.title = @"法律条款";
    item2.hasMore = YES;
    
    BaseItemModel *item3 = [[BaseItemModel alloc] init];
    item3.index = 11;
    item3.title = [NSString stringWithFormat:@"当前版本：%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    item3.hasMore = YES;
    item3.level = 0;
    
    BaseItemModel *item4 = [[BaseItemModel alloc] init];
    item4.index = 12;
    item4.title = @"乘客专车使用指南";
    item4.hasMore = YES;
    item4.level = 1;
    
    BaseItemModel *item5 = [[BaseItemModel alloc] init];
    item5.index = 13;
    item5.title = @"乘客快车使用指南";
    item5.hasMore = YES;
    item5.level = 1;
    
    BaseItemModel *item6 = [[BaseItemModel alloc] init];
    item6.index = 14;
    item6.title = @"乘客快巴使用指南";
    item6.hasMore = YES;
    item6.level = 1;
    
    BaseItemModel *item7 = [[BaseItemModel alloc] init];
    item7.index = 15;
    item7.level = 1;
    item7.title = @"乘客货的使用指南";
    item7.hasMore = YES;
    
    header6.dataArray =[NSArray arrayWithObjects:item1,item2,item3,nil];
    [_dataArray addObject:header6];
    
    [_mTableView reloadData];
}

- (void) buttonTarget:(id)sender
{
    if (sender ==self.leftButton) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else if(sender ==_exitLogin){
        [[GlobalData sharedInstance].user logout];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if([sender isKindOfClass:[VerticalView class]]){
        
        NSInteger tag =((VerticalView*)sender).tag;
        NSLog(@"tag:%ld",(long)((VerticalView*)sender).tag);
        if (tag==0) {
            OrderListController *order = [[OrderListController alloc] init];
            [self.navigationController pushViewController:order animated:YES];
        }else if(tag==1)
        {
            WalletController *wallet =[[WalletController alloc] init];
            [self.navigationController pushViewController:wallet animated:YES];
        }else if(tag==2)
        {
            MessageController *message = [[MessageController alloc] init];
            [self.navigationController pushViewController:message animated:YES];
        }else if(tag==3)
        {

            NSString *telphone = [GlobalData sharedInstance].user.userInfo.serviceNo;
            if (telphone && [telphone length]>0) {
                [CommonUtility callTelphone:telphone];
            }else{
                [MBProgressHUD showAndHideWithMessage:[NSString stringWithFormat:@"电话号码%@不存在或者为空!",telphone] forHUD:nil];
            }
        }
//        UserCenterController *userctrl = [[UserCenterController alloc] init];
//        [self.navigationController pushViewController:userctrl animated:YES];
    }else if([sender isKindOfClass:[BaseItemModel class]]){
        [self checkBankAccount];
    }else{
        UIButton *btn =(UIButton*)sender;
        NSString *msg = btn.titleLabel.text;
        if ([@"个人资料" isEqualToString:msg]) {
            EditUserController *editor = [[EditUserController alloc] init];
            editor.delegateCallback = self;
            [self.navigationController pushViewController:editor animated:YES];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CenterModel *model = _dataArray[section];
    return model.dataArray.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CenterModel *model = _dataArray[indexPath.section];
    if (model.type==1) {
        static NSString *cellid1 = @"cellids1";
        CenterHeaderCell *cell= [tableView dequeueReusableCellWithIdentifier:cellid1];
        if (!cell) {
            cell = [[CenterHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid1];
        }
        cell.delegate = self;
        [cell setModel:model.dataArray[indexPath.row]];
        return cell;
    }else if (model.type==2) {//CenterFunctionCell.h
        static NSString *cellid2 = @"cellids2";
        CenterFunctionCell *cell= [tableView dequeueReusableCellWithIdentifier:cellid2];
        if (!cell) {
            cell = [[CenterFunctionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid2];
        }
        cell.whereTo = @"userCenter";
        cell.delegate = self;
        [cell setModel:model.dataArray[indexPath.row]];
        
        return cell;
    }else if (model.type==3) {
        static NSString *cellid3 = @"cellids3";
        UserInfoCell *cell= [tableView dequeueReusableCellWithIdentifier:cellid3];
        if (!cell) {
            cell = [[UserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid3];
        }
        cell.delegate = self;
        [cell setModel:model.dataArray[indexPath.row]];
        return cell;
    }else if (model.type==5) {
        static NSString *cellid5 = @"cellids5";
        CenterRadioCell *cell= [tableView dequeueReusableCellWithIdentifier:cellid5];
        if (!cell) {
            cell = [[CenterRadioCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid5];
        }
        cell.delegate = self;
        [cell setModel:model.dataArray[indexPath.row]];
        return cell;
    }else if (model.type==7) {
        static NSString *cellid5 = @"cellids5";
        CenterInputCell *cell= [tableView dequeueReusableCellWithIdentifier:cellid5];
        if (!cell) {
            cell = [[CenterInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid5];
        }
        cell.delegate = self;
        [cell setModel:model.dataArray[indexPath.row]];
        return cell;
    }else{
        static NSString *cellid = @"cellids";
        UserInfoCell *cell= [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[UserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.delegate = self;
        [cell setModel:model.dataArray[indexPath.row]];
        return cell;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CenterModel *model = _dataArray[indexPath.section];
    BaseItemModel *mods = model.dataArray[0];
    return mods.height;//model;
}


- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CenterModel *model = _dataArray[section];
    if (model.isShowHeader) {
        
        UIView *container = [[UIView alloc] init];
//        [container setBackgroundColor:RGBHex(g_assit_green)];
        UIView *view = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, 100, 40)];
        [view setBackgroundColor:[UIColor whiteColor]];
        UIImageView *leftIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:model.icons]];
        [view addSubview:leftIcon];
        [leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(view).offset(10);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setText:model.cata_title];
        UIFont *font = [UIFont systemFontOfSize:16];
        CGSize size = [model.cata_title sizeWithFont:font maxSize:CGSizeMake(200, 1000)];
        [titleLabel setFont:[UIFont systemFontOfSize:16]];
        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(30);
            make.width.mas_equalTo(size.width);
            make.centerY.equalTo(view);
        }];
        
        [container addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(container).offset(5);
            make.left.equalTo(container);
            make.bottom.equalTo(container).offset(-1);
            make.width.equalTo(container);
        }];
        
        UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 0, 1)];
        [grayLine setBackgroundColor:[UIColor whiteColor]];
        [container addSubview:grayLine];
        [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(container);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(container);
            make.width.mas_equalTo(10);
        }];
        return container;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CenterModel *model = _dataArray[section];
    if (model.isShowHeader) {
        return 50;
    }
    if (section == 0) {
        return 0.001;
    }
    return 5;
}


#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CenterModel *model = _dataArray[indexPath.section];
    [self jumpControllerChange:model.dataArray[indexPath.row]];
}

- (void)jumpControllerChange:(BaseItemModel*)model;
{
    switch (model.index) {
        case 6:
        {
            SearchAddressController *search = [[SearchAddressController alloc] init];
            search.city = [GlobalData sharedInstance].city;
            search.delegate =self;
            _addressType = 0;
            [self.navigationController pushViewController:search animated:YES];
            
        }
            break;
        case 7:
        {
            SearchAddressController *search = [[SearchAddressController alloc] init];
            search.delegate =self;
            search.city = [GlobalData sharedInstance].city;
            _addressType = 1;
            [self.navigationController pushViewController:search animated:YES];
        }
            break;
        case 8:
        {
//            SearchAddressController *search = [[SearchAddressController alloc] init];
//            search.city = [GlobalData sharedInstance].city;
//            search.delegate =self;
//            [self.navigationController pushViewController:search animated:YES];
        }break;
        case 9:
        {
            BrowerController *brower = [[BrowerController alloc] init];
            [brower setTitleStr:@"使用指南"];
            brower.urlStr =[NSString stringWithFormat:@"%@getArticle?id=1&token=%@",
                            kserviceURL,
                            [GlobalData sharedInstance].user.session];
            [self.navigationController pushViewController:brower animated:YES];
        }break;
        case 10:
        {
            BrowerController *brower = [[BrowerController alloc] init];
            [brower setTitleStr:@"法律条款"];
            brower.urlStr =[NSString stringWithFormat:@"%@getArticle?id=2&token=%@",
                            kserviceURL,
                            [GlobalData sharedInstance].user.session];
            [self.navigationController pushViewController:brower animated:YES];
        }break;
        case 11:
        {
            BrowerController *brower = [[BrowerController alloc] init];
            [brower setTitleStr:@"版本信息"];
            brower.urlStr =[NSString stringWithFormat:@"%@getArticle?id=3&token=%@&version=%@",
                            kserviceURL,
                            [GlobalData sharedInstance].user.session,
                            [CommonUtility versions]];
            [self.navigationController pushViewController:brower animated:YES];
        }break;
        default:
            break;
    }
}

- (void)searchViewController:(SearchAddressController*)searchViewController didSelectLocation:(CMLocation *)locations
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([GlobalData sharedInstance].user.isLogin) {
        [params setObject:[GlobalData sharedInstance].user.userInfo.ids forKey:@"id"];
    }
    
    if (_addressType==0) {
        [params setObject:locations.name forKey:@"usualStart"];
        [params setObject:locations.name forKey:@"address"];
        [params setObject:[NSString stringWithFormat:@"%f",locations.coordinate.latitude] forKey:@"slatitude"];
        [params setObject:[NSString stringWithFormat:@"%f",locations.coordinate.longitude] forKey:@"slongitude"];
        [params setObject:locations.name forKey:@"slocation"];

    }else if(_addressType==1)
    {
        [params setObject:locations.name forKey:@"usualEnd"];
        [params setObject:locations.name forKey:@"company"];
        [params setObject:[NSString stringWithFormat:@"%f",locations.coordinate.latitude] forKey:@"elatitude"];
        [params setObject:[NSString stringWithFormat:@"%f",locations.coordinate.longitude] forKey:@"elongitude"];
        [params setObject:locations.name forKey:@"elocation"];
        
    }else{
        [params setObject:locations.name forKey:@"usualStart"];
        [params setObject:locations.name forKey:@"address"];
        [params setObject:[NSString stringWithFormat:@"%f",locations.coordinate.latitude] forKey:@"slatitude"];
        [params setObject:[NSString stringWithFormat:@"%f",locations.coordinate.longitude] forKey:@"slongitude"];
        [params setObject:locations.name forKey:@"slocation"];
    }
    
    [UserInfoModel commitEditUserInfo:params succ:^(NSDictionary *resultDictionary) {
        NSLog(@"result:%@",resultDictionary);
        NSDictionary *data = resultDictionary[@"data"];
        UserInfoModel *user = [[UserInfoModel alloc] initWithDictionary:data error:nil];
        [GlobalData sharedInstance].user.userInfo = user;
        [[GlobalData sharedInstance].user save];
        
        
        if (_addressType==0) {
            CenterModel *address = _dataArray[3];
            BaseItemModel *home = address.dataArray[0];
            home.title = [NSString stringWithFormat:@"家庭地址:%@",[GlobalData sharedInstance].user.userInfo.address];
            
        }else{
        
            CenterModel *address = _dataArray[3];
            BaseItemModel *home = address.dataArray[1];
            home.title = [NSString stringWithFormat:@"单位地址:%@",[GlobalData sharedInstance].user.userInfo.company];
        }
        [self.mTableView reloadData];
        [MBProgressHUD showAndHideWithMessage:@"保存成功" forHUD:nil];
        //[];
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        NSLog(@"%ld %@",(long)errorCode,errorMessage);
        //[MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
    }];
}


- (void) checkBankAccount
{
    if ([GlobalData sharedInstance].user.isLogin) {
        
        NSMutableDictionary *param =[NSMutableDictionary dictionary];
        if(_md_commend_people.hasMore && _md_commend_people.value && [_md_commend_people.value length]>0){
            [param setObject:_md_commend_people.value forKey:@"introducer"];
        }
        
        //introducer
        if (param.allKeys.count>0) {
            [self saveUserInfo:param canback:NO];
        }else{
            [MBProgressHUD showAndHideWithMessage:@"参数无变化" forHUD:nil];
//            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

- (void) saveUserInfo:(NSMutableDictionary*)params canback:(BOOL)isBack
{
    if ([GlobalData sharedInstance].user.isLogin) {
        [params setObject:[GlobalData sharedInstance].user.userInfo.ids forKey:@"id"];
    }
    [UserInfoModel commitEditUserInfo:params succ:^(NSDictionary *resultDictionary) {
        NSLog(@"result:%@",resultDictionary);
        NSDictionary *data = resultDictionary[@"data"];
        UserInfoModel *user = [[UserInfoModel alloc] initWithDictionary:data error:nil];
        [GlobalData sharedInstance].user.userInfo = user;
        [[GlobalData sharedInstance].user save];
        
        [self initData];
        [self.mTableView reloadData];
        [MBProgressHUD showAndHideWithMessage:@"保存成功" forHUD:nil onCompletion:^{
            if (isBack) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
    }];
}


- (void) callback:(id)sender
{
    [self.mTableView reloadData];
}
@end
