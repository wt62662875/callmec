//
//  TripAdressView.h
//  callmec
//
//  Created by sam on 16/6/29.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLocation.h"

@protocol TripViewDelegate <NSObject>

@optional

- (void) tripViewClick:(UIView*)item;

@end

@interface TripAdressView : UIView

@property (nonatomic,strong) CMLocation *startLocation;
@property (nonatomic,strong) CMLocation *endLocation;
@property (nonatomic,assign) BOOL isHiddenTime;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,weak) id<TripViewDelegate> delegate;
@property (nonatomic,copy) NSString *headerTitle;
- (void) appendView:(UIView*)view;
@end
