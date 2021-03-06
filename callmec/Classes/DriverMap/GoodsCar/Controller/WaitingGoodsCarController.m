//
//  WaitingGoodsCarController.m
//  callmec
//
//  Created by sam on 16/8/12.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "WaitingGoodsCarController.h"
#import "PayOrderController.h"

#import "LeftIconLabel.h"
#import "MovingAnnotationView.h"
#import "BottomPayView.h"
#import "LeftIconView.h"
#import "CancelView.h"

#import "CMSearchManager.h"
#import "GoodsOrderModel.h"
#import "CLLocation+Center.h"


@interface WaitingGoodsCarController ()<TargetActionDelegate>

@property (nonatomic,strong) UIView *container;
@property (nonatomic,strong) UIView *topline;
@property (nonatomic,strong) UIView *driverInfoView;
@property (nonatomic,strong) UILabel *headerLabel;
@property (nonatomic,strong) LeftIconLabel *typeLabel;
@property (nonatomic,strong) LeftIconLabel *timeLabel;
@property (nonatomic,strong) LeftIconLabel *startLabel;
@property (nonatomic,strong) LeftIconLabel *endLabel;
@property (nonatomic,strong) LeftIconLabel *goodsNameLabel;
@property (nonatomic,strong) LeftIconLabel *goodsInfoLabel;

@property (nonatomic,strong) LeftIconView *driverInfoLabel;
@property (nonatomic,strong) UIButton *buttonMessage;
@property (nonatomic,strong) UIButton *buttonCall;

@property (nonatomic,strong) BottomPayView *bottom_pay;
@end

@implementation WaitingGoodsCarController
{
    BOOL _needsFirstLocating;
    BOOL _isLocating;
    CLLocation *_olocation;
    NSInteger _nIndex;
    NSString *_dPhone;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMapView];
    [self initView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateViews:) name:NOTICE_ORDER_STATE_UPDATE object:nil];
    _needsFirstLocating = YES;
    _isLocating = NO;
    _nIndex = 0;
    if (_model) {
        [self fetchDetailIds:_model.ids];
    }
}



