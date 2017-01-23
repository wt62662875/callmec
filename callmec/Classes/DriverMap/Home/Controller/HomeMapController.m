//
//  ViewController.m
//  callmec
//
//  Created by sam on 16/6/21.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "HomeMapController.h"


#import "RegisterController.h"
#import "UserCenterController.h"
#import "MessageController.h"
#import "DriverInfoController.h"
#import "PayOrderController.h"

//test start controller
#import "TestController.h"
#import "ScanCodeBusController.h"
#import "WaitingBusController.h"

#import "AppraiseController.h"

//test end controller
#import "SpecialHomeController.h"
#import "CarPoolingHomeController.h"
#import "SpeedBusHomeController.h"
#import "GoodsHomeController.h"

#import "WaitingCarPoolingCtrl.h"       //拼车等待页面
#import "PayOrderController.h"          //支付页面
#import "WaitDriverController.h"        //专车等待页面


#import "VerticalView.h"
#import "TripTypeModel.h"
#import "CarOrderModel.h"
#import "AppVersionModel.h"

#import "PopView.h"
#import "TripTypeView.h"

#define kSetingViewHeight 215

@interface HomeMapController() <TargetActionDelegate>
@property (nonatomic,strong) TripTypeView *top_container;
@property (nonatomic,strong) NSArray *carTypeArray;
@property (nonatomic, strong) TripTypeModel *tripModel;

@end

@implementation HomeMapController
{
    UIViewController *currentController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderUnfinishedNotice:) name:NOTICE_ORDER_UNFIHISHED_STATE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNoticeUpdateState:) name:NOTICE_ORDER_STATE_UPDATE object:nil];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self initData];
    [self initView];
}

- (void) initData
{
    [self setTitle:@"呼 我"];
//    if ([[USERDEFAULTS objectForKey:@"selectHomeButton"] isEqualToString:@"1"]) {
        _carTypeArray =[NSArray arrayWithObjects:[TripTypeModel instance:@"快车" icons:@"guang" selectIcons:@"guang" colro:g_blue type:@"2"],[TripTypeModel instance:@"专车" icons:@"guang" selectIcons:@"guang" colro:g_blue type:@"1"]
                        ,nil];
  
        
    CarPoolingHomeController *carpoolingHome = [[CarPoolingHomeController alloc] init];
    [carpoolingHome setTripModel:_carTypeArray[0]];
    [self addChildViewController:carpoolingHome];
    SpecialHomeController *specialHome = [[SpecialHomeController alloc] init];
    [specialHome setTripModel:_carTypeArray[1]];
    [self addChildViewController:specialHome];
//    }
//    else{
//        _carTypeArray =[NSArray arrayWithObjects:[TripTypeModel instance:@"快巴" icons:@"" selectIcons:@"guang" colro:g_blue type:@"3"],
//                        [TripTypeModel instance:@"货的" icons:@"" selectIcons:@"guang" colro:g_blue type:@"4"], nil];
//        SpeedBusHomeController *specialHome3 = [[SpeedBusHomeController alloc] init];
//        [specialHome3 setTripModel:_carTypeArray[0]];
//        [self addChildViewController:specialHome3];
//        
//        GoodsHomeController *specialHome4 = [[GoodsHomeController alloc] init];
//        [specialHome4 setTripModel:_carTypeArray[1]];
//        [self addChildViewController:specialHome4];
//    }
    
    [self checkVersion];
}

