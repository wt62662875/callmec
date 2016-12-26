//
//  WalletInfoModel.m
//  callmec
//
//  Created by sam on 16/7/13.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "WalletInfoModel.h"

@implementation WalletInfoModel


+ (void) fetchWalletInfoSuccess:(QuerySuccessBlock)sucess failed:(QueryErrorBlock)fail
{
    if (![GlobalData sharedInstance].user.isLogin)
    {
        NSLog(@"未登录");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GlobalData sharedInstance].user.userInfo.ids forKey:@"memberId"];
    [HttpShareEngine callWithFormParams:params withMethod:@"cAccount" succ:^(NSDictionary *resultDictionary) {
        if (sucess) {
            sucess(resultDictionary);
        }
    } fail:fail];
}
@end
