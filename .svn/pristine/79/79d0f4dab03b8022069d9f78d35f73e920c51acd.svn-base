//
//  AppDelegate+CategorySet.h
//  MiGuFM
//
//  Created by LiuYing on 15/12/14.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (CategorySet)

/**
 *  @brief 设置根控制器
 *
 *
 **/
- (void)_setRootViewController;

/**
 *  @brief shareSDK注册
 *
 *
 **/
- (void)registerShareSDK;

/**
 *  @brief 初始化IFlyMSC
 *
 *
 **/
- (void)initializeIFlyMSC;

/**
 *  @brief 友盟统计
 *
 *
 **/
- (void)umengTrack;

/**
 *  @brief 自动登陆
 *
 *
 **/
- (void)autoLogin;

@end



#pragma mark - APNS
@interface AppDelegate (APNS)

/**
 *  @brief 推送设置  包括远程推送与本地推送
 *
 *  @param launchOptions 启动信息
 *
 **/
- (void)APNS:(nullable NSDictionary *)launchOptions;

/**
 *  @brief 注册推送通知
 *
 *
 **/
- (void)registerUserNotification;

/**
 *  @brief 注册推送通知
 *
 *
 **/
- (void) clearBadge:(NSDictionary *)launchOptions;
/**
 *  @brief APP被“远程推送”启动时推送消息处理（APP 未启动--》启动）
 *
 *  @param launchOptions 启动信息
 *
 **/
- (void)receiveRemoteNotificationByLaunchingOptions:(nullable NSDictionary *)launchOptions;

/**
 *  @brief APP被“本地推送”启动时推送消息处理（APP 未启动--》启动）
 *
 *  @param launchOptions 启动信息
 *
 **/
- (void)receiveLocalNotificationByLaunchingOptions:(nullable NSDictionary *)launchOptions;


- (void) didregisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken;

@end
