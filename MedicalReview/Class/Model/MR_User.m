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
        self.isRememberPw = NO;
    }
    return self;
}

- (id)initWithData:(NSDictionary *)userDic
{
    if (self = [super init]) {
        if (userDic) {
            self.uId = [userDic objectForKey:KEY_userId];
            self.uName = [userDic objectForKey:KEY_userName];
            self.uPassWord = [userDic objectForKey:KEY_userPassword];
            NSNumber *isRemember = [userDic objectForKey:KEY_userIsRemember];
            if (isRemember) {
                self.isRememberPw = [isRemember boolValue];
            }
        }
    }
    return self;
}

- (NSDictionary *)user2Data
{
    NSDictionary *userDic = [[[NSDictionary alloc] initWithObjectsAndKeys:
                              _uId, KEY_userId,
                              _uName, KEY_userName,
                              _uPassWord, KEY_userPassword,
                              [NSNumber numberWithBool:_isRememberPw], KEY_userIsRemember,
                              nil] autorelease];
    return userDic;
}

-(void)dealloc
{
    self.uId = nil;
    self.uName = nil;
    [super dealloc];
}

@end
