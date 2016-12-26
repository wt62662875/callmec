//
//  DriverOrderInfo.m
//  callmec
//
//  Created by sam on 16/7/11.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "DriverOrderInfo.h"

@implementation DriverOrderInfo

+ (void) fetchOrderDetail:(NSString*)orderId success:(QuerySuccessBlock)succ failed:(QueryErrorBlock)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (orderId) {
        [params setObject:orderId forKey:@"id"];
    }
    [HttpShareEngine callWithFormParams:params withMethod:@"getOrderDetail" succ:^(NSDictionary *resultDictionary) {
        if (succ) {
            succ(resultDictionary);
        }
    } fail:fail];
}

+ (void) fetchOrderFee:(NSMutableDictionary*)dict success:(QuerySuccessBlock)succ failed:(QueryErrorBlock)fail
{
    [HttpShareEngine callWithFormParams:dict withMethod:@"calculateOrder" succ:^(NSDictionary *resultDictionary) {
        if (succ) {
            succ(resultDictionary);
        }
    } fail:fail];
}

- (void) setType:(NSString<Optional> *)type
{
    _type = type;
//    if (type) {
//        if ([type intValue]==9) {
//            _state = @"4";
//        }else if ([type intValue]==4) {
//            _state = @"5";
//        }else if ([type intValue]==5) {
//            _state = @"6";
//        }else{
//            _state = type;
//        }
//    }
}
@end
