//
//  NSDate+Common.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-22.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "NSDate+Common.h"
#import "NSDate+Helper.h"

@implementation NSDate(Common)

+ (NSString *)nowTimeString
{
    NSString *str = [[NSDate date] stringWithFormat:[NSDate timeFormatString]];
    NSString *timeString = [[[NSString alloc] initWithString:str] autorelease];
    return timeString;
}
+ (NSString *)nowDayString
{
    NSString *str = [[NSDate date] stringWithFormat:[NSDate dateFormatString]];
    NSString *dayString = [[[NSString alloc] initWithString:str] autorelease];
    return dayString;
}
+ (NSString *)nowDayTimeString
{
    NSString *str = [[NSDate date] stringWithFormat:[NSDate timestampFormatString]];
    NSString *dayTimeString = [[[NSString alloc] initWithString:str] autorelease];
    return dayTimeString;
}

//获取相差几日的日期
-(NSDate *)getDateWithDay:(int)day
{
    NSDateComponents *comps = [[NSDateComponents alloc] init]; 
    [comps setDay:day]; 
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; 
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:self options:0]; 
    [comps release]; 
    [calender release]; 
    return mDate; 
} 

//获取相差几月的日期
-(NSDate *)getDateWithMonth:(int)month
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:self options:0];
    [comps release];
    [calender release];
    return mDate;
}

+ (NSString *)getDateFromString:(NSString*)timeString fromFormat:(NSString*)fromFormat toFormat:(NSString*)toFormat
{
    NSDate *fromDate = [NSDate dateFromString:timeString withFormat:fromFormat];
    NSString *toDateStr = [fromDate stringWithFormat:toFormat];
    NSString *result = [[[NSString alloc] initWithString:toDateStr] autorelease];
    return result;
}

@end
