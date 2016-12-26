//
//  UIViewController+Storyboard.m
//  crownbee
//
//  Created by Likid on 10/10/15.
//  Copyright © 2015 crownbee. All rights reserved.
//

#import "UIViewController+Storyboard.h"

@implementation UIViewController (Storyboard)

+ (instancetype)instantiateFromStoryboard {
    NSAssert(NO, @"**Error** Subclass must override this method with own implement!");
    return nil;
}

+ (instancetype)instantiateFromStoryboardWithName:(NSString *)name {
    UIViewController *vc = nil;
    @try {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:name bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    } @catch (NSException *exception) {
//        LKLogDebug(@"%@", exception);
//        LKLogError(exception.reason);
        
        NSAssert(NO, @"%@", exception);
    } @finally {
        return vc;
    }
}

@end
