//
//  ViewController.h
//  callmec
//
//  Created by sam on 16/6/21.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavController.h"
#import "CMLocation.h"
#import "CarOrderModel.h"

@interface WaitDriverController : BaseNavController
@property (nonatomic, strong) CMLocation * currentLocation;
@property (nonatomic, strong) CMLocation * destinationLocation;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic,strong) AMapPath *routPath;
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,strong) CarOrderModel *model;
@end

