//
//  MR_ClauseView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"
#import "CollapseClick.h"

@interface MR_ClauseView : MR_RootView <CollapseClickDelegate>

@property(nonatomic, retain) NSDictionary *jsonData;

@end
