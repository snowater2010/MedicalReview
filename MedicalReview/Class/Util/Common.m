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

@end
