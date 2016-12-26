//
//  BaseNavController.m
//  callmec
//
//  Created by sam on 16/6/23.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseNavController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface BaseNavController ()

@end

@implementation BaseNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AMapServices sharedServices].apiKey=MAPAPIKey;
}


- (void)viewDidAppear:(BOOL)animated
{
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    _mapView.showsUserLocation = NO;
    _mapView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Handle Action

- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [self clearMapView];
}


- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = nil;
}

- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    }
    
    self.mapView.frame = self.view.bounds;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    _mapView.showsCompass = NO;
    _mapView.rotateEnabled = NO;
    _mapView.showsScale = NO;
    // 去除精度圈。
    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    
    [self.view addSubview:_mapView];
}


- (void)initIFlySpeech
{
    if (self.iFlySpeechSynthesizer == nil)
    {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
}


@end
