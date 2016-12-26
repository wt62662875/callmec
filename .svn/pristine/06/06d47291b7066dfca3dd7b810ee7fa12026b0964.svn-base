//
//  TimeTool.m
//  TimePicker
//
//  Created by App on 1/14/16.
//  Copyright © 2016 App. All rights reserved.
//

#import "MyTimeTool.h"
#define MAXCOUNTDAYS 100

@implementation MyTimeTool

+(NSArray *)daysFromNowToDeadLine:(NSString *)deadLine{
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyyMMdd"];
    NSDate *startDate = [f dateFromString:[self summaryTimeUsingDate:[NSDate date]]];
    NSDate *endDate = [f dateFromString:deadLine];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:endDate
                                                          toDate:startDate
                                                         options:NSCalendarWrapComponents];
    int diffDays = components.day;
    if(diffDays==0) return @[[self summaryTimeUsingDate:[NSDate date]]];
    NSMutableArray *dayArray = [NSMutableArray array];
    if(diffDays > MAXCOUNTDAYS) diffDays = MAXCOUNTDAYS;
    for (int i = 0; i <= diffDays; i++) {
        NSTimeInterval  iDay = 24*60*60*i;  //1天的长度
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:iDay];
        [dayArray addObject:[self summaryTimeUsingDate:date]];
    }
    return dayArray;
}

+(int)currentDateHour{
    //NSLog(@"hour is: %d", [self dateComponents].hour);
    return [self dateComponents].hour;
}

+(int)currentDateMinute{
    //NSLog(@"minute is: %d", [self dateComponents].minute);
    return [self dateComponents].minute;
}

+(NSDateComponents *)dateComponents{
    NSDate *currentDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:currentDate];
    return dateComponent;
}

+(NSString *)summaryTimeUsingDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+(NSString *)summaryTimeUsingDate1:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+(NSDate *)summaryDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return [dateFormatter dateFromString:dateStr];
}

+(NSString *)displayedSummaryTimeUsingString:(NSString *)string
{
    NSMutableString *result = [[NSMutableString alloc] initWithString:[string substringWithRange:NSMakeRange(0, 4)]];
    [result appendString:@"-"];
    [result appendString:[string substringWithRange:NSMakeRange(4, 2)]];
    [result appendString:@"-"];
    [result appendString:[string substringWithRange:NSMakeRange(6, 2)]];
    return result;
}

+ (NSString*) formatDateTime:(NSString*)dateTimer withFormat:(NSString*)format
{
    
    NSDateFormatter *dsf = [[NSDateFormatter alloc] init];
    [dsf setDateFormat:@"yyyyMMddHHmm"];//yyyy-MM-dd HH:mm:ss
    NSDate *date = [dsf dateFromString:dateTimer];
    
    if (format) {
        NSDateFormatter *ddf = [[NSDateFormatter alloc] init];
        [ddf setDateFormat:format];
        return [ddf stringFromDate:date];
    }
    
    
    //NSCalendarUnitHour
//    NSCalendarUnitDay
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    /*
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitHour
                                                        fromDate:[NSDate date]
                                                          toDate:date
                                                         options:NSCalendarWrapComponents];
    */
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSUInteger unitFlags = NSHourCalendarUnit|NSDayCalendarUnit;
//    NSDateComponents *cp = [gregorianCalendar components:unitFlags fromDate:date];
    
    NSUInteger unitFlags = NSHourCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *cpday =[gregorianCalendar components:unitFlags fromDate:[MyTimeTool summaryDate:[NSDate date]] toDate:date options:NSCalendarWrapComponents];
    
    NSDateComponents *cp = [gregorianCalendar components:unitFlags fromDate:date];
    
    if (cpday.day==0) {
        if(cp.hour>=0 && cp.hour<5)
        {
            [dateFormatter setDateFormat:@"MM月dd日 今天 凌晨 HH:mm"];
        }else if (cp.hour>5 && cp.hour<=9) {
            [dateFormatter setDateFormat:@"MM月dd日 今天 早上 HH:mm"];
        }else if (cp.hour>9 && cp.hour<=12) {
            [dateFormatter setDateFormat:@"MM月dd日 今天 上午 HH:mm"];
        }else if (cp.hour>12 && cp.hour<=19) {
            [dateFormatter setDateFormat:@"MM月dd日 今天 下午 HH:mm"];
        }else if (cp.hour>19 && cp.hour<=23) {
            [dateFormatter setDateFormat:@"MM月dd日 今天 晚上 HH:mm"];
        }
        
    }else if(cpday.day==1){
        if(cp.hour>=0 && cp.hour<= 5)
        {
            [dateFormatter setDateFormat:@"MM月dd日 明天 凌晨 HH:mm"];
        }else if (cp.hour>5 && cp.hour<=9) {
            [dateFormatter setDateFormat:@"MM月dd日 明天 早上 HH:mm"];
        }else if (cp.hour>9 && cp.hour<=12) {
            [dateFormatter setDateFormat:@"MM月dd日 明天 上午 HH:mm"];
        }else if (cp.hour>12 && cp.hour<=19) {
            [dateFormatter setDateFormat:@"MM月dd日 明天 下午 HH:mm"];
        }else if (cp.hour>19 && cp.hour<=23) {
            [dateFormatter setDateFormat:@"MM月dd日 明天 晚上 HH:mm"];
        }
    }else if(cpday.day==2)
    {
        if(cp.hour>=0 && cp.hour<= 5)
        {
            [dateFormatter setDateFormat:@"MM月dd日 后天 凌晨 HH:mm"];
        }else if (cp.hour>5 && cp.hour<=9) {
            [dateFormatter setDateFormat:@"MM月dd日 后天 早上 HH:mm"];
        }else if (cp.hour>9 && cp.hour<=12) {
            [dateFormatter setDateFormat:@"MM月dd日 后天 上午 HH:mm"];
        }else if (cp.hour>12 && cp.hour<=19) {
            [dateFormatter setDateFormat:@"MM月dd日 后天 下午 HH:mm"];
        }else if (cp.hour>19 && cp.hour<=23) {
            [dateFormatter setDateFormat:@"MM月dd日 后天 晚上 HH:mm"];
        }
    }else{
        [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    }
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSLog(@"components %@",dateString);
    return dateString;
}

-(NSString*)timeformatFromSeconds:(NSInteger)seconds
{
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}

- (NSInteger)compareFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate
{
    NSUInteger unitFlags = NSHourCalendarUnit|NSDayCalendarUnit;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *cp = [gregorianCalendar components:unitFlags fromDate:fromDate];
    return cp.second;
}

@end
