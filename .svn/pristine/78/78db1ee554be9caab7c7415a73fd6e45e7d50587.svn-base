//
//  WalletInfoModel.h
//  callmec
//
//  Created by sam on 16/7/13.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseModel.h"

@interface WalletInfoModel : BaseModel
@property (nonatomic,copy) NSString<Optional>* cash;
@property (nonatomic,copy) NSString<Optional>* cmoney;
@property (nonatomic,copy) NSString<Optional>* descriptions;
@property (nonatomic,copy) NSString<Optional>* icardNo;
@property (nonatomic,copy) NSString<Optional>* level;
@property (nonatomic,copy) NSString<Optional>* grade;
@property (nonatomic,copy) NSString<Optional>* account;
@property (nonatomic,copy) NSString<Optional>* accountId;
/*
"cash": 100,
"cmoney": 100,
"createDate": "2016-06-19",
"description": "",
"icardNo": "",
"level": 1
*/

+ (void) fetchWalletInfoSuccess:(QuerySuccessBlock)sucess failed:(QueryErrorBlock)fail;
@end
