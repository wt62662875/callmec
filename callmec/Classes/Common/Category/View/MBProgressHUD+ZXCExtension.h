//
//  MBProgressHUD+ZXCExtension.h
//  crownbee
//
//  Created by 张小聪 on 16/3/4.
//  Copyright © 2016年 张小聪. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (ZXCExtension)

/**
 *  显示纯文字的
 */
+ (MBProgressHUD *)showTextHUBWithText:(NSString *)text inView:(UIView *)view;
/**
 *  显示纯文字（详细）
 */
+ (MBProgressHUD *)showDetailTextHUBWithText:(NSString *)text inView:(UIView *)view;
@end
