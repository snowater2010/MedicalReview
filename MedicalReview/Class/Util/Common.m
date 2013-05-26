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

//根据16进制获取颜色
+ (UIColor *)colorWithR:(int)r withG:(int)g withB:(int)b
{
	UIColor* result = [[[UIColor alloc] initWithRed:((float) r / 255.0f)
                                      green:((float) g / 255.0f)
                                       blue:((float) b / 255.0f)
                                      alpha:1.0f] autorelease];
    return result;
}

@end
