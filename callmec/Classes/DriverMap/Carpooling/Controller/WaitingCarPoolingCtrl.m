//
//  ViewController.m
//  callmec
//
//  Created by sam on 16/6/21.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "WaitingCarPoolingCtrl.h"

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

#import "VerticalView.h"
#import "TripTypeModel.h"


#import "SpecialCarController.h"
#import "PayOrderController.h"

#import "PopView.h"
#import "ItemView.h"
#import "DriverNoticeView.h"
#import "DriverOrderView.h"
#import "LeftIconView.h"
#import "CancelView.h"

#import "PayModel.h"
#import <AVFoundation/AVFoundation.h>

#import <MAMapKit/MAPolyline.h>
#define kSetingViewHeight 215

#define NOTICE_UPDATE_CARPOOLING_INFO @"NOTICE_UPDATE_CARPOOLING_INFO"

static BOOL WaitingCarPoolingCtrl_HASVISIABLE = NO;
@interface WaitingCarPoolingCtrl() <TargetActionDelegate,MAMapViewDelegate,CMDriverManagerDelegate, CMLocationViewDelegate>
@property (nonatomic,assign) BOOL isCurrentLocal;
@property (nonatomic,strong) UIButton *buttonLocating;
@property (nonatomic, assign) BOOL isLocating;
@property (nonatomic,strong) UIView *top_container;                 //等待司机接单界面
//@property (nonatomic,strong) DriverNoticeView *notice_container;    //司机订单界面
@property (nonatomic,strong) DriverOrderView *order_container;
@property (nonatomic, assign) CMState state;
@property (nonatomic,strong) dispatch_source_t timer;



@property (nonatomic, strong) CMLocationView *locationView;

@property (nonatomic,strong) LeftIconView *driverHeaderView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIView *headerTopView;
@property (nonatomic, strong) UIView *grayLine;
@property (nonatomic,strong) UIView *bottomLine;
@property (nonatomic, strong) ItemView *timeItem;               //时间
@property (nonatomic, strong) ItemView *startItem;              //上车地点
@property (nonatomic, strong) ItemView *endItem;              //上车地点
@property (nonatomic,strong) ItemView *routeLine;               //线路
@property (nonatomic,strong) ItemView *peopleNumber;            //上车人数
//@property (nonatomic,strong) ItemView *feeTip;                  //费用提示
@property (nonatomic,strong) ItemView *extraMessage;            //附加留言
@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UIButton *buttonCall;
@property (nonatomic,copy) NSString *dPhoneNo;//
@property (nonatomic,strong) UIButton *cancelOrder;

@property(nonatomic,strong) AVAudioPlayer *movePlayer ;

@end

@implementation WaitingCarPoolingCtrl
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
        [self updateNoticeView:_model];
        [self requestPathInfo];
    }
}

- (void) initView
{
    [self setTitle:@"等待应答"];
    [self.leftButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [self.leftButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.leftButton setContentMode:UIViewContentModeCenter];
    [self.leftButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.rightButton setTitleColor:RGBHex(g_red) forState:UIControlStateNormal];
//    [self setRightButtonText:@"取消用车" withFont:[UIFont systemFontOfSize:14]];
//    [self.rightButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//    [self.rightButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    _top_container =[[UIView alloc] init];
    [_top_container setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_top_container];
    [_top_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.height.mas_equalTo(400);
        make.width.equalTo(self.view);
    }];
    
    _headerTopView = [[UIView alloc] init];
    [_headerTopView setBackgroundColor:RGBHex(g_blue)];
    [_top_container addSubview:_headerTopView];
    [_headerTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_top_container);
        make.left.equalTo(_top_container);
        make.height.mas_equalTo(80);
        make.width.equalTo(_top_container);
    }];
    
    _driverHeaderView =[[LeftIconView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_driverHeaderView setImageUrl:@"icon_driver"];
    [_headerTopView addSubview:_driverHeaderView];
    [_driverHeaderView setTitleFont:[UIFont systemFontOfSize:15]];
    [_driverHeaderView setContentFont:[UIFont systemFontOfSize:12]];
    [_driverHeaderView setTitle:@""];
    [_driverHeaderView setContent:@""];
    [_driverHeaderView setHidden:YES];
    [_driverHeaderView setFontNumber:14];
    [_driverHeaderView setHeightLeftIcon:56];
    [_driverHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerTopView);
        make.left.equalTo(_headerTopView);
        make.height.equalTo(_headerTopView);
        make.width.equalTo(_headerTopView);
    }];
    
    _cancelOrder = [UIButton buttonWithType:UIButtonTypeCustom];
