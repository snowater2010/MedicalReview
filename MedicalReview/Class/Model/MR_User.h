//
//  MR_User.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

@interface MR_User : NSObject

@property(nonatomic, retain) NSString *uId;
@property(nonatomic, retain) NSString *uName;
@property(nonatomic, retain) NSString *uPassWord;
@property(nonatomic, assign) BOOL isRememberPw;

- (id)initWithData:(NSDictionary *)userDic;
- (NSDictionary *)user2Data;

@end
