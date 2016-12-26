//
//  BaseItemModel.h
//  callmec
//
//  Created by sam on 16/6/25.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseModel.h"

@interface BaseItemModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *icons;
@property (nonatomic,assign) BOOL hasMore;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) BOOL isCanSelected;
@property (nonatomic,assign) NSInteger level;
@property (nonatomic,copy) NSString *value;
@property (nonatomic,copy) NSString *placeHolder;
@end

@interface UserItemModel : BaseItemModel
@property (nonatomic,strong) UserInfoModel *userInfo;
@end

@interface AccountModel : BaseItemModel

@end

@interface AddressModel : BaseItemModel

@end

@interface SpeakerModel : BaseItemModel

@end

@interface FunctionModel : BaseItemModel
@property (nonatomic,strong) NSArray *dataArray;
@end

@interface FunctionItemModel : BaseItemModel

@end

@interface HelpfulModel : BaseItemModel

@end
