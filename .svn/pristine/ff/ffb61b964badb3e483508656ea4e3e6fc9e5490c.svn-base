//
//  ThirdPartyLogin.m
//  crownbee
//
//  Created by Likid on 10/13/15.
//  Copyright © 2015 crownbee. All rights reserved.
//

#import "ThirdPartyLogin.h"
#import "WXApi.h"
#import "payRequsestHandler.h"

NSString *const WeChatAppID = @"wx8eeabbb30fe1be98";
NSString *const WeChatAppSecret = @"89086dc308cab435ba9d25b9c99d63de";

@interface ThirdPartyLogin () <WXApiDelegate>

@property (copy, nonatomic) NSString *accessToken;
@property (copy, nonatomic) NSString *openId;
@property (copy, nonatomic) NSString *code;
@property (assign, nonatomic) BOOL isBind;
@property (copy, nonatomic) LKObjectBlock success;
@property (copy, nonatomic) QueryErrorBlock failure;

@end

@implementation ThirdPartyLogin


- (void) setIsBind:(BOOL)isBind
{
    _isBind = isBind;
}

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

+ (void)weChatAuthRequestInViewController:(UIViewController *)viewController
                                  success:(LKObjectBlock)success
                                  failure:(QueryErrorBlock)failure {
    [self weChatAuthRequestInViewController:viewController isBind:NO success:success failure:failure];
}

+ (void)weChatAuthRequestInViewController:(UIViewController *)viewController
                                   isBind:(BOOL)isBind
                                  success:(LKObjectBlock)success
                                  failure:(QueryErrorBlock)failure
{
    [ThirdPartyLogin sharedInstance].success = success;
    [ThirdPartyLogin sharedInstance].failure = failure;
    [ThirdPartyLogin sharedInstance].isBind = isBind;
    
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo,snsapi_base"; //应用授权作用域，如获取用户个人信息则填写snsapi_userinfo
    req.state = @"0789";  //用于保持请求和回调的状态，授权请求后原样带回给第三方。该参数可用于防止csrf攻击（跨站请求伪造攻击），建议第三方带上该参数，可设置为简单的随机数加session进行校验
    req.openID = [ThirdPartyLogin sharedInstance].openId;
    
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendAuthReq:req viewController:viewController delegate:AppDelegateInstance()];
}

+ (void)wechatAuthResponse:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResq = (id)resp;
        
        NSLog(@"errorCode: %d", authResq.errCode);
        if (authResq.errCode == 0) {
            [[self sharedInstance] getAccessTokenWithCode:authResq.code];
        } else {
            if ([ThirdPartyLogin sharedInstance].failure) {
                [ThirdPartyLogin sharedInstance].failure(authResq.errCode, authResq.errStr);
            }
        }
    }
}


/**
 *  通过code来获取用户的access_token
 */
- (void)getAccessTokenWithCode:(NSString *)code
{
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",APP_ID, APP_SECRET, code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%s %@", __FUNCTION__, data);
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"accessToken: %@", dict);
                
                self.accessToken = dict[@"access_token"];
                self.openId = dict[@"openid"];
                [self getUserInfoWithToken:self.accessToken openID:self.openId];
            }
        });
    });
}

/**
 *  通过token来获取用户的个人信息
 */
- (void)getUserInfoWithToken:(NSString *)token openID:(NSString *)openid
{
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token, openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%s %@", __FUNCTION__, data);
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"getUserInfo: %@", dict);
                // 保存微信个人用户信息
                /*WeChatInfo * weCahtInfo = [[WeChatInfo alloc]init];
                weCahtInfo.city = dict[@"city"];
                weCahtInfo.country = dict[@"country"];
                weCahtInfo.headimgurl = dict[@"headimgurl"];
                weCahtInfo.language = dict[@"language"];
                weCahtInfo.nickname = dict[@"nickname"];
                weCahtInfo.openid = dict[@"openid"];
                weCahtInfo.privilege = dict[@"privilege"];
                weCahtInfo.province = dict[@"province"];
                weCahtInfo.sex = dict[@"sex"];
                weCahtInfo.unionid = dict[@"unionid"];
                [WeChatInfo saveWeChatInfo:weCahtInfo];
                */
//                NSLog(@"RRRRRRRRRRRRRRRRRRRRRRRRRR:%@", [WeChatInfo unSaveWeChatInfo]);
                
                [self weChatLoginWithParams:dict];
            }
        });
    });
}

- (void)weChatLoginWithParams:(NSDictionary *)wechatParams {
    if (self.isBind) {
        if (self.success) {
            self.success(@{@"Wechat": wechatParams});
        }
    } else {

        [[HttpShareEngine sharedInstance] callWithParams:wechatParams method:@"App2/user/weixinlogin"
        OnCompletion:^(NSDictionary *resultDictionary) {
            id params = resultDictionary;
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
            [dic setObject:wechatParams forKey:@"Wechat"];
            if (self.success) {
                self.success(dic);
            }
        }
        onError:^(NSInteger errorCode, NSString *errorMessage) {
            if (self.failure) {
                self.failure(errorCode, errorMessage);
            }
        }];
    }
}

+ (void)queryWeChatBindingOnSuccess:(LKObjectBlock)success failure:(QueryErrorBlock)failure {
    /*
     params.put("ST", st);
     object.put("methods", "app/user/stweixin");
     */

    NSString *session = @"";//[GlobalData sharedInstance].userInfo.session;

    [[HttpShareEngine sharedInstance] callWithParams:@{
        @"ST" : session
    } method:@"app/user/stweixin" OnCompletion:^(NSDictionary *resultDictionary) {
        if (success) {
            success(resultDictionary);
        }
    } onError:failure];
}

+ (void)bindWeChatWithWechatParams:(NSDictionary *)wechatParams
                         OnSuccess:(LKObjectBlock)success
                           failure:(QueryErrorBlock)failure {
    /*
     params.put("ST", st);
     object.put("methods", "app/user/addweixin");
     params.put("extra_params", op);
     */
    NSString *session = @"";//[GlobalData sharedInstance].userInfo.session;

    [[HttpShareEngine sharedInstance] callWithParams:@{
        @"ST" : session,
        @"extra_params" : wechatParams
    } method:@"app/user/addweixin" OnCompletion:^(NSDictionary *resultDictionary) {
        if (success) {
            success(resultDictionary);
        }
    } onError:failure];
}

@end
