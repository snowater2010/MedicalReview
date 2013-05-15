//
//  MR_CollapseClauseView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-29.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ClauseView.h"

#define CELL_MARGIN 10

@interface MR_CollapseClauseView : UIScrollView <UIScrollViewDelegate, ClauseHeadDelegate>

@property(nonatomic, retain) NSArray *clauseData;
@property(nonatomic, retain) NSDictionary *scoreData;
@property(nonatomic, retain) NSArray *nodeData;
@property(nonatomic, assign) id<ClauseScoredDelegate> scoredDelegate;

@end
