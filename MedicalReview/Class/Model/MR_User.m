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
        self.loginIsRememberPw = NO;
    }
    return self;
}

- (id)initWithData:(NSDictionary *)userDic
{
    if (self = [super init]) {
        if (userDic) {
            self.loginName = [userDic objectForKey:KEY_loginName];
            self.loginPassWord = [userDic objectForKey:KEY_loginPassWord];
            NSNumber *isRemember = [userDic objectForKey:KEY_loginIsRememberPw];
            if (isRemember) {
                self.loginIsRememberPw = [isRemember boolValue];
            }
        }
    }
    return self;
}

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
