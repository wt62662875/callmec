//
//  BaseNavController.h
//  callmec
//
//  Created by sam on 16/6/23.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
//#import "DDLocation.h"
//#import "DDSearchViewController.h"
//#import "DDSearchManager.h"

//#import "DDDriverManager.h"
//#import "DDLocationView.h"

#import "iflyMSC/IFlySpeechError.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"

typedef NS_ENUM(NSUInteger, CMState) {
    CMState_Init = 0,               //初始状态，显示选择终点
    CMState_Confirm_Destination,    //选定起始点和目的地，显示马上叫车
    CMState_Call_Taxi,              //正在叫车，显示我已上车
    CMState_On_Taxi,                //正在车上状态，显示支付
    CMState_Finish_pay  //到达终点，显示评价
};

@interface BaseNavController : BaseController <MAMapViewDelegate,IFlySpeechSynthesizerDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

- (void)initMapView;

- (void)initIFlySpeech;

- (void)returnAction;
@end
