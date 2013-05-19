//
//  NSArray+Helper.m
//  MedicalReview
//
//  Created by lipeng11 on 13-5-18.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "NSArray+Helper.h"

@implementation NSArray (Helper)

- (int)getIndexWithString:(NSString *)theStr
{
    if (!theStr && self.count <= 0)
        return NO_STRING_INDEX;
    
    for (int i = 0; i < self.count; i++) {
        NSString *str = [self objectAtIndex:i];
        if ([str isEqualToString:theStr]) {
            return i;
        }
    }
    return NO_STRING_INDEX;
}

@end
