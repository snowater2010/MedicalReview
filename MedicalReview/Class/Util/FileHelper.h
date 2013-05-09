//
//  FileHelper.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-22.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

@interface FileHelper : NSObject

//pist相关
+ (NSDictionary*)getInfoPlistDic;

//Document目录，放数据文件
+ (NSString*)getDocumentPath;

//获取条款缓存文件路径
+ (NSString*)getClauseCacheFilePath;

//根据用户名，得到用户的打分缓存路径
+ (NSString*)getScoreCacheFilePath;

//根据用户名，得到用户的打分缓存路径(本地更新)
+ (NSString*)getScoreUpdateCacheFilePath;

//是否有缓存条款
+ (BOOL)ifHaveClauseCache;

//是否有缓存打分
+ (BOOL)ifHaveScoreCache;

//是否有缓存打分本地更新
+ (BOOL)ifHaveScoreUpdateCache;

//删除文件
+ (BOOL)removeFileAtPath:(NSString*)path;

//从缓存中读取条款数据
+ (NSDictionary *)readClauseDataFromCache;

//将条款数据写入缓存
+ (BOOL)writeClauseDataToCache:(NSDictionary *)dataDic;

+ (NSDictionary *)readScoreDataFromCache;

//更新打分数据缓存
+ (BOOL)writeScoreDataToCache:(NSDictionary *)dataDic;
//异步更新
+ (void)asyWriteScoreDataToCache:(NSDictionary *)dataDic;

+ (NSDictionary *)readScoreUpdateDataFromCache;

//更新打分数据缓存，本地更新
+ (BOOL)writeScoreUpdateDataToCache:(NSDictionary *)dataDic;
//异步更新
+ (void)asyWriteScoreUpdateDataToCache:(NSDictionary *)dataDic;

//从文件中读取条款数据，demo
+ (NSDictionary *)readClauseDataFromFile;

//从文件中读取打分数据，demo
+ (NSDictionary *)readScoreDataFromFile;


//------------

+ (BOOL)ifHaveCacheFile:(NSString *)fileName;
+ (NSString*)getCacheFilePath:(NSString *)fileName;
+ (BOOL)writeData:(NSDictionary *)dataDic toCacheFile:(NSString *)fileName;

//从文件中读取条款数据
+ (NSDictionary *)readDataFileWithName:(NSString *)fileName;


@end
