//
//  UIViewController+Storyboard.h
//  crownbee
//
//  Created by Likid on 10/10/15.
//  Copyright © 2015 crownbee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Storyboard)

+ (instancetype)instantiateFromStoryboard;
+ (instancetype)instantiateFromStoryboardWithName:(NSString *)name;

@end
