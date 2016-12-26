//
//  CellView.h
//  callmec
//
//  Created by sam on 16/7/17.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellView : UIView

@property (nonatomic,copy) NSString *iconUrl;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,weak) id<TargetActionDelegate> delegate;
@end
