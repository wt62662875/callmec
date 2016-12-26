//
//  DriverInfoModel.h
//  callmec
//
//  Created by sam on 16/6/27.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseModel.h"

@interface DriverInfoModel : BaseModel
@property (nonatomic,copy) NSString<Optional> * bizType;
@property (nonatomic,copy) NSString<Optional> * carId;
@property (nonatomic,copy) NSString<Optional> * carType;
@property (nonatomic,copy) NSString<Optional> * descriptions;
@property (nonatomic,copy) NSString<Optional> * distance;
@property (nonatomic,copy) NSString<Optional> * duration;
@property (nonatomic,copy) NSString<Optional> * fullJob;
@property (nonatomic,copy) NSString<Optional> * gender;
@property (nonatomic,copy) NSString<Optional> * ids;
@property (nonatomic,copy) NSString<Optional> * identifierNo;
@property (nonatomic,copy) NSString<Optional> * latitude;
@property (nonatomic,copy) NSString<Optional> * licenseDate;
@property (nonatomic,copy) NSString<Optional> * licenseNo;
@property (nonatomic,copy) NSString<Optional> * licenseType;
@property (nonatomic,copy) NSString<Optional> * loginName;
@property (nonatomic,copy) NSString<Optional> * longitude;
@property (nonatomic,copy) NSString<Optional> * nativePlace;
@property (nonatomic,copy) NSString<Optional> * no;
@property (nonatomic,copy) NSString<Optional> * passed;
@property (nonatomic,copy) NSString<Optional> * phoneNo;
@property (nonatomic,copy) NSString<Optional> * ready;
@property (nonatomic,copy) NSString<Optional> * realName;
@property (nonatomic,copy) NSString<Optional> * regCity;
@property (nonatomic,copy) NSString<Optional> * state;

@end