- (void) initView
{
    
    [self.rightButton setHidden:YES];
    [self.rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self setRightButtonText:@"取消" withFont:[UIFont systemFontOfSize:15]];
    
    _container = [[UIView alloc] init];
    [_container setBackgroundColor:[UIColor whiteColor]];
    [_container setHidden:YES];
    [self.view addSubview:_container];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(200);
    }];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    
    
    _driverInfoView = [[UIView alloc] init];
    [_container addSubview:_driverInfoView];
    [_driverInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container).offset(5);
        make.centerX.equalTo(_container);
        make.width.equalTo(_container);
        make.height.mas_greaterThanOrEqualTo(30);
    }];
    
    _headerLabel =[[UILabel alloc] init];
    [_headerLabel setFont:[UIFont systemFontOfSize:15]];
    [_headerLabel setText:@"正在发送信息到司机"];
    [_headerLabel setTextAlignment:NSTextAlignmentCenter];
    [_container addSubview:_headerLabel];
    [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container).offset(5);
        make.centerX.equalTo(_container);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(280);
    }];
   
    _topline = [[UIView alloc] init];
    [_topline setBackgroundColor:RGBHex(g_gray)];
    [_container addSubview:_topline];
    [_topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerLabel.mas_bottom).offset(5);
        make.centerX.equalTo(_container);
        make.height.mas_equalTo(1);
        make.width.equalTo(_container);
    }];
    
    _typeLabel = [[LeftIconLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_typeLabel setImageUrl:@"icon_pc_pepo"];
    [_typeLabel setImageW:20 withH:20];
    [_container addSubview:_typeLabel];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topline.mas_bottom);
        make.left.equalTo(_container).offset(10);
        make.height.mas_equalTo(30);
        make.right.equalTo(_container);
    }];
    
    _timeLabel = [[LeftIconLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_container addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeLabel.mas_bottom);
        make.left.equalTo(_container).offset(10);
        make.height.mas_equalTo(30);
        make.right.equalTo(_container);
    }];
    
    _startLabel = [[LeftIconLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_startLabel setImageUrl:@"icon_fahuo"];
    [_startLabel setImageW:13 withH:17];
    [_container addSubview:_startLabel];
    [_startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom);
        make.left.equalTo(_container).offset(10);
        make.height.mas_equalTo(30);
        make.right.equalTo(_container);
    }];
    
    _endLabel = [[LeftIconLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_endLabel setImageUrl:@"icon_shouhuo"];
    [_endLabel setImageW:13 withH:17];
    [_container addSubview:_endLabel];
    [_endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_startLabel.mas_bottom);
        make.left.equalTo(_container).offset(10);
        make.height.mas_equalTo(30);
        make.right.equalTo(_container);
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:RGBHex(g_gray)];
    [_container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_endLabel.mas_bottom);
        make.left.equalTo(_container);
        make.height.mas_equalTo(1);
        make.right.equalTo(_container);
    }];
    
    _goodsNameLabel = [[LeftIconLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_container addSubview:_goodsNameLabel];
    [_goodsNameLabel setImageUrl:@"icon_pc_pepo"];
    [_goodsNameLabel setImageW:20 withH:20];
    [_goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.equalTo(_container).offset(10);
        make.height.mas_equalTo(30);
        make.right.equalTo(_container);
    }];
    _goodsInfoLabel = [[LeftIconLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_goodsInfoLabel setImageUrl:@"icon_pc_bei"];
    [_goodsInfoLabel setImageW:20 withH:20];
    [_container addSubview:_goodsInfoLabel];
    [_goodsInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsNameLabel.mas_bottom);
        make.left.equalTo(_container).offset(10);
        make.height.mas_equalTo(30);
        make.right.equalTo(_container);
        make.bottom.equalTo(_container).offset(-10);
    }];
    
    _bottom_pay = [[BottomPayView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _bottom_pay.delegate = self;
    _bottom_pay.hidden = YES;
    [self.view addSubview:_bottom_pay];
    [_bottom_pay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;//YES开启定位，NO关闭定位
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    // 第一次定位时才将定位点显示在地图中心 发现和经一次定位不准确，第二次才能定准确所以让ＭＡＰ 多做了一次更新位置。
    if (updatingLocation && _needsFirstLocating) {
        if (!_olocation) {
            _olocation = self.mapView.userLocation.location;
            self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
             NSLog(@"first time");
        }else{
            float distance = [self.mapView.userLocation.location distanceFromLocation:_olocation];
            if (distance>100) {
                _olocation = self.mapView.userLocation.location;
            }else{
                _needsFirstLocating = NO;
            }
            self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
        }
        [self actionLocating:nil];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
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
//        UIImage *image = [UIImage imageNamed:@"icon_marker_1"];
//        annotationView.image = image;
//        annotationView.centerOffset = CGPointMake(0, -22);
//        annotationView.canShowCallout = YES;
//        annotationView.center = self.mapView.center;
//        return annotationView;
        return nil;
    }else if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        NSString *title = ((MAPointAnnotation*)annotation).title;
        static NSString *pointReuseIndetifier = @"driverReuseIndetifier";
        
        MovingAnnotationView *annotationView = (MovingAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MovingAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:pointReuseIndetifier];
        }
        UIImage *image;
        if (title && [title isEqualToString:@"装货地点"]) {
            image = [UIImage imageNamed:@"icon_fahuo"];
        }else if(title && [title isEqualToString:@"卸货地点"]){
            image = [UIImage imageNamed:@"icon_shouhuo"];
        }
        annotationView.image = image;
        annotationView.centerOffset = CGPointMake(0,0);
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

- (void)requestPathInfoStart:(CMLocation*)sLocation withEnd:(CMLocation*)eLocation
{
    _nIndex = 0;
    //检索所需费用
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.requireExtension = YES;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:sLocation.coordinate.latitude
                                           longitude:sLocation.coordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:eLocation.coordinate.latitude
                                                longitude:eLocation.coordinate.longitude];
    
    //__weak __typeof(&*self) weakSelf = self;
    [[CMSearchManager sharedInstance] searchForRequest:navi completionBlock:^(id request, id response, NSError *error) {
        
        AMapRouteSearchResponse *naviResponse = response;
        
        if (naviResponse.route == nil)
        {
            [MBProgressHUD showAndHideWithMessage:@"获取路径失败" forHUD:nil];
            return;
        }
        AMapPath * path = [naviResponse.route.paths firstObject];
        MAPointAnnotation *startPoint = [[MAPointAnnotation alloc] init];
        startPoint.coordinate = sLocation.coordinate;
        startPoint.title=@"装货地点";
        [self.mapView addAnnotation:startPoint];
            if (path) {
            NSInteger index =0;
            for (AMapStep *steps in path.steps) {
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
                    spoints[0]=sLocation.coordinate;
                    spoints[1]=points[0];
                    MAPolyline *lineOne = [MAPolyline polylineWithCoordinates:spoints count:2];
                    [self.mapView addOverlay:lineOne];
                }
                MAPolyline *lineOne = [MAPolyline polylineWithCoordinates:points count:n];
                [self.mapView addOverlay:lineOne];
                index++;
                if (index==path.steps.count) {
                    if (n>0) {
                        CLLocationCoordinate2D epoints[2];
                        epoints[0]=eLocation.coordinate;
                        epoints[1]=points[n-1];
                        MAPolyline *lineOne = [MAPolyline polylineWithCoordinates:epoints count:2];
                        [self.mapView addOverlay:lineOne];
                        NSLog(@"path.steps.count path.steps.count");
                    }
                }
            }
        }
        
//        if (index==0) {
//            CLLocationCoordinate2D spoints[2];
//            points[0]=sLocation.coordinate;
//            points[1]=points[0];
//            MAPolyline *lineOne = [MAPolyline polylineWithCoordinates:spoints count:1];
//            [self.mapView addOverlay:lineOne];
//        }
        
        MAPointAnnotation *endPoint = [[MAPointAnnotation alloc] init];
        endPoint.coordinate = eLocation.coordinate;
        endPoint.title=@"卸货地点";
        [self.mapView addAnnotation:endPoint];
    }];
}

