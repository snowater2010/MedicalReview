//
//  MR_User.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#define TEST_USER_NAME @"test2013"

enum USER_TYPE {
    USER_TYPE_TEST,
    USER_TYPE_NORMAL
};

@interface MR_User : NSObject

<<<<<<< HEAD
@property(nonatomic, retain) NSString *uId;
@property(nonatomic, retain) NSString *uName;
@property(nonatomic, retain) NSString *uPassWord;
@property(nonatomic, assign) BOOL isRememberPw;

- (id)initWithData:(NSDictionary *)userDic;
=======
@property(nonatomic, assign) enum USER_TYPE userType;
@property(nonatomic, retain) NSString *loginName;
@property(nonatomic, retain) NSString *loginPassWord;
@property(nonatomic, assign) BOOL loginIsRememberPw;

- (id)initWithData:(NSDictionary *)userDic;
- (void)setLoginName:(NSString *)name passWord:(NSString *)passWord isRememberPw:(BOOL)isRememberPw;
>>>>>>> branch
- (NSDictionary *)user2Data;

@end
