//
//  CarPoolingHomeControllerViewController.m
//  callmec
//
//  Created by sam on 16/7/24.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "CarPoolingHomeController.h"



#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "CMLocation.h"
#import "CMDriver.h"
//#import "CMSearchViewController.h"
#import "CMSearchManager.h"

#import "CMDriverManager.h"
#import "CMLocationView.h"
#import "CMTaxiCallRequest.h"

#import "MovingAnnotationView.h"
#import "RegisterController.h"
#import "UserCenterController.h"
#import "MessageController.h"
#import "DriverInfoController.h"
#import "PayOrderController.h"  //test
#import "WaitingCarPoolingCtrl.h"

#import "VerticalView.h"
#import "chooseLineViewController.h"



#import "SpecialCarController.h"
#import "GoodsCarController.h"
#import "AppiontmentController.h"


#import "PopView.h"
#import "TripTypeView.h"

#import "DriverInfoModel.h"
#import "DriverOrderView.h" //test

#import "CarPoolingCell.h"

#import "SearchAddressController.h"
#import "chooseAddressViewController.h"
#import "chooseEndAddressViewController.h"
#import "MyTimePickerView.h"
#import "MyTimeTool.h"
#import "chooseEndLineViewController.h"

//#import "<#header#>"
#define kSetingViewHeight 215
#define ONEDAYARRAY @[@"今天"]
#define TWODAYARRAY @[@"今天", @"明天"]
#define THREEDAYARRAY @[@"今天", @"明天", @"后天"]
#define HOURARRAY @[@"0点", @"1点", @"2点", @"3点", @"4点", @"5点", @"6点", @"7点", @"8点", @"9点", @"10点", @"11点", @"12点", @"13点", @"14点", @"15点", @"16点", @"17点", @"18点", @"19点", @"20点", @"21点", @"22点", @"23点"]
#define MINUTEARRAY @[@"0分", @"10分", @"20分", @"30分", @"40分", @"50分"]


@interface CarPoolingHomeController() <TargetActionDelegate,
MAMapViewDelegate,
CMDriverManagerDelegate,
CMLocationViewDelegate,UITableViewDataSource,UITableViewDelegate,CellTargetDelegate,CallBackDelegate,sendLineDelegate,sendDatasDelegate>

@property (nonatomic,assign) BOOL isCurrentLocal;
@property (nonatomic,strong) UIButton *buttonLocating;
@property (nonatomic, assign) BOOL isLocating;
//@property (nonatomic,strong) TripTypeView *top_container;
@property (nonatomic,strong) UIView *bottom_container;
@property (nonatomic,strong) NSArray *carTypeArray;
@property (nonatomic, assign) CMState state;



@property (nonatomic, strong) CMLocation * currentLocation;
@property (nonatomic, strong) CMLocation * destinationLocation;
@property (nonatomic, strong) CMLocationView *locationView;

@property (nonatomic, strong) UIButton *btn_left;
@property (nonatomic, strong) UIButton *btn_right;

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIView *tipView;


@property (nonatomic,strong) UIView *middle_container;

@property (nonatomic,strong) UILabel *startHeadLabel;
@property (nonatomic,strong) UILabel *startDisLabel;

@property (nonatomic,strong) UIButton *timeButton;

@property (nonatomic,strong) UILabel *endHeadLabel;

@property (nonatomic,strong) NSDictionary *startDatasDic;
@property (nonatomic,strong) NSDictionary *endDatasDic;


@property (nonatomic,strong) UIButton *startButton;
@property (nonatomic,strong) UIButton *endButton;
@property (nonatomic,strong) AppiontRouteModel *routeModel;

@property (nonatomic,strong) CMLocation *startlocation;
@property (nonatomic,strong) CMLocation *offLocation;

@property (nonatomic,strong) UIButton *startLineButton;
@property (nonatomic,strong) UIButton *endLineButton;

@property (nonatomic, copy) NSString *startTime;


@end


@implementation CarPoolingHomeController
{
    BOOL _needsFirstLocating;
    CMDriverManager * _driverManager;
    NSArray * _drivers;
    MAPointAnnotation * _selectedDriver;
    MAPointAnnotation * _centerAnnotion;
    UIButton *_buttonAction;
    UIButton *_buttonCancel;
    UIButton *_buttonLocating;
    
    int _currentSearchLocation; //0 start, 1 end
    MAPinAnnotationView *centerAnnotationView;
    PopView *popView;
    CLLocationCoordinate2D local2D;
    NSInteger page;
    UIView * lineView;
    
    NSDictionary *sendAllDatas;
    NSDictionary *getStartDatas;
    NSDictionary *getEndDatas;

    BOOL isBool;

}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initMapView];
    isBool = NO;
    [self initView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"NOTICE_UPDATE_CARPOOLING_INFO" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getEndAddress:) name:@"SEND_END_ADDRESS"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getStartAddress:) name:@"SEND_START_ADDRESS"object:nil];

}

- (void) initView
{
    
    [self.headerView setHidden:YES];
    _buttonLocating = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonLocating setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    _buttonLocating.backgroundColor = [UIColor whiteColor];
    _buttonLocating.layer.cornerRadius = 6;
    _buttonLocating.layer.shadowColor = [UIColor blackColor].CGColor;
    _buttonLocating.layer.shadowOffset = CGSizeMake(1, 1);
    _buttonLocating.layer.shadowOpacity = 0.5;
    [_buttonLocating addTarget:self action:@selector(actionLocating:) forControlEvents:UIControlEventTouchUpInside];
    _buttonLocating.frame = CGRectMake(30, 110, 40, 40);
    [self initTableCenterView];

    [self initBottomView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.bottom_container.mas_top);
    }];
    _bottom_container.layer.cornerRadius = 15;
    [_bottom_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView).offset(23);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(120);
    }];
    
    [self initTableView];
    
    _tipView =[[UIView alloc] init];
    UILabel *tipLabel = [[UILabel alloc] init];
    [tipLabel setText:@"尊敬的用户\n欢迎使用呼我快车，点击底部按钮开始愉快行程"];
    [tipLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    [tipLabel setTextColor:RGBHex(g_assit_c)];
    [tipLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [tipLabel setNumberOfLines:0];
    [_tipView setBackgroundColor:[UIColor whiteColor]];
    [_tipView addSubview:tipLabel];
    [_tipView setHidden:YES];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tipView);
        make.left.equalTo(_tipView);
        make.right.equalTo(_tipView);
        make.bottom.equalTo(_tipView);
    }];
    [self.view addSubview:_tipView];
    [_tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;//YES开启定位，NO关闭定位
    
    //获取默认时间
    NSMutableString *dateValue = [[NSMutableString alloc] initWithString:[MyTimeTool daysFromNowToDeadLine:@"20160601"][0]];
    [dateValue appendString:[self formatOriArray:[self validHourArray]][0]];
    [dateValue appendString:[self formatOriArray:[self validMinuteArray]][0]];
    _startTime = dateValue;
    [_timeButton setTitle:[MyTimeTool formatDateTime:dateValue withFormat:nil] forState:UIControlStateNormal];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_mTableView) {
        [_mTableView.mj_header beginRefreshing];
    }
}

#pragma mark - Init & Construct

