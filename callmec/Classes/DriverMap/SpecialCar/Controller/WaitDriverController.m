//
//  ViewController.m
//  callmec
//
//  Created by sam on 16/6/21.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "WaitDriverController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "MANaviRoute.h"

#import "CMDriver.h"
//#import "CMSearchViewController.h"
#import "CMSearchManager.h"
#import "CMDriverManager.h"
#import "CMLocationView.h"
#import "CMTaxiCallRequest.h"

#import "MovingAnnotationView.h"
#import "RegisterController.h"
#import "UserCenterController.h"
#import "SpecialCarController.h"
#import "PayOrderController.h"

#import "PopView.h"
#import "ItemView.h"
#import "DriverNoticeView.h"
#import "DriverOrderView.h"
#import "VerticalView.h"
#import "CancelView.h"

#import "PayModel.h"
#import "TripTypeModel.h"
#import "CarOrderModel.h"

#import <MAMapKit/MAPolyline.h>
#define kSetingViewHeight 215

static BOOL WaitDriverController_HASVISIABLE = NO;

@interface WaitDriverController() <TargetActionDelegate,MAMapViewDelegate,CMDriverManagerDelegate, CMLocationViewDelegate>
@property (nonatomic,assign) BOOL isCurrentLocal;
@property (nonatomic,strong) UIButton *buttonLocating;
@property (nonatomic, assign) BOOL isLocating;
@property (nonatomic,strong) UIView *top_container;     //等待司机接单界面
@property (nonatomic,strong) DriverNoticeView *notice_container;   //司机订单界面
@property (nonatomic,strong) DriverOrderView *order_container;
@property (nonatomic, assign) CMState state;
@property (nonatomic,strong) dispatch_source_t timer;
@property (nonatomic,strong) dispatch_source_t task_timer;


@property (nonatomic, strong) CMLocationView *locationView;

@property (nonatomic,strong) UIButton *cancelOrder;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) ItemView *timeItem;
@property (nonatomic, strong) ItemView *startItem;
@property (nonatomic, strong) ItemView *endItem;
@end

@implementation WaitDriverController
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
    NSInteger cancelTimes;
    NSInteger lastTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDriverReceivedOrder:) name:NOTICE_ORDER_STATE_UPDATE object:nil];
    [self initMapView];
    _needsFirstLocating = YES;
    _isLocating = NO;
    cancelTimes =0;
    [self initView];
    if (_model && 3>=[_model.state intValue]) {
        [self initTimer];
    }else if(_model==nil)
    {
        [self initTimer];
    }
    if (_model) {
        //[DriverOrderInfo fromOrderInfo:_model]
        [self updateNoticeView:_model];
    }
    
}

- (void) initTask
{
    _task_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_main_queue());
    dispatch_source_set_timer(_task_timer,
                              DISPATCH_TIME_NOW,
                              20.0*NSEC_PER_SEC,
                              0.0);
    
    dispatch_source_set_event_handler(_task_timer, ^{
        NSLog(@"timers: fetch Task");
        [self fetchOrderStatus];
    });
    dispatch_resume(_task_timer);
}

- (void) initTimer
{
   //dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_main_queue());
    dispatch_source_set_timer(_timer,
                              DISPATCH_TIME_NOW,
                              1.0*NSEC_PER_SEC,
                              0.0);
    
    dispatch_source_set_event_handler(_timer, ^{
        lastTimer++;
        [_headerLabel setText:[NSString stringWithFormat:@"正在发送信息到司机"]];
    });
    dispatch_resume(_timer);
}

-(NSString*)TimeformatFromSeconds:(NSInteger)seconds
{
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}

- (void) cancelTask
{
    if (_task_timer) {
        dispatch_source_cancel(_task_timer);
        _task_timer = nil;
    }
}