- (void) setModel:(CarOrderModel *)model
{
    _model = model;
//    if (_model) {
//        CMLocation *slocation =[[CMLocation alloc] init];
//        slocation.coordinate = CLLocationCoordinate2DMake([_model.slatitude floatValue],[_model.slongitude floatValue]);
//        CMLocation *elocation =[[CMLocation alloc] init];
//        elocation.coordinate = CLLocationCoordinate2DMake([_model.dLatitude floatValue],[_model.dLatitude floatValue]);
//        [self requestPathInfoStart:slocation withEnd:elocation];
//    }
}

- (void) fetchDetailIds:(NSString*)orderId
{
    [GoodsOrderModel  fetchGoodsOrderDetail:orderId success:^(NSDictionary *resultDictionary) {
        NSLog(@"resultDictionary:%@",resultDictionary);
        NSDictionary *data = resultDictionary[@"data"];
        if (data) {
            NSInteger state =[data[@"state"] integerValue];
            CarOrderModel *model = [[CarOrderModel alloc] initWithDictionary:data error:nil];
            [self setTitle:[CommonUtility getGoodsOrderDesc:[NSString stringWithFormat:@"%ld",(long)state]]];
            [self creatDriverInfoView:model];
            
            //typeLabel  chartered
            if([data[@"chartered"] integerValue]==0)
            {
                [_typeLabel setTitle:@"拼货"];
            }else{
                [_typeLabel setTitle:@"包车"];
                
            }
            
            [_timeLabel setTitle:data[@"appointDate"]];
            [_startLabel setTitle:data[@"slocation"]];
            [_endLabel setTitle:data[@"elocation"]];
            [_goodsNameLabel setTitle:data[@"goodsName"]];
            NSArray *scale = data[@"goodsScale"];
            [_goodsInfoLabel setTitle:[NSString stringWithFormat:@"%@(千克) 长%@ 宽%@ 高%@ (M)",
                                    data[@"goodsWeight"],
                                    [CommonUtility fetchDataFromArrayByIndex:scale withIndex:0],
                                    [CommonUtility fetchDataFromArrayByIndex:scale withIndex:1],
                                    [CommonUtility fetchDataFromArrayByIndex:scale withIndex:2]]];
            
            CMLocation *slocation =[[CMLocation alloc] init];
            slocation.coordinate = CLLocationCoordinate2DMake([data[@"slatitude"] floatValue],[data[@"slongitude"] floatValue]);
            CMLocation *elocation =[[CMLocation alloc] init];
            elocation.coordinate = CLLocationCoordinate2DMake([data[@"elatitude"] floatValue],[data[@"elongitude"] floatValue]);
            CLLocation *sll = [[CLLocation alloc] initWithLatitude:slocation.coordinate.latitude
                                                         longitude:slocation.coordinate.longitude];
            CLLocation *ell = [[CLLocation alloc] initWithLatitude:elocation.coordinate.latitude
                                                         longitude:elocation.coordinate.longitude];
            NSLog(@"errorMessage:%f",[sll distanceFromLocation:ell]);
            [self resetMapToCenter:[sll centerFrom:ell].coordinate];
            [self requestPathInfoStart:slocation withEnd:elocation];
        }
    } failed:^(NSInteger errorCode, NSString *errorMessage) {
        NSLog(@"errorMessage:%@",errorMessage);
    }];
}

