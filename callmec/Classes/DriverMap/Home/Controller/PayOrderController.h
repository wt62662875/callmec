//
//  PayOrderController.h
//  callmec
//
//  Created by sam on 16/7/17.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseController.h"

@interface PayOrderController : BaseController

@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,assign) BOOL isCanback;
+ (BOOL) hasVisiabled;
@end
