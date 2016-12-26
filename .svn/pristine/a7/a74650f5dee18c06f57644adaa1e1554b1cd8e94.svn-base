//
//  CMDriversManager.m
//  callmec
//
//  Created by sam on 16/6/24.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "CMDriversManager.h"

@implementation CMDriversManager


+ (instancetype)sharedInstance {
    static CMDriversManager *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[CMDriversManager alloc]init];
    });
    
    return _shared;
}

@end
