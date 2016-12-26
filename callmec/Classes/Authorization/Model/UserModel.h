//
//  UserModel.h
//  callmec
//
//  Created by sam on 16/6/27.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : BaseModel
@property (nonatomic,copy) NSString *session;
@property (nonatomic,assign) BOOL isLogin;
@property (nonatomic,strong) UserInfoModel *userInfo;

- (void) logout;
- (void) save;
+ (void) saveUser:(UserModel*)model;
+ (UserModel*) defaultUserInfo;
+ (void) clearUp;

@end
