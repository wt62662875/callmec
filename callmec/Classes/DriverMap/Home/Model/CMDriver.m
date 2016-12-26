//
//  CMDriver.m
//
//  Created by Sam.yan on 6/13/16.
//  Copyright (c) 2016 callmec. All rights reserved.
//

#import "CMDriver.h"

@implementation CMDriver

+ (instancetype)driverWithID:(NSString *)idInfo coordinate:(CLLocationCoordinate2D)coordinate
{
    return [[self alloc] initWithID:idInfo coordinate:coordinate];
}

- (id)initWithID:(NSString *)idInfo coordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init])
    {
        self.idInfo = idInfo;
        self.coordinate = coordinate;
    }
    return self;
}

+ (void) fetchDriverWithCoordinate:(NSMutableDictionary*)params succed:(QuerySuccessListBlock)list fail:(QueryErrorBlock)failed
{
    
    [HttpShareEngine callWithFormParams:params withMethod:@"listDrivers" succList:^(NSArray *result, int pageCount, int recordCount) {
        if (list) {
            list(result,pageCount,recordCount);
        }
    } fail:failed];
}
@end
