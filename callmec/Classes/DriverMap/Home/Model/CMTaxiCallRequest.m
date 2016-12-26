//
//  TaxiCallingRequest.m
//  TripDemo
//
//  Created by yi chen on 4/3/15.
//  Copyright (c) 2015 AutoNavi. All rights reserved.
//

#import "CMTaxiCallRequest.h"

@implementation CMTaxiCallRequest

+ (instancetype)requestFrom:(CMLocation *)start to:(CMLocation *)end
{
    return [[self alloc] initWithStart:start to:end];
}

- (id)initWithStart:(CMLocation *)start to:(CMLocation *)end
{
    if (self = [super init])
    {
        self.start = start;
        self.end = end;
    }
    
    return self;
}

@end
