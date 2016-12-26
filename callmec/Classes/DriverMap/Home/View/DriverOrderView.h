//
//  DriverOrderView.h
//  callmec
//
//  Created by sam on 16/7/16.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriverOrderInfo.h"
#import "CarOrderModel.h"

@interface DriverOrderView : UIView
@property (nonatomic,strong) UIView *top_container;
@property (nonatomic,strong) buttonTaget handel;
@property (nonatomic,strong) CarOrderModel *model;
@property (nonatomic,assign) BOOL dismissWhenTouchOutside;
@end
