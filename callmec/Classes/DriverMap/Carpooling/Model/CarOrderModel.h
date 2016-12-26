//
//  CarPoolingModel.h
//  callmec
//  拼车信息模型
//  Created by sam on 16/7/24.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseModel.h"
#import "AppiontRouteModel.h"
#import "DriverOrderInfo.h"
#import "AppiontBusModel.h"

@class AppiontBusModel;
@interface CarOrderModel : BaseModel
/*
 arrivalDate = "2016-08-06 03:42";
 bizType = 1;
 carDesc = "";
 carNo = "\U4e91AA8888";
 carType = 3;
 createDate = "2016-08-06 03:42";
 dGender = 0;
 dLatitude = "23.17771809895833";
 dLevel = 4;
 dLongitude = "113.5848516167535";
 dPhoneNo = 13560360291;
 dRealName = "\U5f20\U4e09";
 dServiceNum = 63;
 dType = 0;
 driverId = 9;
 mPhoneNo = 13570901783;
 startDate = "2016-08-06 03:42";
 */
@property (nonatomic,copy) NSString<Optional> *actFee;
@property (nonatomic,copy) NSString<Optional> *appoint;
@property (nonatomic,copy) NSString<Optional> *appointDate;
@property (nonatomic,copy) NSString<Optional> *carPoolNum;
@property (nonatomic,copy) NSString<Optional> *createDate;
@property (nonatomic,copy) NSString<Optional> *descriptions;
@property (nonatomic,copy) NSString<Optional> *elocation;
@property (nonatomic,copy) NSString<Optional> *elatitude;
@property (nonatomic,copy) NSString<Optional> *elongitude;
@property (nonatomic,copy) NSString<Optional> *fee;
@property (nonatomic,copy) NSString<Optional> *ids;
@property (nonatomic,copy) NSString<Optional> *lineDesc;
@property (nonatomic,copy) NSString<Optional> *lineId;
@property (nonatomic,copy) NSString<Optional> *lineName;
@property (nonatomic,copy) NSString<Optional> *lineDis;
@property (nonatomic,copy) NSString<Optional> *lineElat;
@property (nonatomic,copy) NSString<Optional> *lineElong;
@property (nonatomic,copy) NSString<Optional> *lineSlat;
@property (nonatomic,copy) NSString<Optional> *lineSlong;

@property (nonatomic,copy) NSString<Optional> *mRealName;
@property (nonatomic,copy) NSString<Optional> *no;
@property (nonatomic,copy) NSString<Optional> *orderPerson;
@property (nonatomic,copy) NSString<Optional> *otherFee;
@property (nonatomic,copy) NSString<Optional> *slatitude;
@property (nonatomic,copy) NSString<Optional> *slocation;
@property (nonatomic,copy) NSString<Optional> *slongitude;
@property (nonatomic,copy) NSString<Optional> *state;
@property (nonatomic,copy) NSString<Optional> *type;
@property (nonatomic,copy) NSString<Optional> *oType;
@property (nonatomic,copy) NSString<Optional> *distance;

@property (nonatomic,copy) NSString<Optional> *arrivalDate;
@property (nonatomic,copy) NSString<Optional> *bizType;  ///bizType : 1, // 抢单 1， 派单 2 适用专车
@property (nonatomic,copy) NSString<Optional> *carDesc;
@property (nonatomic,copy) NSString<Optional> *carNo;
@property (nonatomic,copy) NSString<Optional> *mPhoneNo;
@property (nonatomic,copy) NSString<Optional> *dGender;
@property (nonatomic,copy) NSString<Optional> *dLatitude;
@property (nonatomic,copy) NSString<Optional> *dLevel;
@property (nonatomic,copy) NSString<Optional> *dLongitude;
@property (nonatomic,copy) NSString<Optional> *dPhoneNo;
@property (nonatomic,copy) NSString<Optional> *dRealName;
@property (nonatomic,copy) NSString<Optional> *dServiceNum;
@property (nonatomic,copy) NSString<Optional> *dType;       //driverType : 1, //1 => 自营  2挂靠
@property (nonatomic,copy) NSString<Optional> *driverId;
@property (nonatomic,copy) NSString<Optional> *startDate;
@property (nonatomic,copy) NSString<Optional> *cancelled;
//oType


+ (void) fetchCarPoolingOrderList:(NSInteger)page Succes:(QuerySuccessListBlock)suc failed:(QueryErrorBlock)fail;
+ (void) fetchOrderList:(NSInteger)page Succes:(QuerySuccessListBlock)suc failed:(QueryErrorBlock)fail;
+ (CarOrderModel*) convertDriverModel:(DriverOrderInfo*)model;
+ (CarOrderModel*) convertAppiontBusModel:(AppiontBusModel*)model;
+ (void) fetchOrderList:(NSInteger)page withType:(NSString*)type Succes:(QuerySuccessListBlock)suc failed:(QueryErrorBlock)fail;
@end
