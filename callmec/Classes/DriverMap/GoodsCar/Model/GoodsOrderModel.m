//
//  GoodsOrderModel.m
//  callmec
//
//  Created by sam on 16/8/12.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "GoodsOrderModel.h"

@implementation GoodsOrderModel
+ (void) fetchGoodsOrderDetail:(NSString*)ids success:(QuerySuccessBlock)suc failed:(QueryErrorBlock)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (ids) {
        [params setObject:ids forKey:@"id"];
    }
    
    [HttpShareEngine callWithFormParams:params withMethod:@"getOrderDetail" succ:^(NSDictionary *resultDictionary) {
        if (suc) {
            suc(resultDictionary);
        }
    } fail:fail];
}
@end
