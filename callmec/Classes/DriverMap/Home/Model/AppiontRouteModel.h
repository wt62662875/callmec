//
//  AppiontRouteModel.h
//  callmec
//
//  Created by sam on 16/7/22.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseModel.h"

@interface AppiontRouteModel : BaseModel
@property (nonatomic,copy) NSString *ids;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *descriptions;
@property (nonatomic,copy) NSString *distance;
@property (nonatomic,copy) NSString *elocation;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *no;
@property (nonatomic,copy) NSString *slocation;
@property (nonatomic,copy) NSString *spentTime;
@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *distances;


+ (void) fetchAppiontRouteWithPage:(NSInteger)page withKeyWords:(NSString*)key withEnd:(NSString*)end Success:(QuerySuccessListBlock)succ failed:(QueryErrorBlock)fail;
@end
