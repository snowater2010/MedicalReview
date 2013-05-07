//
//  MR_Doctor.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_Doctor.h"

@implementation MR_Doctor

- (id)initWithData:(NSDictionary *)userDic
{
    if (self = [super init]) {
        if (userDic) {
            self.hospitalId = [userDic objectForKey:KEY_userHospitalId];
            self.hospitalName = [userDic objectForKey:KEY_userHospitalName];
        }
    }
    return self;
}

-(void)dealloc
{
    self.hospitalId = nil;
    self.hospitalName = nil;
    [super dealloc];
}

@end
