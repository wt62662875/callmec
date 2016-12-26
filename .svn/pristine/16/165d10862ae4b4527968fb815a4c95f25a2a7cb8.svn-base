//
//  AppiontBusModel.m
//  callmec
//
//  Created by sam on 16/9/3.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "AppiontBusModel.h"

@implementation AppiontBusModel


+ (void)appiontBus:(NSMutableDictionary*)dict succes:(QuerySuccessBlock)suc failed:(QueryErrorBlock)fail
{
    [HttpShareEngine callWithFormParams:dict withMethod:@"createPreOrder" succ:suc fail:fail];
}

+ (void)appiontBusCancel:(NSString*)ids reason:(NSString*)reason succes:(QuerySuccessBlock)suc failed:(QueryErrorBlock)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(ids)[params setObject:ids forKey:@"id"];
    if (reason) {
        [params setObject:reason forKey:@"cancelReason"];
    }
    [HttpShareEngine callWithFormParams:params withMethod:@"cancelPreOrder" succ:suc fail:fail];
}
@end