- (void)configMapView
{
    //    [self.mapView setDelegate:self];
    //    [self.mapView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.headerView.mas_bottom);
    //        make.left.equalTo(self.view);
    //        make.width.equalTo(self.view);
    //        make.bottom.equalTo(self.view);
    //    }];
    //    [self.view insertSubview:self.mapView atIndex:0];
    //    self.mapView.showsUserLocation = YES;
    
    popView = [[PopView alloc] init];
    [popView setBackgroundColor:RGBHex(g_blue)];
    [popView setTitle:@"当前位置"];
    [popView setLeftTime:@"3分钟"];
    [self.view addSubview:popView];
    if (!centerAnnotationView) {
        centerAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:_centerAnnotion
                                                               reuseIdentifier:@"map_user_center"];
    }
    centerAnnotationView.draggable = YES;
    [centerAnnotationView setDragState:(MAAnnotationViewDragStateDragging)];
    UIImage *image = [UIImage imageNamed:@"map_me"];
    centerAnnotationView.image = image;
    UILabel *label = [[UILabel alloc] init];
    [label setFrame:CGRectMake(0, 0, 60, 20)];
    [label setText:@"3分钟"];
    centerAnnotationView.leftCalloutAccessoryView = label;
    centerAnnotationView.centerOffset = CGPointMake(0,0);
    centerAnnotationView.frame = CGRectMake(self.mapView.center.x-image.size.width/2,
                                            self.mapView.center.y-6,
                                            image.size.width,
                                            image.size.height);
    centerAnnotationView.canShowCallout = NO;
    [self.view addSubview:centerAnnotationView];
    [centerAnnotationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mapView).offset(0);
        make.centerY.equalTo(self.mapView).offset(0);
        make.size.mas_equalTo(image.size);
    }];
    [popView setTitle:@"当前位置上车"];
    [popView setLeftTime:@"3分钟"];
    [popView setCornerRadius:5];
    [popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerAnnotationView.mas_top).offset(-5);
        make.centerX.equalTo(self.mapView);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
    }];
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    // 第一次定位时才将定位点显示在地图中心
    //NSLog(@"%d    %d",_needsFirstLocating,updatingLocation);
    if (_needsFirstLocating && updatingLocation)
    {
        
        [self actionLocating:nil];
        self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
        _needsFirstLocating = NO;
        
        CMLocation *loca = [[CMLocation alloc] init];
        self.currentLocation = loca;
        [self searchReGeocodeWithCoordinate:self.mapView.userLocation.location.coordinate];
        local2D = self.mapView.userLocation.location.coordinate;
        [self updatingDrivers];
    }
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    /* 自定义userLocation对应的annotationView. */
    //    if ([annotation isKindOfClass:[MAUserLocation class]])
    //    {
    //        static NSString *userLocationStyleReuseIndetifier = @"userLocationReuseIndetifier";
    //        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
    //        if (annotationView == nil)
    //        {
    //            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:nil
    //                                                             reuseIdentifier:userLocationStyleReuseIndetifier];
    //        }
    //        annotationView.draggable = YES;
    //        [annotationView setDragState:(MAAnnotationViewDragStateDragging)];
    //        //(MAAnnotationViewDragState)
    //        UIImage *image = [UIImage imageNamed:@"map_me"];
    //        annotationView.image = image;
    //        UILabel *label = [[UILabel alloc] init];
    //        [label setFrame:CGRectMake(0, 0, 60, 20)];
    //        [label setText:@"3分钟"];
    //        [label setBackgroundColor:[UIColor blueColor]];
    //        annotationView.leftCalloutAccessoryView = label;
    //        annotationView.centerOffset = CGPointMake(0, -22);
    //        annotationView.canShowCallout = YES;
    //        annotationView.center = self.mapView.center;
    //        return annotationView;
    //    }
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"driverReuseIndetifier";
        
        MovingAnnotationView *annotationView = (MovingAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MovingAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:pointReuseIndetifier];
        }
        
        UIImage *image = [UIImage imageNamed:@"dirver_marker"];
        
        annotationView.image = image;
        annotationView.centerOffset = CGPointMake(0, -22);
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }else{
        
        static NSString *userLocationStyleReuseIndetifier = @"common_user_indetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        UIImage *image = [UIImage imageNamed:@"icon_qidian_dot_3"];
        annotationView.image = image;
        annotationView.centerOffset = CGPointMake(0,0);
        annotationView.canShowCallout = NO;
        return annotationView;
    }
    
    return nil;
}


#pragma mark -  Action Reset Locating

- (void) resetMapToCenter:(CLLocationCoordinate2D)coordinate
{
    self.mapView.centerCoordinate = coordinate;
    self.mapView.zoomLevel = 17;
    
    // 使得userLocationView在最前。
    [self.mapView selectAnnotation:self.mapView.userLocation animated:YES];
}

- (void) updateCarsDrivers
{
    _isLocating = NO;
}

- (void) buttonTarget:(id)sender
{
    /*
     if (YES) {
     PayOrderController *order = [[PayOrderController alloc] init];
     order.orderId = @"218";
     [self.navigationController pushViewController:order animated:YES];
     return;
     }
     */
    if (sender ==self.leftButton) {
        if (![GlobalData sharedInstance].user.isLogin) {
            RegisterController *login = [[RegisterController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
        }else{
            UserCenterController *center = [[UserCenterController alloc] init];
            [self.navigationController pushViewController:center animated:YES];
        }
    }else if(sender == self.rightButton)
    {
        //MessageController *message = [[MessageController alloc] init];
        //[self.navigationController pushViewController:message animated:YES];
        
        DriverInfoController *driverInfo = [[DriverInfoController alloc] init];
        [self.navigationController pushViewController:driverInfo animated:YES];
        
    }else if([sender isKindOfClass:[UIButton class]])
    {
        /*
        WaitingCarPoolingCtrl *waiting = [[WaitingCarPoolingCtrl alloc] init];
        [self.navigationController pushViewController:waiting animated:YES];
        return;*/
        
        if(![GlobalData sharedInstance].user.isLogin)
        {
            [MBProgressHUD showAndHideWithMessage:@"您现在是未登录状态无法预约车!" forHUD:nil];
            return;
        }
        UIButton *but = (UIButton*)sender;
        switch (but.tag) {
            case 1:
            {
                if (!_tripModel) {
                    [MBProgressHUD showAndHideWithMessage:@"请选择出行方式，专车、快车或者其他!" forHUD:nil];
                    return;
                }
                if ([@"1" isEqualToString:_tripModel.tripType]) {
                    SpecialCarController *special = [[SpecialCarController alloc] init];
                    special.startLocation = self.currentLocation;
                    special.isNowUseCar = YES;
                    special.carTypeModel = _tripModel;
                    [self.navigationController pushViewController:special animated:YES];
                }else if([@"2" isEqualToString:_tripModel.tripType])
                {
                    if ([_startHeadLabel.text isEqualToString:@"选择上车地点"]) {
                        [MBProgressHUD showAndHideWithMessage:@"请选择上车地点!" forHUD:nil];
                    }else if([_endHeadLabel.text isEqualToString:@"选择下车地点"]){
                        [MBProgressHUD showAndHideWithMessage:@"请选择下车地点!" forHUD:nil];
                    }else{
                    AppiontmentController *special = [[AppiontmentController alloc] init];
                    [special setStartTime:_startTime];
                    NSLog(@"%@",_currentLocation);
                    special.startLocation = _startlocation;
                    special.isNowUseCar = YES;
                    special.tripTypeModel = _tripModel;
                    special.location = _startlocation;
                    special.offLocation = _offLocation;
                    special.allDatas = sendAllDatas;
                    [self.navigationController pushViewController:special animated:YES];
                    }
                }else if([@"3" isEqualToString:_tripModel.tripType])
                {
                    SpecialCarController *special = [[SpecialCarController alloc] init];
                    special.startLocation = self.currentLocation;
                    special.isNowUseCar = YES;
                    special.carTypeModel = _tripModel;
                    [self.navigationController pushViewController:special animated:YES];
                }else if([@"4" isEqualToString:_tripModel.tripType])
                {
                    GoodsCarController *special = [[GoodsCarController alloc] init];
                    special.startLocation = self.currentLocation;
                    special.isNowUseCar = YES;
                    special.carTypeModel = _tripModel;
                    [self.navigationController pushViewController:special animated:YES];
                }
                
            }
                break;
            case 2:
            {
                if (!_tripModel) {
                    [MBProgressHUD showAndHideWithMessage:@"请选择出行方式，专车、快车或者其他!" forHUD:nil];
                    return;
                }
                
                SpecialCarController *special = [[SpecialCarController alloc] init];
                special.startLocation = self.currentLocation;
                special.isNowUseCar = NO;
                special.carTypeModel = _tripModel;
                [self.navigationController pushViewController:special animated:YES];
            }
                break;
            default:
                break;
        }
    }else if([sender isKindOfClass:[VerticalView class]])
    {
        NSInteger tag = ((UIView*)sender).tag;
        _tripModel = _carTypeArray[tag];
        if (tag==0) {
            [_btn_left setTitle:@"现在用车" forState:UIControlStateNormal];
            [_btn_left mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_bottom_container);
                make.left.equalTo(_bottom_container);
                make.height.equalTo(_bottom_container);
                make.width.equalTo(_bottom_container.mas_width).dividedBy(2);
            }];
            
            [_btn_right mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_bottom_container);
                make.left.equalTo(_btn_left.mas_right).offset(1);
                make.height.equalTo(_bottom_container);
                make.width.equalTo(_bottom_container.mas_width).dividedBy(2);
            }];
        }else if (tag==1)
        {
            [_btn_left setTitle:@"下一步" forState:UIControlStateNormal];
            [_btn_left mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_bottom_container);
                make.left.equalTo(_bottom_container);
                make.height.equalTo(_bottom_container);
                make.width.equalTo(_bottom_container.mas_width).multipliedBy(1);
            }];
            /*
             [_btn_right mas_remakeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(_bottom_container);
             make.left.equalTo(_btn_left.mas_right).offset(1);
             make.height.equalTo(_bottom_container);
             make.width.equalTo(_bottom_container.mas_width).multipliedBy(0.5);
             }];*/
        }else if (tag==2)
        {
            [_btn_left setTitle:@"快吧预约" forState:UIControlStateNormal];
            [_btn_left mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_bottom_container);
                make.left.equalTo(_bottom_container);
                make.height.equalTo(_bottom_container);
                make.width.equalTo(_bottom_container.mas_width).multipliedBy(1);
            }];
        }else if (tag==3)
        {
            [_btn_left setTitle:@"带货预约" forState:UIControlStateNormal];
            [_btn_left mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_bottom_container);
                make.left.equalTo(_bottom_container);
                make.height.equalTo(_bottom_container);
                make.width.equalTo(_bottom_container.mas_width).multipliedBy(1);
            }];
        }
    }
    
}

