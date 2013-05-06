//
//  MR_ClauseHeadView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"
#import "MR_ScoreRadioView.h"
#import "MR_OperateView.h"

#define ARROW_SIZE 12
#define ARROW_MARGIN 2

@class MR_ArrowView;

@protocol ClauseHeadDelegate <NSObject>

@optional
- (void)clickClauseHead:(id)sender;
- (void)clauseHeadScored:(NSString *)score;

@end

@interface MR_ClauseHeadView : MR_RootView <RadioButtonViewDelegate>

@property(nonatomic, retain) NSDictionary *jsonData;
@property(nonatomic, retain) NSDictionary *scoreData;

@property(nonatomic, assign) id<ClauseHeadDelegate> delegate;
@property(nonatomic, assign) enum CLAUSE_HEAD_STATE headState;

- (void)showHeadState;
- (NSDictionary *)getHeadScore;

@end