//    _cancelOrder.hidden = YES;
    _cancelOrder.layer.cornerRadius = 5;
    [_cancelOrder setTitle:@"取消\n订单" forState:UIControlStateNormal];
    _cancelOrder.titleLabel.numberOfLines = 2;
    [_cancelOrder.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_cancelOrder setTitleColor:RGBHex(g_blue) forState:UIControlStateNormal];
    [_cancelOrder setBackgroundColor:[UIColor whiteColor]];
    [_cancelOrder addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    [_headerTopView addSubview:_cancelOrder];
    [_cancelOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerTopView).offset(10);
        make.right.mas_equalTo(_headerTopView).offset(-10);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
    }];
    
    _headerLabel = [[UILabel alloc] init];
    [_headerLabel setText:@"正在发送信息到司机"];
    _headerLabel.numberOfLines = 2;
    _headerLabel.textColor = [UIColor whiteColor];
    [_headerLabel setFont:[UIFont systemFontOfSize:15]];
    [_headerTopView addSubview:_headerLabel];
    [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_cancelOrder);
        make.right.equalTo(_cancelOrder.mas_left).offset(-10);
        make.left.equalTo(_headerTopView).offset(10);
    }];
    
    _grayLine = [[UIView alloc] init];
    [_top_container addSubview:_grayLine ];
    [_grayLine setBackgroundColor:RGBHex(g_gray)];
    [_grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerTopView.mas_bottom).offset(0);
        make.height.mas_equalTo(1);
        make.left.equalTo(_top_container).offset(10);
        make.right.equalTo(_top_container).offset(-10);
    }];
    
    _buttonCall = [[UIButton alloc] init];
    [_buttonCall.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_buttonCall setBackgroundImage:[ImageTools imageWithColor:RGB(237, 249, 255)] forState:UIControlStateNormal];
    [_buttonCall addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonCall.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_buttonCall.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_buttonCall.titleLabel setNumberOfLines:0];
    [_buttonCall.layer setMasksToBounds:YES];
    [_buttonCall.layer setCornerRadius:5];
    [_buttonCall.layer setBorderWidth:1];
    [_buttonCall.layer setBorderColor:RGBHex(g_blue).CGColor];
    
    [_buttonCall setTitle:@"拨打电话" forState:UIControlStateNormal];
    [_buttonCall setTitleColor:RGBHex(g_blue) forState:UIControlStateNormal];
    [_buttonCall setImage:[UIImage imageNamed:@"形状-39"] forState:UIControlStateNormal];
    _buttonCall.titleLabel.numberOfLines = 2;
    
    [_top_container addSubview:_buttonCall];
    [_buttonCall mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_top_container).offset(-20);
