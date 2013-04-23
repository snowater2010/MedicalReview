//
//  MR_Leader.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_Leader.h"

@implementation MR_Leader

- (id)init
{
    self = [super init];
    if (self) {
        self.members = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    self.members = nil;
    [super dealloc];
}

@end