- (void) initView
{
    [self.leftButton setImage:[UIImage imageNamed:@"qian"] forState:UIControlStateNormal];
    [self.leftButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.leftButton setContentMode:UIViewContentModeCenter];
    [self.leftButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rightButton setImage:[UIImage imageNamed:@"qianse"] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
    self.bottomHeaderLine.hidden = YES;

    _top_container =[[TripTypeView alloc] init];
    [_top_container setBackgroundColor:RGBHex(g_white)];
    [self.view addSubview:_top_container];
    [_top_container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.height.mas_equalTo(60);
        make.width.equalTo(self.view);
    }];
    [_top_container setSelectColor:RGBHex(g_blue)];
    [_top_container setDataArray:_carTypeArray];
    [_top_container setDelegate:self];
    [_top_container setIndexSelect:0];
     NSLog(@" intivew orderUnfinishedNotice");
    
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
//            _locationManger = [[CLLocationManager alloc] init];
//            locationManger.delegate = self;
//            [locationManger startUpdatingLocation];
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        //NSlog("定位功能不可用，提示用户或忽略");
//        [JCAlertView showTwoButtonsWithTitle:@"温馨提示" Message:@"定位功能不可用" ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"取消" Click:^{
//        } ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"确定" Click:^{
//           
//        }];
        
        [JCAlertView showOneButtonWithTitle:@"温馨提示" Message:@"定位功能不可用" ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"知道了" Click:^{
            
        }];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(![GlobalData sharedInstance].user.isLogin)
    {
        RegisterController *register1 = [[RegisterController alloc] init];
        [self.navigationController pushViewController:register1 animated:YES];
    }else{
        
    }
//    WaitingBusController *po = [[WaitingBusController alloc] init];
//    [self.navigationController pushViewController:po animated:YES];
//    TestController *testController = [[TestController alloc] init];
//    [self.navigationController pushViewController:testController animated:YES];
    
//    AppraiseController *testController = [[AppraiseController alloc] init];
//    [self.navigationController pushViewController:testController animated:YES];
    
//    AppiontBusController *bus = [[AppiontBusController alloc] init];
//    [self.navigationController pushViewController:bus animated:YES];
    
//    PayOrderController *payorder = [[PayOrderController alloc] init];
//    [self.navigationController pushViewController:payorder animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
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
//        DriverInfoController *driverInfo = [[DriverInfoController alloc] init];
//        [self.navigationController pushViewController:driverInfo animated:YES];
        MessageController *message =[[MessageController alloc] init];
        [self.navigationController pushViewController:message animated:YES];
    }else if([sender isKindOfClass:[UIButton class]])
    {
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
                   /* SpecialCarController *special = [[SpecialCarController alloc] init];
                    special.startLocation = self.currentLocation;
                    special.isNowUseCar = YES;
                    special.carTypeModel = _tripModel;
                    [self.navigationController pushViewController:special animated:YES];*/
                }else if([@"2" isEqualToString:_tripModel.tripType])
                {/*
                    AppiontmentController *special = [[AppiontmentController alloc] init];
                    special.startLocation = self.currentLocation;
                    special.isNowUseCar = YES;
                    special.tripTypeModel = _tripModel;
                    [self.navigationController pushViewController:special animated:YES];*/
                }else if([@"3" isEqualToString:_tripModel.tripType])
                {
                    /*SpecialCarController *special = [[SpecialCarController alloc] init];
                    special.startLocation = self.currentLocation;
                    special.isNowUseCar = YES;
                    special.carTypeModel = _tripModel;
                    [self.navigationController pushViewController:special animated:YES];*/
                }else if([@"4" isEqualToString:_tripModel.tripType])
                {
                   /*GoodsCarController *special = [[GoodsCarController alloc] init];
                    special.startLocation = self.currentLocation;
                    special.isNowUseCar = YES;
                    special.carTypeModel = _tripModel;
                    [self.navigationController pushViewController:special animated:YES];*/
                }
                
            }
                break;
            case 2:
            {
                if (!_tripModel) {
                    [MBProgressHUD showAndHideWithMessage:@"请选择出行方式，专车、快车或者其他!" forHUD:nil];
                    return;
                }
                /*
                SpecialCarController *special = [[SpecialCarController alloc] init];
                special.startLocation = self.currentLocation;
                special.isNowUseCar = NO;
                special.carTypeModel = _tripModel;
                [self.navigationController pushViewController:special animated:YES];*/
            }
                break;
            default:
                break;
        }
    }else if([sender isKindOfClass:[VerticalView class]])
    {
        NSInteger tag = ((UIView*)sender).tag;
        _tripModel = _carTypeArray[tag];
        [self changeViewController:tag];
    }
    
}

