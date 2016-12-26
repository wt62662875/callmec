//
//  GlobalData.m
//  callmec
//
//  Created by sam on 16/6/22.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "GlobalData.h"


@implementation GlobalData

+ (instancetype)sharedInstance {
    static GlobalData *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[GlobalData alloc]init];
    });
    
    return _shared;
}


#pragma mark - 创建的时候注册一个通知，用于注销登录
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addNotifications];
    }
    return self;
}

//- (void) 


- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionInvalid:) name:SessionInvalidNotification object:nil];
}

#pragma mark - 注销登录
- (void)sessionInvalid:(NSNotification *)notification {
    //    [self.userInfo logout];
}

- (UserModel*) user
{
    if (!_user) {
        _user =[UserModel defaultUserInfo];
    }
    return _user;
}

- (void) setLocation:(CMLocation *)location
{
    _location = location;
}
@end
