//
//  AppiontBusController.m
//  callmec
//
//  Created by sam on 16/9/3.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "AppiontBusController.h"
#import "BrowerController.h"
#import "SearchAddressController.h"
#import "WaitingBusController.h"

#import "AppiontFastBusCell.h"
#import "LeftInputView.h"
#import "BottomDialogView.h"

#import "AppiontBusModel.h"
#import "CMSearchManager.h"



@interface AppiontBusController()<UITableViewDataSource,UITableViewDelegate,SearchViewControllerDelegate,TargetActionDelegate>
@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) CMLocation *location;
@property (nonatomic,strong) CMLocation *endlocation;
@property (nonatomic,strong) UIButton *buttonSubmit;
@property (nonatomic,assign) NSInteger peopleNumber;
@property (nonatomic,assign) NSInteger distance;
@end

@implementation AppiontBusController
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDriverReceivedOrder:) name:NOTICE_ORDER_STATE_UPDATE object:nil];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) initView
{
    [self setTitle:@"一键发布用车"];
    [self.headerView setBackgroundColor:[UIColor whiteColor]];
    [self setRightButtonText:@"计价说明" withFont:[UIFont systemFontOfSize:14]];
    [self.rightButton setTitleColor:RGBHex(g_blue) forState:UIControlStateNormal];
    [self.view setBackgroundColor:RGBHex(g_gray)];
    CarOrderModel *models =  [[CarOrderModel alloc] init];
    _location = [GlobalData sharedInstance].location;
    models.slocation =_location.name;
    models.slatitude = [NSString stringWithFormat:@"%f",_location.coordinate.latitude];
    models.slongitude = [NSString stringWithFormat:@"%f",_location.coordinate.longitude];
    models.state = @"1";
    _dataArray =[[NSArray alloc] initWithObjects:models, nil];
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [_mTableView setBackgroundColor:RGBHex(g_gray)];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    [self.view addSubview:_mTableView];
    [self initTableView];
    
    _buttonSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonSubmit setTitle:@"呼叫快吧" forState:UIControlStateNormal];
    [_buttonSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonSubmit setBackgroundImage:[ImageTools imageWithColor:RGBHex(g_blue)] forState:UIControlStateNormal];
    [_buttonSubmit setBackgroundImage:[ImageTools imageWithColor:RGBHex(g_blue)] forState:UIControlStateHighlighted];
    [_buttonSubmit setBackgroundColor:RGBHex(g_red)];
    [_buttonSubmit.layer setCornerRadius:5];
    [_buttonSubmit.layer setMasksToBounds:YES];
    [_buttonSubmit addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonSubmit];
    [_buttonSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(50);
    }];
    
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(_buttonSubmit.mas_top);
    }];
    [_mTableView reloadData];
}

