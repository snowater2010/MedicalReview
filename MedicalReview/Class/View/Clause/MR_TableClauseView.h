//
//  MR_TableClauseView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-5-15.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"
#import "MR_ClauseHeadView.h"
#import "MR_ClauseNodeView.h"

#define DEFAULT_CELL_HEIGHT 60
#define NAME_TEXT_SIZE 14
#define TAG_CELL_NODE_VIEW 10000

@protocol TableClauseViewDelegate <NSObject>

@optional
- (void)clauseScored:(NSDictionary *)scoredData;

@end

@interface MR_TableClauseView : MR_RootView <ClauseHeadDelegate, ClauseNodeDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, assign) BOOL readOnly;
@property(nonatomic, retain) NSArray *clauseData;
@property(nonatomic, retain) NSDictionary *scoreData;
@property(nonatomic, retain) NSArray *nodeData;
@property(nonatomic, assign) id<TableClauseViewDelegate> scoredDelegate;

- (void)reloadData;
- (void)reSizeTable:(CGRect)frame;

@end
