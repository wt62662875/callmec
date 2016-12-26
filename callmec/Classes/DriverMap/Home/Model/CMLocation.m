//
//  DDLocation.m
//  TripDemo
//
//  Created by xiaoming han on 15/4/2.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import "CMLocation.h"

@implementation CMLocation

- (void) setCity:(NSString *)city
{
    if (city) {
        _city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
    }else{
        _city = city;
    }
}
- (void) setDistrict:(NSString *)district{
    NSLog(@"%@",district);
    if (district) {
        if (district.length >= 3) {
            _district = [district stringByReplacingOccurrencesOfString:@"区" withString:@""];
            _district = [_district stringByReplacingOccurrencesOfString:@"县" withString:@""];
        }
    }else{
        _district = district;
    }

}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name:%@, cityCode:%@, address:%@, coordinate:%f, %f", self.name, self.cityCode, self.address, self.coordinate.latitude, self.coordinate.longitude];
}

+ (NSMutableDictionary*)toDictionary:(CMLocation*)location{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:location.name forKey:@"name"];
    [dict setObject:location.cityCode forKey:@"cityCode"];
    [dict setObject:location.address forKey:@"address"];
    [dict setObject:[NSString stringWithFormat:@"%ld@",location.targetIndex] forKey:@"targetIndex"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%f@",location.coordinate.latitude] forKey:@"latitude"];
    [param setObject:[NSString stringWithFormat:@"%f@",location.coordinate.longitude] forKey:@"longitude"];
    
    [dict setObject:param forKey:@"coordinate"];
    
    return dict;
}
+ (CMLocation*)toCMLocation:(NSMutableDictionary*)dict
{
    if (dict) {
        CMLocation *location=nil;
        @try {
            location = [[CMLocation alloc] init];
            location.city = dict[@"city"];
            location.district = dict[@"district"];
            location.name = dict[@"name"];
            location.cityCode = dict[@"cityCode"];
            location.address = dict[@"address"];
            location.targetIndex = [dict[@"targetIndex"] integerValue];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([(dict[@"coordinate"][@"latitude"]) floatValue], [dict[@"coordinate"][@"longitude"] floatValue]);
            location.coordinate = coordinate;
            
        } @catch (NSException *exception) {
            location =nil;
        } @finally {
            return location;
        }
        
    }
    return [[CMLocation alloc] init];
}

@end
