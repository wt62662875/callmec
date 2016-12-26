//
//  WaitingGoodsCarController.h
//  callmec
//
//  Created by sam on 16/8/12.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseController.h"
#import "BaseNavController.h"

@interface WaitingGoodsCarController : BaseNavController
@property (nonatomic,strong) CarOrderModel *model;
@property (nonatomic,strong) NSDictionary *model_dict;
@property (nonatomic,copy) NSString *orderId;
@end
