//
//  BottomDialogView.h
//  callmec
//
//  Created by sam on 16/7/22.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomDialogView : UIView

@property (nonatomic,assign) NSInteger columnNumber;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,weak) id<TargetActionDelegate> delegate;
@property (nonatomic,assign) BOOL isNeedExtra;
- (void) updateContainerHeight:(CGFloat)height;
- (void) addContainerView:(UIView*)view;

@end