- (void) cancelTimer
{
    lastTimer = 0;
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void) initView
{
    [self setTitle:@"等待应答"];
//    [self.leftButton setImage:[UIImage imageNamed:@"zuohua-16"] forState:UIControlStateNormal];
//    [self.leftButton setTitle:@"" forState:UIControlStateNormal];
//    [self.leftButton mas_updateConstraints:^(MASConstraintMaker *make)
//    {
//        make.width.mas_equalTo(100);
//        make.left.equalTo(self.headerView).offset(10);
//    }];
//    [self.leftButton setTitleColor:RGBHex(g_red) forState:UIControlStateNormal];
//    [self.leftButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//    [self.leftButton setContentMode:UIViewContentModeCenter];
//    [self.leftButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _buttonLocating = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonLocating setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    _buttonLocating.backgroundColor = [UIColor whiteColor];
    _buttonLocating.layer.cornerRadius = 6;
    _buttonLocating.layer.shadowColor = [UIColor blackColor].CGColor;
    _buttonLocating.layer.shadowOffset = CGSizeMake(1, 1);
    _buttonLocating.layer.shadowOpacity = 0.5;
    [_buttonLocating addTarget:self action:@selector(actionLocating:) forControlEvents:UIControlEventTouchUpInside];
    _buttonLocating.frame = CGRectMake(30, 110, 40, 40);
    
    _top_container =[[UIView alloc] init];
    [_top_container setBackgroundColor:RGBHex(g_white)];
    [self.view addSubview:_top_container];
    [_top_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.height.mas_equalTo(200);
        make.width.equalTo(self.view);
    }];
    UIView *blueLine = [[UIView alloc] init];
    [_top_container addSubview:blueLine ];
    [blueLine setBackgroundColor:RGBHex(g_blue)];

    ItemView *itemTime = [[ItemView alloc] init];
    [_top_container addSubview:itemTime];
    
    _cancelOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelOrder.layer.cornerRadius = 5;
    [_cancelOrder setTitle:@"取消\n订单" forState:UIControlStateNormal];
    _cancelOrder.titleLabel.numberOfLines = 2;
    [_cancelOrder.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_cancelOrder setTitleColor:RGBHex(g_blue) forState:UIControlStateNormal];
    [_cancelOrder setBackgroundColor:[UIColor whiteColor]];
    [_cancelOrder addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    [_top_container addSubview:_cancelOrder];
    [_cancelOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_top_container).offset(10);
        make.right.mas_equalTo(_top_container).offset(-10);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
    }];
    
    _headerLabel = [[UILabel alloc] init];
    [_headerLabel setText:@"正在发送信息到司机"];
    _headerLabel.numberOfLines = 2;
    _headerLabel.textColor = [UIColor whiteColor];
    [_headerLabel setFont:[UIFont systemFontOfSize:15]];
    [_top_container addSubview:_headerLabel];
    [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_cancelOrder);
        make.right.equalTo(_cancelOrder.mas_left).offset(-10);
        make.left.equalTo(_top_container).offset(10);
    }];
      [blueLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.height.mas_equalTo(80);
        make.left.equalTo(_top_container);
        make.right.equalTo(_top_container);
    }];
    
    /**    **/
    _timeItem =[[ItemView alloc] init];
    
    [_top_container addSubview:_timeItem];
    [_timeItem.leftImageView setImage:[UIImage imageNamed:@"icon_time"]];
    if (_startTime) {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:_startTime];
        [attributedText addAttribute:NSForegroundColorAttributeName value:RGBHex(g_blue) range:NSMakeRange(_startTime.length-5, 5)];
        _timeItem.titleLabel.attributedText = attributedText;
    }else{
        [_timeItem.titleLabel setText:@"现在出发"];
    }
    [_timeItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blueLine.mas_bottom).offset(10);
        make.left.equalTo(_top_container).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(_top_container.mas_width);
    }];
    
    
    _startItem = [[ItemView alloc] init];
    [_startItem.leftImageView setImage:[UIImage imageNamed:@"icon_qidian_dot_3"]];//icon_qidian_dot_4
    [_startItem.titleLabel setText:_currentLocation.name];
    [_top_container addSubview:_startItem];
    
    [_startItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeItem.mas_bottom).offset(10);
        make.left.equalTo(_top_container).offset(10);
        make.height.mas_greaterThanOrEqualTo(30);
        make.width.mas_equalTo(_top_container.mas_width);
    }];
    
    _endItem =[[ItemView alloc] init];
    [_endItem.leftImageView setImage:[UIImage imageNamed:@"icon_qidian_dot_4"]];
    [_top_container addSubview:_endItem];
    [_endItem.titleLabel setText:_destinationLocation.name];
    [_endItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_startItem.mas_bottom).offset(10);
        make.left.equalTo(_top_container).offset(10);
        make.height.mas_greaterThanOrEqualTo(30);
        make.width.mas_equalTo(_top_container.mas_width);
    }];
    
    if (_model) {
        [_endItem.titleLabel setText:_model.elocation];//_model.elocation
        [_startItem.titleLabel setText:_model.slocation];//_model.slocation
    }
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    
    [self drawRouteLine];
    
    _driverManager = [[CMDriverManager alloc] init];
    _driverManager.delegate = self;
    
    
    _currentLocation = [[CMLocation alloc] init];
    /*
    _locationView = [[CMLocationView alloc] initWithFrame:CGRectMake(0, 120, CGRectGetWidth(self.view.bounds) - 1 * 2, 44)];
    _locationView.delegate = self;
    _locationView.startLocation = _currentLocation;
    [self.view addSubview:_locationView];
    */
    [self setState:CMState_Init];
