//
//  chooseDetailsLineCollectionViewController.h
//  callmec
//
//  Created by wt on 2016/11/23.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
@protocol backLineDelegate <NSObject>

- (void)backLine:(NSString *)start end:(NSString *)end;
@end
@interface chooseDetailsLineCollectionViewController : BaseController
@property (nonatomic, strong) NSString *startOrEnd;

@property (nonatomic, strong) NSArray *shortNameArray;
@property (nonatomic, strong) NSString *startLine;


@property (nonatomic, retain) id <backLineDelegate> delegate;

@end
