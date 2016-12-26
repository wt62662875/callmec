//
//  UserInfoModel.m
//  callmec
//
//  Created by sam on 16/6/22.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel


+ (void) login:(NSString *)username withPwd:(NSString *)pwd succ:(QuerySuccessBlock)suc fail:(QueryErrorBlock)fai
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:username forKey:@"loginName"];
    [params setObject:pwd forKey:@"loginPwd"];
    if([GlobalData sharedInstance].clientId)
    {
        [params setObject:[GlobalData sharedInstance].clientId forKey:@"clientId"];
    }
    
    [HttpShareEngine callWithFormParams:params withMethod:@"cLogin" succ:^(NSDictionary *resultDictionary) {
        if (suc) {
            suc(resultDictionary);
        }
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        if (fai) {
            fai(errorCode,errorMessage);
        }
    }];
}

+ (void) fetchValidateCode:(NSString*)mobile succ:(QuerySuccessBlock)suc fail:(QueryErrorBlock)fai
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:mobile forKey:@"phoneNo"];

    [HttpShareEngine callWithFormParams:params withMethod:@"cAuthCode" succ:^(NSDictionary *resultDictionary) {
        if (suc) {
            suc(resultDictionary);
        }
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        if (fai) {
            fai(errorCode,errorMessage);
        }
    }];
}

+ (void) save:(UserInfoModel*)userinfo
{
    
}

+ (void) commitEditUserInfo:(NSMutableDictionary*)params succ:(QuerySuccessBlock)suc fail:(QueryErrorBlock)fai
{
    
    [HttpShareEngine callWithFormParams:params withMethod:@"cEdit" succ:^(NSDictionary *resultDictionary) {
        if (suc) {
            suc(resultDictionary);
        }
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        if (fai) {
            fai(errorCode,errorMessage);
        }
    }];
}

+ (void) fetchUserHeaderImage:(NSString*)ids succ:(QuerySuccessBlock)suc fail:(QueryErrorBlock)fai
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:ids forKey:@"id"];
    //getDHeadIcon
    [HttpShareEngine callWithUrlParams:params withMethod:@"getMHeadIcon" succ:^(NSDictionary *resultDictionary) {
        if (suc) {
            suc(resultDictionary);
        }
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        if (fai) {
            fai(errorCode,errorMessage);
        }
    }];
}

#pragma Model key
- (NSString<Optional>*) birthday
{
    if (_birthday) {
        return _birthday;
    }
    return @"";
}

- (NSString<Optional>*)icon
{
    if (_icon) {
        return _icon;
    }
    return @"";
}
@end