//    [self.mapView addAnnotation:(id<MAAnnotation>)]
    [self configMapView];
    [self.view addSubview:_buttonLocating];
    [_buttonLocating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.bottom.equalTo(self.view).offset(-80);
    }];
}

- (void) viewWillLayoutSubviews
{

}

- (void)viewDidAppear:(BOOL)animated
{
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;//YES开启定位，NO关闭定位
    [self initTask];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    WaitDriverController_HASVISIABLE = YES;
}

- (void) viewDidDisappear:(BOOL)animated
{
    [self cancelTimer];
    [self cancelTask];
    WaitDriverController_HASVISIABLE = NO;
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
    
    /*
    popView = [[PopView alloc] init];
    [popView setBackgroundColor:[UIColor redColor]];
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
    */
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
    }
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:nil
                                                             reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.draggable = YES;
        [annotationView setDragState:(MAAnnotationViewDragStateDragging)];
        //(MAAnnotationViewDragState)
        UIImage *image = [UIImage imageNamed:@"icon_marker_1"];
        annotationView.image = image;
        annotationView.centerOffset = CGPointMake(0, -22);
        annotationView.canShowCallout = YES;
        annotationView.center = self.mapView.center;
        return annotationView;
    }else if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier1 = @"driverReuseIndetifier1";
        
        MovingAnnotationView *annotationView = (MovingAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier1];
        if (annotationView == nil)
        {
            annotationView = [[MovingAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:pointReuseIndetifier1];
        }
        
        UIImage *image = [UIImage imageNamed:@"icon_marker_2"];
        
        annotationView.image = image;
        annotationView.centerOffset = CGPointMake(0, -22);
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }else{
        
        static NSString *userLocationStyleReuseIndetifier2 = @"common_user_indetifier2";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier2];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:userLocationStyleReuseIndetifier2];
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
    if (sender ==self.leftButton) {
        /*
        CarPoolingCancelCtrl *cancel = [[CarPoolingCancelCtrl alloc] init];
        cancel.orderId = _orderId;
        [self.navigationController pushViewController:cancel animated:YES];*/
        [self.navigationController popViewControllerAnimated:YES];
        
    }else
        if(sender == _cancelOrder){
            if ([@"10" isEqualToString:_model.type]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                CancelView *mcancel = [[CancelView alloc] initWithFrame:self.view.bounds];
                mcancel.orderId = self.orderId;
                mcancel.order  = _model;
                __weak WaitDriverController *ctrl = self;
                [self.view.window addSubview:mcancel];
                mcancel.block = ^(NSInteger type,BOOL isNeedClose){
                    [ctrl.navigationController popToRootViewControllerAnimated:YES];
                };
            }
    }else if(sender == self.rightButton)
    {
        
    }else if([sender isKindOfClass:[UIButton class]])
    {
        UIButton *but = (UIButton*)sender;
        switch (but.tag) {
            case 1:
            {
                SpecialCarController *special = [[SpecialCarController alloc] init];
                special.startLocation = self.currentLocation;
                special.isNowUseCar = YES;
                [self.navigationController pushViewController:special animated:YES];
            }
                break;
            case 2:
            {
                SpecialCarController *special = [[SpecialCarController alloc] init];
                 special.startLocation = self.currentLocation;
                special.isNowUseCar = NO;
                [self.navigationController pushViewController:special animated:YES];
            }
                break;
            default:
                break;
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
                NSLog(@"currentLocation:%@", weakSelf.currentLocation);
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
    [_driverManager searchDriversWithinMapRect:rect];
}

#pragma mark - driversManager delegate

- (void)searchDoneInMapRect:(MAMapRect)mapRect withDriversResult:(NSArray *)drivers timestamp:(NSTimeInterval)timestamp
{
    /*
    [self.mapView removeAnnotations:_drivers];
    NSMutableArray * currDrivers = [NSMutableArray arrayWithCapacity:[drivers count]];
    [drivers enumerateObjectsUsingBlock:^(CMDriver * obj, NSUInteger idx, BOOL *stop) {
        MAPointAnnotation * driver = [[MAPointAnnotation alloc] init];
        driver.coordinate = obj.coordinate;
        driver.title = obj.idInfo;
        [currDrivers addObject:driver];
    }];
    
    [self.mapView addAnnotations:currDrivers];
    
    _drivers = currDrivers;
    
    */
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
    return;
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
   /*
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
        
        [self searchReGeocodeWithCoordinate:local];
    }
    */
}

- (void) mapViewDidFinishLoadingMap:(MAMapView *)mapView
{
//    NSLog(@"mapViewDidFinishLoadingMap");
//    [self actionLocating:nil];

}

- (void) mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState fromOldState:(MAAnnotationViewDragState)oldState
{
    NSLog(@"didChangeDragStatedidChangeDragState");
}

- (MAOverlayRenderer*) mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineRenderer *render = [[MAPolylineRenderer alloc] initWithOverlay:overlay];
        render.lineWidth = 4;
        render.strokeColor = RGBHex(@"#05fd11");
        render.fillColor =  RGBHex(@"#05fd11");
        render.lineJoinType = kMALineJoinRound;//连接类型
        return render;
    }
    return nil;
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
        if (order) {
            if (_model &&([order.state integerValue]>[_model.state integerValue])) {
                _model = [CarOrderModel convertDriverModel:order];
                [_notice_container setModel:_model];
                [self updateNoticeView:_model];
            }else if([@"10" isEqualToString:order.type]){
                _model = [CarOrderModel convertDriverModel:order];
                [_notice_container setModel:_model];
                [self updateNoticeView:_model];
            }
        }
    }
}

