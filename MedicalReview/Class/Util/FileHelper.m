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

#pragma mark -
#pragma mark --- clause

//获取条款缓存文件路径
+ (NSString*)getClauseCacheFilePath
{
    NSString* clausePath = [[FileHelper getDocumentPath] stringByAppendingPathComponent:CACHE_CLAUSE];
    NSString* path = [[[NSString alloc]initWithString:clausePath] autorelease];
    return path;
}

//是否有缓存条款
+ (BOOL)ifHaveClauseCache
{
    NSString *clausePath = [self getClauseCacheFilePath];
    return [[NSFileManager defaultManager] fileExistsAtPath:clausePath];
}

+ (id)readClauseDataFromCache
{
    NSDictionary *result = nil;
    if ([self ifHaveClauseCache]) {
        NSString *cachePath = [FileHelper getClauseCacheFilePath];
        result = [[[NSDictionary alloc] initWithContentsOfFile:cachePath] autorelease];
    }
    return result;
}

+ (BOOL)writeClauseDataToCache:(id)dataDic
{
    if (!dataDic)
        return NO;
    
    NSString *cachePath = [FileHelper getClauseCacheFilePath];
    
    //移出先
    BOOL removed = [self removeFileAtPath:cachePath];
    
    if (removed) {
        return [dataDic writeToFile:cachePath atomically:YES];
    }
    else {
        return NO;
    }
}

