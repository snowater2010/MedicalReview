//
//  MR_User.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

@interface MR_User : NSObject

@property(nonatomic, retain) NSString *loginName;
@property(nonatomic, retain) NSString *loginPassWord;
@property(nonatomic, assign) BOOL loginIsRememberPw;

- (id)initWithData:(NSDictionary *)userDic;
- (void)setLoginName:(NSString *)name passWord:(NSString *)passWord isRememberPw:(BOOL)isRememberPw;
- (NSDictionary *)user2Data;

@end
