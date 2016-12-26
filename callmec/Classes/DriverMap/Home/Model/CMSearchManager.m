//
//  DDSearchManager.m
//  TripDemo
//
//  Created by xiaoming han on 15/4/3.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import "CMSearchManager.h"

@interface CMSearchManager ()<AMapSearchDelegate>
{
    AMapSearchAPI *_search;
    NSMapTable *_mapTable;
    NSMapTable *_blockTable;
    CMSearchResultWithCMLocationBlock _sblock;
}
@end

@implementation CMSearchManager

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _search  = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
        
        _mapTable = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsCopyIn];
        
        _blockTable=[NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsCopyIn];
    }
    return self;
}

- (void)searchLocation:(CLLocation*)location completionBlock:(CMSearchResultWithCMLocationBlock)block
{
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
    if (location==nil) {
        request.location = [AMapGeoPoint locationWithLatitude:[GlobalData sharedInstance].coordinate.latitude
                                                    longitude:[GlobalData sharedInstance].coordinate.longitude];
        request.requireExtension = NO;
    }else{
        request.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude
                                                    longitude:location.coordinate.longitude];
        request.requireExtension = NO;
    }
    request.radius = 3000;
    [self searchForRequest:request completionBlock:^(id request, id response, NSError *error) {
        [self paserGeoAddress:response withBlock:block];
    }];
}
- (void)searchForStartLocation:(CMLocation*)start end:(CMLocation*)end completionBlock:(CMSearchCompletionBlock)block
{

    //检索所需费用
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.requireExtension = YES;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:start.coordinate.latitude
                                           longitude:start.coordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:end.coordinate.latitude
                                                longitude:end.coordinate.longitude];
    [self searchForRequest:navi completionBlock:block];
}

- (void) paserGeoAddress:(id)response withBlock:(CMSearchResultWithCMLocationBlock)block
{

            CMLocation * currentLocation = [[CMLocation alloc] init];
            AMapReGeocodeSearchResponse * regeoResponse = response;
            if (regeoResponse.regeocode != nil)
            {
                if (regeoResponse.regeocode.pois.count > 0)
                {
                    AMapPOI *poi = regeoResponse.regeocode.pois[0];
                    currentLocation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
                    currentLocation.name = poi.name;
                    currentLocation.address = poi.address;
                }else{
                    currentLocation.coordinate = CLLocationCoordinate2DMake(regeoResponse.regeocode.addressComponent.streetNumber.location.latitude, regeoResponse.regeocode.addressComponent.streetNumber.location.longitude);
                    currentLocation.name = [NSString stringWithFormat:@"%@%@%@%@%@", regeoResponse.regeocode.addressComponent.township, regeoResponse.regeocode.addressComponent.neighborhood, regeoResponse.regeocode.addressComponent.streetNumber.street, regeoResponse.regeocode.addressComponent.streetNumber.number, regeoResponse.regeocode.addressComponent.building];
                    
                    currentLocation.address = regeoResponse.regeocode.formattedAddress;
                }
                currentLocation.cityCode = regeoResponse.regeocode.addressComponent.citycode;
                if (regeoResponse.regeocode.addressComponent.city.length<=0) {
                    currentLocation.city = regeoResponse.regeocode.addressComponent.province;
                }else{
                    currentLocation.city = regeoResponse.regeocode.addressComponent.city;
                }
                [GlobalData sharedInstance].city = currentLocation.city;
                currentLocation.district = regeoResponse.regeocode.addressComponent.district;
                [GlobalData sharedInstance].location = currentLocation;

            }
    if (block) {
        block(nil,currentLocation,nil);
    }
}
- (void)searchForRequest:(id)request completionBlock:(CMSearchCompletionBlock)block
{
    if ([request isKindOfClass:[AMapPOIKeywordsSearchRequest class]])
    {
        [_search AMapPOIKeywordsSearch:request];
        [_mapTable setObject:block forKey:request];
    }
    else if ([request isKindOfClass:[AMapDrivingRouteSearchRequest class]])
    {
        [_search AMapDrivingRouteSearch:request];
        [_mapTable setObject:block forKey:request];
    }
    else if ([request isKindOfClass:[AMapInputTipsSearchRequest class]])
    {
        [_search AMapInputTipsSearch:request];
        [_mapTable setObject:block forKey:request];
    }
    else if ([request isKindOfClass:[AMapGeocodeSearchRequest class]])
    {
        [_search AMapGeocodeSearch:request];
        [_mapTable setObject:block forKey:request];
    }
    else if ([request isKindOfClass:[AMapReGeocodeSearchRequest class]])
    {
        [_search AMapReGoecodeSearch:request];
        [_mapTable setObject:block forKey:request];
    }else if([request isKindOfClass:[AMapNearbySearchRequest class]])
    {
        [_search AMapNearbySearch:request];
        [_mapTable setObject:block forKey:request];
    }else{
        NSLog(@"unsupported request");
        return;
    }
}

#pragma mark - Helpers

- (void)performBlockWithRequest:(id)request withResponse:(id)response
{
    CMSearchCompletionBlock block = [_mapTable objectForKey:request];
    if (block)
    {
        block(request, response, nil);
    }
    [_mapTable removeObjectForKey:request];
}

#pragma mark - AMapSearchDelegate

- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    CMSearchCompletionBlock block = [_mapTable objectForKey:request];
    
    if (block)
    {
        block(request, nil, error);
    }else{
        CMSearchCompletionBlock block = [_blockTable objectForKey:request];
        if (block) {
            block(request,nil, nil);
        }
    }
    
    [_mapTable removeObjectForKey:request];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    [self performBlockWithRequest:request withResponse:response];
}

- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    [self performBlockWithRequest:request withResponse:response];
}

- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self performBlockWithRequest:request withResponse:response];
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    [self performBlockWithRequest:request withResponse:response];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    [self performBlockWithRequest:request withResponse:response];
}

@end
