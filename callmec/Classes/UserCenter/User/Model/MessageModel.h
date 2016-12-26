//
//  MessageModel.h
//  callmec
//
//  Created by sam on 16/7/6.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseModel.h"

@interface MessageModel : BaseModel

@property (nonatomic,copy) NSString<Optional> *ids;
@property (nonatomic,copy) NSString<Optional> *title;
@property (nonatomic,copy) NSString<Optional> *type;
@property (nonatomic,copy) NSString<Optional> *creatDate;
@property (nonatomic,copy) NSString<Optional> *alias;
@property (nonatomic,copy) NSString<Optional> *descriptions;
@property (nonatomic,copy) NSString<Optional> *direction;
@property (nonatomic,copy) NSString<Optional> *memberShip;
@property (nonatomic,copy) NSString<Optional> *ownerID;
@property (nonatomic,copy) NSString<Optional> *state;
@property (nonatomic,copy) NSString<Optional> *tag;


+ (void) fetchMessageListWithPage:(NSInteger)page success:(QuerySuccessListBlock)list failed:(QueryErrorBlock)fail;
@end
