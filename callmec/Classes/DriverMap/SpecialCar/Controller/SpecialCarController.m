//
//  SpecialCarController.m
//  callmec
//
//  Created by sam on 16/6/28.
//  Copyright © 2016年 sam. All rights reserved.
//


#import "SpecialCarController.h"


#import <AMapSearchKit/AMapSearchAPI.h>
#import "SearchAddressController.h"
#import "WaitDriverController.h"
#import "BrowerController.h"

#import "CarsChoiceView.h"
#import "TripAdressView.h"

#import "CarModel.h"
#import "MyTimePickerView.h"
#import "MyTimeTool.h"

#import "CMSearchManager.h"
#import "CMDriverManager.h"
#import "DriverOrderInfo.h"

@interface SpecialCarController()<TripViewDelegate,SearchViewControllerDelegate,TargetActionDelegate>

@property (nonatomic,strong) UIButton *buttonCall,*buttonLeft;
@property (nonatomic,strong) TripAdressView *tripView;
@property (nonatomic,strong) CarsChoiceView *carsView;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic,strong) AMapPath *amap_path;
@property (nonatomic,strong) TripMode *tmode;
@property (nonatomic,strong) CarModel *cmodel;
@property (nonatomic,strong) NSArray *carArray;
@property (nonatomic,assign) NSInteger locationType;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,strong) UIView *scrollContainer;
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation SpecialCarController


- (void) viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void) viewWillLayoutSubviews
{
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 420)];
    [_scrollContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView);
        make.top.equalTo(_scrollView);
        make.right.equalTo(_scrollView);
        make.bottom.equalTo(_scrollView);
        make.height.mas_equalTo(_scrollView.contentSize.height);
        make.width.mas_equalTo(_scrollView.contentSize.width);
    }];
}

- (void) initView
{
    [self.view setBackgroundColor:RGBHex(g_gray)];
    
    if (_isNowUseCar) {
        [self setTitle:@"现在用车"];
    }else{
        [self setTitle:@"预约用车"];
    }
    
    
    [self.headerView setBackgroundColor:RGBHex(g_white)];
    /*
    [self.rightButton setTitle:@"计价说明" forState:UIControlStateNormal];
    [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    */
    [self setRightButtonText:@"计价说明" withFont:[UIFont systemFontOfSize:14]];
    [self.rightButton setTitleColor:RGBHex(g_blue) forState:UIControlStateNormal];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 420)];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    _scrollContainer = [[UIView alloc] init];
    [_scrollView addSubview:_scrollContainer];
    [_scrollContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView);
        make.right.equalTo(_scrollView);
        make.top.equalTo(_scrollView);
        make.bottom.equalTo(_scrollView);
        
        make.height.mas_equalTo(_scrollView.contentSize.height);
        make.width.mas_equalTo(_scrollView.contentSize.width);
    }];
    
    
    _tripView = [[TripAdressView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [_tripView setBackgroundColor:[UIColor redColor]];
    _tripView.delegate = self;
    [_tripView setIsHiddenTime:_isNowUseCar];
    [_tripView.layer setCornerRadius:5];
    [_tripView.layer setMasksToBounds:YES];
    [_tripView setBackgroundColor:[UIColor whiteColor]];
    _city = _startLocation.city;
    [_scrollContainer addSubview:_tripView];
    
    [_tripView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollContainer).offset(10);
        make.left.equalTo(_scrollContainer).offset(5);
        make.right.equalTo(_scrollContainer).offset(-5);
        make.height.mas_equalTo(_isNowUseCar?150:200);
    }];
    if (_startLocation) {
        _tripView.startLocation = _startLocation;
    }
    if (_endLocation) {
        _tripView.endLocation = _endLocation;
    }
    _carsView =[[CarsChoiceView alloc] init];
    CarModel *model1 = [[CarModel alloc] initWithDictionary:@{@"carTitle":@"轿车",
                                                              @"carIcon":@"shushihei",
                                                              @"carIconLight":@"shushilan",
                                                              @"carType":@"4",
                                                              @"isSelected":@"0",
                                                              @"carMoney":@"10.0"} error:nil];
    CarModel *model2 = [[CarModel alloc] initWithDictionary:@{@"carTitle":@"7座商务",
                                                              @"carIcon":@"putonghei",
                                                              @"carIconLight":@"putonglan",
                                                              @"isSelected":@"1",
                                                              @"carType":@"3",
                                                              @"carMoney":@"10.0"} error:nil];
