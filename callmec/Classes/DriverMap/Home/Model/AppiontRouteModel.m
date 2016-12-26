//
//  AppiontRouteModel.m
//  callmec
//
//  Created by sam on 16/7/22.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "AppiontRouteModel.h"

@implementation AppiontRouteModel

+ (void) fetchAppiontRouteWithPage:(NSInteger)page withKeyWords:(NSString*)key withEnd:(NSString*)end Success:(QuerySuccessListBlock)succ failed:(QueryErrorBlock)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@"1" forKey:@"state"];
    if (key) {
        [params setObject:key forKey:@"slocation"];
    }
    if (end) {
        [params setObject:end forKey:@"elocation"];
    }
    [params setObject:@(10) forKey:@"pageSize"];
    
    [HttpShareEngine callWithFormParams:params withMethod:@"listLine" succList:^(NSArray *result, int pageCount, int recordCount) {
        if (succ) {
            succ(result,pageCount,recordCount);
        }
    } fail:fail];
}
@end