- (void)actionLocating:(UIButton *)sender
{
    // 只有初始状态下才可以进行定位。
    if (!_isLocating)
    {
        _isLocating = YES;
        [self resetMapToCenter:self.mapView.userLocation.location.coordinate];
        //[self searchReGeocodeWithCoordinate:self.mapView.userLocation.location.coordinate];
    }
}

- (void) resetMapToCenter:(CLLocationCoordinate2D)coordinate
{
    self.mapView.centerCoordinate = coordinate;
    self.mapView.zoomLevel = 12;
    
    // 使得userLocationView在最前。
//    [self.mapView selectAnnotation:self.mapView.userLocation animated:YES];
}

- (void)updateViews:(NSNotification *)oderinfo
{

    DriverOrderInfo *order =nil;
    @try {
        order = [[DriverOrderInfo alloc] initWithDictionary:oderinfo.userInfo error:nil];
        NSLog(@"oderinfo:%@",oderinfo.userInfo);
    }
    @catch (NSException *exception){}
    @finally{}
    [self updateNoticeView:[CarOrderModel convertDriverModel:order]];
}

- (void) updateNoticeView:(CarOrderModel*)order
{
    NSLog(@"order :%@",order);
    [self setTitle:[CommonUtility getGoodsOrderDesc:order.state]];
    [self creatDriverInfoView:order];
}

- (void) buttonTarget:(id)sender
{
    if (sender == self.leftButton) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if(sender == self.rightButton){
        
//        if (!cancel) {
//            cancel = [[CancelView alloc] initWithFrame:self.view.bounds];
//        }
//        cancel.orderId = self.orderId;
//        __weak WaitingGoodsCarController *ctrl = self;
//        [self.view.window addSubview:cancel];
//        cancel.block = ^(NSInteger type,BOOL isNeedClose){
//            [ctrl.navigationController popToRootViewControllerAnimated:YES];
//        };
        
        CancelView *mcancel = [[CancelView alloc] initWithFrame:self.view.bounds];
        mcancel.orderId = self.orderId;
        __weak WaitingGoodsCarController *ctrl = self;
        [self.view.window addSubview:mcancel];
        mcancel.block = ^(NSInteger type,BOOL isNeedClose){
            [ctrl.navigationController popToRootViewControllerAnimated:YES];
        };
        /*CarPoolingCancelCtrl *cancel = [[CarPoolingCancelCtrl alloc] init];
        cancel.orderId = self.orderId;
        [self.navigationController pushViewController:cancel animated:YES];*/
    }else if(sender == self.bottom_pay){
        PayOrderController *order = [[PayOrderController alloc] init];
        order.orderId = _model.ids;
        if (self.orderId) {
            order.orderId = self.orderId;
        }
        [self.navigationController pushViewController:order animated:YES];
    }else if(sender == self.buttonCall)
    {
        if (_dPhone) {
            [CommonUtility callTelphone:_dPhone];
        }
    }else if(sender == self.buttonMessage)
    {
        if (_dPhone) {
            [CommonUtility sendMessage:_dPhone];
        }
    }
}

- (void) setOrderId:(NSString *)orderId
{
    _orderId = orderId;
    [self fetchDetailIds:orderId];
}

