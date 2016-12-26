//
//  LeftIconLabel.h
//  callmec
//
//  Created by sam on 16/7/23.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftIconLabel : UIView

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,strong) UIFont *titleFont;
@property (nonatomic,assign) CGFloat imageH;
@property (nonatomic,assign) BOOL showLine;

- (void) setImageW:(CGFloat)w withH:(CGFloat)h;
@end