#pragma mark - search
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = NO;
    
    __weak __typeof(&*self) weakSelf = self;
    //@weakify(self);
    [[CMSearchManager sharedInstance] searchForRequest:regeo completionBlock:^(id request, id response, NSError *error) {
        if (error)
        {
            NSLog(@"error :%@", error);
        }
        else
        {
            AMapReGeocodeSearchResponse * regeoResponse = response;
            if (regeoResponse.regeocode != nil)
            {
                if (regeoResponse.regeocode.pois.count > 0)
                {
                    AMapPOI *poi = regeoResponse.regeocode.pois[0];
                    
                    weakSelf.currentLocation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
                    weakSelf.currentLocation.name = poi.name;
                    
                    weakSelf.currentLocation.address = poi.address;
                }
                else
                {
                    weakSelf.currentLocation.coordinate = CLLocationCoordinate2DMake(regeoResponse.regeocode.addressComponent.streetNumber.location.latitude, regeoResponse.regeocode.addressComponent.streetNumber.location.longitude);
                    weakSelf.currentLocation.name = [NSString stringWithFormat:@"%@%@%@%@%@", regeoResponse.regeocode.addressComponent.township, regeoResponse.regeocode.addressComponent.neighborhood, regeoResponse.regeocode.addressComponent.streetNumber.street, regeoResponse.regeocode.addressComponent.streetNumber.number, regeoResponse.regeocode.addressComponent.building];
                    
                    weakSelf.currentLocation.address = regeoResponse.regeocode.formattedAddress;
                }
                
                weakSelf.currentLocation.cityCode = regeoResponse.regeocode.addressComponent.citycode;
                weakSelf.currentLocation.city = regeoResponse.regeocode.addressComponent.city;
                weakSelf.isLocating = NO;
                [GlobalData sharedInstance].city = weakSelf.currentLocation.city;
                //                weakSelf.currentLocation.coordinate = local2D;
                NSLog(@"currentLocation:%@===", weakSelf.currentLocation);

            }
            

        }
    }];
}

#pragma mark - Action

- (void)actionAddEnd:(UIButton *)sender
{
    NSLog(@"actionAddEnd");
    
    if (_currentLocation.cityCode.length == 0)
    {
        NSLog(@"the city have not been located");
        return;
    }
    
    _currentSearchLocation = 1;
    
    /*
     DDSearchViewController *searchController = [[CMSearchViewController alloc] init];
     searchController.delegate = self;
     searchController.city = _currentLocation.cityCode;
     [self.navigationController pushViewController:searchController animated:YES];
     */
}

- (void)actionCancel:(UIButton *)sender
{
    NSLog(@"actionCancel");
    [self setState:CMState_Init];
}

- (void)actionCallTaxi:(UIButton *)sender
{
    NSLog(@"actionCallTaxi");
    if (self.currentLocation && self.destinationLocation)
    {
        
        CMTaxiCallRequest * request = [[CMTaxiCallRequest alloc] initWithStart:self.currentLocation to:self.destinationLocation];
        [_driverManager callTaxiWithRequest:request];
        //        _messageView = [_mapView viewForMessage:@"正在呼叫司机..." title:nil image:nil];
        //        _messageView.center = [_mapView centerPointForPosition:@"center" withToast:_messageView];
        //        [self.mapView addSubview:_messageView];
        
    }
}

- (void)actionLocating:(UIButton *)sender
{
    NSLog(@"actionLocating");
    
    // 只有初始状态下才可以进行定位。
    if (_state != CMState_Init)
    {
        [MBProgressHUD showAndHideWithMessage:@"重新请求需先取消用车" forHUD:nil];
        return;
    }
    
    if (!_isLocating)
    {
        _isLocating = YES;
        
        [self resetMapToCenter:self.mapView.userLocation.location.coordinate];
        [self searchReGeocodeWithCoordinate:self.mapView.userLocation.location.coordinate];
        [self updatingDrivers];
    }
}

#pragma mark - drivers
- (void)updatingDrivers
{
#define latitudinalRangeMeters 1000.0
#define longitudinalRangeMeters 1000.0
    
    MAMapRect rect = MAMapRectForCoordinateRegion(MACoordinateRegionMakeWithDistance(self.mapView.centerCoordinate, latitudinalRangeMeters, longitudinalRangeMeters));
    [_driverManager searchDriver:rect WithCoordinate2D:local2D withCarType:@"1"];
}

#pragma mark - driversManager delegate

- (void)searchDoneInMapRect:(MAMapRect)mapRect withDriversResult:(NSArray *)drivers timestamp:(NSTimeInterval)timestamp
{
    [self.mapView removeAnnotations:_drivers];
    NSMutableArray * currDrivers = [NSMutableArray arrayWithCapacity:[drivers count]];
    [drivers enumerateObjectsUsingBlock:^(DriverInfoModel * obj, NSUInteger idx, BOOL *stop) {
        MAPointAnnotation * driver = [[MAPointAnnotation alloc] init];
        CLLocationDegrees latitude = [obj.latitude floatValue];
        CLLocationDegrees longitude = [obj.longitude floatValue];
        CLLocationCoordinate2D coordinate =CLLocationCoordinate2DMake(latitude,longitude);
        
        driver.coordinate = coordinate;
        driver.title = obj.identifierNo;
        [currDrivers addObject:driver];
    }];
    
    [self.mapView addAnnotations:currDrivers];
    
    _drivers = currDrivers;
    
}

//CMTaxiCallRequest
- (void)callTaxiDoneWithRequest:(CMTaxiCallRequest *)request Taxi:(CMDriver *)driver
{
    
    [self.mapView removeAnnotations:_drivers];
    
    _selectedDriver = [[MAPointAnnotation alloc] init];
    _selectedDriver.coordinate = driver.coordinate;
    _selectedDriver.title = driver.idInfo;
    [self.mapView addAnnotation:_selectedDriver];
    
    //    [self.messageView removeFromSuperview];
    //    [self.mapView makeToast:[NSString stringWithFormat:@"已选择司机%@",driver.idInfo, nil] duration:0.5 position:@"center"];
    
    [self setState:CMState_Call_Taxi];
    
}

