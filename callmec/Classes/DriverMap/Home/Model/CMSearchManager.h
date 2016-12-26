//
//  DDSearchManager.h
//  TripDemo
//
//  Created by xiaoming han on 15/4/3.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "CMLocation.h"
typedef void(^CMSearchCompletionBlock)(id request, id response, NSError *error);

typedef void(^CMSearchResultWithCMLocationBlock)(id request,CMLocation *location,NSError *error);

/**
 *  搜索管理类。对高德搜索SDK进行了封装，使用block回调，无需频繁设置代理。
 */
@interface CMSearchManager : NSObject

+ (instancetype)sharedInstance;

- (void)searchForRequest:(id)request completionBlock:(CMSearchCompletionBlock)block;

- (void)searchForStartLocation:(CMLocation*)start end:(CMLocation*)end completionBlock:(CMSearchCompletionBlock)block;

- (void)searchLocation:(CLLocation*)location completionBlock:(CMSearchResultWithCMLocationBlock)block;
@end
