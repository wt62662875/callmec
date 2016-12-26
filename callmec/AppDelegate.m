//
//  AppDelegate.m
//  callmec
//
//  Created by sam on 16/6/21.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeMapController.h"
#import "AppDelegate+AMap.h"
#import "AppDelegate+CategorySet.h"
#import "AppDelegate+ThirdLogin.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "chooseRootViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置网络亲求时，状态了里展示请求的进度条
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [self netWorkStatusListener];
    //[HttpShareEngine sharedInstance];
    // 创建键盘管理工具单利
    IQKeyboardManager *keyBoardManager = [IQKeyboardManager sharedManager];
    keyBoardManager.enable = YES;
    keyBoardManager.shouldResignOnTouchOutside = YES;
    keyBoardManager.shouldToolbarUsesTextFieldTintColor = YES;
    keyBoardManager.enableAutoToolbar = NO;
    
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    UINavigationController *navctrl = [[UINavigationController alloc] initWithRootViewController:[[HomeMapController alloc]init]];
//    chooseRootViewController *chooseView = [[chooseRootViewController alloc]initWithNibName:@"chooseRootViewController" bundle:nil];
//    UINavigationController *navctrl = [[UINavigationController alloc]initWithRootViewController:chooseView];
    self.window.rootViewController = navctrl;
    [self.window makeKeyAndVisible];
    [self APNS:launchOptions];
    [self configureAPIKey];
    [self configIFlySpeech];
    [self setupWechat];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLocation) name:NOTICE_LOCATION_START object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopLocation) name:NOTICE_LOCATION_STOP object:nil];
//    [self initLocationConfig];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive");
    [self clearBadge:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/***********************
 *调起第三方应用
 ***********************/
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    return [self applicationDealWithOpenURL:url];
}

/**************
 *
 **************/
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication  annotation:(id)annotation {
    return [self applicationDealWithOpenURL:url];
}

- (void) netWorkStatusListener
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
            //网络变化的通知
        [GlobalData sharedInstance].netStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
            NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus([GlobalData sharedInstance].netStatus));
    }];
        // 开始监测网络
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