- (void)onUpdatingLocations:(NSArray *)locations forDriver:(CMDriver *)driver
{
    if ([locations count] > 0) {
        
        [self.mapView selectAnnotation:_selectedDriver animated:NO];
        _selectedDriver.coordinate = ((CLLocation*) [locations lastObject]).coordinate;
        
        CLLocationCoordinate2D * locs = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * [locations count]);
        [locations enumerateObjectsUsingBlock:^(CLLocation * obj, NSUInteger idx, BOOL *stop) {
            locs[idx] = obj.coordinate;
        }];
        
        MovingAnnotationView * driverView = (MovingAnnotationView *)[self.mapView viewForAnnotation:_selectedDriver];
        
        [driverView addTrackingAnimationForCoordinates:locs count:[locations count] duration:2.0];
        
        free(locs);
    }
}


- (void)actionOnTaxi:(UIButton *)sender
{
    NSLog(@"actionOnTaxi");
    [self setState:CMState_On_Taxi];
}

- (void)actionOnPay:(UIButton *)sender
{
    NSLog(@"actionOnPay");
    [self setState:CMState_Finish_pay];
}

- (void)actionOnEvaluate:(UIButton *)sender
{
    NSLog(@"actionOnEvaluate");
    [self setState:CMState_Init];
}


#pragma mark - Utility

- (void)requestPathInfo
{
    //检索所需费用
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.requireExtension = YES;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude
                                           longitude:_currentLocation.coordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:_destinationLocation.coordinate.latitude
                                                longitude:_destinationLocation.coordinate.longitude];
    
    __weak __typeof(&*self) weakSelf = self;
    [[CMSearchManager sharedInstance] searchForRequest:navi completionBlock:^(id request, id response, NSError *error) {
        
        AMapRouteSearchResponse *naviResponse = response;
        
        if (naviResponse.route == nil)
        {
            [weakSelf.locationView setInfo:@"获取路径失败"];
            return;
        }
        
        AMapPath * path = [naviResponse.route.paths firstObject];
        [weakSelf.locationView setInfo:[NSString stringWithFormat:@"预估费用%.2f元  距离%.1f km  时间%.1f分钟", naviResponse.route.taxiCost, path.distance / 1000.f, path.duration / 60.f, nil]];
    }];
}

