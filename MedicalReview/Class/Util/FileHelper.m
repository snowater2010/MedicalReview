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
+ (NSDictionary*)getInfoPlistDic
{
    NSDictionary* resDic = [[[NSDictionary alloc]initWithDictionary:[[NSBundle mainBundle] infoDictionary]] autorelease];
    return resDic;
}

//获取doc路径
+ (NSString*)getDocumentPath
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return path;
}

//获取条款缓存文件路径
+ (NSString*)getClauseFilePath
{
    NSString* clausePath = [[FileHelper getDocumentPath] stringByAppendingPathComponent:CACHE_CLAUSE];
    NSString* path = [[[NSString alloc]initWithString:clausePath] autorelease];
    return path;
}

//获取打分缓存文件路径
+ (NSString*)getScoreFilePath
{
    NSString* scorePath = [[FileHelper getDocumentPath] stringByAppendingPathComponent:CACHE_SCORE];
    NSString* path = [[[NSString alloc]initWithString:scorePath] autorelease];
    return path;
}

+ (BOOL)ifHaveClauseCache
{
    NSString *clausePath = [self getClauseFilePath];
    BOOL isss = [[NSFileManager defaultManager] fileExistsAtPath:clausePath];
    return isss;
}

//根据指定路径，删除文件
+ (BOOL)removeFileAtPath:(NSString*)path
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

+ (NSDictionary *)readClauseDataFromCache
{
    NSString *cachePath = [FileHelper getClauseFilePath];
    
    NSDictionary *jsonDic = [NSDictionary dictionaryWithContentsOfFile:cachePath];
    _LOG_(@"读取条款缓存成功！");
    
    return jsonDic;
}

+ (BOOL)writeDataToCache:(NSDictionary *)dataDic
{
    NSString *cachePath = [FileHelper getClauseFilePath];
    
    BOOL result = [dataDic writeToFile:cachePath atomically:YES];
    if (result) {
        _LOG_(@"写入条款缓存成功！");
    }
    return result;
}

+ (NSDictionary *)readClauseDataFromFile
{
    NSString *fileName = @"json_clause.txt";
    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *jsonDic = [[NSDictionary dictionaryWithDictionary:[jsonData objectFromJSONData]] autorelease];
    return jsonDic;
}

+ (NSDictionary *)readScoreDataFromFile
{
    NSString *fileName = @"json_score.txt";
    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *jsonDic = [[NSDictionary dictionaryWithDictionary:[jsonData objectFromJSONData]] autorelease];
    return jsonDic;
}

@end
