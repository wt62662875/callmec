//
//  TripAddressModel.h
//  callmec
//
//  Created by sam on 16/6/29.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseModel.h"
#import "CarModel.h"
@interface TripAddressModel : BaseModel
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *iconUrl;
@property (nonatomic,assign) BOOL isSelfNeed;
@property (nonatomic,strong) NSString *needTime;
@property (nonatomic,strong) NSString *startLocation;
@property (nonatomic,strong) NSString *endLocation;
@property (nonatomic,strong) CarModel *carModel;
@end
