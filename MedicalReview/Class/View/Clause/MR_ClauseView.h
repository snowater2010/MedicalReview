//
//  MR_ClauseView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"
#import "MR_ClauseHeadView.h"
#import "MR_ClauseNodeView.h"

#define DEFAULT_CELL_HEIGHT 50

#define NAME_TEXT_SIZE 14

enum CLAUSE_HEAD_STATE {
    CLAUSE_HEAD_STATE_OPEN = 0,
    CLAUSE_HEAD_STATE_CLOSE = 1,
};

@class MR_ClauseHeadView;

@interface MR_ClauseView : MR_RootView <ClauseHeadDelegate, ClauseNodeDelegate>

@property(nonatomic, retain) NSDictionary *jsonData;
@property(nonatomic, retain) NSDictionary *scoreData;
@property(nonatomic, assign) float cellHeight;
@property(nonatomic, retain) id<ClauseHeadDelegate> delegate;
@property(nonatomic, retain) MR_ClauseHeadView *headView;
@property(nonatomic, retain) UIView *contentView;
@property(nonatomic, assign) enum CLAUSE_HEAD_STATE headState;

- (id)initWithFrame:(CGRect)frame cellHeight:(float)cellHeight;
- (float)getAllHeight;

- (void)showHeadState;

@end
