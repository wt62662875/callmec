//
//  AppDelegate+CTCallCenter.m
//  MiGuFM
//
//  Created by LiuYing on 15/12/18.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "AppDelegate+CTCallCenter.h"
#import <objc/runtime.h>

@implementation AppDelegate (CTCallCenter)
@dynamic callCenter;


- (CTCallCenter *)callCenter {
    CTCallCenter *callCenter = objc_getAssociatedObject(self, @selector(callCenter));
    if (callCenter) return callCenter;
    callCenter = [[CTCallCenter alloc] init];
    objc_setAssociatedObject(self, @selector(callCenter), callCenter,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return callCenter;
}



@end