//        make.left.equalTo(_top_container).offset(20);
        make.centerX.equalTo((_grayLine.mas_centerX));
        make.width.mas_equalTo(180);
        make.top.equalTo(_grayLine.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    _timeItem =[[ItemView alloc] init];
    [_top_container addSubview:_timeItem];
    [_timeItem.leftImageView setImage:[UIImage imageNamed:@"5yue"]];
    _startTime = _model.appointDate;
    if (_startTime) {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:_startTime];
        [attributedText addAttribute:NSForegroundColorAttributeName value:RGBHex(g_black) range:NSMakeRange(_startTime.length-5,5)];
        _timeItem.titleLabel.attributedText = attributedText;
    }else{
        [_timeItem.titleLabel setText:@"现在出发"];
    }
    [_timeItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buttonCall.mas_bottom).offset(10);
        make.left.equalTo(_top_container).offset(10);
        make.height.mas_equalTo(20);
        make.width.equalTo(_top_container);
    }];
    
    ///路线
    _routeLine = [[ItemView alloc] init];
    [_routeLine.leftImageView setImage:[UIImage imageNamed:@"chongq"]];//icon_qidian_dot_4
    [_routeLine.titleLabel setText:[NSString stringWithFormat:@"%@",_model.lineName]];
    [_top_container addSubview:_routeLine];
    
    [_routeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeItem.mas_bottom).offset(10);
        make.left.equalTo(_top_container).offset(10);
        make.height.mas_equalTo(20);
        make.width.equalTo(_top_container);
    }];
    
    _startItem =[[ItemView alloc] init];
    [_startItem.leftImageView setImage:[UIImage imageNamed:@"icon_pc_shang"]];
    [_top_container addSubview:_startItem];
    [_startItem.titleLabel setText:[NSString stringWithFormat:@"%@",_model.slocation]];
    [_startItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_routeLine.mas_bottom).offset(10);
        make.left.equalTo(_top_container).offset(10);
        make.height.mas_equalTo(20);
        make.width.equalTo(_top_container);
    }];
    
    _endItem =[[ItemView alloc] init];
    [_endItem.leftImageView setImage:[UIImage imageNamed:@"icon_pc_xia"]];
    [_top_container addSubview:_endItem];
    [_endItem.titleLabel setText:[NSString stringWithFormat:@"%@",_model.elocation]];
    [_endItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_startItem.mas_bottom).offset(10);
        make.left.equalTo(_top_container).offset(10);
        make.height.mas_equalTo(20);
        make.width.equalTo(_top_container);
    }];
    
    _peopleNumber =[[ItemView alloc] init];
    [_peopleNumber.leftImageView setImage:[UIImage imageNamed:@"2"]];
    [_top_container addSubview:_peopleNumber];
    [_peopleNumber.titleLabel setText:[NSString stringWithFormat:@"%@人",_model.orderPerson]];
    [_peopleNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_endItem.mas_bottom).offset(10);
        make.left.equalTo(_top_container).offset(10);
        make.height.mas_equalTo(20);
        make.width.equalTo(_top_container);
    }];
    
