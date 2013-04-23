//
//  FileHelper.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-22.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper

//获取属性列表数据
+(NSDictionary*)getInfoPlistDic
{
    NSDictionary* resDic = [[[NSDictionary alloc]initWithDictionary:[[NSBundle mainBundle] infoDictionary]] autorelease];
    return resDic;
}

//获取doc路径
+(NSString*)getDocumentPath
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return path;
}

//根据指定路径，删除文件
+(BOOL)removeFileAtPath:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path])
    {
		NSError *removeError = nil;
		[fileManager removeItemAtPath:path error:&removeError];
		if (removeError)
        {
            NSLog(@"file remove failed :%@", [removeError domain]);
			return NO;
		}
	}
	return YES;
}

@end
