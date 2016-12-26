//
//  BaseModel.h
//  callmec
//
//  Created by sam on 16/6/22.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@interface TripMode : NSObject

@property (nonatomic,strong) NSString *distance;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *fee;

@end

@interface BaseModel : JSONModel


@end
