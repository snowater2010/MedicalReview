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

- (id)initWithId:(NSString *)uId name:(NSString *)uName;

@end
