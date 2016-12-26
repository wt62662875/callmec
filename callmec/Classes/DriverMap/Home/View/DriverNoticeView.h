//
//  DriverOrderView.h
//  callmec
//  司机接单后界面
//  Created by sam on 16/7/11.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarOrderModel.h"
#import "CMSearchManager.h"

//typedef void (^QuerySuccessBlock)(NSDictionary* resultDictionary);

@interface DriverNoticeView : UIView
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) buttonTaget handel;
@property (nonatomic,strong) CarOrderModel *model;
@property (nonatomic,strong) CMLocation *endLocation;
@property (nonatomic,strong) CMLocation *startLocation;
//@property (nonatomic,assign) 
@end
