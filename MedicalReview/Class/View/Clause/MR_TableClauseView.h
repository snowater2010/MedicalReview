//
//  MR_TableClauseView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-5-15.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"
#import "MR_ClauseHeadView.h"

@interface MR_TableClauseView : MR_RootView <ClauseHeadDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) NSArray *clauseData;
@property(nonatomic, retain) NSDictionary *scoreData;
@property(nonatomic, retain) NSArray *nodeData;

- (void)reloadData;

@end
