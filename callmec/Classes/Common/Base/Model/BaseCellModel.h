//
//  BaseCellModel.h
//  callmec
//
//  Created by sam on 16/7/9.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseModel.h"

@interface BaseCellModel : BaseModel
@property (nonatomic,copy) NSString<Optional> *ids;
@property (nonatomic,copy) NSString<Optional> *title;
@property (nonatomic,copy) NSString<Optional> *value;
@property (nonatomic,assign) BOOL hasMore;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,copy) NSString<Optional> *hasChanged;
@end