//    CarModel *model3 = [[CarModel alloc] initWithDictionary:@{@"carTitle":@"豪华型",
//                                                              @"carIcon":@"icon_cartype_3",
//                                                              @"carIconLight":@"icon_cartype_fcs3",
//                                                              @"isSelected":@"0",
//                                                              @"carType":@"5",
//                                                              @"carMoney":@"10.0"} error:nil];
    _cmodel = model2;
    _carArray =[NSArray arrayWithObjects:model2,model1,nil];
    [_carsView setDataArray:_carArray];
    [_scrollContainer addSubview:_carsView];
    [_carsView.layer setCornerRadius:5];
    [_carsView.layer setMasksToBounds:YES];
    [_carsView setDelegate:self];
    
    [_carsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tripView.mas_bottom).offset(10);
        make.left.equalTo(_scrollContainer).offset(5);
        make.right.equalTo(_scrollContainer).offset(-5);
        make.height.mas_equalTo(130);
    }];
    
    _buttonCall = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonCall.layer setCornerRadius:5];
    [_buttonCall.layer setMasksToBounds:YES];
    [_buttonCall setBackgroundImage:[ImageTools imageWithColor:RGBHex(g_blue)] forState:UIControlStateNormal];
    [_buttonCall setBackgroundImage:[ImageTools imageWithColor:RGBHex(g_blue)] forState:UIControlStateHighlighted];
    
