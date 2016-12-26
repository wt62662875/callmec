//
//  GoodsOrderModel.h
//  callmec
//
//  Created by sam on 16/8/12.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseModel.h"

@interface GoodsOrderModel : BaseModel

+ (void) fetchGoodsOrderDetail:(NSString*)ids success:(QuerySuccessBlock)suc failed:(QueryErrorBlock)fail;
@end
