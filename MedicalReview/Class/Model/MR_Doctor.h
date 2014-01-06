//
//  MR_Doctor.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_User.h"

@interface MR_Doctor : MR_User

<<<<<<< HEAD
@property(nonatomic, retain) NSString *hospitalId;
@property(nonatomic, retain) NSString *hospitalName;

=======
@property(nonatomic, retain) NSString *expertNo;
@property(nonatomic, retain) NSString *expertName;
@property(nonatomic, retain) NSString *reviewId;
@property(nonatomic, retain) NSString *groupId;
@property(nonatomic, retain) NSString *hospitalId;
@property(nonatomic, retain) NSString *hospitalName;

- (id)initWithData:(NSDictionary *)userDic;
- (NSDictionary *)user2Data;

>>>>>>> branch
@end
