//
//  chooseAddressViewController.h
//  callmec
//
//  Created by wt on 2016/11/23.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
@protocol sendDatasDelegate <NSObject>

- (void)sendDatas:(NSString *)name lat:(NSString *)lat lon:(NSString *)lon where:(NSString *)where startDatas:(NSDictionary *)startDatas endDatas:(NSDictionary *)endDatas;
@end
@interface chooseAddressViewController : BaseController
@property (strong, nonatomic) NSDictionary *addressDic;

@property (nonatomic, retain) id <sendDatasDelegate> delegate;

@end
