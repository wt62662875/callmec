//
//  MBProgressHUD+ZXCExtension.m
//  crownbee
//
//  Created by 张小聪 on 16/3/4.
//  Copyright © 2016年 张小聪. All rights reserved.
//

#import "MBProgressHUD+ZXCExtension.h"

#define HUDHiddenDelayDuration 0.5

@implementation MBProgressHUD (ZXCExtension)

/**
 *  显示纯文字的
 */
+ (MBProgressHUD *)showTextHUBWithText:(NSString *)text inView:(UIView *)view {
    if (view == nil) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    
    [hud hide:YES afterDelay:HUDHiddenDelayDuration];
    
    return hud;
}

/**
 *  显示纯文字（详细）
 */
+ (MBProgressHUD *)showDetailTextHUBWithText:(NSString *)text inView:(UIView *)view {
    if (view == nil) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = text;
    
    [hud hide:YES afterDelay:HUDHiddenDelayDuration];
    
    return hud;
}




@end
