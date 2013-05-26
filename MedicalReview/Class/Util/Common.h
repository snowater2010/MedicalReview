//
//  MR_AppDelegate.h
//  Common
//
//  Created by lipeng11 on 13-4-22.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

@interface Common : NSObject

+ (BOOL)isEmptyString:(NSString *)str;

+ (BOOL)isNotEmptyString:(NSString *)str;

+ (void)callDelegate:(id)delegate method:(SEL)seletor;

+ (void)callDelegate:(id)delegate method:(SEL)seletor withObject:(id)object;

+ (UIColor *)colorWithR:(int)r withG:(int)g withB:(int)b;

@end
