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

#import "helpViewController.h"
#import "setUpViewController.h"
#import "WalletController.h"
#import "OrderListController.h"
#import "VerticalView.h"
#import "TripTypeModel.h"
#import "CarOrderModel.h"
#import "AppVersionModel.h"
#import "HomeBackView.h"
#import "EditUserController.h"
#import "PopView.h"
#import "TripTypeView.h"
#import <AVFoundation/AVFoundation.h>
#import "UserCenterController.h"

#define kSetingViewHeight 215
#define OPENCENTERX 250.0
#define DIVIDWIDTH 70.0 //OPENCENTERX 对应确认是否打开或关闭的分界线。

@interface HomeMapController() <TargetActionDelegate,UIGestureRecognizerDelegate>
{
    CGPoint openPointCenter;
    CGPoint closePointCenter;
    
    CGPoint leftOpenPointCenter;
}
@property (nonatomic,strong) TripTypeView *top_container;
@property (nonatomic,strong) NSArray *carTypeArray;
@property (nonatomic, strong) TripTypeModel *tripModel;
@property(nonatomic,strong) AVAudioPlayer *movePlayer ;

@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) HomeBackView *leftView;
@property (nonatomic,strong) UIView *blackView;

@end

@implementation HomeMapController
{
    UIViewController *currentController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBackView];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderUnfinishedNotice:) name:NOTICE_ORDER_UNFIHISHED_STATE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNoticeUpdateState:) name:NOTICE_ORDER_STATE_UPDATE object:nil];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self initData];
    [self initView];
}
-(void)initBackView{
    
    
    //    self.headerView.hidden = YES;
    
    _backView = [[UIView alloc]initWithFrame:self.view.frame];
    [_backView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_backView];
    
    _leftView = [[NSBundle mainBundle] loadNibNamed:@"HomeBackView" owner:self options:nil][0];
    _leftView.delegate = self;
    [_leftView setFrame:CGRectMake(-250, 0,250, kScreenSize.height)];
    _leftView.backgroundColor = [UIColor whiteColor];
    [_leftView.sureButton addTarget:self action:@selector(sureButton:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_leftView];
    
    [self.headerView removeFromSuperview];
    
    [_backView addSubview:self.headerView];
    [_backView addSubview:self.leftButton];
    [_backView addSubview:self.rightButton];
    [_backView addSubview:self.bottomHeaderLine];
    [_backView addSubview:self.titleLabel];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView);
        make.left.equalTo(_backView);
        make.width.equalTo(_backView);
        make.height.mas_equalTo(KTopbarH);
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(20);
        make.left.equalTo(self.headerView).offset(10);
        make.width.height.mas_equalTo(44);
        make.bottom.equalTo(self.headerView).offset(0);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(20);
        make.right.equalTo(self.headerView).offset(-10);
        make.width.height.mas_equalTo(44);
    }];
    [self.bottomHeaderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView);
        make.bottom.equalTo(self.headerView);
        make.height.mas_equalTo(1);
        make.width.equalTo(self.headerView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(20);
        make.height.mas_equalTo(44);
        make.centerX.equalTo(self.headerView);
    }];
    
    //KVO监听
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];
    panGestureRecognizer.delegate = self;
    [self.backView addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handleTap:)];
    tapGestureRecognizer.delegate = self;
    [self.backView addGestureRecognizer:tapGestureRecognizer];
    openPointCenter = CGPointMake(self.backView.center.x + OPENCENTERX,
                                  self.backView.center.y);
    leftOpenPointCenter = CGPointMake(self.leftView.center.x + OPENCENTERX, self.leftView.center.y);
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //Tip:我们可以通过打印touch.view来看看具体点击的view是具体是什么名称,像点击UITableViewCell时响应的View则是UITableViewCellContentView.
    //    NSLog(@"%@",[touch.view class]);
    if ([NSStringFromClass([touch.view class])    isEqualToString:@"UITableViewCellContentView"]) {
        //返回为NO则屏蔽手势事件
        return NO;
    }
    return YES;
}
-(void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    float x = self.backView.center.x + translation.x;
    float n = self.leftView.center.x + translation.x;
    
    if (x < self.view.center.x) {
        x = self.view.center.x;
    }
    if (n < -250) {
        n = -250;
    }
    
    
    NSLog(@"%f",_leftView.frame.origin.x);
    NSLog(@"%f",_backView.frame.origin.x);
    float alphaFloat = self.view.center.x/x;
    
    if (!_blackView) {
        _blackView = [[UIView alloc]initWithFrame:_backView.frame];
        _blackView.alpha = 0.0;
        _blackView.backgroundColor = [UIColor blackColor];
        [_backView addSubview:_blackView];
    }
    if (alphaFloat >= 0.5) {
        _blackView.alpha = 1-alphaFloat;
    }else{
        _blackView.alpha = 0.5;
    }
    
    self.backView.center = CGPointMake(x, openPointCenter.y);
    self.leftView.center = CGPointMake(n, leftOpenPointCenter.y);
    
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.2
                              delay:0.01
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void)
         {
             if (x > openPointCenter.x -  DIVIDWIDTH) {
                 _blackView.alpha = 0.5;
                 self.backView.center = openPointCenter;
                 self.leftView.center = leftOpenPointCenter;
             }else{
                 _blackView.alpha = 0.0;
                 _blackView = nil;
                 [_blackView removeFromSuperview];
                 self.backView.center = CGPointMake(openPointCenter.x - OPENCENTERX,
                                                    openPointCenter.y);
                 self.leftView.center = CGPointMake(leftOpenPointCenter.x - OPENCENTERX,
                                                    leftOpenPointCenter.y);
                 if ([GlobalData sharedInstance].user.userInfo.attribute1 && [[GlobalData sharedInstance].user.userInfo.attribute1 length]>0) {
                     _leftView.sureButton.hidden = YES;
                     _leftView.refereesTextField.userInteractionEnabled = NO;
                     _leftView.refereesTextField.text = [GlobalData sharedInstance].user.userInfo.attribute1;
                 }else{
                     _leftView.sureButton.hidden = NO;
                     _leftView.refereesTextField.userInteractionEnabled = YES;
                 }
                 [_leftView.refereesTextField resignFirstResponder];

             }
             
         }completion:^(BOOL isFinish){
             
         }];
    }
    
    [recognizer setTranslation:CGPointZero inView:self.backView];
}