//    _feeTip =[[ItemView alloc] init];
//    [_feeTip.leftImageView setImage:[UIImage imageNamed:@"30yuan"]];
//    [_top_container addSubview:_feeTip];
//    [_feeTip.titleLabel setText:[NSString stringWithFormat:@"%@元",_model.otherFee]];
//    [_feeTip mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_peopleNumber.mas_bottom).offset(10);
//        make.left.equalTo(_top_container).offset(10);
//        make.height.mas_equalTo(20);
//        make.width.equalTo(_top_container);
//    }];
    
    _extraMessage =[[ItemView alloc] init];
    [_extraMessage.leftImageView setImage:[UIImage imageNamed:@"beizhu"]];
    [_top_container addSubview:_extraMessage];
    if (_model.descriptions.length>0) {
        [_extraMessage.titleLabel setText:[NSString stringWithFormat:@"%@",_model.descriptions]];
    }else{
        [_extraMessage.titleLabel setText:@"无"];
    }
    [_extraMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_peopleNumber.mas_bottom).offset(10);
        make.left.equalTo(_top_container).offset(10);
        make.height.mas_equalTo(20);
        make.width.equalTo(_top_container);
    }];
    
    _bottomLine = [[UIView alloc] init];
    [_top_container addSubview:_bottomLine ];
    [_bottomLine setBackgroundColor:RGBHex(g_gray)];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_extraMessage.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
        make.left.equalTo(_top_container).offset(10);
        make.right.equalTo(_top_container).offset(-10);
    }];
    
    //bottomLine
    _moneyLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_moneyLabel setText:[NSString stringWithFormat:@"金额：%@元",_model.fee]];
    [_moneyLabel setTextColor:[UIColor blackColor]];
    [_moneyLabel setTextAlignment:NSTextAlignmentCenter];
    [_moneyLabel setFont:[UIFont systemFontOfSize:15]];
    [_top_container addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_top_container);
        make.top.equalTo(_bottomLine.mas_bottom);
        make.bottom.equalTo(_top_container);
        //make.width.equalTo(_top_container).multipliedBy(0.8); can casue app crash. <multiplie>
    }];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    MAPointAnnotation *endPoint = [[MAPointAnnotation alloc] init];
    endPoint.coordinate = self.destinationLocation.coordinate;
    endPoint.title=@"下车地点";
    [self.mapView addAnnotation:endPoint];
    
    /*
    if (_routPath) {
        for (AMapStep *steps in _routPath.steps) {
           NSArray *routes = [steps.polyline componentsSeparatedByString:@";"];
            int  n =[routes count];
           CLLocationCoordinate2D points[n];
            for (int i = 0; i < n; i++) {
                CLLocationCoordinate2D coords;
                
                NSArray *po = [[routes objectAtIndex:i] componentsSeparatedByString:@","];
                coords.longitude=[[po objectAtIndex:0] floatValue];
                coords.latitude=[[po objectAtIndex:1] floatValue];
                
                CLLocationDegrees lat = coords.latitude;
                CLLocationDegrees longit = coords.longitude;
                points[i]=CLLocationCoordinate2DMake(lat,longit);
                //NSLog(@"point:%f %f",lat,longit);
            }
            
            MAPolyline *lineOne = [MAPolyline polylineWithCoordinates:points count:n];
            [self.mapView addOverlay:lineOne];
        }
    }
    */
    _driverManager = [[CMDriverManager alloc] init];
    _driverManager.delegate = self;
    
    _currentLocation = [[CMLocation alloc] init];
    [self setState:CMState_Init];
    [self configMapView];
}

- (void) viewWillLayoutSubviews
{

}

