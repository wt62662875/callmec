//
//  PopView.h
//  callmec
//
//  Created by sam on 16/6/30.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopView : UIView

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *leftTime;
- (void) setCornerRadius:(CGFloat)f;
@end
