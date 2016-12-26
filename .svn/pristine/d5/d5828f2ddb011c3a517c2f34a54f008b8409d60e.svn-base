//
//  CMDriver.h
//  callmec
//
//  Created by Sam.yan on 6/13/16.
//  Copyright (c) 2016 callmec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CMDriver : NSObject

@property (nonatomic, strong) NSString * idInfo;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

+ (instancetype)driverWithID:(NSString *)idInfo coordinate:(CLLocationCoordinate2D)coordinate;

- (id)initWithID:(NSString *)idInfo coordinate:(CLLocationCoordinate2D)coordinate;

+ (void) fetchDriverWithCoordinate:(NSMutableDictionary*)params succed:(QuerySuccessListBlock)list fail:(QueryErrorBlock)failed;
@end
