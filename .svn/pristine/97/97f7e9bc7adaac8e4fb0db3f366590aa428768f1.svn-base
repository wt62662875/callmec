//
//  GlobalData.h
//  callmec
//
//  Created by sam on 16/6/22.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import "UserModel.h"
#import "WalletInfoModel.h"
#import "CMLocation.h"
#import "CarOrderModel.h"
#import <CoreLocation/CoreLocation.h>

@protocol TargetActionDelegate <NSObject>

@optional - (void) buttonTarget:(id)sender;
@optional - (void) buttonSelectedIndex:(NSInteger)index;
@optional - (void) buttonSelected:(UIView*)view Index:(NSInteger)index;
@optional - (void) valueChanged:(UIView*)view;
@end

@protocol CellTargetDelegate <NSObject>

@optional - (void) cellTarget:(id)sender;

@end

@interface GlobalData : NSObject

@property (nonatomic,strong) UserModel *user;

@property (nonatomic,strong) WalletInfoModel *wallet;

@property (nonatomic,readonly) NSString *channel_id;

@property (nonatomic,assign) AFNetworkReachabilityStatus netStatus;

@property (nonatomic,copy) NSString *city;

@property (nonatomic,copy) NSString *clientId;

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

@property (nonatomic,strong) CMLocation *location;

@property (nonatomic,strong) CarOrderModel *fastModel;

+ (instancetype)sharedInstance;

+ (NSString*) getUUID;

- (NSString*) getChannelId;

@end