- (void) updateNoticeView:(CarOrderModel*)order
{
    
    if (order) {
        
        [self setTitle:[CommonUtility getOrderDescription:order.state]];
        if ([order.state intValue]>=3) {
            [self cancelTimer];
        }
        if ([order.state intValue]<3) {
            [self setTitle:@"等待应答"];
        }
        if ([@"3" isEqualToString:order.state]) {//司机接单
            
            [_top_container removeFromSuperview];
            [_order_container removeFromSuperview];
            if (!_notice_container) {
                _notice_container = [[DriverNoticeView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            }
            [self.view addSubview:_notice_container];
            [_notice_container setModel:order];
            [_notice_container.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.headerView.mas_bottom);
            }];
            [_notice_container mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view);
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.bottom.equalTo(self.view);
            }];
            __strong WaitDriverController* ctrl =self;
            _notice_container.handel=^(NSString *msg){
                if ([@"取消订单" isEqualToString:msg]) {
                    [ctrl cancleOrderTip];
                }};
        }else if([@"4" isEqualToString:order.state]){
            [_top_container removeFromSuperview];
            [_order_container removeFromSuperview];
            if (!_notice_container) {
                _notice_container = [[DriverNoticeView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            }
            [self.view addSubview:_notice_container];
            [_notice_container.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.headerView.mas_bottom);
            }];
            [_notice_container mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view);
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.bottom.equalTo(self.view);
            }];
            __strong WaitDriverController* ctrl =self;
            _notice_container.handel=^(NSString *msg){
                if ([@"取消订单" isEqualToString:msg]) {
                    [ctrl cancleOrderTip];
                }};
        }else if([@"5" isEqualToString:order.state])
        {
            [_top_container removeFromSuperview];
            [_notice_container removeFromSuperview];
            [self.leftButton setHidden:YES];
            if (!_order_container) {
                _order_container = [[DriverOrderView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            }
            [self.view addSubview:_order_container];
            [_order_container mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view);
                make.left.equalTo(self.view);
                make.width.equalTo(self.view);
//                make.bottom.equalTo(self.view);//
                make.height.mas_equalTo(230);
            }];
            _order_container.model = order;
            [_order_container.top_container mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.headerView.mas_bottom);
            }];
            
        }else if([@"6" isEqualToString:order.state])
        {
            [_top_container removeFromSuperview];
            [_notice_container removeFromSuperview];
            [self.leftButton setHidden:YES];
            if (!_order_container) {
                _order_container = [[DriverOrderView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            }
            [self.view addSubview:_order_container];
            [_order_container mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view);
                make.left.equalTo(self.view);
                make.width.equalTo(self.view);
                make.bottom.equalTo(self.view);
            }];
            [_order_container.top_container mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.headerView.mas_bottom);
            }];
            
            __block WaitDriverController *ctrl = self;
            _order_container.model = order;
            _order_container.handel=^(NSString *msg){
                if ([@"去支付" isEqualToString:msg]) {
                    PayOrderController *order = [[PayOrderController alloc] init];
                    order.orderId = ctrl.orderId;
                    [ctrl.navigationController pushViewController:order animated:YES];
                }else{
                    [MBProgressHUD showAndHideWithMessage:@"呼叫" forHUD:nil];
                }};
        }else if ([@"10" isEqualToString:order.type]){
//            [_startItem.titleLabel setText:order.sLocation];
//            [_endItem.titleLabel setText:order.eLocation];
            [_headerLabel setText:@"很抱歉，暂无司机应答！您可以联系客服帮您解决."];
            [_headerLabel setTextColor:[UIColor whiteColor]];
        }
    }

}

