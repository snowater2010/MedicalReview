//
//  GlobalInfo.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "GlobalInfo.h"

#pragma mark -
#pragma mark -- ServerInfo
@implementation ServerInfo

-(id)init
{
    if(self = [super init])
    {
        _strWebServiceUrl = nil;
        _strAppUpdateUrl = nil;
    }
    return self;
}

-(void)dealloc
{
    self.strWebServiceUrl = nil;
    self.strAppUpdateUrl = nil;
    [super dealloc];
}


@end

#pragma mark -
#pragma mark -- UserInfo
@implementation UserInfo

-(id)init
{
    if(self = [super init])
    {
        _user = nil;
    }
    return self;
}

-(BOOL)isLeaderUser
{
    return NO;
}

-(BOOL)isMemberUser
{
    return NO;
}

-(void)dealloc
{
    self.user = nil;
    [super dealloc];
}

@end

#pragma mark -
#pragma mark -- GlobalInfo
@implementation GlobalInfo

-(id)init
{
    if(self = [super init])
    {
        _userInfo = [[UserInfo alloc] init];
        _serverInfo = [[ServerInfo alloc] init];
    }
    return self;
}
-(void)dealloc
{
    self.userInfo = nil;
    self.serverInfo = nil;
    [super dealloc];
}

@end
