//
//  OrderModel.m
//  callmec
//
//  Created by sam on 16/7/7.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel


+ (void) fetchOrderListById:(NSString*)ids types:(NSString*)type page:(NSInteger)page succes:(QuerySuccessListBlock)suc failed:(QueryErrorBlock)fail
{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (ids) {
        [param setObject:ids forKey:@"memberId"];
    }
    if (type) {
        [param setObject:type forKey:@"type"];
    }
    if (page>=0) {
        [param setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    }
    [param setObject:@"5" forKey:@"pageSize"];
//    [param setObject:@"1" forKey:@"state"];
    [param setObject:@"desc" forKey:@"orderBy"];
    [HttpShareEngine callWithFormParams:param withMethod:@"listOrder" succ:^(NSDictionary *resultDictionary) {
//        NSLog(@"resultDictionary:%@",resultDictionary);
        NSString *total =[resultDictionary objectForKey:@"total"];
        NSArray *dataList =[resultDictionary objectForKey:@"rows"];
        if (suc) {
            suc(dataList,(int)page,[total intValue]);
        }
        
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        if (fail) {
            fail(errorCode,errorMessage);
        }
    }];
    /*
    [HttpShareEngine callWithFormParams:param withMethod:@"listOrder" succList:^(NSArray *result, int pageCount, int recordCount) {
        if (suc) {
            suc(result,pageCount,recordCount);
        }
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        if (fail) {
            fail(errorCode,errorMessage);
        }
    }];
    */
}

- (NSString<Optional>*) level
{
    if (_level==nil) {
        return @"4";
    }
    return _level;
}

+ (void) submitComment:(NSMutableDictionary*)params succes:(QuerySuccessBlock)suc failed:(QueryErrorBlock)fail
{
    [params setObject:@"1" forKey:@"type"];
    /**
     type : 1, // 评价类型, 1代表针对订单后的评价, 以后可能有其他评价
     ownerId: 1, //评价对象Id， 订单ID
     level : 5, //评价等级
     description : "师傅不错" // 评价描述
     **/
    [HttpShareEngine callWithFormParams:params withMethod:@"commentOrder" succ:^(NSDictionary *resultDictionary) {
        if (suc) {
            suc(resultDictionary);
        }
    } fail:fail];
}
@end
