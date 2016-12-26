//
//  UIView+ZXCSuperView.m
//  crownbee
//
//  Created by 张小聪 on 16/4/25.
//  Copyright © 2016年 张小聪. All rights reserved.
//

#import "UIView+ZXCSuperView.h"

@implementation UIView (ZXCSuperView)

- (UIViewController *)viewController{
    UIResponder *responder = [self nextResponder];
    do{
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }while (responder!=nil);
    return nil;
}

@end
