//
//  UserInfoModel.h
//  callmec
//
//  Created by sam on 16/6/22.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel

@property (nonatomic,copy) NSString<Optional> *address;
@property (nonatomic,copy) NSString<Optional> *alias;
@property (nonatomic,copy) NSString<Optional> *birthday;
@property (nonatomic,copy) NSString<Optional> *company;
@property (nonatomic,copy) NSString<Optional> *email;
@property (nonatomic,copy) NSString<Optional> *fixedNo;
@property (nonatomic,copy) NSString<Optional> *gender;
@property (nonatomic,copy) NSString<Optional> *grade;
@property (nonatomic,copy) NSString<Optional> *ids;
@property (nonatomic,copy) NSString<Optional> *identifierNo;
@property (nonatomic,copy) NSString<Optional> *icon;
@property (nonatomic,copy) NSString<Optional> *level;
@property (nonatomic,copy) NSString<Optional> *loginName;
@property (nonatomic,copy) NSString<Optional> *loginPwd;
@property (nonatomic,copy) NSString<Optional> *no;
@property (nonatomic,copy) NSString<Optional> *phoneNo;
@property (nonatomic,copy) NSString<Optional> *qq;
@property (nonatomic,copy) NSString<Optional> *realName;
@property (nonatomic,copy) NSString<Optional> *sales;
@property (nonatomic,copy) NSString<Optional> *sinaNo;
@property (nonatomic,copy) NSString<Optional> *usualEnd;
@property (nonatomic,copy) NSString<Optional> *usualStart;
@property (nonatomic,copy) NSString<Optional> *slatitude;
@property (nonatomic,copy) NSString<Optional> *slongitude;
@property (nonatomic,copy) NSString<Optional> *slocation;
@property (nonatomic,copy) NSString<Optional> *elatitude;
@property (nonatomic,copy) NSString<Optional> *elongitude;
@property (nonatomic,copy) NSString<Optional> *elocation;
@property (nonatomic,copy) NSString<Optional> *job;
@property (nonatomic,copy) NSString<Optional> *clientId;
@property (nonatomic,copy) NSString<Optional> *descriptions;
@property (nonatomic,copy) NSString<Optional> *city;
@property (nonatomic,copy) NSString<Optional> *serviceNo;

@property (nonatomic,copy) NSString<Optional> *attribute1;
@property (nonatomic,copy) NSString<Optional> *attribute2;
@property (nonatomic,copy) NSString<Optional> *attribute3;
+ (void) save:(UserInfoModel*)userinfo;

+ (void) login:(NSString*)username withPwd:(NSString*)pwd succ:(QuerySuccessBlock)suc fail:(QueryErrorBlock)fai;

+ (void) fetchValidateCode:(NSString*)mobile succ:(QuerySuccessBlock)suc fail:(QueryErrorBlock)fai;

+ (void) commitEditUserInfo:(NSMutableDictionary*)params succ:(QuerySuccessBlock)suc fail:(QueryErrorBlock)fai;

+ (void) fetchUserHeaderImage:(NSString*)ids succ:(QuerySuccessBlock)suc fail:(QueryErrorBlock)fai;
@end
