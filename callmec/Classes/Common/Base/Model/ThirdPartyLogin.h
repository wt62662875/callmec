//
//  ThirdPartyLogin.h
//  crownbee
//
//  Created by Likid on 10/13/15.
//  Copyright © 2015 crownbee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseResp;

extern NSString *const WeChatAppID;
extern NSString *const WeChatAppSecret;

#pragma mark - 主要提供各种方法，用于微信授权和绑定

@interface ThirdPartyLogin : NSObject

- (void) setIsBind:(BOOL)isBind;
// 返回本身
+ (instancetype)sharedInstance;
// 通过token 和 openid 获取用户的微信信息
- (void)getUserInfoWithToken:(NSString *)token openID:(NSString *)openid;

// 使用微信用户信息进行微信登陆
- (void)weChatLoginWithParams:(NSDictionary *)wechatParams;

/**
 *  微信请求授权方法
 *
 *  @param viewController 请求的视图控制器
 *  @param success        请求成功的代码块
 *  @param failure        请求失败的代码块
 */
+ (void)weChatAuthRequestInViewController:(UIViewController *)viewController
                                  success:(LKObjectBlock)success
                                  failure:(QueryErrorBlock)failure;


/**
 *  微信请求授权方法
 *
 *  @param viewController 请求的视图控制器
 *  @param isBind         是否进行绑定
 *  @param success        请求成功的代码块
 *  @param failure        请求失败的代码块
 */
+ (void)weChatAuthRequestInViewController:(UIViewController *)viewController
                                   isBind:(BOOL)isBind
                                  success:(LKObjectBlock)success
                                  failure:(QueryErrorBlock)failure;


/**
 *  微信授权响应
 *
 *  @param resp 响应的内容
 */
+ (void)wechatAuthResponse:(BaseResp *)resp;



/**
 *  查询微信绑定是否成功
 */
+ (void)queryWeChatBindingOnSuccess:(LKObjectBlock)success failure:(QueryErrorBlock)failure;


/**
 *  绑定微信的方法
 *
 *  @param wechatParams 绑定的参数
 *  @param success      绑定成功信息
 *  @param failure      绑定失败信息
 */
+ (void)bindWeChatWithWechatParams:(NSDictionary *)wechatParams
                         OnSuccess:(LKObjectBlock)success
                           failure:(QueryErrorBlock)failure;



@end
