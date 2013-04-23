//
//  NSString+Helper.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-22.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#define kAlphaNum @"0123456789"

@interface NSString (Helper)

- (BOOL)IsEmpty;
- (BOOL)isNumberString;
- (NSString *)toThousand;

- (NSArray *)HexString2RGB;
- (UIColor *)HexString2Color;

@end
