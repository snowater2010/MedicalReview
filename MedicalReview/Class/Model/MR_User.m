//
//  MR_User.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_User.h"

@implementation MR_User

- (id)init
{
    if (self = [super init]) {
<<<<<<< HEAD
        self.isRememberPw = NO;
=======
        self.loginIsRememberPw = NO;
        self.userType = USER_TYPE_TEST;
>>>>>>> branch
    }
    return self;
}

- (id)initWithData:(NSDictionary *)userDic
{
    if (self = [super init]) {
        if (userDic) {
<<<<<<< HEAD
            self.uId = [userDic objectForKey:KEY_userId];
            self.uName = [userDic objectForKey:KEY_userName];
            self.uPassWord = [userDic objectForKey:KEY_userPassword];
            NSNumber *isRemember = [userDic objectForKey:KEY_userIsRemember];
            if (isRemember) {
                self.isRememberPw = [isRemember boolValue];
=======
            self.loginName = [userDic objectForKey:KEY_loginName];
            self.loginPassWord = [userDic objectForKey:KEY_loginPassWord];
            NSNumber *isRemember = [userDic objectForKey:KEY_loginIsRememberPw];
            if (isRemember) {
                self.loginIsRememberPw = [isRemember boolValue];
            }
            
            //用户类型
            if ([self.loginName isEqualToString:TEST_USER_NAME]) {
                self.userType = USER_TYPE_TEST;
            }
            else {
                self.userType = USER_TYPE_NORMAL;
>>>>>>> branch
            }
        }
    }
    return self;
}

<<<<<<< HEAD
- (NSDictionary *)user2Data
{
    NSDictionary *userDic = [[[NSDictionary alloc] initWithObjectsAndKeys:
                              _uId, KEY_userId,
                              _uName, KEY_userName,
                              _uPassWord, KEY_userPassword,
                              [NSNumber numberWithBool:_isRememberPw], KEY_userIsRemember,
=======
- (void)setLoginName:(NSString *)name passWord:(NSString *)passWord isRememberPw:(BOOL)isRememberPw
{
    self.loginName = name;
    self.loginPassWord = passWord;
    self.loginIsRememberPw = isRememberPw;
}

- (NSDictionary *)user2Data
{
    NSDictionary *userDic = [[[NSDictionary alloc] initWithObjectsAndKeys:
                              _loginName, KEY_loginName,
                              _loginPassWord, KEY_loginPassWord,
                              [NSNumber numberWithBool:_loginIsRememberPw], KEY_loginIsRememberPw,
>>>>>>> branch
                              nil] autorelease];
    return userDic;
}

-(void)dealloc
{
    self.loginName = nil;
    self.loginPassWord = nil;
    [super dealloc];
}

@end
