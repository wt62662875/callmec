//
//  DriverOrderInfo.h
//  callmec
//
//  Created by sam on 16/7/11.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseModel.h"

@interface DriverOrderInfo : BaseModel

@property (nonatomic,copy) NSString<Optional> *ids;
@property (nonatomic,copy) NSString<Optional> *driverName;
@property (nonatomic,copy) NSString<Optional> *gender;
@property (nonatomic,copy) NSString<Optional> *phoneNo;
@property (nonatomic,copy) NSString<Optional> *dLongitude;
@property (nonatomic,copy) NSString<Optional> *dLatitude;
@property (nonatomic,copy) NSString<Optional> *bizType;         //1 抢单 2派单
@property (nonatomic,copy) NSString<Optional> *actFee;
@property (nonatomic,copy) NSString<Optional> *type;
@property (nonatomic,copy) NSString<Optional> *rate;
@property (nonatomic,copy) NSString<Optional> *level;
@property (nonatomic,copy) NSString<Optional> *carNo;
@property (nonatomic,copy) NSString<Optional> *carDesc;
@property (nonatomic,copy) NSString<Optional> *serviceNum;
@property (nonatomic,copy) NSString<Optional> *driverId;
@property (nonatomic,copy) NSString<Optional> *driverType;      //1自营  2挂靠
@property (nonatomic,copy) NSString<Optional> *distance;        //距离
@property (nonatomic,copy) NSString<Optional> *appoint;
@property (nonatomic,copy) NSString<Optional> *sLocation;
@property (nonatomic,copy) NSString<Optional> *oType;
@property (nonatomic,copy) NSString<Optional> *eLocation;
@property (nonatomic,copy) NSString<Optional> *fee;
@property (nonatomic,copy) NSString<Optional> *no;
@property (nonatomic,copy) NSString<Optional> *state;
@property (nonatomic,copy) NSString<Optional> *cancelled;

@property (nonatomic,copy) NSString<Optional> *latitude;
@property (nonatomic,copy) NSString<Optional> *longitude;
+ (void) fetchOrderDetail:(NSString*)orderId success:(QuerySuccessBlock)succ failed:(QueryErrorBlock)fail;

+ (void) fetchOrderFee:(NSMutableDictionary*)dict success:(QuerySuccessBlock)succ failed:(QueryErrorBlock)fail;

@end
