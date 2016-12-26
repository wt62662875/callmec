//
//  RightIconView.h
//  callmec
//
//  Created by sam on 16/7/21.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftInputView : UIView
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *placeHolder;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) UIFont *titleFont;
@property (nonatomic,strong) UIFont *contentFont;
@property (nonatomic,strong) UIFont *tailFont;
@property (nonatomic,assign) BOOL enable;
@property (nonatomic,weak)id<TargetActionDelegate> delegate;
@property (nonatomic,assign) BOOL hiddenIcon;
@property (nonatomic,assign) BOOL hiddenTitle;
@property (nonatomic,copy) NSString *tailText;

@property (nonatomic,assign) BOOL touch;


@end
