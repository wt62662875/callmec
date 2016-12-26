//
//  TimeTool.h
//  TimePicker
//
//  Created by App on 1/14/16.
//  Copyright © 2016 App. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTimeTool : NSObject

+(NSArray *)daysFromNowToDeadLine:(NSString *)deadLine;

+(int)currentDateHour;

+(int)currentDateMinute;

+(NSDate *)summaryDate:(NSDate *)date;

+(NSString *)displayedSummaryTimeUsingString:(NSString *)string;

+ (NSString*) formatDateTime:(NSString*)dateTimer withFormat:(NSString*)format;

+ (NSString*)timeformatFromSeconds:(NSInteger)seconds;
@end
