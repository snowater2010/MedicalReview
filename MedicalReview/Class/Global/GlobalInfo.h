//
//  GlobalInfo..h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_Doctor.h"

//服务器信息
@interface ServerInfo : NSObject

@property(nonatomic, retain) NSString *serviceUrl;
@property(nonatomic, retain) NSString *strWebServiceUrl;
@property(nonatomic, retain) NSString *strAppUpdateUrl;

@end

//userInfo
@interface UserInfo : NSObject

@property(nonatomic, retain) MR_Doctor *user;

-(BOOL)isLeaderUser;
-(BOOL)isMemberUser;

@end

//shared data
@interface ShareData : NSObject

@property(nonatomic, retain) NSDictionary *clauseData;
@property(nonatomic, retain) NSArray *statementData;

@end

@interface GlobalInfo : NSObject

@property(nonatomic, retain) UserInfo *userInfo;
@property(nonatomic, retain) ServerInfo *serverInfo;
@property(nonatomic, retain) ShareData *shareData;

@end