#pragma mark -
#pragma mark --- score
//根据用户名，得到用户的打分缓存路径
+ (NSString*)getScoreCacheFilePath
{
    _GET_APP_DELEGATE_(appDelegate);
    NSString *userName = appDelegate.globalinfo.userInfo.user.loginName;
    
    NSString *userPath = [[FileHelper getDocumentPath] stringByAppendingPathComponent:userName];
    
    //if the user folder not exist, create it
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if (![fileManger fileExistsAtPath:userPath]) {
        [fileManger createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *scorePath = [userPath stringByAppendingPathComponent:CACHE_SCORE];
    NSString *result = [[[NSString alloc] initWithString:scorePath] autorelease];
    return result;
}

//根据用户名，得到用户的打分缓存路径(本地更新)
+ (NSString*)getScoreUpdateCacheFilePath
{
    _GET_APP_DELEGATE_(appDelegate);
    NSString *userName = appDelegate.globalinfo.userInfo.user.loginName;
    
    NSString *userPath = [[FileHelper getDocumentPath] stringByAppendingPathComponent:userName];
    
    //if the user folder not exist, create it
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if (![fileManger fileExistsAtPath:userPath]) {
        [fileManger createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *scorePath = [userPath stringByAppendingPathComponent:CACHE_SCORE_UPDATE];
    NSString *result = [[[NSString alloc] initWithString:scorePath] autorelease];
    return result;
}

//删除用户的打分缓存路径(本地更新)
+ (void)removeScoreUpdateCacheFile
{
    if ([FileHelper ifHaveScoreUpdateCache]) {
        NSString *path = [FileHelper getScoreUpdateCacheFilePath];
        [FileHelper removeFileAtPath:path];
    }
}

+ (BOOL)ifHaveScoreCache
{
    _GET_APP_DELEGATE_(appDelegate);
    NSString *userName = appDelegate.globalinfo.userInfo.user.loginName;
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    
    NSString *userPath = [[FileHelper getDocumentPath] stringByAppendingPathComponent:userName];
    if (![fileManger fileExistsAtPath:userPath]) {
        return NO;
    }
    else {
        NSString *scorePath = [userPath stringByAppendingPathComponent:CACHE_SCORE];
        if (![fileManger fileExistsAtPath:scorePath])
            return NO;
        else
            return YES;
    }
}

+ (BOOL)ifHaveScoreUpdateCache
{
    _GET_APP_DELEGATE_(appDelegate);
    NSString *userName = appDelegate.globalinfo.userInfo.user.loginName;
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    
    NSString *userPath = [[FileHelper getDocumentPath] stringByAppendingPathComponent:userName];
    if (![fileManger fileExistsAtPath:userPath]) {
        return NO;
    }
    else {
        NSString *scorePath = [userPath stringByAppendingPathComponent:CACHE_SCORE_UPDATE];
        if (![fileManger fileExistsAtPath:scorePath])
            return NO;
        else
            return YES;
    }
}

+ (NSDictionary *)readScoreDataFromCache
{
    NSDictionary *result = nil;
    
    if ([self ifHaveScoreCache]) {
        NSString *cachePath = [FileHelper getScoreCacheFilePath];
        NSDictionary *jsonDic = [NSDictionary dictionaryWithContentsOfFile:cachePath];
        
        result = [[[NSDictionary alloc] initWithDictionary:jsonDic] autorelease];
        _LOG_(@"读取条款缓存成功！");
    }
    
    return result;
}

+ (void)asyWriteScoreDataToCache:(NSDictionary *)dataDic
{
    [NSThread detachNewThreadSelector:@selector(writeScoreDataToCache:) toTarget:self withObject:dataDic];
}

+ (BOOL)writeScoreDataToCache:(NSDictionary *)dataDic
{
    if (!dataDic)
        return NO;
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    if ([self ifHaveScoreCache]) {
        NSDictionary *scoreDic = [self readScoreDataFromCache];
        if (scoreDic)
            [resultDic addEntriesFromDictionary:scoreDic];
        
        //if have to do delete first, need test;
    }
    [resultDic addEntriesFromDictionary:dataDic];
    
    NSString *cachePath = [FileHelper getScoreCacheFilePath];
    //不知道writeToFile方法是否是线程安全的，所以上锁
    _lock;
    BOOL result = [resultDic writeToFile:cachePath atomically:YES];
    _unlock;
    [resultDic release];
    
    return result;
}

+ (NSDictionary *)readScoreUpdateDataFromCache
{
    NSDictionary *result = nil;
    
    if ([self ifHaveScoreUpdateCache]) {
        NSString *cachePath = [FileHelper getScoreUpdateCacheFilePath];
        NSDictionary *jsonDic = [NSDictionary dictionaryWithContentsOfFile:cachePath];
        
        result = [[[NSDictionary alloc] initWithDictionary:jsonDic] autorelease];
        _LOG_(@"读取条款缓存成功！");
    }
    
    return result;
}

+ (void)asyWriteScoreUpdateDataToCache:(NSDictionary *)dataDic
{
    [NSThread detachNewThreadSelector:@selector(writeScoreUpdateDataToCache:) toTarget:self withObject:dataDic];
}

+ (BOOL)writeScoreUpdateDataToCache:(NSDictionary *)dataDic
{
    if (!dataDic)
        return NO;
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    if ([self ifHaveScoreUpdateCache]) {
        NSDictionary *scoreDic = [self readScoreUpdateDataFromCache];
        if (scoreDic) 
            [resultDic addEntriesFromDictionary:scoreDic];
    }
    [resultDic addEntriesFromDictionary:dataDic];
    
    NSString *cachePath = [FileHelper getScoreUpdateCacheFilePath];
    _lock;
    BOOL result = [resultDic writeToFile:cachePath atomically:YES];
    _unlock;
    [resultDic release];
    
    return result;
}

+ (BOOL)ifHaveCacheFile:(NSString *)fileName
{
    _GET_APP_DELEGATE_(appDelegate);
    NSString *userName = appDelegate.globalinfo.userInfo.user.loginName;
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    
    NSString *userPath = [[FileHelper getDocumentPath] stringByAppendingPathComponent:userName];
    if (![fileManger fileExistsAtPath:userPath]) {
        return NO;
    }
    else {
        NSString *filePath = [userPath stringByAppendingPathComponent:fileName];
        if (![fileManger fileExistsAtPath:filePath])
            return NO;
        else
            return YES;
    }
}

+ (NSString*)getCacheFilePath:(NSString *)fileName
{
    _GET_APP_DELEGATE_(appDelegate);
    NSString *userName = appDelegate.globalinfo.userInfo.user.loginName;
    
    NSString *userPath = [[FileHelper getDocumentPath] stringByAppendingPathComponent:userName];
    
    //if the user folder not exist, create it
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if (![fileManger fileExistsAtPath:userPath]) {
        [fileManger createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *scorePath = [userPath stringByAppendingPathComponent:fileName];
    NSString *result = [[[NSString alloc] initWithString:scorePath] autorelease];
    return result;
}

+ (BOOL)writeData:(id)dataDic toCacheFile:(NSString *)fileName
{
    if (!dataDic)
        return NO;
    
    NSString *cachePath = [FileHelper getCacheFilePath:fileName];
    //不知道writeToFile方法是否是线程安全的，所以上锁
    _lock;
    BOOL result = [dataDic writeToFile:cachePath atomically:YES];
    _unlock;
    
    return result;
}

+ (id)readDataFromCache:(NSString *)fileName
{
    NSArray *result = nil;
    if ([self ifHaveCacheFile:fileName]) {
        NSString *cachePath = [FileHelper getCacheFilePath:fileName];
        result = [[[NSArray alloc] initWithContentsOfFile:cachePath] autorelease];
    }
    return result;
}

#pragma mark -
#pragma mark --- demo file
+ (id)readDataFileWithName:(NSString *)fileName
{
    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    return [jsonData objectFromJSONData];
}
+ (NSDictionary *)readClauseDataFromFile
{
    NSString *fileName = @"json_clause.txt";
    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    return [jsonData objectFromJSONData];
}

+ (NSDictionary *)readScoreDataFromFile
{
    NSString *fileName = @"json_score.txt";
    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    return [jsonData objectFromJSONData];
}

@end
