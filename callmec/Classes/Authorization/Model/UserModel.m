//
//  UserModel.m
//  callmec
//
//  Created by sam on 16/6/27.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "UserModel.h"
#define UserInfoFileName @"userinfo"
@implementation UserModel


- (void) logout
{
    if (self.isLogin == NO) {
        return;
    }
    self.isLogin = NO;
    self.session = @"";
    [UserModel clearUp];
    
    [GlobalData sharedInstance].user = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_USERINFO_UPDATE object:nil];
    [self logoutNetWork];

}

- (void) logoutNetWork
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [HttpShareEngine callWithFormParams:dict withMethod:@"cLogout" succ:^(NSDictionary *resultDictionary) {
        NSLog(@"result:%@",resultDictionary);
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        NSLog(@"errorMessage:%@",errorMessage);
    }];
}

+ (void) saveUser:(UserModel*)model
{
    
}

+ (NSString *)fetchCachesDirectory {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}

+ (NSString *) fetchUserInfoFromFilePath
{
    return [[UserModel fetchCachesDirectory] stringByAppendingPathComponent:UserInfoFileName];
}


#pragma mark - 保存基本的用户的基本信息
+ (void)saveUser {
    [UserModel saveUserInfo:[GlobalData sharedInstance].user];
}

/***********************************
 * 保存文件存储的用户信息
 ************************************/
+ (void) saveUserInfo:(UserModel *)info {
    if (info) {
        [NSKeyedArchiver archiveRootObject:info toFile:[UserModel fetchUserInfoFromFilePath]];
    }
}

- (void) save{
    [UserModel saveUserInfo:self];
}

- (void) saveUser:(UserModel*)userinfo
{
    [self save];
}

+(UserModel*) defaultUserInfo
{
    // 从指定的路径中解档出用户的基本信息
    NSString *path = [UserModel fetchUserInfoFromFilePath];
    UserModel *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (user == nil) {
        user = [[UserModel alloc] init];
        user.isLogin = NO;
        user.session = @"";
    }
    return user;
}

+ (void) clearUp{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [UserModel fetchUserInfoFromFilePath];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
}

@end
