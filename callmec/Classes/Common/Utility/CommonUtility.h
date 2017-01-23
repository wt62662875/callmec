//
//  CommonUtility.h
//  SearchV3Demo
//
//  Created by songjian on 13-8-22.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface CommonUtility : NSObject

+ (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token;

+ (NSArray *)pathForCoordinateString:(NSString *)coordinateString;

+ (NSString*) getOrderDescription:(NSString*)state;
+ (NSString*) getGoodsOrderDesc:(NSString*)state;
+ (NSString*) userHeaderImageUrl:(NSString*)ids;
+ (NSString*) driverHeaderImageUrl:(NSString*)ids;

+ (void) callTelphone:(NSString*)number;
+ (void) sendMessage:(NSString*)number;

+ (NSString*) getArticalUrl:(NSString*)ids type:(NSString *)type;

+ (NSString*) convertDateToString:(NSDate*)date;

+ (NSString*) convertDateToString:(NSDate*)data withFormat:(NSString*)formater;

+ (id) fetchDataFromArrayByIndex:(NSArray*)data withIndex:(NSInteger)index;

+ (NSString*)versions;
+ (NSString*)builds;

+ (BOOL) validateParams:(NSString*)params withRegular:(NSString*)regular;
+ (BOOL) validateNumber:(NSString*)params;
+ (BOOL) validateSizeForm:(NSString*)params;
+ (BOOL) validatePhoneNumber:(NSString*)param;
@end
