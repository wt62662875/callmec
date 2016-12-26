//
//  CancelView.h
//  callmec
//
//  Created by sam on 16/8/14.
//  Copyright © 2016年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CancelBlock)(NSInteger index,BOOL isNeedClose);
typedef void (^ProcessBlock)(NSObject *obj);
@interface CancelView : UIView
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy) CarOrderModel *order;
@property (nonatomic,readwrite,copy) CancelBlock block;
@property (nonatomic,readwrite,copy) ProcessBlock processBlock;
@end
