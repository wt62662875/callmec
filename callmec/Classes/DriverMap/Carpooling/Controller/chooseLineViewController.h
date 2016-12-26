//
//  chooseLineViewController.h
//  callmec
//
//  Created by wt on 2016/11/22.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
@protocol sendLineDelegate <NSObject>

- (void)sendLine:(NSString *)start end:(NSString *)end;
@end

@interface chooseLineViewController : BaseController
@property (nonatomic, strong) NSString *startOrEnd;

@property (nonatomic, strong) NSString *startLine;


@property (nonatomic, retain) id <sendLineDelegate> delegate;

@end
