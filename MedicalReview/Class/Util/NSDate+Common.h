//
//  NSDate+Common.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-22.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

@interface NSDate(Common)

+ (NSString *)nowTimeString;
+ (NSString *)nowDayString;
+ (NSString *)nowDayTimeString;

- (NSDate *)getDateWithDay:(int)day;
- (NSDate *)getDateWithMonth:(int)month;

+ (NSString *)getDateFromString:(NSString*)timeString fromFormat:(NSString*)fromFormat toFormat:(NSString*)toFormat;

@end
