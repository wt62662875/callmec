//
//  CarPoolingModel.m
//  callmec
//
//  Created by sam on 16/7/24.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "CarOrderModel.h"

@implementation CarOrderModel

+ (void) fetchCarPoolingOrderList:(NSInteger)page Succes:(QuerySuccessListBlock)suc failed:(QueryErrorBlock)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"desc" forKey:@"orderBy"];
    [params setObject:@"20" forKey:@"state"];
    [params setObject:@"2" forKey:@"type"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@"10" forKey:@"pageSize"];
    [params setObject:@"0" forKey:@"hasmemberId"];
    [params setObject:@"3" forKey:@"latest"];
    [HttpShareEngine callWithFormParams:params withMethod:@"listOrder" succList:^(NSArray *result,int pageCount,int recordCount)
    {
        if (suc) {
            suc(result,pageCount,recordCount);
        }
    } fail:fail];
}

+ (void) fetchOrderList:(NSInteger)page Succes:(QuerySuccessListBlock)suc failed:(QueryErrorBlock)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"desc" forKey:@"orderBy"];
    [params setObject:@"20" forKey:@"state"];
//    [params setObject:@"2" forKey:@"type"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@"10" forKey:@"pageSize"];
    [params setObject:@"0" forKey:@"hasmemberId"];
    
    [HttpShareEngine callWithFormParams:params withMethod:@"listOrder" succList:^(NSArray *result,int pageCount,int recordCount)
     {
         if (suc) {
             suc(result,pageCount,recordCount);
         }
     } fail:fail];
}


+ (void) fetchOrderList:(NSInteger)page withType:(NSString*)type Succes:(QuerySuccessListBlock)suc failed:(QueryErrorBlock)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"desc" forKey:@"orderBy"];
    [params setObject:@"20" forKey:@"state"];
    [params setObject:type forKey:@"type"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@"10" forKey:@"pageSize"];
    [params setObject:@"0" forKey:@"hasmemberId"];
    
    [HttpShareEngine callWithFormParams:params withMethod:@"listOrder" succList:^(NSArray *result,int pageCount,int recordCount)
     {
         if (suc) {
             suc(result,pageCount,recordCount);
         }
     } fail:fail];
    
}


+ (CarOrderModel*) convertDriverModel:(DriverOrderInfo*)model
{
 
    CarOrderModel *driverInfo = [[CarOrderModel alloc] initWithString:[model toJSONString] error:nil];
    if (driverInfo) {
        driverInfo.dServiceNum = model.serviceNum;
        driverInfo.dRealName = model.driverName;
        driverInfo.fee = model.actFee;
        driverInfo.dPhoneNo = model.phoneNo;
        driverInfo.dLevel = model.level;
        driverInfo.dType = model.driverType;
        driverInfo.dGender = model.gender;
        driverInfo.dLatitude = model.latitude;
        driverInfo.dLongitude = model.longitude;
    }
    return driverInfo;
}
+ (CarOrderModel*) convertAppiontBusModel:(AppiontBusModel*)model
{
    CarOrderModel *driverInfo = [[CarOrderModel alloc] initWithString:[model toJSONString] error:nil];
    if (driverInfo) {
     
    }
    return driverInfo;
}
@end
