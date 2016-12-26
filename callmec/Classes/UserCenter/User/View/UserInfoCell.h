//
//  UserInfoCell.h
//  callmec
//
//  Created by sam on 16/6/25.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"
#import "VerticalView.h"

@interface UserInfoCell : BaseCell

@property (nonatomic,weak) id<TargetActionDelegate> delegate;
@end
