//
//  CommonUtility.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-22.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CommonUtility.h"
static NSDateFormatter *formater;
@implementation CommonUtility

+ (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil) {
        return NULL;
    }
    if (token == nil) {
        token = @",";
    }
    NSString *str = @"";
    if (![token isEqualToString:@","]) {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }
    else {
        str = [NSString stringWithString:string];
    }
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL) {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < count; i++) {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    
    return coordinates;
}

+ (NSArray *)pathForCoordinateString:(NSString *)coordinateString
{
    if (coordinateString.length == 0)
    {
        return nil;
    }
    
    NSUInteger count = 0;
    
    CLLocationCoordinate2D *coordinates = [CommonUtility coordinatesForString:coordinateString
                                                              coordinateCount:&count
                                                                   parseToken:@";"];
    
    NSMutableArray * path = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++)
    {
        CLLocation * loc = [[CLLocation alloc] initWithCoordinate:coordinates[i] altitude:0.0 horizontalAccuracy:0.0 verticalAccuracy:0.0 timestamp:[NSDate date]];
        [path addObject:loc];
    }
    return path;
}

+ (NSString*) getGoodsOrderDesc:(NSString*)state
{
    NSInteger stateI = [state integerValue];
    NSString *descript=@"";
    switch (stateI) {
        case -1:
            descript=@"订单已取消";
            break;
        case 1:
            descript=@"发布成功";//新增订单
            break;
        case 2:
            descript = @"待司机确认";
            break;
        case 3:
            descript = @"待装货";
            break;
        case 4:
            descript = @"司机已到达";
            break;
        case 5:
            descript = @"行程中";
            break;
        case 6:
            descript = @"等待付款";
            break;
        case 7:
            descript = @"待评论";
            break;
        case 8:
            descript = @"已评论";
            break;
        case 9:
            descript = @"司机已到";
            break;
        case 10:
            descript = @"无人接单";
            break;
        case 20:
            descript=@"未完成订单";
            break;
        case 100:
            descript=@"订单关闭";
            break;
        default:
            break;
    }
    return descript;
}
+ (NSString*) getOrderDescription:(NSString*)state
{
    NSInteger stateI = [state integerValue];
    NSString *descript=@"";
    switch (stateI) {
        case -1:
            descript=@"已取消";
            break;
        case 1:
            descript=@"等待应答";//新增订单
            break;
        case 2:
            descript = @"待司机确认";
            break;
        case 3:
            descript = @"司机即将到达";
            break;
        case 4:
            descript = @"司机已到达";
            break;
        case 5:
            descript = @"行程中";
            break;
        case 6:
            descript = @"等待付款";
            break;
        case 7:
            descript = @"待评论";
            break;
        case 8:
            descript = @"已评论";
            break;
        case 9:
            descript = @"司机已到";
            break;
        case 10:
            descript = @"无人接单";
            break;
        case 20:
            descript=@"未完成订单";
            break;
        case 100:
            descript=@"订单关闭";
            break;
        default:
            break;
    }
    /*
    public static int STATE_ORDER_NEW = 1; // 新增, 提交后等待司机抢单
    public static int STATE_ORDER_CONFIRM_PENDNG = 2; // 提交后司机抢到单后， 等待司机确认
    public static int STATE_ORDER_CONFIRMED = 3; //司机确认订单 , 开始出发到目的地
    public static int STATE_ORDER_EXECUTE_PENDING = 4; //司机点了到达目的地, 等待行程开始
    public static int STATE_ORDER_EXECUTE = 5; // 订单执行中, 司机开始点行程开始
    public static int STATE_ORDER_PAY_PENDING = 6; // 订单执行完毕, 司机开始点了行程结束, 等待乘客付款
    public static int STATE_ORDER_FINISHED = 7; // 订单付款成功,该订单完成,如果订单付款失败， 继续回退到等待付款
    public static int STATE_ORDER_COMMENTED = 8; // 订单完成后，被评论
    public static int STATE_ORDER_CANCEL = -1; // 订单被取消，乘客或者司机点了取消订单
    public static int STATE_ORDER_CLOSED = 100; // 订单关闭，司机或者乘客点了关闭订单，这种一般是在取消后，双方确认后，订单由司机改成关闭状态
    public static int STATE_ORDER_UNFINISHED = 20; // 所有未完成的订单, 包括 1, 2, 3, 4, 5, 6
     */
    return descript;
}

+ (NSString*) userHeaderImageUrl:(NSString*)ids
{
    return [NSString stringWithFormat:@"%@getMHeadIcon?id=%@&token=%@",kserviceURL,
     ids,
     [GlobalData sharedInstance].user.session];
}

+ (NSString*) driverHeaderImageUrl:(NSString*)ids
{
    return [NSString stringWithFormat:@"%@getDHeadIcon?id=%@&token=%@",kserviceURL,
            ids,
            [GlobalData sharedInstance].user.session];
}

/*@!
    获取使用指南WebView  1 使用指南 2 法律条款  3 版本信息  4计价说明  5注册司机服务条款
 */
+ (NSString*) getArticalUrl:(NSString*)ids
{
    return [NSString stringWithFormat:@"%@getArticle?id=%@&token=%@",
                    kserviceURL,
                    ids,
                    [GlobalData sharedInstance].user.session];
}


+ (NSString*) convertDateToString:(NSDate*)date withFormat:(NSString*)formater_str
{
    if (!formater) {
        formater = [[NSDateFormatter alloc] init];
    }
    if (formater_str) {
        [formater setDateFormat:formater_str];
    }
    return [formater stringFromDate:date];
}

+ (NSString*) convertDateToString:(NSDate*)date
{
    return [CommonUtility convertDateToString:date withFormat:@"yyyy-MM-dd hh:mm:ss"];
}
+ (id) fetchDataFromArrayByIndex:(NSArray*)data withIndex:(NSInteger)index
{
    @try {
        return data[index]?data[index]:@"";
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@",exception);
    }
    @finally {
        
    }
    return @"";
}

+ (void) callTelphone:(NSString*)number
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",number]]];
}

+ (void) sendMessage:(NSString*)number
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",number]]];
}

+ (BOOL) validateParams:(NSString*)params withRegular:(NSString*)regular
{
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regular];
    return [numberPre evaluateWithObject:params];
}

+ (BOOL) validateNumber:(NSString*)params
{
    ///(^\d+(\.)?)?\d+$
    NSString *number=@"(^\\d+(\\.)?)?\\d+$";//@"^\\d+\\.?\\d+$";//^\d+\.?\d+$ @"^[0-9]+$"
    return [CommonUtility validateParams:params withRegular:number];
}
+ (BOOL) validateSizeForm:(NSString*)params
{
    NSString *size = @"^\\d+(x|X)\\d+(x|X)\\d+$";
    return [CommonUtility validateParams:params withRegular:size];
}

+ (BOOL) validatePhoneNumber:(NSString*)param
{
    NSString *regular = @"^1[3|4|5|7|8]\\d[0-9]\\d{7}$";
    return [CommonUtility validateParams:param withRegular:regular];
}

+ (NSString*)versions
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString*)builds
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}
@end
