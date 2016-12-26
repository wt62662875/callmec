//
//  DDDriverManager.h
//  TripDemo
//
//  Created by yi chen on 4/3/15.
//  Copyright (c) 2015 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import "CMTaxiCallRequest.h"
#import "CMDriver.h"

@protocol CMDriverManagerDelegate;

/**
 *  司机相关管理类。获取司机数据、发送用车请求等。
 */
@interface CMDriverManager : NSObject



@property (nonatomic, weak) id<CMDriverManagerDelegate> delegate;

//根据mapRect取司机数据
- (void)searchDriversWithinMapRect:(MAMapRect)mapRect;

//发送用车请求：起点终点
- (BOOL)callTaxiWithRequest:(CMTaxiCallRequest *)request;

//获取坐标范围的司机
- (void) searchDriver:(MAMapRect)rect WithCoordinate2D:(CLLocationCoordinate2D)c2d withCarType:(NSString*)type;

//创建叫车订单
+ (void) sendCallCarRequest:(NSMutableDictionary*)params success:(QuerySuccessBlock)succ failed:(QueryErrorBlock)fail;

/**取消叫车订单**/
+ (void) cancelCallCarRequest:(NSString*)orderId reason:(NSString*)reason success:(QuerySuccessBlock)succ failed:(QueryErrorBlock)fail;

+ (instancetype)sharedInstance;
@end

@protocol CMDriverManagerDelegate <NSObject>
@optional

//返回司机数据结果
- (void)searchDoneInMapRect:(MAMapRect)mapRect withDriversResult:(NSArray *)drivers timestamp:(NSTimeInterval)timestamp;

//司机选择结果
- (void)callTaxiDoneWithRequest:(CMTaxiCallRequest *)request Taxi:(CMDriver *)driver;

//司机位置更新
- (void)onUpdatingLocations:(NSArray *)locations forDriver:(CMDriver *)driver;



@end
