//
//  AppiontBusModel.h
//  callmec
//
//  Created by sam on 16/9/3.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseModel.h"
#import "CMLocation.h"

@interface AppiontBusModel : BaseModel

@property (nonatomic,copy) NSString<Optional> *feedback;
@property (nonatomic,copy) NSString<Optional> *peopleNumber;
@property (nonatomic,copy) NSString<Optional> *ids;
@property (nonatomic,copy) NSString<Optional> *slatitude;
@property (nonatomic,copy) NSString<Optional> *slocation;
@property (nonatomic,copy) NSString<Optional> *slongitude;
@property (nonatomic,copy) NSString<Optional> *elatitude;
@property (nonatomic,copy) NSString<Optional> *elocation;
@property (nonatomic,copy) NSString<Optional> *elongitude;
@property (nonatomic,copy) NSString<Optional> *state;
@property (nonatomic,copy) NSString<Optional> *type;
@property (nonatomic,copy) NSString<Optional> *oType;
+ (void)appiontBus:(NSMutableDictionary*)dict succes:(QuerySuccessBlock)suc failed:(QueryErrorBlock)fail;
+ (void)appiontBusCancel:(NSString*)ids reason:(NSString*)reason succes:(QuerySuccessBlock)suc failed:(QueryErrorBlock)fail;
@end
