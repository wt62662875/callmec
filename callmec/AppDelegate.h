//
//  AppDelegate.h
//  callmec
//
//  Created by sam on 16/6/21.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

static inline AppDelegate *AppDelegateInstance() {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

