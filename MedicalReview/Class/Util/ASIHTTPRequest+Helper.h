//
//  ASIHTTPRequest+Helper.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#define TIME_OUT_SECONDS 20

@interface ASIHTTPRequest (Helper)

- (void)doRelease;

+ (ASIHTTPRequest*)doRequestForUrl:(NSString*)str_url data:(NSDictionary*)data delegate:(id)delegate userinfo:(NSDictionary*)userinfo;
+ (ASIHTTPRequest*)doRequestForUrl:(NSString*)str_url data:(NSDictionary*)data delegate:(id)delegate;
+ (ASIHTTPRequest*)doRequestForUrl:(NSString*)str_url data:(NSDictionary*)data;
+ (ASIHTTPRequest*)doRequestForUrl:(NSString*)str_url;

@end

@interface ASIFormDataRequest (Helper)

- (void)setDefaultPostValue;

@end