- (void)setState:(CMState)state
{
    _state = state;
    
    switch (state)
    {
        case CMState_Init:
            [self reset];
            
            [_buttonAction setTitle:@"选择终点" forState:UIControlStateNormal];
            [_buttonAction removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [_buttonAction addTarget:self action:@selector(actionAddEnd:) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        case CMState_Confirm_Destination:
            [self requestPathInfo];
            
            [_buttonAction setTitle:@"马上叫车" forState:UIControlStateNormal];
            [_buttonAction removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [_buttonAction addTarget:self action:@selector(actionCallTaxi:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        case CMState_Call_Taxi:
            [_buttonAction setTitle:@"我已上车" forState:UIControlStateNormal];
            [_buttonAction removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            
            [_buttonAction addTarget:self action:@selector(actionOnTaxi:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        case CMState_On_Taxi:
            [_buttonAction setTitle:@"支付" forState:UIControlStateNormal];
            [_buttonAction removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            
            [_buttonAction addTarget:self action:@selector(actionOnPay:) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        case CMState_Finish_pay:
            [_buttonAction setTitle:@"评价" forState:UIControlStateNormal];
            [_buttonAction removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            
            [_buttonAction addTarget:self action:@selector(actionOnEvaluate:) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        default:
            break;
    }
    
    // 设置locationView是否响应交互。
    /*_locationView.userInteractionEnabled = state < CMState_Call_Taxi;*/
    _buttonCancel.hidden = state == CMState_Init;
}

- (void)reset
{
    [self.mapView removeAnnotations:_drivers];
    [self.mapView removeAnnotation:_selectedDriver];
    
    _needsFirstLocating = YES;
    _destinationLocation = nil;
    _locationView.endLocation = nil;
    _locationView.info = nil;
}

/*
 - (void)resetMapToCenter:(CLLocationCoordinate2D)coordinate
 {
 self.mapView.centerCoordinate = coordinate;
 self.mapView.zoomLevel = 15.1;
 
 // 使得userLocationView在最前。
 [self.mapView selectAnnotation:self.mapView.userLocation animated:YES];
 }
 */

#pragma mark - DDLocationViewDelegate

- (void)didClickStartLocation:(CMLocationView *)locationView
{
    _currentSearchLocation = 0;
    /*
     CMSearchViewController *searchController = [[CMSearchViewController alloc] init];
     searchController.delegate = self;
     searchController.text = locationView.startLocation.name;
     searchController.city = locationView.startLocation.cityCode;
     
     [self.navigationController pushViewController:searchController animated:YES];
     */
}

- (void)didClickEndLocation:(CMLocationView *)locationView
{
    _currentSearchLocation = 1;
    /*
     DDSearchViewController *searchController = [[DDSearchViewController alloc] init];
     searchController.delegate = self;
     searchController.text = locationView.endLocation.name;
     searchController.city = locationView.endLocation.cityCode;
     [self.navigationController pushViewController:searchController animated:YES];
     */
}

- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction
{
    //NSLog(@"mapWillMoveByUser%f %f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
    
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction
{
    NSLog(@"mapDidMoveByUser%f %f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
    CLLocationCoordinate2D local =mapView.centerCoordinate;
    if (wasUserAction)
    {
        if (!_centerAnnotion)
        {
            _centerAnnotion =[[MAPointAnnotation alloc] init];
        }
        _centerAnnotion.coordinate = local;
        _centerAnnotion.title =@"选择上车位置";
        centerAnnotationView.annotation = _centerAnnotion;
        
        CMLocation *loca = [[CMLocation alloc] init];
        self.currentLocation = loca;
        [self searchReGeocodeWithCoordinate:local];
        local2D = local;
        [self updatingDrivers];
    }
}

- (void) mapViewDidFinishLoadingMap:(MAMapView *)mapView
{
    
    
}

- (void) mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState fromOldState:(MAAnnotationViewDragState)oldState
{
    NSLog(@"didChangeDragStatedidChangeDragState");
}

- (void) mapView:(MAMapView *)mapView didAddOverlayRenderers:(NSArray *)overlayRenderers
{
    
}

- (void) initData
{
//    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
//    }else{
//        [_dataArray removeAllObjects];
//    }
   
    page = 1;
    [CarOrderModel fetchCarPoolingOrderList:page Succes:^(NSArray *result, int pageCount, int recordCount) {
        _dataArray = [NSMutableArray array];

        for (NSDictionary *dict in result) {
                CarOrderModel *model = [[CarOrderModel alloc] initWithDictionary:dict error:nil];
                [_dataArray addObject:model];
        }
        if (_dataArray.count>0) {
//            [_tipView setHidden:YES];
            [_mTableView setHidden:NO];
            [_middle_container setHidden:YES];
            [_bottom_container setHidden:YES];
        }else{
            [_mTableView setHidden:YES];
            [_middle_container setHidden:NO];
//            [_tipView setHidden:NO];
            [_bottom_container setHidden:NO];

        }
        [_mTableView.mj_header endRefreshing];
        [_mTableView reloadData];
    } failed:^(NSInteger errorCode, NSString *errorMessage) {
        NSLog(@"errorMessage:%@",errorMessage);
        [_mTableView.mj_header endRefreshing];
    }];
}

- (void) initMoreData
{
    page++;
    [CarOrderModel fetchCarPoolingOrderList:page Succes:^(NSArray *result, int pageCount, int recordCount) {
        for (NSDictionary *dict in result) {
            CarOrderModel *model = [[CarOrderModel alloc] initWithDictionary:dict error:nil];
            [_dataArray addObject:model];
        }
        if (_dataArray.count>0) {
            [_tipView setHidden:YES];
            _bottom_container.hidden = YES;
        }else{
            [_tipView setHidden:NO];
            _bottom_container.hidden = NO;
        }
        [_mTableView.mj_footer endRefreshing];
        [_mTableView reloadData];
    } failed:^(NSInteger errorCode, NSString *errorMessage) {
        NSLog(@"errorMessage:%@",errorMessage);
        [_mTableView.mj_footer endRefreshing];
    }];
}

#pragma mark -  UITableViewDataSource
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
    static NSString* cellid=@"cellid";
    CarPoolingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell =[[CarPoolingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    BaseModel *model;
    if (_dataArray.count>0) {
        model = _dataArray[indexPath.section];
    }
    [cell setModel:model];
    [cell setDelegate:self];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseModel *model;
    model = _dataArray[indexPath.section];
    [self cellTarget:model];
}

#pragma mark - cellDelegate
- (void) cellTarget:(CarOrderModel*)sender
{
    if ([@"6" isEqualToString:sender.state]) {
        PayOrderController *order = [[PayOrderController alloc] init];
        order.orderId = sender.ids;
        [self.navigationController pushViewController:order animated:YES];
    }else{
        WaitingCarPoolingCtrl *waiting = [[WaitingCarPoolingCtrl alloc] init];
        waiting.model = sender;
        [self.navigationController pushViewController:waiting animated:YES];
    }
}


- (void) reloadTableView
{
    [self.mTableView.mj_header beginRefreshing];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) reloadData
{
    [self initData];
}

- (void) initBottomView
{
    _bottom_container =[[UIView alloc] init];
    _btn_left = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn_right = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_btn_left setImage:[UIImage imageNamed:@"pinchebai"] forState:UIControlStateNormal];
    _btn_left.layer.cornerRadius = 15;
    [_btn_left setTitle:@"现在用车" forState:UIControlStateNormal];
    [_btn_left setTitleColor:RGBHex(g_white) forState:UIControlStateNormal];
    [_btn_left.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_btn_left setBackgroundColor:RGBHex(g_blue)];
    [_btn_left setTag:1];
    [_btn_left addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btn_right setImage:[UIImage imageNamed:@"yuyuebai1"] forState:UIControlStateNormal];
    [_btn_right setTitle:@"预约用车" forState:UIControlStateNormal];
    [_btn_right setTitleColor:RGBHex(g_white) forState:UIControlStateNormal];
    [_btn_right.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_btn_right setBackgroundColor:RGBHex(g_blue)];
    
    [_btn_right setTag:2];
    [_btn_right addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    UIView *grayline = [[UIView alloc] init];
    [grayline setBackgroundColor:RGBHex(g_assit_gray)];
    [_bottom_container setBackgroundColor:RGBHex(g_gray)];
    [_bottom_container addSubview:grayline];
    [_bottom_container addSubview:_btn_left];
    [_bottom_container addSubview:_btn_right];
    
    [grayline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottom_container);
        make.left.equalTo(_bottom_container);
        make.right.equalTo(_bottom_container);
        make.height.mas_equalTo(0);
    }];
    
    [_btn_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(grayline.mas_bottom);
        make.left.equalTo(_bottom_container);
        make.height.equalTo(_bottom_container);
        make.width.equalTo(_bottom_container.mas_width).dividedBy(2);
    }];
    
//    [_btn_right mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(grayline.mas_bottom);
//        make.left.equalTo(_btn_left.mas_right).offset(1);
//        make.height.equalTo(_bottom_container);
//        make.width.equalTo(_bottom_container.mas_width).dividedBy(2);
//    }];
    [_btn_left setTitle:@"下一步" forState:UIControlStateNormal];
    [_btn_left mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(grayline.mas_bottom);
        make.left.equalTo(_bottom_container);
        make.right.equalTo(_bottom_container);
        make.bottom.equalTo(_bottom_container);
    }];
    
    [self.view addSubview:_bottom_container];

}

- (void) initTableView
{
    _mTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    [_mTableView setHidden:YES];
    _mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    [_mTableView.mj_header beginRefreshing];
    
    _mTableView.mj_footer =[MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self initMoreData];
    }];
    
    [self.view addSubview:_mTableView];
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.bottom_container.mas_top);
    }];
    
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.separatorColor = [UIColor clearColor];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.separatorColor = [UIColor clearColor];
    self.mTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


- (void) initTableCenterView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"https://work.huwochuxing.com/getArticle?id=112"] placeholderImage:[UIImage imageNamed:@"beijing"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_offset(0.45*SCREENWIDTH);
    }];
    
    UIView *verticalLine1 = [[UIView alloc]init];
    verticalLine1.backgroundColor = RGBHex(@"C8CACB");
    [self.view addSubview:verticalLine1];
    [verticalLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(100);
        make.left.equalTo(self.view).offset(50);
        make.width.offset(1);
        make.height.offset(25);
    }];
    UILabel *time = [[UILabel alloc]init];
    time.text = @"时间";
    time.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:time];
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(verticalLine1);
        make.bottom.equalTo(verticalLine1.mas_top).offset(-5);
    }];
    UILabel *sDian = [[UILabel alloc]init];
    sDian.text = @"上车点";
    sDian.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:sDian];
    [sDian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(verticalLine1);
        make.top.equalTo(verticalLine1.mas_bottom).offset(5);
    }];
    UIView *verticalLine2 = [[UIView alloc]init];
    verticalLine2.backgroundColor = RGBHex(@"C8CACB");
    [self.view addSubview:verticalLine2];
    [verticalLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sDian.mas_bottom).offset(5);
        make.centerX.equalTo(verticalLine1);
        make.width.offset(1);
        make.height.offset(25);
    }];
    UILabel *eDian = [[UILabel alloc]init];
    eDian.text = @"下车点";
    eDian.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:eDian];
    [eDian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(verticalLine1);
        make.top.equalTo(verticalLine2.mas_bottom).offset(5);
    }];
    UIImageView *shijian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"time"]];
    [self.view addSubview:shijian];
    [shijian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(time);
        make.right.equalTo(self.view).offset(-40);
    }];
    UIImageView *dingwei = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dingwei3"]];
    [self.view addSubview:dingwei];
    [dingwei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sDian);
        make.right.equalTo(self.view).offset(-40);
    }];
    UIImageView *jia = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jia"]];
    [self.view addSubview:jia];
    [jia mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(eDian);
        make.right.equalTo(self.view.mas_right).offset(-40);
    }];
    
    _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_timeButton setTitleColor:RGBHex(@"#707070") forState:UIControlStateNormal];
    [_timeButton setTitle:@"选择时间" forState:UIControlStateNormal];
    [_timeButton addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_timeButton];
    [_timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(time);
        make.left.equalTo(verticalLine1).offset(30);
    }];
    
    _startHeadLabel = [[UILabel alloc]init];
    _startHeadLabel.font = [UIFont systemFontOfSize:14];
    _startHeadLabel.textColor = RGBHex(@"#707070");
    _startHeadLabel.text = @"选择上车地点";
    [self.view addSubview:_startHeadLabel];
    [_startHeadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sDian);
        make.left.equalTo(verticalLine1).offset(30);
    }];
    _startDisLabel = [[UILabel alloc]init];
    _startDisLabel.font = [UIFont systemFontOfSize:14];
    _startDisLabel.textColor = RGBHex(@"#707070");
    _startDisLabel.text = @"上车距离";
    [self.view addSubview:_startDisLabel];
    [_startDisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sDian);
        make.left.equalTo(_startHeadLabel.mas_right).offset(0);
    }];
    _startDisLabel.hidden = YES;
    
    _endHeadLabel = [[UILabel alloc]init];
    _endHeadLabel.font = [UIFont systemFontOfSize:14];
    _endHeadLabel.textColor = [UIColor blackColor];
    _endHeadLabel.textColor = RGBHex(@"#707070");
    _endHeadLabel.text = @"选择下车地点";
    [self.view addSubview:_endHeadLabel];
    [_endHeadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(eDian);
        make.left.equalTo(verticalLine2).offset(30);
    }];
    
    lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGBHex(@"C8CACB");
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_endHeadLabel).offset(20);
        make.left.equalTo(_endHeadLabel.mas_left);
        make.right.equalTo(jia.mas_left);
        make.height.mas_offset(1);
    }];
    
    UIView *lanLineView = [[UIView alloc]init];
    lanLineView.backgroundColor = RGBHex(@"C8CACB");
    [self.view addSubview:lanLineView];
    [lanLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_startHeadLabel).offset(20);
        make.left.equalTo(_startHeadLabel.mas_left);
        make.right.equalTo(jia.mas_left);
        make.height.mas_offset(1);
    }];
    
    UIView *timeLineView = [[UIView alloc]init];
    timeLineView.backgroundColor = RGBHex(@"C8CACB");
    [self.view addSubview:timeLineView];
    [timeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeButton).offset(20);
        make.left.equalTo(_timeButton.mas_left);
        make.right.equalTo(jia.mas_left);
        make.height.mas_offset(1);
    }];
    
    _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_startButton addTarget:self action:@selector(addressChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startButton];
    [_startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sDian);
        make.left.equalTo(sDian.mas_left).offset(20);
        make.right.equalTo(dingwei);
        make.height.mas_offset(30);
    }];
    
    _endButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_endButton addTarget:self action:@selector(addressChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_endButton];
    [_endButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(eDian);
        make.left.equalTo(eDian.mas_left).offset(20);
        make.right.equalTo(jia);
        make.height.mas_offset(30);
    }];
    
    _currentLocation = [GlobalData sharedInstance].location;

    if (_currentLocation) {
        _startlocation = _currentLocation;
    }

    UIButton *zhuanhuan = [UIButton buttonWithType:UIButtonTypeCustom];
    [zhuanhuan setBackgroundImage:[UIImage imageNamed:@"zhuanhuan"] forState:UIControlStateNormal];
    [zhuanhuan addTarget:self action:@selector(zhuanhuanClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhuanhuan];
    [zhuanhuan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(imageView.mas_bottom).offset(20);
        make.width.offset(21);
        make.height.offset(21);
    }];
    
    UIView *lineView1 = [[UIView alloc]init];
    [lineView1 setBackgroundColor:RGBHex(g_blue)];
    [self.view addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(50);
        make.height.offset(1);
        make.left.equalTo(time).offset(5);
        make.right.equalTo(zhuanhuan.mas_left).offset(-10);
    }];
    UIView *lineView2 = [[UIView alloc]init];
    [lineView2 setBackgroundColor:RGBHex(g_blue)];
    [self.view addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(50);
        make.height.offset(1);
        make.left.equalTo(zhuanhuan.mas_right).offset(10);
        make.right.equalTo(dingwei).offset(-5);
    }];
    
    _startLineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_startLineButton setTitle:@"选择出发地" forState:UIControlStateNormal];
    [_startLineButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_startLineButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_startLineButton addTarget:self action:@selector(chooseLineClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startLineButton];
    [_startLineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom);
        make.bottom.equalTo(lineView1.mas_bottom);
        make.left.equalTo(lineView1.mas_left);
        make.right.equalTo(lineView1.mas_right);
    }];
    
    _endLineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_endLineButton setTitle:@"选择目的地" forState:UIControlStateNormal];
    [_endLineButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_endLineButton addTarget:self action:@selector(chooseLineClick:) forControlEvents:UIControlEventTouchUpInside];
    [_endLineButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:_endLineButton];
    [_endLineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom);
        make.bottom.equalTo(lineView2.mas_bottom);
        make.left.equalTo(lineView2.mas_left);
        make.right.equalTo(lineView2.mas_right);
    }];
    
    
    
    [self initLocationConfig];
}
-(void)chooseLineClick:(UIButton *)sender{
    if (sender == _startLineButton) {
        chooseLineViewController *chooseLineVC = [[chooseLineViewController alloc]initWithNibName:@"chooseLineViewController" bundle:nil];
        NSLog(@"_startLineButton");
        [chooseLineVC setStartOrEnd:@"start"];
        chooseLineVC.delegate = self;
        [self.navigationController pushViewController:chooseLineVC animated:YES];
    }else if(sender == _endLineButton){
        if ([_startLineButton.titleLabel.text isEqualToString:@"选择出发地"]) {
            [MBProgressHUD showAndHideWithMessage:@"请选择出发地!" forHUD:nil];
        }else{
            chooseEndLineViewController *endLineVC = [[chooseEndLineViewController alloc]initWithNibName:@"chooseEndLineViewController" bundle:nil];
            NSLog(@"_endLineButton");
            [endLineVC setStartLine:_startLineButton.titleLabel.text];
            [self.navigationController pushViewController:endLineVC animated:YES];
        }
    }


}
-(void)zhuanhuanClick:(id)sender{
    NSString *tempStr = _startLineButton.titleLabel.text;
    NSString *lineStr = _startHeadLabel.text;
    CMLocation *tempLocation = _startlocation;
    
    if ([_startLineButton.titleLabel.text isEqualToString:@"选择出发地"]) {
        [_startLineButton setTitle:_endLineButton.titleLabel.text forState:UIControlStateNormal];
        [_endLineButton setTitle:@"选择目的地" forState:UIControlStateNormal];
        
    }else if ([_endLineButton.titleLabel.text isEqualToString:@"选择目的地"]) {
        [_startLineButton setTitle:@"选择出发地" forState:UIControlStateNormal];
        [_endLineButton setTitle:tempStr forState:UIControlStateNormal];
    }else if([_startHeadLabel.text isEqualToString:@"选择上车地点"] || [_endHeadLabel.text isEqualToString:@"选择下车地点"]){
        
    }else{
        [_startLineButton setTitle:_endLineButton.titleLabel.text forState:UIControlStateNormal];
        [_endLineButton setTitle:tempStr forState:UIControlStateNormal];
        NSDictionary *tempDic = [[NSDictionary alloc]init];
        tempDic = _startDatasDic;
        _startDatasDic = _endDatasDic;
        _endDatasDic = tempDic;
        _startDisLabel.text = [NSString stringWithFormat:@"(距离当前位置%.1f公里)",[[_startDatasDic objectForKey:@"distance"] floatValue]/1000];
        _startDisLabel.hidden = NO;
        
        _startHeadLabel.text = _endHeadLabel.text;
        _endHeadLabel.text = lineStr;
        _startlocation = _offLocation;
        _offLocation = tempLocation;
        isBool = !isBool;
        if (isBool) {
            sendAllDatas = getEndDatas;
        }else{
            sendAllDatas = getStartDatas;
        }
        
    }
    
    
}
//返回    代理
- (void)sendLine:(NSString *)start end:(NSString *)end{
    if (start.length >0) {
        [_startLineButton setTitle:start forState:UIControlStateNormal];
        _startHeadLabel.text =@"选择上车地点";
        _endHeadLabel.text = @"选择下车地点";
    }
    if (end.length > 0) {
        [_endLineButton setTitle:end forState:UIControlStateNormal];
    }
    
}

