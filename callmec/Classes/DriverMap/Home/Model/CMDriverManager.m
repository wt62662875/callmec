//
//  DDDriverManager.m
//
//
//  Created Sam.yan  on 6/3/16.
//  Copyright (c) 2016 Sam. All rights reserved.
//

#import "CMDriverManager.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import "MANaviRoute.h"
#import "CMSearchManager.h"
#import "DriverInfoModel.h"

@interface CMDriverManager() <AMapSearchDelegate>

@property(nonatomic, strong) CMTaxiCallRequest * currentRequest;
@property(nonatomic, strong) CMDriver * selectDriver;

@property(nonatomic, strong) NSArray * driverPath;
@property(nonatomic, assign) NSUInteger subpathIdx;

@end

@implementation CMDriverManager
{
    
}

//根据mapRect取司机数据
- (void)searchDriversWithinMapRect:(MAMapRect)mapRect
{
    //在mapRect区域里随机生成coordinate
#define MAX_COUNT 50
#define MIN_COUNT 5
    NSUInteger randCount = arc4random() % MAX_COUNT + MIN_COUNT;
    
    NSMutableArray * drivers = [NSMutableArray arrayWithCapacity:randCount];
    for (int i = 0; i < randCount; i++)
    {
        CMDriver * driver = [CMDriver driverWithID:@"粤A****" coordinate:[self randomPointInMapRect:mapRect]];
        [drivers addObject:driver];
    }

    //回调返回司机数据
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchDoneInMapRect:withDriversResult:timestamp:)])
    {
        [self.delegate searchDoneInMapRect:mapRect withDriversResult:drivers timestamp:[NSDate date].timeIntervalSinceReferenceDate];
    }
    
}

- (void) searchDriver:(MAMapRect)rect WithCoordinate2D:(CLLocationCoordinate2D)c2d withCarType:(NSString*)type
{
    NSMutableDictionary *params =[NSMutableDictionary dictionary];
    
    [params setObject:[GlobalData sharedInstance].user.session forKey:@"token"];
    [params setObject:type?type:@"1" forKey:@"type"];
    [params setObject:@"1" forKey:@"state"];
    [params setObject:@"1000" forKey:@"distance"];
    [params setObject:[NSString stringWithFormat:@"%f",c2d.longitude] forKey:@"longitude"];
    [params setObject:[NSString stringWithFormat:@"%f",c2d.latitude] forKey:@"latitude"];
    
    [CMDriver fetchDriverWithCoordinate:params succed:^(NSArray *result, int pageCount, int recordCount) {
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dict in result) {
            DriverInfoModel *model = [[DriverInfoModel alloc] initWithDictionary:dict error:nil];
            [dataArray addObject:model];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(searchDoneInMapRect:withDriversResult:timestamp:)])
        {
            [self.delegate searchDoneInMapRect:rect withDriversResult:dataArray timestamp:[NSDate date].timeIntervalSinceReferenceDate];
        }
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        
    }];
    
}

//发送用车请求：起点终点
- (BOOL)callTaxiWithRequest:(CMTaxiCallRequest *)request
{
    if (request.start == nil || request.end == nil)
    {
        return NO;
    }
    
    _currentRequest = request;

    //在起点附近随机生成司机位置
#define startAroundRangeMeters 500.0
    
    MAMapRect startAround = MAMapRectForCoordinateRegion(MACoordinateRegionMakeWithDistance(_currentRequest.start.coordinate, startAroundRangeMeters, startAroundRangeMeters));

    CLLocationCoordinate2D driverLocation = [self randomPointInMapRect:startAround];
    NSLog(@"driverLocation : %f %f", driverLocation.latitude, driverLocation.longitude);
    _selectDriver = [CMDriver driverWithID:@"京B****" coordinate:driverLocation];
    
    //延迟返回司机选择结果
    __weak __typeof(&*self) weakSelf = self;
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(callTaxiDoneWithRequest:Taxi:)])
        {
            [weakSelf.delegate callTaxiDoneWithRequest:_currentRequest Taxi:_selectDriver];
        }
        
        //司机位置更新
        [weakSelf startUpdateLocationForDriver:_selectDriver];

    });
    
    return YES;
}

- (void)startUpdateLocationForDriver:(CMDriver *)driver
{
    [self searchPathFrom:driver.coordinate to:_currentRequest.start.coordinate];
    
}

//找驾车到达乘客位置的路径
- (void)searchPathFrom:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to
{
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.requireExtension = YES;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:from.latitude
                                           longitude:from.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:to.latitude
                                                longitude:to.longitude];

    __weak __typeof(&*self) weakSelf = self;
    [[CMSearchManager sharedInstance] searchForRequest:navi completionBlock:^(id request, id response, NSError *error) {
        
        AMapRouteSearchResponse *naviResponse = response;

        NSLog(@"%@", naviResponse);
        if (naviResponse.route == nil)
        {
            return;
        }
        
        //路径解析
        MANaviRoute * naviRoute = [MANaviRoute naviRouteForPath:naviResponse.route.paths[0]];
        
        //保存路径串
        weakSelf.driverPath = naviRoute.path;
        weakSelf.subpathIdx = 0;
        
        //开始push给乘客端
        NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(onUpdatingLocation) userInfo:nil repeats:YES];
        [timer fire];

    }];

}

- (void)onUpdatingLocation
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onUpdatingLocations:forDriver:)] && _subpathIdx < self.driverPath.count)
    {
        [self.delegate onUpdatingLocations:self.driverPath[_subpathIdx++] forDriver:self.selectDriver];
    }
}

#pragma mark - Utility
- (CLLocationCoordinate2D)randomPointInMapRect:(MAMapRect)mapRect
{
    MAMapPoint result;
    result.x = mapRect.origin.x + arc4random() % (int)(mapRect.size.width);
    result.y = mapRect.origin.y + arc4random() % (int)(mapRect.size.height);
    
    return MACoordinateForMapPoint(result);

}

+ (void) cancelCallCarRequest:(NSString*)orderId reason:(NSString*)reason success:(QuerySuccessBlock)succ failed:(QueryErrorBlock)fail
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:orderId forKey:@"id"];
    [params setObject:reason forKey:@"cancelReason"];
    [HttpShareEngine callWithFormParams:params withMethod:@"cancelOrder" succ:^(NSDictionary *resultDictionary) {
        if (succ) {
            succ(resultDictionary);
        }
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        if (fail) {
            fail(errorCode,errorMessage);
        }
    }];
}

+ (void) sendCallCarRequest:(NSMutableDictionary*)params success:(QuerySuccessBlock)succ failed:(QueryErrorBlock)fail
{
    [HttpShareEngine callWithFormParams:params withMethod:@"createOrder" succ:^(NSDictionary *resultDictionary) {
        if (succ) {
            succ(resultDictionary);
        }
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        if (fail) {
            fail(errorCode,errorMessage);
        }
    }];

}


+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
@end
