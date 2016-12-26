//
//  OrderModel.h
//  callmec
//
//  Created by sam on 16/7/7.
//  Copyright © 2016年 sam. All rights reserved.
//

#import "BaseModel.h"
#define STATE_ORDER_NEW  @"1" // 新增, 提交后等待司机抢单
#define STATE_ORDER_CONFIRM_PENDNG  @"2" // 提交后司机抢到单后， 等待司机确认
#define STATE_ORDER_CONFIRMED  @"3" //司机确认订单 , 开始出发到目的地
#define STATE_ORDER_EXECUTE_PENDING  @"4" //司机点了到达目的地, 等待行程开始
#define STATE_ORDER_EXECUTE  @"5" // 订单执行中, 司机开始点行程开始
#define STATE_ORDER_PAY_PENDING  @"6" // 订单执行完毕, 司机开始点了行程结束, 等待乘客付款
#define STATE_ORDER_FINISHED  @"7" // 订单付款成功,该订单完成,如果订单付款失败， 继续回退到等待付款
#define STATE_ORDER_COMMENTED  @"8" // 订单完成后，被评论
#define STATE_ORDER_CANCEL  @"-1" // 订单被取消，乘客或者司机点了取消订单
#define STATE_ORDER_CLOSED  @"100" // 订单关闭，司机或者乘客点了关闭订单，这种一般是在取消后，双方确认后，订单由司机改成关闭状态
#define STATE_ORDER_UNFINISHED 20 // 所有未完成的订单, 包括 1, 2, 3, 4, 5, 6

@interface OrderModel : BaseModel

@property (nonatomic,copy) NSString<Optional>* actFee;
@property (nonatomic,copy) NSString<Optional>* createDate;
@property (nonatomic,copy) NSString<Optional>* elocation;
@property (nonatomic,copy) NSString<Optional>* memberShipPhoneNo;
@property (nonatomic,copy) NSString<Optional>* no;
@property (nonatomic,copy) NSString<Optional>* slocation;
@property (nonatomic,copy) NSString<Optional>* state;
@property (nonatomic,copy) NSString<Optional>* type;
@property (nonatomic,copy) NSString<Optional>* ids;
@property (nonatomic,copy) NSString<Optional>* fee;
@property (nonatomic,copy) NSString<Optional>* appoint;
@property (nonatomic,copy) NSString<Optional>* bizType; ///bizType : 1, // 抢单 1， 派单 2 适用专车

/** 车信息 **/
@property (nonatomic,copy) NSString<Optional>* carDesc;
@property (nonatomic,copy) NSString<Optional>* carNo;
@property (nonatomic,copy) NSString<Optional>* carType;
/** 司机信息 **/
@property (nonatomic,copy) NSString<Optional>* dPhoneNo;
@property (nonatomic,copy) NSString<Optional>* dRealName;
@property (nonatomic,copy) NSString<Optional>* driverId;
@property (nonatomic,copy) NSString<Optional>* level;
@property (nonatomic,copy) NSString<Optional>* driverType;

@property (nonatomic,copy) NSString<Optional>* distance;
@property (nonatomic,copy) NSString<Optional>* endDate;
@property (nonatomic,copy) NSString<Optional>* mPhoneNo;
@property (nonatomic,copy) NSString<Optional>* mRealName;
@property (nonatomic,copy) NSString<Optional>* payType;
@property (nonatomic,copy) NSString<Optional>* startDate;

+ (void) fetchOrderListById:(NSString*)ids types:(NSString*)type page:(NSInteger)page succes:(QuerySuccessListBlock)suc failed:(QueryErrorBlock)fail;

+ (void) submitComment:(NSMutableDictionary*)params succes:(QuerySuccessBlock)suc failed:(QueryErrorBlock)fail;
@end