-(void)addressChooseButton:(id)sender{
//    SearchAddressController *search = [[SearchAddressController alloc] init];
//    search.delegateCallback = self;
//    if (_startButton == sender) {
//        search.targetId = 2;
//    }else{
//        search.targetId = 6;
//    }
//    [self.navigationController pushViewController:search animated:YES];
    if ([_startLineButton.titleLabel.text isEqualToString:@"选择出发地"]) {
        [MBProgressHUD showAndHideWithMessage:@"请选择出发地!" forHUD:nil];
        return;
    }
    if ([_endLineButton.titleLabel.text isEqualToString:@"选择目的地"]) {
        [MBProgressHUD showAndHideWithMessage:@"请选择目的地!" forHUD:nil];
        return;
    }
    

    if (_startButton == sender) {
        [self checkLine:_startLineButton.titleLabel.text endLine:_endLineButton.titleLabel.text];
    }else{
        [self theCheckLine:_startLineButton.titleLabel.text endLine:_endLineButton.titleLabel.text];
    }
    
}
#pragma mark 上车点列表
-(void)checkLine:(NSString *)startLine endLine:(NSString *)endLine{
    MBProgressHUD *hud = [MBProgressHUD showProgressView:@"加载中..." inView:nil];
    [hud show:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%@-%@",startLine,endLine] forKey:@"name"];
    
    [HttpShareEngine callWithFormParams:params withMethod:@"listLine" succ:^(NSDictionary *resultDictionary) {
        NSLog(@"%@",resultDictionary);
        NSArray *tempArray = [resultDictionary objectForKey:@"rows"];
        
        if (tempArray.count != 0) {
            NSMutableArray *allDatas = tempArray[0];
            NSString *str = [tempArray[0] objectForKey:@"points"];
            str = [str substringToIndex:[str length]-1];
            NSArray *array = [self getArray:str symbol:@";"]; //从字符A中分隔成2个元素的数组
            
            NSMutableArray *nameArray = [[NSMutableArray alloc]init];
            NSMutableArray *latArray = [[NSMutableArray alloc]init];
            NSMutableArray *lonArray = [[NSMutableArray alloc]init];
            NSMutableArray *tempMutableArray = [[NSMutableArray alloc]init];
            for (int i = 0; i<array.count; i++) {
                [nameArray addObject:[self getArray:array[i] symbol:@":"][0]];
                [tempMutableArray addObject:[self getArray:array[i] symbol:@":"][1]];
            }
            for (int i = 0; i<tempMutableArray.count; i++) {
                [lonArray addObject:[self getArray:tempMutableArray[i] symbol:@","][0]];
                [latArray addObject:[self getArray:tempMutableArray[i] symbol:@","][1]];
            }
            
            NSMutableArray *distanceArray = [[NSMutableArray alloc]init];
            for (int i = 0; i<latArray.count; i++) {
                MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([latArray[i] doubleValue],[lonArray[i] doubleValue]));
                MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([GlobalData sharedInstance].coordinate.latitude,[GlobalData sharedInstance].coordinate.longitude));
                CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
                //                    CGFloat dis = distance;
                [distanceArray addObject:[NSString stringWithFormat:@"%f",distance]];
            }
            NSComparator cmptr = ^(id obj1, id obj2){
                if ([obj1 floatValue] > [obj2 floatValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                if ([obj1 floatValue] < [obj2 floatValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            };

            NSArray *tempDis = [distanceArray sortedArrayUsingComparator:cmptr];
            NSMutableArray *tempName = [[NSMutableArray alloc]init];
            NSMutableArray *tempLat = [[NSMutableArray alloc]init];
            NSMutableArray *tempLon = [[NSMutableArray alloc]init];


            for (int i = 0; i<tempDis.count; i++) {
                for (int n = 0; n<distanceArray.count; n++) {
                    if ([tempDis[i]isEqualToString:distanceArray[n]]) {
                        [tempName addObject:nameArray[n]];
                        [tempLat addObject:latArray[n]];
                        [tempLon addObject:lonArray[n]];
                    }
                }
            }
            
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:tempDis,@"distanceArray",tempName,@"nameArray",tempLat,@"latArray",tempLon,@"lonArray",allDatas,@"allDatas",startLine,@"startShortLine",nil];
            NSLog(@"%@",dic);
            chooseAddressViewController *chooseAdd = [[chooseAddressViewController alloc]initWithNibName:@"chooseAddressViewController" bundle:nil];
            chooseAdd.delegate = self;
            [chooseAdd setAddressDic:dic];
            [self.navigationController pushViewController:chooseAdd animated:YES];

            
            [hud hide:YES];
            
        }else{
            [MBProgressHUD showAndHideWithMessage:@"暂时未开通！" forHUD:nil];
            [hud hide:YES];
            
        }
        
        
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
        [hud hide:YES];
        
    }];
}

#pragma mark 下车点列表
-(void)theCheckLine:(NSString *)startLine endLine:(NSString *)endLine{
    MBProgressHUD *hud = [MBProgressHUD showProgressView:@"加载中..." inView:nil];
    [hud show:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%@-%@",endLine,startLine] forKey:@"name"];
    
    [HttpShareEngine callWithFormParams:params withMethod:@"listLine" succ:^(NSDictionary *resultDictionary) {
        NSLog(@"%@",resultDictionary);
        NSArray *tempArray = [resultDictionary objectForKey:@"rows"];
        
        if (tempArray.count != 0) {
            NSMutableArray *allDatas = tempArray[0];
            NSString *str = [tempArray[0] objectForKey:@"points"];
            str = [str substringToIndex:[str length]-1];
            NSArray *array = [self getArray:str symbol:@";"]; //从字符A中分隔成2个元素的数组
            
            NSMutableArray *nameArray = [[NSMutableArray alloc]init];
            NSMutableArray *latArray = [[NSMutableArray alloc]init];
            NSMutableArray *lonArray = [[NSMutableArray alloc]init];
            NSMutableArray *tempMutableArray = [[NSMutableArray alloc]init];
            for (int i = 0; i<array.count; i++) {
                [nameArray addObject:[self getArray:array[i] symbol:@":"][0]];
                [tempMutableArray addObject:[self getArray:array[i] symbol:@":"][1]];
            }
            for (int i = 0; i<tempMutableArray.count; i++) {
                [lonArray addObject:[self getArray:tempMutableArray[i] symbol:@","][0]];
                [latArray addObject:[self getArray:tempMutableArray[i] symbol:@","][1]];
            }
            NSMutableArray *distanceArray = [[NSMutableArray alloc]init];
            for (int i = 0; i<latArray.count; i++) {
                MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([latArray[i] doubleValue],[lonArray[i] doubleValue]));
                MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([GlobalData sharedInstance].coordinate.latitude,[GlobalData sharedInstance].coordinate.longitude));
                CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
                //                    CGFloat dis = distance;
                [distanceArray addObject:[NSString stringWithFormat:@"%f",distance]];
            }
            NSLog(@"%@",distanceArray);
            NSLog(@"%@",nameArray);
            NSLog(@"%@",latArray);
            
            NSComparator cmptr = ^(id obj1, id obj2){
                if ([obj1 floatValue] > [obj2 floatValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                if ([obj1 floatValue] < [obj2 floatValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            };
            NSArray *tempDis = [distanceArray sortedArrayUsingComparator:cmptr];
            NSMutableArray *tempName = [[NSMutableArray alloc]init];
            NSMutableArray *tempLat = [[NSMutableArray alloc]init];
            NSMutableArray *tempLon = [[NSMutableArray alloc]init];
            
            for (int i = 0; i<tempDis.count; i++) {
                for (int n = 0; n<distanceArray.count; n++) {
                    if ([tempDis[i]isEqualToString:distanceArray[n]]) {
                        [tempName addObject:nameArray[n]];
                        [tempLat addObject:latArray[n]];
                        [tempLon addObject:lonArray[n]];
                    }
                }
            }
            
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:tempDis,@"distanceArray",tempName,@"nameArray",tempLat,@"latArray",tempLon,@"lonArray",allDatas,@"allDatas",endLine,@"endShortName",nil];
            chooseEndAddressViewController *endAdd= [[chooseEndAddressViewController alloc]initWithNibName:@"chooseEndAddressViewController" bundle:nil];
            [endAdd setAddressDic:dic];
            [self.navigationController pushViewController:endAdd animated:YES];
            [hud hide:YES];
            
        }else{
            [MBProgressHUD showAndHideWithMessage:@"暂时未开通！" forHUD:nil];
            [hud hide:YES];
            
        }
        
        
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
        [hud hide:YES];
        
    }];
}
-(NSArray *)getArray:(NSString *)str symbol:(NSString *)symbol{
    NSArray *array = [str componentsSeparatedByString:symbol]; //从字符A中分隔成2个元素的数组
    return array;
}
-(NSString*)nextString:(NSString *)str{
    NSRange range = [str rangeOfString:@"-"];//匹配得到的下标
    return [str substringToIndex:range.location];
}
-(void)sendDatas:(NSString *)name lat:(NSString *)lat lon:(NSString *)lon where:(NSString *)where startDatas:(NSDictionary *)startDatas endDatas:(NSDictionary *)endDatas{
    if ([where isEqualToString:@"0"]) {
        _startHeadLabel.text = name;

        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([lon floatValue],[lat floatValue] );
        _startlocation = [[CMLocation alloc]init];
        _startlocation.coordinate = coordinate;
        _startlocation.name = name;
    }else{
        _endHeadLabel.text = name;

        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([lon floatValue],[lat floatValue] );
        _offLocation = [[CMLocation alloc]init];
        _offLocation.coordinate = coordinate;
        _offLocation.name = name;
    }
    if (startDatas) {
        getStartDatas = startDatas;
    }
    if (endDatas) {
        getEndDatas = endDatas;
    }
    sendAllDatas = getStartDatas;
    
//}else if (loction.targetIndex==6) {
//    _endHeadLabel.text = loction.name;
//    _endContentLabel.text = loction.address;
//    _endDefaultLabel.text = @"";
//    _offLocation = loction;
//}
}

- (void) amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    [super amapLocationManager:manager didUpdateLocation:location];
        [[CMSearchManager sharedInstance] searchLocation:location completionBlock:^(id request,
                                                                                    CMLocation *clocation,
                                                                                    NSError *error)
         {
             NSLog(@"clocation:%@",clocation);
             [self getStartCity:clocation.city district:clocation.district];
             [self stopLocation];
         }];
}
-(void)getStartCity:(NSString *)city district:(NSString *)district{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(1) forKey:@"page"];
    [params setObject:@"1" forKey:@"pageSize"];
    [params setObject:district forKey:@"name"];

    [HttpShareEngine callWithFormParams:params withMethod:@"listLine" succ:^(NSDictionary *resultDictionary) {
        NSLog(@"%@",resultDictionary);
        NSArray *resultArray = [resultDictionary objectForKey:@"rows"];
        if (resultArray.count>0) {
            [GlobalData sharedInstance].city = district;
            [_startLineButton setTitle:district forState:UIControlStateNormal];
        }else{
            [self getStartCity:city district:city];
        }
        
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
    }];
}

- (void) amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error) {
        NSLog(@"error:%@",error);
        [MBProgressHUD showAndHideWithMessage:@"无法获取定位信息！请手动选择!" forHUD:nil onCompletion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    [super amapLocationManager:manager didFailWithError:error];
}
-(void)getEndAddress:(NSNotification *)aNSNotification{
    NSMutableDictionary *dic = [aNSNotification object];
    _endDatasDic = dic;
    NSLog(@"%@",dic);
    [_endLineButton setTitle:[dic objectForKey:@"endShortName"] forState:UIControlStateNormal];
    _endHeadLabel.text = @"输入目的地";

    
    _endHeadLabel.text = [dic objectForKey:@"name"];

    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[dic objectForKey:@"lat"] floatValue],[[dic objectForKey:@"lon"] floatValue] );
    _offLocation = [[CMLocation alloc]init];
    _offLocation.coordinate = coordinate;
    _offLocation.name = [dic objectForKey:@"name"];
    getEndDatas = [dic objectForKey:@"allDatas"];

}
-(void)getStartAddress:(NSNotification *)aNSNotification{
    NSMutableDictionary *dic = [aNSNotification object];
    _startDatasDic = dic;
    NSLog(@"%@",dic);
    _startHeadLabel.text = [dic objectForKey:@"name"];
    _startDisLabel.text = [NSString stringWithFormat:@"(距离当前位置%.1f公里)",[[dic objectForKey:@"distance"] floatValue]/1000];
    _startDisLabel.hidden = NO;

    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[dic objectForKey:@"lat"] floatValue],[[dic objectForKey:@"lon"] floatValue] );
    _startlocation = [[CMLocation alloc]init];
    _startlocation.coordinate = coordinate;
    _startlocation.name = [dic objectForKey:@"name"];
    getStartDatas = [dic objectForKey:@"allDatas"];
    sendAllDatas = getStartDatas;


}
-(void)selectTime:(UIButton *)sender{
    //选择时间
    [MyTimePickerView showTimePickerViewDeadLine:@"20160601" withTitle:@"请选择出发时间" CompleteBlock:^(NSDictionary *infoDic) {
        
        _startTime = infoDic[@"time_value"];
        NSString *time_fromat = [MyTimeTool formatDateTime:_startTime withFormat:nil];
        //[_tripView setTime:time_fromat];
        [_timeButton setTitle:time_fromat forState:UIControlStateNormal];
        NSLog(@"infoDic:%@",infoDic);
    }];

}
-(NSArray *)genShowDayArrayByDayArray:(NSArray *)dayArray{
    int arrayCount = dayArray.count;
    if(arrayCount == 1) return ONEDAYARRAY;
    if(arrayCount == 2) return TWODAYARRAY;
    if(arrayCount == 3) return THREEDAYARRAY;
    NSMutableArray *showDayArray = [NSMutableArray arrayWithArray:THREEDAYARRAY];
    NSArray *tmpArray = [dayArray subarrayWithRange:NSMakeRange(3, arrayCount - 3)];
    for (int i = 0; i< tmpArray.count; i++) {
        [showDayArray addObject:[MyTimeTool displayedSummaryTimeUsingString:tmpArray[i]]];
    }
    return showDayArray;
}

