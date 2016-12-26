//
//  BaseController.h
//  callmec
//
//  Created by sam on 16/6/21.
//  Copyright © 2016年 sam. All rights reserved.
//
#define KTopbarH 64

#import <UIKit/UIKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

//#define macro
@protocol CallBackDelegate <NSObject>

@optional
- (void) callback:(id)sender;

@end
@interface BaseController : UIViewController<AMapLocationManagerDelegate>

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIView *bottomHeaderLine;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,weak) id<CallBackDelegate> delegateCallback;
@property (nonatomic,strong) AMapLocationManager *locationManager;

- (void) initDefaultHeader;
- (void) setRightButtonText:(NSString*)title withFont:(UIFont*)font;
- (void) setLeftButtonText:(NSString*) title withFont:(UIFont*)font;

- (void) callback:(id)sender;
- (void) reloadData;
+ (BOOL) hasVisiabled;
- (void) buttonTarget:(id)sender;
- (void) startLocation;
- (void) stopLocation;
- (void) initLocationConfig;
@end
