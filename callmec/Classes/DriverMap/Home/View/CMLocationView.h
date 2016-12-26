//
//  DDLocationView.h
//  TripDemo
//
//  Created by xiaoming han on 15/4/2.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMLocation;
@class CMLocationView;

@protocol CMLocationViewDelegate <NSObject>
@optional

- (void)didClickStartLocation:(CMLocationView *)locationView;
- (void)didClickEndLocation:(CMLocationView *)locationView;

@end

/**
 *  显示起始位置以及路径信息的视图。
 */
@interface CMLocationView : UIView

@property (nonatomic, weak) id<CMLocationViewDelegate> delegate;

@property (nonatomic, strong) CMLocation *startLocation;
@property (nonatomic, strong) CMLocation *endLocation;
@property (nonatomic, copy) NSString *info;

@end
