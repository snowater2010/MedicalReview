//
//  MR_Doctor.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_Doctor.h"

@implementation MR_Doctor

<<<<<<< HEAD
- (id)initWithData:(NSDictionary *)userDic
{
    if (self = [super init]) {
        if (userDic) {
=======
- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (id)initWithData:(NSDictionary *)userDic
{
    if (self = [super initWithData:userDic]) {
        if (userDic) {
            self.expertNo = [userDic objectForKey:KEY_userExpertNod];
            self.expertName = [userDic objectForKey:KEY_userExpertName];
            self.reviewId = [userDic objectForKey:KEY_userReviewId];
            self.groupId = [userDic objectForKey:KEY_userGroupId];
>>>>>>> branch
            self.hospitalId = [userDic objectForKey:KEY_userHospitalId];
            self.hospitalName = [userDic objectForKey:KEY_userHospitalName];
        }
    }
    return self;
}

-(void)dealloc
{
<<<<<<< HEAD
=======
    self.expertNo = nil;
    self.expertName = nil;
    self.reviewId = nil;
    self.groupId = nil;
>>>>>>> branch
    self.hospitalId = nil;
    self.hospitalName = nil;
    [super dealloc];
}

<<<<<<< HEAD
=======
- (NSDictionary *)user2Data
{
    NSDictionary *superDic = [super user2Data];
    if (superDic) {
        NSMutableDictionary *userDic = [[[NSMutableDictionary alloc] initWithDictionary:superDic] autorelease];
        [userDic setValue:_expertNo forKey:KEY_userExpertNod];
        [userDic setValue:_expertName forKey:KEY_userExpertName];
        [userDic setValue:_reviewId forKey:KEY_userReviewId];
        [userDic setValue:_groupId forKey:KEY_userGroupId];
        [userDic setValue:_hospitalId forKey:KEY_userHospitalId];
        [userDic setValue:_hospitalName forKey:KEY_userHospitalName];
        return userDic;
    }
    else {
        return nil;
    }
}

>>>>>>> branch
@end