- (void) fetchOrderStatus
{
    [CarOrderModel fetchOrderList:1 Succes:^(NSArray *result, int pageCount, int recordCount) {
        for (NSDictionary *doc in result) {
            _model = [[CarOrderModel alloc] initWithDictionary:doc error:nil];
            break;
        }
        if (_model) {
             NSLog(@"query node:%@",_model);
            [self updateNoticeView:_model];
        }
    } failed:^(NSInteger errorCode, NSString *errorMessage) {
        NSLog(@"errorMessage");
    }];
    
}

- (void) cancleOrderTip
{
    CancelView *mcancel = [[CancelView alloc] initWithFrame:self.view.bounds];
    mcancel.orderId = self.orderId;
    mcancel.order = _model;
    if (_model) {
        mcancel.orderId = _model.ids;
    }
    __weak WaitDriverController *ctrl = self;
    [self.view.window addSubview:mcancel];
    mcancel.block = ^(NSInteger type,BOOL isNeedClose){
        [ctrl.navigationController popToRootViewControllerAnimated:YES];
    };
}

- (void)drawRouteLine
{
    
    if (_routPath) {
        if (self.destinationLocation) {
            MAPointAnnotation *endPoint = [[MAPointAnnotation alloc] init];
            endPoint.coordinate = self.destinationLocation.coordinate;
            endPoint.title=@"下车地点";
            [self.mapView addAnnotation:endPoint];
        }
        NSInteger index =0;
        for (AMapStep *steps in _routPath.steps) {
            
            NSArray *routes = [steps.polyline componentsSeparatedByString:@";"];
            NSInteger n =[routes count];
            CLLocationCoordinate2D points[n];
            for (int i = 0; i < n; i++) {
                CLLocationCoordinate2D coords;
                
                NSArray *po = [[routes objectAtIndex:i] componentsSeparatedByString:@","];
                coords.longitude=[[po objectAtIndex:0] floatValue];
                coords.latitude=[[po objectAtIndex:1] floatValue];
                
                CLLocationDegrees lat = coords.latitude;
                CLLocationDegrees longit = coords.longitude;
                points[i]=CLLocationCoordinate2DMake(lat,longit);
            }
            if (index==0) {
                CLLocationCoordinate2D spoints[2];
                spoints[0]=_currentLocation.coordinate;
                spoints[1]=points[0];
                MAPolyline *lineOne = [MAPolyline polylineWithCoordinates:spoints count:2];
                [self.mapView addOverlay:lineOne];
            }
            
            MAPolyline *lineOne = [MAPolyline polylineWithCoordinates:points count:n];
            [self.mapView addOverlay:lineOne];
            
            index++;
            if (index==_routPath.steps.count) {
                if (n>0) {
                    CLLocationCoordinate2D epoints[2];
                    epoints[0]=_destinationLocation.coordinate;
                    epoints[1]=points[n-1];
                    MAPolyline *lineOne = [MAPolyline polylineWithCoordinates:epoints count:2];
                    [self.mapView addOverlay:lineOne];
                    NSLog(@"path.steps.count path.steps.count");
                }
            }
        }
    }else{
        
        if (_model) {
            CMLocation *start = [[CMLocation alloc] init];
            start.coordinate = CLLocationCoordinate2DMake([_model.slatitude floatValue], [_model.slongitude floatValue]);
            CMLocation *end = [[CMLocation alloc] init];
            end.coordinate = CLLocationCoordinate2DMake([_model.elatitude floatValue], [_model.elongitude floatValue]);
            
            [[CMSearchManager sharedInstance] searchForStartLocation:start end:end completionBlock:^(id request, id response, NSError *error) {
                AMapRouteSearchResponse *naviResponse = response;
                if (naviResponse.route == nil)
                {
                    [MBProgressHUD showAndHideWithMessage:@"获取路径失败" forHUD:nil];
                    return;
                }
                AMapPath * path = [naviResponse.route.paths firstObject];
                _routPath = path;
                _destinationLocation = end;
                start.coordinate =  self.mapView.userLocation.coordinate;
                _currentLocation = start;
                if (_routPath) {
                    [self drawRouteLine];
                }
            }];
        }
    }
}

+ (BOOL) hasVisiabled
{
    return WaitDriverController_HASVISIABLE;
}


- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end