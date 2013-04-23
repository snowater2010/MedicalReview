//
//  MR_User.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_User.h"

@implementation MR_User

- (id)initWithId:(NSString *)uId name:(NSString *)uName;
{
    if (self = [super init]) {
        self.uId = uId;
        self.uName = uName;
    }
    return self;
}

-(void)dealloc
{
    self.uId = nil;
    self.uName = nil;
    [super dealloc];
}

@end
