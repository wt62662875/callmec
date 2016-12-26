//
//  CarModel.h
//  callmec
//
//  Created by sam on 16/6/29.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseModel.h"

@interface CarModel : BaseModel
@property (nonatomic,copy) NSString *carTitle;
@property (nonatomic,copy) NSString *carType;
@property (nonatomic,copy) NSString *carIcon;
@property (nonatomic,copy) NSString *carIconLight;
@property (nonatomic,copy) NSString *carMoney;
@property (nonatomic,assign) BOOL isSelected;
@end