-(void) handleTap:(UITapGestureRecognizer*) recognizer
{
    [_leftView.refereesTextField resignFirstResponder];
    [UIView animateWithDuration:0.2
                          delay:0.01
                        options:UIViewAnimationOptionTransitionCurlUp animations:^(void){
                            _blackView.alpha = 0.0;
                            _blackView = nil;
                            [_blackView removeFromSuperview];
                            self.backView.center = CGPointMake(openPointCenter.x - OPENCENTERX,
                                                               openPointCenter.y);
                            self.leftView.center = CGPointMake(leftOpenPointCenter.x - OPENCENTERX,
                                                               leftOpenPointCenter.y);
                            if ([GlobalData sharedInstance].user.userInfo.attribute1 && [[GlobalData sharedInstance].user.userInfo.attribute1 length]>0) {
                                _leftView.sureButton.hidden = YES;
                                _leftView.refereesTextField.userInteractionEnabled = NO;
                                _leftView.refereesTextField.text = [GlobalData sharedInstance].user.userInfo.attribute1;
                            }else{
                                _leftView.sureButton.hidden = NO;
                                _leftView.refereesTextField.userInteractionEnabled = YES;
                            }
                        }completion:nil];
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
    [_backView addSubview:_top_container];
    [_top_container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(_backView);
        make.height.mas_equalTo(60);
        make.width.equalTo(_backView);
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
//            UserCenterController *center = [[UserCenterController alloc] init];
//            [self.navigationController pushViewController:center animated:YES];
            if ([GlobalData sharedInstance].user.userInfo.attribute1 && [[GlobalData sharedInstance].user.userInfo.attribute1 length]>0) {
                _leftView.sureButton.hidden = YES;
                _leftView.refereesTextField.userInteractionEnabled = NO;
                _leftView.refereesTextField.text = [GlobalData sharedInstance].user.userInfo.attribute1;
            }else{
                _leftView.sureButton.hidden = NO;
                _leftView.refereesTextField.userInteractionEnabled = YES;
            }
            if (!_blackView) {
                _blackView = [[UIView alloc]initWithFrame:_backView.frame];
                _blackView.alpha = 0.0;
                _blackView.backgroundColor = [UIColor blackColor];
                [_backView addSubview:_blackView];
            }
            [UIView animateWithDuration:0.2
                                  delay:0.01
                                options:UIViewAnimationOptionTransitionCurlUp animations:^(void){
                                    _blackView.alpha = 0.5;
                                    self.backView.center = openPointCenter;
                                    self.leftView.center = leftOpenPointCenter;
                                }completion:nil];

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

        UserCenterController *center = [[UserCenterController alloc] init];
        EditUserController *editor = [[EditUserController alloc] init];
        OrderListController *order = [[OrderListController alloc] init];
        WalletController *wallet =[[WalletController alloc] init];
        setUpViewController *setUpVC =[[setUpViewController alloc] initWithNibName:@"setUpViewController" bundle:nil];
        helpViewController *helpVC =[[helpViewController alloc] initWithNibName:@"helpViewController" bundle:nil];
        
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
            case 10:
                editor.delegateCallback = self;
                [self.navigationController pushViewController:editor animated:YES];

//                [self.navigationController pushViewController:center animated:YES];
                break;
            case 11:
                [self.navigationController pushViewController:order animated:YES];

                break;
            case 12:
                [self.navigationController pushViewController:wallet animated:YES];
                break;
            case 13:
                [self.navigationController pushViewController:setUpVC animated:YES];
                break;
            case 14:
                [self.navigationController pushViewController:helpVC animated:YES];
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
        [_backView addSubview:currentController.view];
        [currentController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_top_container.mas_bottom);
            make.left.equalTo(_backView);
            make.right.equalTo(_backView);
            make.bottom.equalTo(_backView);
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
    
    if ([@"21" isEqualToString:order.type]) {
        NSString *tmp2= [[NSBundle mainBundle] pathForResource:@"newMessage" ofType:@"m4r"];
        NSURL *moveMP32=[NSURL fileURLWithPath:tmp2];
        NSError *err=nil;
        self.movePlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:moveMP32 error:&err];
        self.movePlayer.volume=1.0;
        [self.movePlayer prepareToPlay];
        [self.movePlayer play];
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
- (void)sureButton:(UIButton *)sender {
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:_leftView.refereesTextField.text forKey:@"introducer"];
    [param setObject:[GlobalData sharedInstance].user.userInfo.ids forKey:@"id"];
    [UserInfoModel commitEditUserInfo:param succ:^(NSDictionary *resultDictionary) {
        NSLog(@"result:%@",resultDictionary);
        NSDictionary *data = resultDictionary[@"data"];
        UserInfoModel *user = [[UserInfoModel alloc] initWithDictionary:data error:nil];
        [GlobalData sharedInstance].user.userInfo = user;
        [[GlobalData sharedInstance].user save];
        
        
        [MBProgressHUD showAndHideWithMessage:@"保存成功" forHUD:nil onCompletion:^{
            _leftView.sureButton.hidden = YES;
            _leftView.refereesTextField.userInteractionEnabled = YES;
            _leftView.refereesTextField.text = [GlobalData sharedInstance].user.userInfo.attribute1;
        }];
        
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
    }];
    
}
@end
