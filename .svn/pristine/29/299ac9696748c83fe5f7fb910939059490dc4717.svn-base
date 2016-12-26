//
//  IntegrateModel.m
//  callmec
//
//  Created by sam on 16/8/17.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "IntegrateModel.h"

@implementation IntegrateModel

+ (void) fetchIntegrateList:(NSInteger)page type:(NSInteger)type accountId:(NSString*)ids success:(QuerySuccessListBlock)succes failed:(QueryErrorBlock)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(20) forKey:@"pageSize"];
    if (ids) {
        [params setObject:ids forKey:@"accountId"];
    }
    
    [params setObject:@(type) forKey:@"searchRange"];
    
    [HttpShareEngine callWithFormParams:params withMethod:@"listGrade" succList:^(NSArray *result, int pageCount, int recordCount) {
        if (succes) {
            succes(result,pageCount,recordCount);
        }
    } fail:fail];
}
@end
