//
//  ASIHTTPRequest+Helper.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "ASIHTTPRequest+Helper.h"
#import "ASIFormDataRequest.h"

@implementation ASIHTTPRequest (Helper)

- (void)doRelease
{
    [self clearDelegatesAndCancel];
    [self release];
}

+ (ASIHTTPRequest*)doRequestForUrl:(NSString*)str_url data:(NSDictionary*)data delegate:(id)delegate userinfo:(NSDictionary*)userinfo
{
    ASIHTTPRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str_url]];
    request.persistentConnectionTimeoutSeconds = TIME_OUT_SECONDS;
    
    if (data)
        [request setBodyByDictionary:data];
    
    if (delegate)
        request.delegate = delegate;
    
    if (userinfo)
        request.userInfo = userinfo;
    
    [request startAsynchronous];
    
    return request;
}

+ (ASIHTTPRequest*)doRequestForUrl:(NSString*)str_url data:(NSDictionary*)data delegate:(id)delegate
{
    return [self doRequestForUrl:str_url data:data delegate:delegate userinfo:nil];
}

+ (ASIHTTPRequest*)doRequestForUrl:(NSString*)str_url data:(NSDictionary*)data
{
    return [self doRequestForUrl:str_url data:data delegate:nil userinfo:nil];
}

+ (ASIHTTPRequest*)doRequestForUrl:(NSString*)str_url
{
    return [self doRequestForUrl:str_url data:nil delegate:nil userinfo:nil];
}

- (void) setBodyByDictionary:(NSDictionary *)content
{
	NSString * tmpdata = [content JSONString];
    [self appendPostData:[tmpdata dataUsingEncoding:NSNonLossyASCIIStringEncoding allowLossyConversion:YES]];
}

@end

@implementation ASIFormDataRequest (Helper)

- (void)setDefaultPostValue
{
    _GET_APP_DELEGATE_(appDelegate);
    NSString *uid = appDelegate.globalinfo.userInfo.user.loginName;
    NSString *reviewId = appDelegate.globalinfo.userInfo.user.reviewId;
    NSString *expertNo = appDelegate.globalinfo.userInfo.user.expertNo;
    NSString *groupId = appDelegate.globalinfo.userInfo.user.groupId;
    
    [self setPostValue:uid forKey:@"uid"];
    [self setPostValue:reviewId forKey:@"reviewId"];
    [self setPostValue:expertNo forKey:@"expertNo"];
    [self setPostValue:groupId forKey:@"groupId"];
}

@end
