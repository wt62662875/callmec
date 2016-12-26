//
//  CommonVerticalView.h
//  callmec
//
//  Created by sam on 16/6/29.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonVerticalView : UIView

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *hightLightImage;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,strong) UIColor *imageBackgroudColor;
@property (nonatomic,strong) UIFont *titleFont;
@property (nonatomic,weak) id<TargetActionDelegate> delegate;

- (void) setTitleColor:(UIColor*)color state:(UIControlState)state;

@end