-(NSArray *)validHourArray{
    int startIndex = [MyTimeTool currentDateHour];
    if ([MyTimeTool currentDateMinute] >= 40) startIndex++;
    if (startIndex>=HOURARRAY.count) {
        startIndex = 0;
    }
    return [HOURARRAY subarrayWithRange:NSMakeRange(startIndex, HOURARRAY.count - startIndex)];
}

-(NSArray *)validMinuteArray{
    int startIndex = [MyTimeTool currentDateMinute] / 10 +2;
    if ([MyTimeTool currentDateMinute] >= 40) startIndex = 1;
    return [MINUTEARRAY subarrayWithRange:NSMakeRange(startIndex, MINUTEARRAY.count - startIndex)];
}
-(NSArray *)formatOriArray:(NSArray *)oriArray{
    NSMutableArray *newArray = [NSMutableArray array];
    for (NSString *hourStr in oriArray) {
        NSString *tmpStr = [self removeLastChareacter:hourStr];
        [newArray addObject: [self append0IfNeed:tmpStr]];
    }
    return newArray;
}
-(NSString *)removeLastChareacter:(NSString *)oriString{
    return [oriString substringToIndex:oriString.length -1];
}

-(NSString *)append0IfNeed:(NSString *)oriString{
    if(oriString.length <2) return [NSString stringWithFormat:@"0%@", oriString];
    return oriString;
}
//- (void) callback:(id)sender
//{
//    _routeModel = (AppiontRouteModel*)sender;
//    CMLocation *loction =  (CMLocation*)sender;
//    if (loction.targetIndex==2) {
//        _startHeadLabel.text = loction.name;
//        _startContentLabel.text = loction.address;
//        _startDefaultLabel.text = @"";
//        _startlocation = loction;
//    }else if (loction.targetIndex==6) {
//        _endHeadLabel.text = loction.name;
//        _endContentLabel.text = loction.address;
//        _endDefaultLabel.text = @"";
//        _offLocation = loction;
//    }
//}


- (void) gesture:(UITapGestureRecognizer*)g
{
    AppiontmentController *special = [[AppiontmentController alloc] init];
    special.startLocation = self.currentLocation;
    special.isNowUseCar = YES;
    special.tripTypeModel = _tripModel;
    [self.navigationController pushViewController:special animated:YES];
}
@end
