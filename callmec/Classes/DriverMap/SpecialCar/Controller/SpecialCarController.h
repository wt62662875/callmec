//
//  SpecialCarController.h
//  callmec
//
//  Created by sam on 16/6/28.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseController.h"
#import "CMLocation.h"
#import "TripTypeModel.h"

@interface SpecialCarController : BaseController
@property (nonatomic,strong) CMLocation *startLocation;
@property (nonatomic,strong) CMLocation *endLocation;
@property (nonatomic,assign) BOOL isNowUseCar;
@property (nonatomic,strong) TripTypeModel *carTypeModel;
@end