- (void)viewDidAppear:(BOOL)animated
{
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = NO;//YES开启定位，NO关闭定位
    WaitingCarPoolingCtrl_HASVISIABLE = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dta = [[NSDate alloc] init];
    dta = [dateformater dateFromString:_startTime];
    
    NSDate *datenow = [NSDate date];
    NSInteger miniTime = [datenow timeIntervalSince1970] - [dta timeIntervalSince1970];

    if ([USERDEFAULTS objectForKey:@"defaultNO"] &&[USERDEFAULTS objectForKey:@"defaultTIME"]) {
            if ([_model.state isEqualToString:@"1"] && miniTime/60 >= 10) {
                
                [MBProgressHUD showAndHideWithMessage:@"订单信息已过时,请重新发布!" forHUD:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
    }else{
        [USERDEFAULTS setObject:_model.no forKey:@"defaultNO"];
        [USERDEFAULTS setObject:_startTime forKey:@"defaultTIME"];
    }


}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    WaitingCarPoolingCtrl_HASVISIABLE= NO;
}

#pragma mark - Init & Construct

- (void)configMapView
{
    [self.mapView setShowsUserLocation:NO];
//    [self.mapView.];
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
//    if (_needsFirstLocating && updatingLocation)
//    {
//        [self actionLocating:nil];
//        self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
//        _needsFirstLocating = NO;
//    }
}


#pragma mark -  Action Reset Locating

- (void) resetMapToCenter:(CLLocationCoordinate2D)coordinate
{
    self.mapView.centerCoordinate = coordinate;
//    MKCoordinateSpan span = [self coordinateSpanWithMapView:self centerCoordinate:centerCoordinate andZoomLevel:zoomLevel];
//    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
//    self.mapView.zoomLevel = 8;
//    使得userLocationView在最前。
//    [self.mapView selectAnnotation:self.mapView.userLocation animated:YES];
}

- (void) updateCarsDrivers
{
    _isLocating = NO;
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
        NSLog(@"%@",[self TimeformatFromSeconds:lastTimer]);

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
- (void) buttonTarget:(id)sender
{
    if (sender ==self.leftButton) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if(sender == self.cancelOrder)
    {
        /*
        CarPoolingCancelCtrl *cancel = [[CarPoolingCancelCtrl alloc] init];
        cancel.orderId = _model.ids;
        [self.navigationController pushViewController:cancel animated:YES];
        */
        CancelView *mcancel = [[CancelView alloc] initWithFrame:self.view.bounds];
        mcancel.orderId = self.orderId;
        if (_model) {
            mcancel.orderId = _model.ids;
        }
        __weak WaitingCarPoolingCtrl *ctrl = self;
        [self.view.window addSubview:mcancel];
        mcancel.block = ^(NSInteger type,BOOL isNeedClose){
            [ctrl.navigationController popToRootViewControllerAnimated:YES];
        };
        
    }else if(sender == _buttonCall){
        if (_dPhoneNo) {
            [CommonUtility callTelphone:_dPhoneNo];
        }
        return;
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
        
        NSString *image_s= @"icon_marker_1";
        MAPointAnnotation *man = (MAPointAnnotation*)annotation;
        if ([@"上车地点" isEqualToString:man.title]) {
            image_s=@"icon_marker_1";
        }else if([@"下车地点" isEqualToString:man.title]){
            image_s=@"icon_marker_2";
        }else{
            image_s=@"icon_marker_1";
        }
        
        UIImage *image = [UIImage imageNamed:image_s];
        annotationView.image = image;
        annotationView.centerOffset = CGPointMake(0, 0);
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
        UIImage *image = [UIImage imageNamed:@"icon_marker_2"];
        annotationView.image = image;
        annotationView.centerOffset = CGPointMake(0,0);
        annotationView.canShowCallout = NO;
        return annotationView;
    }
    
    return nil;
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
        order = [[DriverOrderInfo alloc] initWithDictionary:oderinfo.userInfo error:nil];
        NSLog(@"oderinfo:%@",oderinfo.userInfo);
    }
    @catch (NSException *exception){}
    @finally{}
    if([@"-1" isEqualToString:order.state]){
        NSString *tmp2= [[NSBundle mainBundle] pathForResource:@"driveCancelOrder" ofType:@"wav"];
        NSURL *moveMP32=[NSURL fileURLWithPath:tmp2];
        NSError *err=nil;
        _movePlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:moveMP32 error:&err];
        _movePlayer.volume=1.0;
        [_movePlayer prepareToPlay];
        [_movePlayer play];
        [MBProgressHUD showAndHideWithMessage:@"司机已取消订单" forHUD:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }{
        [self updateNoticeView:[CarOrderModel convertDriverModel:order]];
    }
}

- (void) updateNoticeView:(CarOrderModel*)order
{
    
    if (order) {
        if ([order.state integerValue]<3) {
            [self setTitle:@"等待应答"];
        }else{
            [self setTitle:[CommonUtility getOrderDescription:order.state]];
        }
        _dPhoneNo = order.dPhoneNo;
        [self changeButtonCallStatue];
        if ([@"3" isEqualToString:order.state] || [@"4" isEqualToString:order.state]) {
            [_headerLabel removeFromSuperview];
            [_driverHeaderView setIsIndicated:YES];
            [_driverHeaderView setHidden:NO];
            [_order_container removeFromSuperview];
            [_driverHeaderView setImageUrl:[CommonUtility driverHeaderImageUrl:order.driverId]];
            [_driverHeaderView setTitle:order.dRealName];
            [_driverHeaderView setContent:[NSString stringWithFormat:@"%@ %@",order.carNo,order.carDesc]];
            [_driverHeaderView setButtonText:@""];
        }else if([@"10" isEqualToString:order.type]){
            [_headerLabel removeFromSuperview];
            [_order_container removeFromSuperview];
            [_driverHeaderView setIsIndicated:YES];
            [_driverHeaderView setHidden:NO];
            [_driverHeaderView setImageUrl:[CommonUtility driverHeaderImageUrl:order.driverId]];
            [_driverHeaderView setTitle:@""];
            [_driverHeaderView setButtonText:@"无人接单"];
        }
//        else if([@"4" isEqualToString:order.state]){
//            [_top_container removeFromSuperview];            
//            [self.leftButton setHidden:YES];
//            [self initOrderView:order];
//        }
        else if([@"5" isEqualToString:order.state])
        {
            [_top_container removeFromSuperview];
            
            [self.leftButton setHidden:YES];
            [self.rightButton setHidden:YES];
            [self.rightButton setEnabled:YES];
            [self initOrderView:order];
        }else if([@"6" isEqualToString:order.state])
        {
            [_top_container removeFromSuperview];
            [self.leftButton setHidden:YES];
            [self.rightButton setHidden:YES];
            [self initOrderView:order];
            __block WaitingCarPoolingCtrl *ctrl = self;
            _order_container.model = order;
            _order_container.handel=^(NSString *msg){
                if ([@"去支付" isEqualToString:msg]) {
                    PayOrderController *orderv = [[PayOrderController alloc] init];
                    orderv.orderId = order.ids;
                    [ctrl.navigationController pushViewController:orderv animated:YES];
                }else{
                    [MBProgressHUD showAndHideWithMessage:@"呼叫" forHUD:nil];
                }};
        }else if([@"7" isEqualToString:order.state]){
            PayOrderController *orderv = [[PayOrderController alloc] init];
            orderv.orderId = order.ids;
            [self.navigationController pushViewController:orderv animated:YES];
        }
    }
}

- (void) cancleOrderTip
{
    [JCAlertView showTwoButtonsWithTitle:@"温馨提示" Message:@"您的订单已经生成！您确定要取消订单么？" ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"取消" Click:^{
    } ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"确定" Click:^{
        MBProgressHUD *hud = [MBProgressHUD showProgressView:@"请稍后..." inView:nil];
        hud.completionBlock=^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        [hud show:YES];
        [CMDriverManager cancelCallCarRequest:_model.ids reason:@"协商取消用车" success:^(NSDictionary *resultDictionary) {
            [hud hide:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_UPDATE_CARPOOLING_INFO object:nil];
        } failed:^(NSInteger errorCode, NSString *errorMessage) {
            [hud hide:YES];
            [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
            cancelTimes++;
            if ((int)cancelTimes>=3) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
}

- (void) setModel:(CarOrderModel *)model
{
    _model = model;
    [_timeItem.titleLabel setText:_model.appointDate];
    [_routeLine.titleLabel setText:model.lineName];
    [_startItem.titleLabel setText:model.slocation];
    [_peopleNumber.titleLabel setText:model.orderPerson];
//    [_feeTip.titleLabel setText:model.otherFee];


    if (model.descriptions.length>0) {
        [_extraMessage.titleLabel setText:model.descriptions];
    }else{
        [_extraMessage.titleLabel setText:@"无"];
    }
    _dPhoneNo = _model.dPhoneNo;
    [self changeButtonCallStatue];
}

- (void) changeButtonCallStatue
{
    if (_dPhoneNo) {
        [_buttonCall setHidden:NO];
        [_buttonCall setEnabled:YES];
        [_timeItem mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_buttonCall.mas_bottom).offset(10);
            make.left.equalTo(_top_container).offset(10);
            make.height.mas_equalTo(20);
            make.width.equalTo(_top_container);
        }];
    }else{
        [_buttonCall setHidden:YES];
        [_buttonCall setEnabled:NO];
        [_timeItem mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_grayLine.mas_bottom).offset(10);
            make.left.equalTo(_top_container).offset(10);
            make.height.mas_equalTo(20);
            make.width.equalTo(_top_container);
        }];
    }
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (BOOL) hasVisiabled
{
    return WaitingCarPoolingCtrl_HASVISIABLE;
}


#pragma mark - Utility

- (void)requestPathInfo
{
    if (!_model) {
        return;
    }
    //检索所需费用
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.requireExtension = YES;
    
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:[_model.lineSlat floatValue]
                                           longitude:[_model.lineSlong floatValue]];
    
    
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:[_model.elatitude floatValue]
                                                longitude:[_model.elongitude floatValue]];
    
    [[CMSearchManager sharedInstance] searchForRequest:navi completionBlock:^(id request, id response, NSError *error) {
        
        AMapRouteSearchResponse *naviResponse = response;
        
        if (naviResponse.route == nil)
        {
            NSLog(@"%@",@"获取路径失败");
            return;
        }
        
        AMapPath * path = [naviResponse.route.paths firstObject];
        NSLog(@"%@",[NSString stringWithFormat:@"预估费用%.2f元  距离%.1f km  时间%.1f分钟", naviResponse.route.taxiCost, path.distance / 1000.f, path.duration / 60.f, nil]);
        [self updatePoly:path withStartPoint: navi.origin endPoint:navi.destination];
    }];
}



#pragma mark - draw route line
- (void) updatePoly:(AMapPath*)routPath withStartPoint:(AMapGeoPoint*)start endPoint:(AMapGeoPoint*)end
{
    MAPointAnnotation *endPoint = [[MAPointAnnotation alloc] init];
    endPoint.coordinate = CLLocationCoordinate2DMake(end.latitude, end.longitude);
    endPoint.title=@"下车地点";
    
    MAPointAnnotation *startPoint = [[MAPointAnnotation alloc] init];
    startPoint.coordinate = CLLocationCoordinate2DMake(start.latitude, start.longitude);
    startPoint.title=@"上车地点";
    [self.mapView addAnnotation:startPoint];
    [self.mapView addAnnotation:endPoint];
    
    
    if (routPath) {
        NSInteger index =0;
        for (AMapStep *steps in routPath.steps) {
            
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
                spoints[0]=startPoint.coordinate;
                spoints[1]=points[0];
                MAPolyline *lineOne = [MAPolyline polylineWithCoordinates:spoints count:2];
                
                [self.mapView addOverlay:lineOne];
            }
            
            MAPolyline *lineOne = [MAPolyline polylineWithCoordinates:points count:n];
            [self.mapView addOverlay:lineOne];
            
            index++;
            if (index==routPath.steps.count) {
                if (n>0) {
                    CLLocationCoordinate2D epoints[2];
                    epoints[0]=endPoint.coordinate;
                    epoints[1]=points[n-1];
                    MAPolyline *lineOne = [MAPolyline polylineWithCoordinates:epoints count:2];
                    [self.mapView addOverlay:lineOne];
                }
            }
        }
    }
    //30.984189 108.400897
    CLLocationCoordinate2D center;
    center= CLLocationCoordinate2DMake((startPoint.coordinate.latitude+endPoint.coordinate.latitude)/2,
                                       (startPoint.coordinate.longitude+endPoint.coordinate.longitude)/2);
    [self resetMapToCenter:center];
}

- (void) initOrderView:(CarOrderModel*)order
{
    if (!_order_container) {
        _order_container = [[DriverOrderView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    [self.view addSubview:_order_container];
    if ([@"4" isEqualToString:order.state]||[@"5" isEqualToString:order.state]) {
        [_order_container mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.width.equalTo(self.view);
            make.height.mas_equalTo(370);
//            make.bottom.equalTo(self.view);
        }];
    }else{
        [_order_container mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.width.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    
    [_order_container.top_container mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    _order_container.model = order;
}
@end
