//
//  TaxiCallingRequest.h
//  TripDemo
//
//  Created by yi chen on 4/3/15.
//  Copyright (c) 2015 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMLocation.h"

/**
 *  用车请求对象。
 */
@interface CMTaxiCallRequest : NSObject

@property (nonatomic, strong) CMLocation * start;

@property (nonatomic, strong) CMLocation * end;

@property (nonatomic, strong) NSString * info;

+ (instancetype)requestFrom:(CMLocation *)start to:(CMLocation *)end;

- (id)initWithStart:(CMLocation *)start to:(CMLocation *)end;

@end
