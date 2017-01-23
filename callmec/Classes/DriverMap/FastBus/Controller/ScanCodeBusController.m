//
//  AppiontBusController.m
//  callmec
//
//  Created by sam on 16/8/10.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "ScanCodeBusController.h"
#import "BrowerController.h"
#import "WaitingBusController.h"
#import "SearchAddressController.h"

#import "LeftIconLabel.h"
#import "LeftInputView.h"

#import "CMSearchManager.h"
#import "CMDriverManager.h"


@interface ScanCodeBusController ()<TargetActionDelegate,SearchViewControllerDelegate>

@property (nonatomic,strong) UIView *container;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UIButton *buttonInsurance;
@property (nonatomic,strong) LeftIconLabel *imageHeader;
@property (nonatomic,strong) LeftIconLabel *timeLabel;
@property (nonatomic,strong) LeftInputView *addressLabel;
@property (nonatomic,strong) LeftIconLabel *scanResultLabel;
@property (nonatomic,strong) CMLocation *endLocation;
@end

@implementation ScanCodeBusController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}


- (void) initView
{
    [self setTitle:@"搭乘快巴"];
    
    [self setRightButtonText:@"计价说明" withFont:[UIFont systemFontOfSize:14]];
    [self.rightButton setTitleColor:RGBHex(g_red) forState:UIControlStateNormal];
    
    [self.headerView setBackgroundColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:RGBHex(g_gray)];
    _container = [[UIView alloc] init];
    [_container.layer setCornerRadius:5];
    [_container.layer setMasksToBounds:YES];
    [_container setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_container];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-10);
    }];
    
    _imageHeader = [[LeftIconLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_imageHeader setImageUrl:@"icon_userss"];
//    [_imageHeader setImageUrl:[CommonUtility userHeaderImageUrl:[GlobalData sharedInstance].user.userInfo.ids]];
    [_imageHeader setImageH:0.8];
    [_container addSubview:_imageHeader];
    [_imageHeader setTitle:@"本人用车"];
    [_imageHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container).offset(10);
        make.left.equalTo(_container).offset(10);
        make.height.mas_equalTo(50);
    }];
    
    _timeLabel = [[LeftIconLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_container addSubview:_timeLabel];
    [_timeLabel setTitle:[CommonUtility convertDateToString:[NSDate date]]];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageHeader.mas_bottom).offset(10);
        make.left.equalTo(_container).offset(15);
        make.height.mas_equalTo(30);
    }];
    
    _addressLabel = [[LeftInputView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_addressLabel setImageUrl:@"icon_timelines_1"];
    [_addressLabel setTitle:@"请选择上车地"];
    [_addressLabel setPlaceHolder:@"请选择上车地"];
    [_addressLabel setDelegate:self];
    [_addressLabel setEnable:NO];
    [_addressLabel setHidden:YES];
    [_container addSubview:_addressLabel];
    __block ScanCodeBusController *objs= self;
    if ([GlobalData sharedInstance].location) {
        [_addressLabel setTitle:[GlobalData sharedInstance].location.address];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showProgressView:@"正在查询地址!" inView:nil];
        [hud show:YES];
        [[CMSearchManager sharedInstance] searchLocation:nil completionBlock:^(id request, id response, NSError *error) {
            NSLog(@"respone:%@",response);
            [objs.addressLabel setTitle:[GlobalData sharedInstance].location.address];
            [hud hide:YES];
        }];
    }
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom).offset(10);
        make.left.equalTo(_container).offset(5);
        make.right.equalTo(_container).offset(-10);
        make.height.mas_equalTo(50);
    }];
    
    _buttonInsurance = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonInsurance setTitle:@"购买保险" forState:UIControlStateNormal];
    [_buttonInsurance.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_buttonInsurance setHidden:YES];
    [_buttonInsurance setContentMode:UIViewContentModeBottomLeft];
    [_buttonInsurance setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [_buttonInsurance setImage:[UIImage imageNamed:@"checks"] forState:UIControlStateSelected];
    [_buttonInsurance setImage:[UIImage imageNamed:@"checks"] forState:UIControlStateHighlighted];
    [_buttonInsurance addTarget:self action:@selector(buttonSwitchStatus:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonInsurance setTitleColor:RGBHex(g_black) forState:UIControlStateNormal];
    [_buttonInsurance setImageEdgeInsets:UIEdgeInsetsMake(0, -180, 0, 0)];
    [_buttonInsurance setTitleEdgeInsets:UIEdgeInsetsMake(0, -155, 0, 0)];
    //    [_buttonInsurance setBackgroundColor:[UIColor redColor]];
    [_container addSubview:_buttonInsurance];
    [_buttonInsurance mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_addressLabel.mas_bottom);//
        make.top.equalTo(_timeLabel.mas_bottom);
        make.left.equalTo(_container).offset(15);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(260);
    }];
    
    _scanResultLabel = [[LeftIconLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];//icon_pc_pepo
    [_scanResultLabel setHidden:YES];
    [_container addSubview:_scanResultLabel];
    [_scanResultLabel setTitle:[NSString stringWithFormat:@"扫描结果:%@",self.carNo]];
    [_scanResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressLabel.mas_bottom).offset(10);
        make.left.equalTo(_container).offset(10);
        make.height.mas_equalTo(50);
    }];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_container addSubview:_button];
    [_button setTitle:@"确认搭车" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button setBackgroundImage:[ImageTools imageWithColor:RGBHex(g_red)] forState:UIControlStateNormal];
    [_button setBackgroundImage:[ImageTools imageWithColor:RGBHex(g_gray)] forState:UIControlStateHighlighted];
    [_button addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    [_button setBackgroundColor:RGBHex(g_red)];
    [_button.layer setCornerRadius:5];
    [_button.layer setMasksToBounds:YES];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_container);
        make.width.mas_equalTo(256);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(_container).offset(-10);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) buttonTarget:(id)sender
{
    if (sender == self.leftButton) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if(sender == self.rightButton)
    {
        BrowerController *webview = [[BrowerController alloc] init];
        webview.urlStr = [CommonUtility getArticalUrl:@"4" type:@"4"];
        webview.titleStr = @"计价说明";
        [self.navigationController pushViewController:webview animated:YES];
    }else if([sender isKindOfClass:[LeftInputView class]]){
        SearchAddressController *search = [[SearchAddressController alloc] init];
        search.delegate = self;
        [self.navigationController pushViewController:search animated:YES];
        
    }else {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[NSString stringWithFormat:@"%@",[GlobalData sharedInstance].user.userInfo.ids] forKey:@"memberId"];
        NSMutableDictionary *order =[NSMutableDictionary dictionary];
        
        [order setObject:@"4" forKey:@"type"];
        [order setObject:@"false" forKey:@"appoint"];
        [order setObject:_timeLabel.title forKey:@"appointDate"];
        [order setObject:[NSString stringWithFormat:@"%@",[GlobalData sharedInstance].location.name] forKey:@"sLocation"];
        [order setObject:[NSString stringWithFormat:@"%f",[GlobalData sharedInstance].location.coordinate.longitude] forKey:@"sLongitude"];
        [order setObject:[NSString stringWithFormat:@"%f",[GlobalData sharedInstance].location.coordinate.latitude] forKey:@"sLatitude"];
//        if (!_carNo) {
//            [MBProgressHUD showAndHideWithMessage:@"请选择目的地" forHUD:nil];
//            return;
//        }
        [order setObject:_carNo?_carNo:@"" forKey:@"carNo"];
//        if (!_endLocation) {
//            [MBProgressHUD showAndHideWithMessage:@"请选择目的地" forHUD:nil];
//            return;
//        }
        [order setObject:[NSString stringWithFormat:@"%@",_endLocation.name] forKey:@"eLocation"];
        [order setObject:[NSString stringWithFormat:@"%f",_endLocation.coordinate.longitude] forKey:@"eLongitude"];
        [order setObject:[NSString stringWithFormat:@"%f",_endLocation.coordinate.latitude] forKey:@"eLatitude"];
        [order setObject:_buttonInsurance.selected?@"true":@"false" forKey:@"insurance"];
        [params setObject:[order lk_JSONString] forKey:@"order"];
        
        NSLog(@"post:%@",[params lk_JSONString]);
        MBProgressHUD *hud = [MBProgressHUD showProgressView:@"正在提交订单..." inView:nil];
        [hud show:YES];
        [CMDriverManager sendCallCarRequest:params success:^(NSDictionary *resultDictionary) {
            [MBProgressHUD showAndHideWithMessage:@"创建快巴订单成功!" forHUD:nil];
            WaitingBusController *waiter = [[WaitingBusController alloc] init];
            NSDictionary *message = resultDictionary[@"message"];
            CarOrderModel *model = [[CarOrderModel alloc] initWithDictionary:message error:nil];
            
            model.dRealName = message[@"driverName"];
            model.dLevel = message[@"level"];
            model.type = message[@"oType"];
            model.state = @"5";
            model.mPhoneNo = message[@"phoneNo"];
            model.dServiceNum = message[@"serviceNum"];
            model.slocation=_addressLabel.title;
            model.appointDate = _timeLabel.title;
            waiter.model = model ;
            [GlobalData sharedInstance].fastModel = nil;
            [self.delegateCallback callback:nil];
            self.delegateCallback = nil;
            [hud hide:YES];
            [self.navigationController pushViewController:waiter animated:YES];
            
        } failed:^(NSInteger errorCode, NSString *errorMessage) {
            [hud hide:YES];
            [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
        }];
    }
}

- (void)buttonSwitchStatus:(UIButton*)sender
{
    sender.selected = !sender.selected;
}

- (void) searchViewController:(SearchAddressController *)searchViewController didSelectLocation:(CMLocation *)location
{
    _endLocation = location;
    _addressLabel.title = location.name;
}


@end
