//
//  NSString+Helper.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-22.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

#pragma mark -- 字符串

-(BOOL)isNumberString
{
    if([Common isEmptyString:self])
        return NO;
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL basic = [self isEqualToString:filtered];
    
    return basic;
}

- (BOOL)isContainsString:(NSString *)str
{
    if (!str)
        return NO;
    
    NSRange range = [self rangeOfString:str];
    return range.length != 0;
}

//转千分位
- (NSString *)toThousand
{
    if([Common isEmptyString:self])
        return @"";
	NSMutableString* strThousand = [[[NSMutableString alloc]initWithString: self] autorelease];
	NSRange range = [strThousand rangeOfString:@"."];
	
	int iLen;
	if(range.length == 0){
		iLen = [strThousand length];
	}else{
		iLen = range.location;
	}
	int iWhole = iLen / 3;
	int iRemainder = iLen % 3;
	int iPos;
	
	for(int iIndex=iWhole; iIndex>0; iIndex--){
		iPos = iRemainder + (iIndex-1)*3;
		if(iPos != 0){
			if(iPos != 1 || (iPos == 1 && ![[strThousand substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"-"])){
				[strThousand insertString:@"," atIndex:iPos];
			}
		}
	}
	return strThousand;
}

#pragma mark -- 颜色
//根据16进制获取颜色组
- (NSArray *)HexString2RGB
{
	NSString *cString = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	
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
	NSString *rString = [cString substringWithRange:range];
	
	range.location = 2;
	NSString *gString = [cString substringWithRange:range];
	
	range.location = 4;
	NSString *bString = [cString substringWithRange:range];
	
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

//根据16进制获取颜色
- (UIColor *)HexString2Color
{
	NSArray *rgb = [[self HexString2RGB] retain];
	
	unsigned int r = [[rgb objectAtIndex:0] intValue];
	unsigned int g = [[rgb objectAtIndex:1] intValue];
	unsigned int b = [[rgb objectAtIndex:2] intValue];
	
	[rgb release];
	
	UIColor* result = [UIColor colorWithRed:((float) r / 255.0f)
                                      green:((float) g / 255.0f)
                                       blue:((float) b / 255.0f)
                                      alpha:1.0f];
    return result;
}

@end
