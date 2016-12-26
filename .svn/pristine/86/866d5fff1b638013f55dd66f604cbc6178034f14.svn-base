//
//  CLLocation+Center.m
//  callmec
//
//  Created by sam on 16/8/13.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "CLLocation+Center.h"

@implementation CLLocation (Center)


- (CLLocation*) centerFrom:(CLLocation*)location
{
    return [[CLLocation alloc] initWithLatitude:(self.coordinate.latitude+location.coordinate.latitude)/2 longitude:(self.coordinate.longitude+location.coordinate.longitude)/2];
}
@end