- (void) creatDriverInfoView:(CarOrderModel*)model
{
    _model = model;
    [_container setHidden:NO];
    [self.mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    if (!_driverInfoLabel) {
        _driverInfoLabel = [[LeftIconView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_driverInfoLabel setTitleFont:[UIFont systemFontOfSize:13]];
        [_driverInfoLabel setContentFont:[UIFont systemFontOfSize:14]];
        [_driverInfoView addSubview:_driverInfoLabel];
        [_driverInfoLabel setHeightLeftIcon:50];
        [_driverInfoLabel setHiddenStatus:YES];
    }
    
    [_driverInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_driverInfoView).offset(5);
        make.left.equalTo(_driverInfoView).offset(10);
        make.right.equalTo(_driverInfoView).offset(-10);
        make.height.mas_equalTo(50);
    }];
    
    if (!_buttonMessage) {
        _buttonMessage = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonMessage setTitleColor:RGBHex(g_black) forState:UIControlStateNormal];
        [_buttonMessage.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_buttonMessage.layer setCornerRadius:5];
        [_buttonMessage.layer setMasksToBounds:YES];
        [_buttonMessage.layer setBorderWidth:1];
        [_buttonMessage.layer setBorderColor:RGBHex(g_gray).CGColor];
        [_buttonMessage setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [_buttonMessage addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonMessage setImage:[UIImage imageNamed:@"icon_msg_hd"] forState:UIControlStateNormal];
        [_buttonMessage setTitle:@"发送消息" forState:UIControlStateNormal];
        [_driverInfoView addSubview:_buttonMessage];
    }
   
    
    if (!_buttonCall) {
        _buttonCall = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonCall setTitleColor:RGBHex(g_black) forState:UIControlStateNormal];
        [_buttonCall.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_buttonCall.layer setCornerRadius:5];
        [_buttonCall.layer setMasksToBounds:YES];
        [_buttonCall.layer setBorderWidth:1];
        [_buttonCall addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonCall.layer setBorderColor:RGBHex(g_gray).CGColor];
        [_buttonCall setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [_buttonCall setImage:[UIImage imageNamed:@"icon_phone_hd"] forState:UIControlStateNormal];
        [_buttonCall setTitle:@"拨打电话" forState:UIControlStateNormal];
        [_driverInfoView addSubview:_buttonCall];
    }
    
    
    [_buttonMessage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_driverInfoLabel.mas_bottom).offset(5);
        make.right.equalTo(_driverInfoView.mas_centerX).offset(-5);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(140);
        make.bottom.equalTo(_driverInfoView).offset(-5);
    }];
    [_buttonCall mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_driverInfoLabel.mas_bottom).offset(5);
        make.left.equalTo(_driverInfoView.mas_centerX).offset(5);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(140);
        make.bottom.equalTo(_driverInfoView).offset(-5);
    }];
    [_driverInfoLabel setIsIndicated:NO];
    [_driverInfoLabel setTitle:[NSString stringWithFormat:@"%@",model.dRealName]];
    [_driverInfoLabel setContent:[NSString stringWithFormat:@"%@ %@",model.carNo,model.carDesc]];
    [_driverInfoLabel setImageUrl:[CommonUtility driverHeaderImageUrl:model.driverId]];
    if ([@"6" isEqualToString: model.state]) {
        [_bottom_pay setHidden:NO];
    }
    
    if ([@"1" isEqualToString: model.state]||[@"2" isEqualToString: model.state]||[@"3" isEqualToString: model.state]
        ||[@"4" isEqualToString: model.state])
    {
        [self.rightButton setHidden:NO];
    }else{
        [self.rightButton setHidden:YES];
    }
    if ([@"1" isEqualToString: model.state])
    {
        [_headerLabel setHidden:NO];
        [_driverInfoView setHidden:YES];
        [_topline mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerLabel.mas_bottom).offset(5);
            make.centerX.equalTo(_container);
            make.height.mas_equalTo(1);
            make.width.equalTo(_container);
        }];
    }else{
        [_headerLabel setHidden:YES];
        [_driverInfoView setHidden:NO];
        [_topline mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_driverInfoView.mas_bottom).offset(5);
            make.centerX.equalTo(_container);
            make.height.mas_equalTo(1);
            make.width.equalTo(_container);
        }];
    }
    _dPhone = model.dPhoneNo;
}


- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
