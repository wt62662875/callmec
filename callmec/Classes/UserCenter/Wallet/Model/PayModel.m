//
//  PayModel.m
//  callmec
//
//  Created by sam on 16/7/15.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "PayModel.h"

@implementation PayModel

+ (void) payOrderRequestOrderId:(NSString*)orderId withPayType:(NSString*)type succes:(QuerySuccessBlock)succ failed:(QueryErrorBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (orderId) {
        [param setObject:orderId forKey:@"id"];
    }
    if (type) {
        [param setObject:type forKey:@"payType"];
    }
    [HttpShareEngine callWithFormParams:param withMethod:@"signOrder" succ:^(NSDictionary *resultDictionary) {
        if (succ) {
            succ(resultDictionary);
        }
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        if (fail) {
            fail(errorCode,errorMessage);
        }
    }];
}
@end
