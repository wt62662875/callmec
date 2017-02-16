//
//  AppDelegate+CategorySet.m
//  MiGuFM
//
//  Created by LiuYing on 15/12/14.
//  Copyright © 2015年 sam. All rights reserved.
//

#define kGtAppId           @"8R4WDNZ4qM8QqHwP6LlCh6"
#define kGtAppKey          @"z59Wwkc9cI9Djyz9pmJno7"
#define kGtAppSecret       @"1ltTyvL2t79aGZa3lY5mJ3"


#import "AppDelegate+CategorySet.h"
#import "GeTuiSdk.h"
#import "CarOrderModel.h"
#import "UserInfoModel.h"

//#import "UMSocial.h"
//#import "MobClick.h"
//#import "UMSocialWechatHandler.h"
//#import "UMSocialQQHandler.h"
//
//#import "BPush.h"


@interface AppDelegate() <GeTuiSdkDelegate>


@end

@implementation AppDelegate (CategorySet)

#pragma mark - 设置根控制器
- (void)_setRootViewController {
    
    /*AspTabController *tabController = [[AspTabController alloc] initWithViewControllers:@[[[ASPRecommendViewController alloc]init],
                                                                                          [[ASPDiscoverController alloc]init],
                                                                                          [[ASPCategoryNController alloc]init],
                                                                                          [[MyViewController alloc]init]]];
    
    [[AspGlobalData sharedInstance] setMTabController:tabController];
    [self.window setRootViewController:[[UINavigationController alloc] initWithRootViewController:tabController]];*/
}

#pragma mark -  shareSDK注册
- (void)registerShareSDK {
    /*
    [ShareSDK registerApp:@"c12bd686c48f"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeQQ), @(SSDKPlatformTypeWechat)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType) {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType) {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"2120487833"
                                                appSecret:@"eb97aab3cb26523e97f645104935a3b4"
                                              redirectUri:@"http://www.migu.cn/"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeQQ:
                      //设置Facebook应用信息，其中authType设置为只用SSO形式授权 老客户才有web
                      [appInfo SSDKSetupQQByAppId:@"1104858867" appKey:@"FPrwXvr2gnOT0IIk" authType:SSDKAuthTypeSSO];
                      break;
                  case SSDKPlatformTypeWechat: //wx578ac4b6acb464ac  9881f6ded9148579da6144772f913334
                      [appInfo SSDKSetupWeChatByAppId:@"wx578ac4b6acb464ac" appSecret:@"9881f6ded9148579da6144772f913334"];
                      break;
                  default:
                      break;
              }
          }];*/
}



#pragma mark - 初始化IFlyMSC
- (void)initializeIFlyMSC {
    //创建语音配置,appid必须要传入，仅执行一次则可
    
}

#pragma mark - 友盟统计
- (void)umengTrack {
    
//    [MobClick setCrashReportEnabled:YES];
//    
//    //设置友盟社会化组件appkey
//    [UMSocialData setAppKey:kUMAppKey];
//    #if DEBUG
//    //打开调试log的开关
//    [UMSocialData openLog:YES];
//    #endif
//    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
//    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
//    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
//    
//    //设置微信AppId，设置分享url，默认使用友盟的网址
//    [UMSocialWechatHandler setWXAppId:@"wx2118050177752a35" appSecret:@"1e3fb42e86a2840e08b094276ca40201" url:@"http://www.umeng.com/social"];
    
}

#pragma mark - 自动登陆
- (void)autoLogin {
    /*if (![AspUserinfo shareInstance].isLogin) {
        NSDictionary *dict = [AspUserinfo getUserInfo];
        if (!dict) return;
        
        [AspUserinfo userWithDict:dict];
        // 未登录
        [AspTool autoLoginWithUserType:[AspUserinfo shareInstance].userType
                               loginId:[AspUserinfo shareInstance].loginId
                              authType:1 pwd:[AspUserinfo shareInstance].pwd];
    }*/
}

@end



#pragma mark - APNS

@implementation AppDelegate (APNS)

#pragma mark - 推送设置  包括远程推送与本地推送
- (void)APNS:(NSDictionary *)launchOptions {
    
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    //开启推送权限
    [self registerUserNotification];
    //远程推送
//    [self receiveRemoteNotificationByLaunchingOptions:launchOptions];
    //本地推送
//    [self receiveLocalNotificationByLaunchingOptions:launchOptions];
    
    [self setupRemoteNotification:launchOptions];
    
    
    if (launchOptions) {
        //获取应用程序消息通知标记数（即小红圈中的数字）
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        if (badge>0) {
            //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
            badge--;
            //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
            NSDictionary *pushInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
            
            //获取推送详情
            NSString *pushString = [NSString stringWithFormat:@"%@",[pushInfo  objectForKey:@"aps"]];
            NSLog(@"pushInfo:%@",pushInfo);
        }
    }
}