#pragma mark - TargetAction
- (void) buttonTarget:(UIView*)sender
{
    if ([sender isKindOfClass:[LeftInputView class]]) {
        NSInteger tag = sender.tag;
        if (tag==0) {
            SearchAddressController * search =[[SearchAddressController alloc] init];
            search.delegate = self;
            search.targetId = 0;
            [self.navigationController pushViewController:search animated:YES];
        }else if(tag==1){
            SearchAddressController * search =[[SearchAddressController alloc] init];
            search.delegate = self;
            search.targetId = 1;
            [self.navigationController pushViewController:search animated:YES];
        }else if(tag==2)
        {
            BottomDialogView *dialog = [[BottomDialogView alloc] init];
            [dialog setColumnNumber:6];
            [dialog setTitle:@"请点击数字选择乘车人数"];
            [dialog setDesc:@"记得和车主侃大山噢～"];
            [dialog setDelegate:self];
            [self.view addSubview:dialog];
            [dialog mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view);
                make.left.equalTo(self.view);
                make.bottom.equalTo(self.view);
                make.right.equalTo(self.view);
            }];
            
            for (int i=0;i<6;i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                //[btn addTarget:self action:@selector(buttonTagetPeople:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:[NSString stringWithFormat:@"%d人",i+1] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [btn setBackgroundImage:[ImageTools imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                btn.tag = i;
                [dialog addContainerView:btn];
            }
            
            [dialog updateContainerHeight:150];
        }
    }else if(sender == self.rightButton){
        BrowerController *webview = [[BrowerController alloc] init];
        webview.urlStr = [CommonUtility getArticalUrl:@"4"];
        webview.titleStr = @"计价说明";
        [self.navigationController pushViewController:webview animated:YES];
    }else if(sender == self.buttonSubmit){
        CarOrderModel *model = _dataArray[0];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSMutableDictionary *order = [NSMutableDictionary dictionary];
//        if (!_location) {
//            [MBProgressHUD showAndHideWithMessage:@"请选择乘车地点" forHUD:nil];
//            return;
//        }
        if (!_endlocation) {
            [MBProgressHUD showAndHideWithMessage:@"请选择下车地点" forHUD:nil];
            return;
        }
        [order setObject:_location.name?_location.name:@"" forKey:@"sLocation"];
        [order setObject:[NSString stringWithFormat:@"%f",_location.coordinate.longitude] forKey:@"sLongitude"];
        [order setObject:[NSString stringWithFormat:@"%f",_location.coordinate.latitude] forKey:@"sLatitude"];
        
        [order setObject:_endlocation.name?_endlocation.name:@"" forKey:@"eLocation"];
        [order setObject:[NSString stringWithFormat:@"%f",_endlocation.coordinate.longitude] forKey:@"eLongitude"];
        [order setObject:[NSString stringWithFormat:@"%f",_endlocation.coordinate.latitude] forKey:@"eLatitude"];
        
        [order setObject:@(_distance) forKey:@"distance"];
        [order setObject:model.descriptions?model.descriptions:@"" forKey:@"description"];
        [order setObject:model.orderPerson?[model.orderPerson stringByReplacingOccurrencesOfString:@"人" withString:@""]:@"1" forKey:@"orderPerson"];
        
        [param setObject:[order lk_JSONString] forKey:@"order"];
        if ([GlobalData sharedInstance].user.isLogin) {
            [param setObject:[GlobalData sharedInstance].user.userInfo.ids forKey:@"memberId"];
        }
        MBProgressHUD *hud = [MBProgressHUD showProgressView:@"正在提交信息..." inView:nil];
        [hud show:YES];
        [AppiontBusModel appiontBus:param succes:^(NSDictionary *resultDictionary) {
            NSLog(@"resultDictionary:%@",resultDictionary);
             [GlobalData sharedInstance].fastModel =_dataArray[0];
            [hud hide:YES];
            [MBProgressHUD showAndHideWithMessage:@"预约成功" forHUD:nil onCompletion:^{
                NSLog(@"预约成功 finish");
                
                CarOrderModel *md = _dataArray[0];
                md.ids = [NSString stringWithFormat:@"%@",resultDictionary[@"message"]];
                
                if ([GlobalData sharedInstance].fastModel &&
                    [[GlobalData sharedInstance].fastModel.ids isEqualToString:md.ids])
                {
                    md.type =[GlobalData sharedInstance].fastModel.type;
                }
                [GlobalData sharedInstance].fastModel =md;
                
                if (self.delegateCallback) {
                    [self.delegateCallback callback:nil];
                }
                [self.navigationController popToRootViewControllerAnimated:YES];
//                WaitingBusController *waiter = [[WaitingBusController alloc] init];
//                waiter.model = [CarOrderModel convertAppiontBusModel:md];
//                [self.navigationController pushViewController:waiter animated:YES];
            }];
        } failed:^(NSInteger errorCode, NSString *errorMessage) {
            [hud hide:YES];
            [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
        }];
        
    }else{
        [super buttonTarget:sender];
    }
}

