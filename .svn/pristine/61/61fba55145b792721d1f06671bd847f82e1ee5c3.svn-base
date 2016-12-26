//
//  CancelModel.m
//  callmec
//
//  Created by sam on 16/7/30.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "CancelModel.h"

@implementation CancelModel


+ (void) fetchCancelReasonListSuccess:(QuerySuccessListBlock)suc failed:(QueryErrorBlock)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"24" forKey:@"typeId"];
    [HttpShareEngine callWithFormParams:params withMethod:@"listCancelReason" succList:^(NSArray *result, int pageCount, int recordCount) {
        if (suc) {
            suc(result,pageCount,recordCount);
        }
    } fail:fail];
}
@end
