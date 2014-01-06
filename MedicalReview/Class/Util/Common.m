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

<<<<<<< HEAD
=======
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

//根据16进制获取颜色
+(UIColor*)colorWithHexString:(NSString*) hexstring
{
	NSArray *rgb = [self HexString2RGB:hexstring];
	
	unsigned int r = [[rgb objectAtIndex:0] intValue];
	unsigned int g = [[rgb objectAtIndex:1] intValue];
	unsigned int b = [[rgb objectAtIndex:2] intValue];
	
	return [UIColor colorWithRed:((float) r / 255.0f)
						   green:((float) g / 255.0f)
							blue:((float) b / 255.0f)
						   alpha:1.0f];
}

//根据十六进制颜色值解析成RGB值
+(NSArray*) HexString2RGB:(NSString*)hexstring
{
	NSString* cString = [[hexstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	
	// String should be 6 or 8 characters
	if ([cString length] < 6)
		return 0;
	
	// strip 0X if it appears
	if([cString hasPrefix:@"0X"])
		cString = [cString substringFromIndex:2];
	if([cString hasPrefix:@"#"])
		cString = [cString substringFromIndex:1];
	if([cString length] != 6)
		return 0;
	
	// Separate into r, g, b substrings
	NSRange range;
	range.location = 0;
	
	range.length = 2;
	NSString* rString = [cString substringWithRange:range];
	
	range.location = 2;
	NSString* gString = [cString substringWithRange:range];
	
	range.location = 4;
	NSString* bString = [cString substringWithRange:range];
	
	// Scan values
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
 	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	
	NSArray *rgb = [NSArray arrayWithObjects:
					[NSNumber numberWithInt:r],
					[NSNumber numberWithInt:g],
					[NSNumber numberWithInt:b],nil];
	return rgb;
}

>>>>>>> branch
@end
