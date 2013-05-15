//
//  Common.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-22.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (BOOL)isEmptyString:(NSString *)str;
{
    if(!str || [str length] <= 0)
        return YES;
    return NO;
}

+ (BOOL)isNotEmptyString:(NSString *)str;
{
    return ![self isEmptyString:str];
}

+ (void)callDelegate:(id)delegate method:(SEL)seletor
{
    if ([delegate respondsToSelector:seletor])
        [delegate performSelector:seletor];
}

+ (void)callDelegate:(id)delegate method:(SEL)seletor withObject:(id)object
{
    if ([delegate respondsToSelector:seletor])
        [delegate performSelector:seletor withObject:object];
}

+ (BOOL)isValue:(int)value inNumberArray:(NSArray *)valueArr
{
    for (NSNumber *number in valueArr) {
        if (value == number.intValue) {
            return YES;
        }
    }
    return NO;
}

+ (void)addValue:(int)value inNumberArray:(NSMutableArray **)valueArr
{
    if (![self isValue:value inNumberArray:*valueArr])
        [*valueArr addObject:[NSNumber numberWithInt:value]];
}

+ (void)removeValue:(int)value inNumberArray:(NSMutableArray **)valueArr
{
    NSNumber *removeNumber = nil;
    for (NSNumber *number in *valueArr) {
        if (value == number.intValue) {
            removeNumber = number;
            break;
        }
    }
    if (removeNumber) {
        [*valueArr removeObject:removeNumber];
    }
}

@end