- (void) changeViewController:(NSInteger)index
{
    @try {
        if (currentController) {
            [currentController.view removeFromSuperview];
        }
        currentController = self.childViewControllers[index];
        [self.view addSubview:currentController.view];
        [currentController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_top_container.mas_bottom);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
        if (currentController && [currentController isKindOfClass:[BaseController class]])
        {
            [((BaseController*)currentController) reloadData];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"changeViewController%@",exception);
    }
    @finally {
        
    }
}

- (void) orderUnfinishedNotice:(NSNotification*)notice
{
    NSLog(@"orderUnfinishedNotice");
    CarOrderModel *order = [[CarOrderModel alloc] initWithDictionary:notice.userInfo error:nil];
//    if ([notice.userInfo[@"type"] integerValue]>4) {
//        DriverOrderInfo *notices = [[DriverOrderInfo alloc] initWithDictionary:notice.userInfo error:nil];
//        order = [CarOrderModel convertDriverModel:notices];
//    }else{
//        order = [[CarOrderModel alloc] initWithDictionary:notice.userInfo error:nil];
//    }
    //order = [[DriverOrderInfo alloc] initWithDicvhhtionary:oderinfo.userInfo error:&error];
    if (order) {
        if ([@"1" isEqualToString:order.type]) {
            
            [_top_container setIndexSelect:1];
            [self changeViewController:1];
        }else if ([@"2" isEqualToString:order.type]) {
            [_top_container setIndexSelect:0];
            [self changeViewController:0];
            
        }else if ([@"3" isEqualToString:order.type]) {
            [_top_container setIndexSelect:3];
            [self changeViewController:3];
            ((GoodsHomeController*)currentController).model = order;
            ((GoodsHomeController*)currentController).model_dict = notice.userInfo;
        }else if ([@"4" isEqualToString:order.type]) {
            
            [_top_container setIndexSelect:2];
            [self changeViewController:2];
        }
        [self jumpLogicController:order];
    }
    NSLog(@"NSNotification:%@",notice.userInfo);
}


- (void) pushNoticeUpdateState:(NSNotification*)notice
{
    NSLog(@"pushNoticeUpdateState");
//    CarOrderModel *order = [[CarOrderModel alloc] initWithDictionary:notice.userInfo error:nil];
    
    CarOrderModel *order;
    if ([notice.userInfo[@"type"] integerValue]>4) {
        DriverOrderInfo *notices = [[DriverOrderInfo alloc] initWithDictionary:notice.userInfo error:nil];
        order = [CarOrderModel convertDriverModel:notices];
        if (notices && [@"5" isEqualToString:notices.type] &&notices.cancelled) { //对于type==5
            BOOL exits = [PayOrderController hasVisiabled];
            if (!exits) {
                PayOrderController *pay = [[PayOrderController alloc] init];
                pay.orderId = order.ids;
                [self.navigationController pushViewController:pay animated:YES];
            }
            return;
        }
    }else{
        order = [[CarOrderModel alloc] initWithDictionary:notice.userInfo error:nil];
    }
    
    if (order) {
        if ([@"1" isEqualToString:order.oType]) {
            [_top_container setIndexSelect:0];
            [self changeViewController:0];
            if ([@"21"  isEqualToString:order.type]) {
                [self showAlertMessage:@"暂无业务处理!"];
            }
        }else if ([@"2" isEqualToString:order.oType]) {
            [_top_container setIndexSelect:1];
            [self changeViewController:1];
            if ([@"21"  isEqualToString:order.type]) {
                [self showAlertMessage:@"暂无业务处理!"];
            }
        }else if ([@"3" isEqualToString:order.oType]) {
            [_top_container setIndexSelect:3];
            [self changeViewController:3];
            ((GoodsHomeController*)currentController).model = order;
            ((GoodsHomeController*)currentController).model_dict = notice.userInfo;
            if ([@"21"  isEqualToString:order.type]) {
                [self showAlertMessage:@"暂无业务处理!"];
            }
        }else if ([@"4" isEqualToString:order.oType]) {
            [GlobalData sharedInstance].fastModel = order;
            [_top_container setIndexSelect:2];
            [self changeViewController:2];
            if ([@"21"  isEqualToString:order.type]) {
                [self showAlertMessage:@"暂无业务处理!"];
            }
        }else{
            if ([@"21"  isEqualToString:order.type]) {
                [self showAlertMessage:@"暂无业务处理!"];
            }
        }
        //[self jumpLogicController:order];
    }
    NSLog(@"pushNoticeUpdateState end:%@",notice.userInfo);
}


