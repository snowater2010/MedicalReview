//
//  MR_ExplainView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"

#define TAG_VIEW_EXPLAIN 0101

@interface MR_ExplainView : MR_RootView

@property(nonatomic, retain) NSString *wordExplan;
@property(nonatomic, assign) float textSize;
@property(nonatomic, assign) BOOL readOnly;

- (void)btPressed;
- (NSString *)getExplain;

@end
