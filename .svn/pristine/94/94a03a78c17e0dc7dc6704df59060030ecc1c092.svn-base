//
//  UIBarButtonItem+ZXCExtension.m
//  crownbee
//
//  Created by 张小聪 on 16/3/23.
//  Copyright © 2016年 张小聪. All rights reserved.
//

#import "UIBarButtonItem+ZXCExtension.h"

@implementation UIBarButtonItem (ZXCExtension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    //button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

@end
