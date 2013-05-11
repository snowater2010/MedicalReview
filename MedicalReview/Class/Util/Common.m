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

@end