- (void) buttonSelected:(UIView *)view Index:(NSInteger)index
{
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton*)view;
        NSRange range = [btn.titleLabel.text rangeOfString:@"元"];
        if (range.location !=NSNotFound) {
//            _money = [btn.titleLabel.text stringByReplacingOccurrencesOfString:@"元" withString:@""];
//            [_thankFee setTitle:btn.titleLabel.text];
        }else{
            _peopleNumber = btn.tag+1;
            ((CarOrderModel*)_dataArray[0]).orderPerson = btn.titleLabel.text;
            [self.mTableView reloadData];
        }
    }
}

#pragma  mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *static_id=@"static_ids";
    AppiontFastBusCell *cell = [tableView dequeueReusableCellWithIdentifier:static_id];
    if (!cell) {
        cell = [[AppiontFastBusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:static_id];
    }
    AppiontBusModel *model = _dataArray[indexPath.section];
    [cell setModel:model];
    [cell setDelegate:self];
    return cell;
}

#pragma  mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

#pragma mark - SearchViewControllerDelegate

- (void) searchViewController:(SearchAddressController *)searchViewController didSelectLocation:(CMLocation *)location
{
    if (searchViewController.targetId==0) {
        _location = location;
        ((CarOrderModel*)_dataArray[0]).slocation = _location.name;
        ((CarOrderModel*)_dataArray[0]).slatitude = [NSString stringWithFormat:@"%f",_location.coordinate.latitude];
        ((CarOrderModel*)_dataArray[0]).slongitude = [NSString stringWithFormat:@"%f",_location.coordinate.longitude];
        [self.mTableView reloadData];
        [self caculateDistance];
    }else if(searchViewController.targetId==1){
        _endlocation = location;
        ((CarOrderModel*)_dataArray[0]).elocation = _endlocation.name;
        ((CarOrderModel*)_dataArray[0]).elatitude =  [NSString stringWithFormat:@"%f",_endlocation.coordinate.longitude];
        ((CarOrderModel*)_dataArray[0]).elongitude = [NSString stringWithFormat:@"%f",_endlocation.coordinate.longitude];
        [self.mTableView reloadData];
        [self caculateDistance];
    }
}

- (void) caculateDistance
{
    if (!_location || !_endlocation) {
        NSLog(@"可能还没有选择起始位置？");
        return;
    }
    __weak __typeof(&*self) weakSelf = self;
    [[CMSearchManager sharedInstance] searchForStartLocation:_location end:_endlocation completionBlock:^(id request, id response, NSError *error) {
        AMapRouteSearchResponse *naviResponse = response;
        
        if (naviResponse.route == nil)
        {
            //[weakSelf.locationView setInfo:@"获取路径失败"];
            NSLog(@"获取路径失败");
            return;
        }
        AMapPath * path = [naviResponse.route.paths firstObject];
        weakSelf.distance = path.distance;
       NSLog(@"caclute:%@",[NSString stringWithFormat:@"预估费用%.2f元  距离%.1f km  时间%.1f分钟", naviResponse.route.taxiCost, path.distance / 1000.f, path.duration / 60.f, nil]);
    }];
}


- (void) initTableView
{
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.separatorColor = [UIColor clearColor];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.separatorColor = [UIColor clearColor];
    self.mTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) showDriverReceivedOrder:(NSNotification *)oderinfo
{
    DriverOrderInfo *order =nil;
    @try {
        NSError *error;
        order = [[DriverOrderInfo alloc] initWithDictionary:oderinfo.userInfo error:&error];
        
        NSLog(@"push oderinfo:%@",oderinfo.userInfo);
        if (error) {
            NSLog(@"push exception parse: %@",error);
        }
    }
    @catch (NSException *exception){
        NSLog(@"push exception:%@",exception);
    }
    @finally{
        CarOrderModel *_model;
        if (order && [@"4" isEqualToString:order.oType]) {
            if (_model &&([order.state integerValue]>[_model.state integerValue])) {
                _model = [CarOrderModel convertDriverModel:order];
                
            }else if([@"10" isEqualToString:order.type]){
                _model = [CarOrderModel convertDriverModel:order];
                if ([GlobalData sharedInstance].fastModel) {
                    [GlobalData sharedInstance].fastModel.type = @"10";
                }
            }
        }
    }
}

@end