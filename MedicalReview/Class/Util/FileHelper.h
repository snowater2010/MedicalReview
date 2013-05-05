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
+ (NSString*)getClauseFilePath;

//获取打分缓存文件路径
+ (NSString*)getScoreFilePath;

//是否有缓存条款
+ (BOOL)ifHaveClauseCache;

//删除文件
+ (BOOL)removeFileAtPath:(NSString*)path;

//从缓存中读取条款数据
+ (NSDictionary *)readClauseDataFromCache;

//将条款数据写入缓存
+ (BOOL)writeDataToCache:(NSDictionary *)dataDic;

//从文件中读取条款数据，demo
+ (NSDictionary *)readClauseDataFromFile;

//从文件中读取打分数据，demo
+ (NSDictionary *)readScoreDataFromFile;

@end
