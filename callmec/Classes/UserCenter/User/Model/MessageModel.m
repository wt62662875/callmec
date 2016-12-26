//
//  MessageModel.m
//  callmec
//
//  Created by sam on 16/7/6.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel


+ (void) fetchMessageListWithPage:(NSInteger)page success:(QuerySuccessListBlock)list failed:(QueryErrorBlock)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if ([GlobalData sharedInstance].user.isLogin) {
        [params  setObject:[GlobalData sharedInstance].user.userInfo.ids forKey:@"ownerId"];
    }
    [params setObject:@"1" forKey:@"state"];
    [params setObject:@"3" forKey:@"type"];
    [params setObject:@"10" forKey:@"pageSize"];
    if (page>0) {
        [params setObject:@(page) forKey:@"page"];
    }else{
        [params setObject:@"1" forKey:@"page"];
    }
    
    [HttpShareEngine callWithFormParams:params withMethod:@"listMessage" succList:^(NSArray *result, int pageCount, int recordCount) {
        if (list) {
            list(result,pageCount,recordCount);
        }
    } fail:fail];
}
@end
