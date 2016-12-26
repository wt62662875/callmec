//
//  MBProgressHUD+LKAddition.h
//  accounting369
//
//  Created by Likid on 3/9/15.
//  Copyright (c) 2015 Yasoon. All rights reserved.
//

#import "MBProgressHUD.h"

extern NSString *const YASHUDLoadingText;
extern const NSTimeInterval YASHUDHiddenDelayDuration;

@interface MBProgressHUD (LKAddition)

+ (MBProgressHUD *)showTextHUBWithText:(NSString *)text inView:(UIView *)view;

+ (MBProgressHUD *)showDetailTextHUBWithText:(NSString *)text inView:(UIView *)view;

+ (MBProgressHUD *)showProgressView:(NSString*)title inView:(UIView*) view;
//+ (void)showAndHideWithError:(NSError *)error forHUD:(MBProgressHUD *)hud;
//+ (void)showAndHideWithError:(NSError *)error forHUD:(MBProgressHUD *)hud onCompletion:(LKSimpleBlock)completion;

+ (void)showAndHideWithMessage:(NSString *)message forHUD:(MBProgressHUD *)hud;
+ (void)showAndHideWithMessage:(NSString *)message forHUD:(MBProgressHUD *)hud onCompletion:(LKSimpleBlock)completion;

- (void)hideWithMessage:(NSString *)message;
- (void)hideWithMessage:(NSString *)message onCompletion:(LKSimpleBlock)completion;

@end