- (void)jumpLogicController:(CarOrderModel*)order
{
//    return;
    if ([@"6" isEqualToString:order.state])
    {
        BOOL exits = [PayOrderController hasVisiabled];
        if (!exits) {
            PayOrderController *pay = [[PayOrderController alloc] init];
            pay.orderId = order.ids;
            [self.navigationController pushViewController:pay animated:YES];
        }
    }else{
        if ([@"1" isEqualToString:order.type]) {
            
            BOOL exits = [WaitDriverController hasVisiabled];
            if (!exits) {
                WaitDriverController *waiter = [[WaitDriverController alloc] init];
                waiter.orderId = order.ids;
                waiter.model = order;
                [self.navigationController pushViewController:waiter animated:YES];
            }
            
        }else if ([@"2" isEqualToString:order.type]) {
            BOOL exits = [WaitingCarPoolingCtrl hasVisiabled];
            if (!exits) {
                WaitingCarPoolingCtrl *waiter = [[WaitingCarPoolingCtrl alloc] init];
                waiter.orderId = order.ids;
                waiter.model = order;
                [self.navigationController pushViewController:waiter animated:YES];
            }
            //TestController *waiter = [[TestController alloc] init];
            //[self.navigationController pushViewController:waiter animated:YES];
        }else if ([@"3" isEqualToString:order.type]) {
            
        }else if ([@"4" isEqualToString:order.type]) {
            BOOL exits = [WaitingBusController hasVisiabled];
            if (!exits) {
                WaitingBusController *waiter = [[WaitingBusController alloc] init];
                waiter.orderId = order.ids;
                waiter.model = order;
                [self.navigationController pushViewController:waiter animated:YES];
            }
        }
        
    }
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) showAlertMessage:(NSString*)msg
{
    [self showAlertMessage:msg withTitle:@"温馨提示"];
}

- (void) showAlertMessage:(NSString*)msg withTitle:(NSString*)title
{
    [self showAlertMessage:msg withTitle:title bOne:@"知道了" bTwo:nil withHandler:nil];
}

- (void)showAlertMessage:(NSString*)msg withTitle:(NSString*)title bOne:(NSString*)btn_one bTwo:(NSString*)btn_two withHandler:(clickHandle)handler
{
    if ((btn_one==nil && btn_two ==nil)||(btn_one&& btn_two ==nil)) {
        if (handler) {
            [JCAlertView showOneButtonWithTitle:title Message:msg ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:btn_one Click:handler];
        }else{
            [JCAlertView showOneButtonWithTitle:title Message:msg ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:btn_two Click:^{
                
            }];
        }
    }else if(btn_one && btn_two){
        [JCAlertView showTwoButtonsWithTitle:title Message:msg ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:btn_one Click:nil ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:btn_two Click:handler];
    }
    
}

- (void) checkVersion
{
    [AppVersionModel checkAppVersionWithSucess:^(NSDictionary *resultDictionary) {
        NSLog(@"checkVersion resultDictionary:%@",resultDictionary);
        if ([[[resultDictionary objectForKey:@"data"] objectForKey:@"newVersion"] intValue] != 0) {
            AppVersionModel *model = [[AppVersionModel alloc] initWithDictionary:resultDictionary[@"data"] error:nil];
            [self showAlertMessage:@"升级提示" withTitle:model.descriptions bOne:@"稍后升级" bTwo:@"马上升级" withHandler:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1148376316"]];
            }];
        }
    } withFail:^(NSInteger errorCode, NSString *errorMessage) {
        NSLog(@"errorMessage:%@",errorMessage);
    }];
}
@end
