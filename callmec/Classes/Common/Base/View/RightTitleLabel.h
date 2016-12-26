//
//  RightTitleLabel.h
//  callmec
//
//  Created by sam on 16/7/16.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightTitleLabel : UIView

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSAttributedString *contentAttribute;

@property (nonatomic,strong) UIFont *titleFont;
@property (nonatomic,strong) UIFont *contentFont;
@property (nonatomic,strong) UIColor *titleColor;
@property (nonatomic,strong) UIColor *contentColor;
@property (nonatomic,assign) BOOL hiddenLine;
@end
