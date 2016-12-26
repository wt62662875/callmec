//
//  AppVersionModel.h
//  callmed
//
//  Created by sam on 16/10/21.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseModel.h"

@interface AppVersionModel : BaseModel

@property (nonatomic,copy) NSString *version;
@property (nonatomic,copy) NSString *descriptions;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *type;

+ (void) checkAppVersionWithSucess:(QuerySuccessBlock)success withFail:(QueryErrorBlock)error;
@end