- (void) clearBadge:(NSDictionary *)launchOptions
{
    //获取应用程序消息通知标记数（即小红圈中的数字）
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badge>0) {
        //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
        badge--;
        //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
        [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        if (launchOptions) {
            NSDictionary *pushInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
            NSString *pushString = [NSString stringWithFormat:@"%@",[pushInfo  objectForKey:@"aps"]];
            NSLog(@"pushInfo:%@",pushInfo);
        }
    }
}

#pragma mark - 推送通知
- (void)registerUserNotification {
    
    /*
     注册通知(推送)
     申请App需要接受来自服务商提供推送消息
     */
    
    // 判读系统版本是否是“iOS 8.0”以上
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
        [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)//UIUserNotificationTypeAlert |
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        //{"id”:”1111”,”type”:”1”,”oType”:”3”}
        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else { // iOS8.0 以前远程推送设置方式
        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音) //| UIRemoteNotificationTypeAlert
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound;
        
        // 注册远程通知 -根据远程通知类型
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}


- (void) setupRemoteNotification:(NSDictionary*)launchOptions
{

    /*
     通过“远程推送”启动APP
     UIApplicationLaunchOptionsRemoteNotificationKey 远程推送Key
     */
    //NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    /*
    [BPush registerChannel:launchOptions apiKey:@"o3z6fYMOHZaYC4m66FG5xy2k" pushMode:BPushModeDevelopment withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
    
    */
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}

#pragma mark - 用户通知(推送)回调 _IOS 8.0以上使用

/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}

#pragma mark - 远程通知(推送)回调

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // [3]:向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
    if ([GlobalData sharedInstance].user.isLogin) {
        //[GeTuiSdk bindAlias:[GlobalData sharedInstance].user.userInfo.phoneNo];
    }
    
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0; // 标签
    
    NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    // 处理APN
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    if (![[GlobalData sharedInstance].clientId isEqualToString:clientId]) {
        [UserInfoModel login:[SandBoxHelper fetchLoginNumber] withPwd:[SandBoxHelper fetchLoginRandomCode] succ:^(NSDictionary *resultDictionary) {
            NSLog(@"succes:%@",resultDictionary);
            UserInfoModel *userInfo = [[UserInfoModel alloc] initWithDictionary:[resultDictionary objectForKey:@"data"] error:nil];
            if (userInfo) {
                NSString *token = [resultDictionary objectForKey:@"token"];
                [GlobalData sharedInstance].user.session = token;
                [GlobalData sharedInstance].user.isLogin = YES;
                [GlobalData sharedInstance].user.userInfo = userInfo;
                [[GlobalData sharedInstance].user save];
            }else{
                [MBProgressHUD showAndHideWithMessage:@"解析失败" forHUD:nil];
            }
            
        } fail:^(NSInteger errorCode, NSString *errorMessage) {
            [MBProgressHUD showAndHideWithMessage:errorMessage forHUD:nil];
        }];
    }
    [GlobalData sharedInstance].clientId = clientId;
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    if ([GlobalData sharedInstance].user.isLogin) {
        [CarOrderModel fetchOrderList:1 Succes:^(NSArray *result, int pageCount, int recordCount) {
            NSLog(@"result:%@",result);
            for (NSDictionary *doc in result) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_ORDER_UNFIHISHED_STATE object:nil userInfo:doc];
                break;
            }
        } failed:^(NSInteger errorCode, NSString *errorMessage) {
            NSLog(@"errorMessage");
        }];
    }
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}


/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    
    // [4]: 收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    NSDictionary *dic = [payloadMsg lk_objectFromJSONString];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_ORDER_STATE_UPDATE object:nil userInfo:dic];
    NSLog(@"%@",dic);
   /*
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@", taskId, msgId, payloadMsg, offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
    */
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"\n>>>[GexinSdk DidSendMessage]:%@\n\n", msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
    NSLog(@"\n>>>[GexinSdk SdkState]:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"\n>>>[GexinSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    
    NSLog(@"\n>>>[GexinSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}
@end
