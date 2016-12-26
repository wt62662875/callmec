//
//  MBProgressHUD+LKAddition.m
//  accounting369
//
//  Created by Likid on 3/9/15.
//  Copyright (c) 2015 Yasoon. All rights reserved.
//

#import "MBProgressHUD+LKAddition.h"

NSString *const YASHUDLoadingText = @"正在加载...";
const NSTimeInterval YASHUDHiddenDelayDuration = 1.5;

@implementation MBProgressHUD (LKAddition)

+ (MBProgressHUD *)showTextHUBWithText:(NSString *)text inView:(UIView *)view {
    if (view == nil) {
        view = AppDelegateInstance().window;
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;

    [hud hide:YES afterDelay:YASHUDHiddenDelayDuration];

    return hud;
}

+ (MBProgressHUD *)showDetailTextHUBWithText:(NSString *)text inView:(UIView *)view {
    if (view == nil) {
        view = AppDelegateInstance().window;
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = text;

    [hud hide:YES afterDelay:YASHUDHiddenDelayDuration];

    return hud;
}

+ (MBProgressHUD *)showProgressView:(NSString*)title inView:(UIView*)view
{
    if (view == nil) {
        view = AppDelegateInstance().window;
    }
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    //如果设置此属性则当前的view置于后台
//    HUD.dimBackground = YES;
    HUD.removeFromSuperViewOnHide = YES;
    //设置对话框文字
    HUD.labelText = title;
    
    /*
    //显示对话框
    [HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        //sleep(3);
    } completionBlock:^{
        //操作执行完后取消对话框
        [HUD removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
    */
    /*
    __block MBProgressHUD *sd = HUD;
    HUD.completionBlock =^{
        //操作执行完后取消对话框
        [sd removeFromSuperview];
        if (completion) {
            completion();
        }
    };
    */
    return HUD;
}

+ (void)showAndHideWithMessage:(NSString *)message forHUD:(MBProgressHUD *)hud {
    [self showAndHideWithMessage:message forHUD:hud onCompletion:NULL];
}

+ (void)showAndHideWithMessage:(NSString *)message forHUD:(MBProgressHUD *)hud onCompletion:(LKSimpleBlock)completion {
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:AppDelegateInstance().window animated:YES];
    }

    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    [hud hide:YES afterDelay:YASHUDHiddenDelayDuration];
    
    [self handleCompletion:completion];
}

+ (void)showAndHideWithError:(NSError *)error forHUD:(MBProgressHUD *)hud {
    [self showAndHideWithError:error forHUD:hud onCompletion:NULL];
}

+ (void)showAndHideWithError:(NSError *)error forHUD:(MBProgressHUD *)hud onCompletion:(LKSimpleBlock)completion {
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:AppDelegateInstance().window animated:YES];
    }

    hud.mode = MBProgressHUDModeText;
    hud.labelText = error.localizedFailureReason;

    if (error.helpAnchor && [error.helpAnchor isEqualToString:error.localizedFailureReason] == NO) {
        hud.detailsLabelText = error.helpAnchor;
    }

    [hud hide:YES afterDelay:YASHUDHiddenDelayDuration];

    [self handleCompletion:completion];
}

+ (void)handleCompletion:(LKSimpleBlock)completion {
    if (completion) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(YASHUDHiddenDelayDuration * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           completion();
                       });
    }
}

- (void)hideWithMessage:(NSString *)message {
    [self hideWithMessage:message onCompletion:NULL];
}

- (void)hideWithMessage:(NSString *)message onCompletion:(LKSimpleBlock)completion {
    [MBProgressHUD showAndHideWithMessage:message forHUD:self onCompletion:completion];
}

@end