//    [_buttonCall setImage:[ImageTools imageWithColor:RGBHex(g_gray)] forState:UIControlStateNormal];
    
    [_buttonCall setTitle:@"呼叫专车" forState:UIControlStateNormal];
    [_buttonCall.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_buttonCall addTarget:self action:@selector(buttonTargetSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollContainer addSubview:_buttonCall];
    [_buttonCall mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_scrollContainer);
        make.left.equalTo(_scrollContainer).offset(20);
        make.right.equalTo(_scrollContainer).offset(-20);
        make.bottom.equalTo(_scrollContainer).offset(-10);
        make.height.mas_equalTo(50);
    }];
    
    
    _buttonLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonLeft setTitle:@"购买保险" forState:UIControlStateNormal];
    [_buttonLeft setHidden:YES];
    [_buttonLeft.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_buttonLeft setContentMode:UIViewContentModeBottomLeft];
    [_buttonLeft setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [_buttonLeft setImage:[UIImage imageNamed:@"checks"] forState:UIControlStateSelected];
    [_buttonLeft setImage:[UIImage imageNamed:@"checks"] forState:UIControlStateHighlighted];
    [_buttonLeft addTarget:self action:@selector(buttonSwitchStatus:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonLeft setTitleColor:RGBHex(g_black) forState:UIControlStateNormal];
    [_buttonLeft setImageEdgeInsets:UIEdgeInsetsMake(0, -165, 0, 0)];
    [_buttonLeft setTitleEdgeInsets:UIEdgeInsetsMake(0, -145, 0, 0)];
    [_tripView appendView:_buttonLeft];
//    [_buttonLeft mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineView.mas_bottom);
//        make.right.equalTo(_top_container.mas_centerX).offset(4);
//        make.height.mas_equalTo(40);
//        make.width.mas_equalTo(150);
//    }];
    
//    UIView *midline = [[UIView alloc] init];
//    [midline setBackgroundColor:RGBHex(g_assit_gray)];
//    [_top_container addSubview:midline];
//    [midline mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineView.mas_bottom);
//        make.height.mas_equalTo(40);
//        make.centerX.equalTo(_top_container);
//        make.width.mas_equalTo(1);
//    }];
}

- (void) setStartLocation:(CMLocation *)startLocation
{
    _startLocation = startLocation;
    _tripView.startLocation = _startLocation;
}

- (void) setEndLocation:(CMLocation *)endLocation
{
    _endLocation = endLocation;
    _tripView.endLocation = _endLocation;
}

- (void) tripViewClick:(UIView *)item
{
//    NSLog(@"trapId:%d",item.tag);
    switch (item.tag)
    {
        case 0:
            
            break;
        case 1:
        {
            [MyTimePickerView showTimePickerViewDeadLine:@"20160601" withTitle:@"请选择出发时间" CompleteBlock:^(NSDictionary *infoDic) {
                
                _startTime = infoDic[@"time_value"];
                NSString *time_fromat = [MyTimeTool formatDateTime:_startTime withFormat:nil];
                [_tripView setTime:time_fromat];
                NSLog(@"infoDic:%@",infoDic);
            }];
        }
            break;
        case 2:
        {
            SearchAddressController *search1 = [[SearchAddressController alloc] init];
            search1.delegate = self;
            search1.city = _city;
            _locationType=2;
            [self.navigationController pushViewController:search1 animated:YES];
        }
            break;
        case 3:
        {
            SearchAddressController *search = [[SearchAddressController alloc] init];
            search.delegate = self;
            search.city = _city;
            _locationType=3;
            [self.navigationController pushViewController:search animated:YES];
        }
            
            break;
        default:
            break;
    }
}

- (void) buttonTarget:(UIView*)sender
{
    if (sender==self.leftButton) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (sender == self.rightButton){
        BrowerController *webview = [[BrowerController alloc] init];
        webview.urlStr = [CommonUtility getArticalUrl:@"4"];
        webview.titleStr = @"计价说明";
        [self.navigationController pushViewController:webview animated:YES];
    }else{
        NSInteger tag = sender.tag;
        _cmodel =_carArray[tag];
        [self caculater];
    }
}

- (void) buttonTargetSubmit:(id)sender
{
    /*
    WaitDriverController *waiter =[[WaitDriverController alloc] init];
    waiter.orderId = @"";
    waiter.currentLocation = self.startLocation;
    waiter.destinationLocation = self.endLocation;
    if (_startTime) {
        NSString *time_fromat = [MyTimeTool formatDateTime:_startTime withFormat:nil];
        waiter.startTime = time_fromat;
    }
    waiter.routPath = self.amap_path;
    [self.navigationController pushViewController:waiter animated:YES];
    if (YES) {
        return;
    }
    */
    if (!_startTime && !_isNowUseCar) {
        [MBProgressHUD showAndHideWithMessage:@"请选择出发时间" forHUD:nil];
        return;
    }
    if (!_endLocation) {
        [MBProgressHUD showAndHideWithMessage:@"请选择目的地" forHUD:nil];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    NSString *userId = [GlobalData sharedInstance].user.userInfo.ids;
    [params setObject:userId?userId:@"" forKey:@"memberId"];
    
    NSMutableDictionary *order = [NSMutableDictionary dictionary];
    
    
    [order setObject:_carTypeModel.tripType forKey:@"type"];
    [order setObject:self.isNowUseCar?@"false":@"true" forKey:@"appoint"];
    if (_startTime) {
        [order setObject:[MyTimeTool formatDateTime:_startTime withFormat:@"yyyy-MM-dd HH:mm:00"] forKey:@"appointDate"];//appointDate
    }else{
        
    }

    if (!_startLocation) {
        [MBProgressHUD showAndHideWithMessage:@"出发点没有获取到，请稍后!" forHUD:nil];
        return;
    }
    [order setObject:_startLocation.name?_startLocation.name:@"" forKey:@"sLocation"];
    [order setObject:_endLocation.name?_endLocation.name:@"" forKey:@"eLocation"];
    [order setObject:[NSString stringWithFormat:@"%f",_startLocation.coordinate.longitude] forKey:@"sLongitude"];
    [order setObject:[NSString stringWithFormat:@"%f",_startLocation.coordinate.latitude] forKey:@"sLatitude"];
    [order setObject:[NSString stringWithFormat:@"%f",_endLocation.coordinate.longitude] forKey:@"eLongitude"];
    [order setObject:[NSString stringWithFormat:@"%f",_endLocation.coordinate.latitude] forKey:@"eLatitude"];
    [order setObject:_tmode.fee?_tmode.fee:@"0" forKey:@"fee"];
    [order setObject:_tmode.distance?_tmode.distance:@"" forKey:@"distance"];
    [order setObject:_buttonLeft.selected?@"true":@"false" forKey:@"protect"];
    
    [order setObject:_cmodel.carType forKey:@"carType"];
    [order setObject:@"false" forKey:@"other"];
    [order setObject:@"" forKey:@"otherPhone"];
    [order setObject:@"" forKey:@"otherName"];
    
    [params setObject:[order lk_JSONString] forKey:@"order"];
    MBProgressHUD *hud = [MBProgressHUD showProgressView:@"正在提交信息..." inView:nil];
    [hud show:YES];
    [CMDriverManager sendCallCarRequest:params success:^(NSDictionary *resultDictionary) {
        NSLog(@"resultDictionary:%@",resultDictionary);
        [hud hide:YES];
        NSString *orderId = [resultDictionary objectForKey:@"message"];
        [MBProgressHUD showAndHideWithMessage:@"已经为您通知附近的司机！请稍后!" forHUD:nil];
        WaitDriverController *waiter =[[WaitDriverController alloc] init];
        waiter.orderId = orderId;
        waiter.currentLocation = self.startLocation;
        waiter.destinationLocation = self.endLocation;
        if (_startTime) {
            NSString *time_fromat = [MyTimeTool formatDateTime:_startTime withFormat:nil];
            waiter.startTime = time_fromat;
        }
        waiter.routPath = self.amap_path;
        [self.navigationController pushViewController:waiter animated:YES];
        
    } failed:^(NSInteger errorCode, NSString *errorMessage) {
        [hud hide:YES];
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
    }];
    
}

- (void) searchViewController:(SearchAddressController *)searchViewController didSelectLocation:(CMLocation *)location
{
    if (_locationType==2) {
        
        self.startLocation = location;
        _tripView.startLocation = location;
    }else{
        self.endLocation = location;
        _tripView.endLocation = location;
    }
    [self requestPathInfo];
}


- (void)requestPathInfo
{
    //检索所需费用
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.requireExtension = YES;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:_startLocation.coordinate.latitude
                                           longitude:_startLocation.coordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:_endLocation.coordinate.latitude
                                                longitude:_endLocation.coordinate.longitude];
    
    //__weak __typeof(&*self) weakSelf = self;
    [[CMSearchManager sharedInstance] searchForRequest:navi completionBlock:^(id request, id response, NSError *error) {
        
        AMapRouteSearchResponse *naviResponse = response;
        
        if (naviResponse.route == nil)
        {
            [MBProgressHUD showAndHideWithMessage:@"获取路径失败" forHUD:nil];
            return;
        }
        
        AMapPath * path = [naviResponse.route.paths firstObject];
        _amap_path = path;
        _tmode = [[TripMode alloc] init];
        _tmode.distance = [NSString stringWithFormat:@"%.1f",(float)path.distance];
        _tmode.time = [NSString stringWithFormat:@"%.1f",path.duration / 60.f];
//        _tmode.fee = [NSString stringWithFormat:@"%.2f",naviResponse.route.taxiCost];
        [self caculater];
        /*
        [_carsView setAboutMoney:[NSString stringWithFormat:@"费用约%.2f元  共%.1f km  约%.1f分钟", naviResponse.route.taxiCost, path.distance / 1000.f, path.duration / 60.f, nil]];
        */
        
    }];
}

- (void) caculater
{
    if (_tmode==nil) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_tmode.distance forKey:@"distance"];
    [params setObject:_cmodel.carType forKey:@"carType"];
    [params setObject:_carTypeModel.tripType forKey:@"type"];
    [params setObject:[NSString stringWithFormat:@"%f",_startLocation.coordinate.latitude]forKey:@"sLatitude"];
    [params setObject:[NSString stringWithFormat:@"%f",_startLocation.coordinate.longitude] forKey:@"sLongitude"];

    [DriverOrderInfo fetchOrderFee:params success:^(NSDictionary *resultDictionary) {
        NSLog(@"resultDictionary:%@",resultDictionary);
        
        NSDictionary *data = resultDictionary[@"data"];
        NSString* total_fee = data[@"totalFee"];
        _tmode.fee = total_fee;
        [_carsView setAboutMoney:total_fee];
        
    } failed:^(NSInteger errorCode, NSString *errorMessage) {
        NSLog(@"errorMessage:%@ %d",errorMessage,errorCode);
    }];
}

- (void)buttonSwitchStatus:(UIButton*)sender
{
    sender.selected = !sender.selected;
}
@end
