//
//  MR_ClauseHeadView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"
<<<<<<< HEAD
#import "MR_ScoreRadioView.h"
#import "MR_OperateView.h"
=======
#import "MR_OperateView.h"
#import "MR_PopSelectListView.h"
#import "MR_ExplainView.h"
>>>>>>> branch

#define ARROW_SIZE 12
#define ARROW_MARGIN 2

@class MR_ArrowView;

@protocol ClauseHeadDelegate <NSObject>

@optional
- (void)clickClauseHead:(id)sender;
<<<<<<< HEAD
- (void)clauseHeadScored:(NSString *)score;

@end

@interface MR_ClauseHeadView : MR_RootView <RadioButtonViewDelegate>

@property(nonatomic, retain) NSDictionary *jsonData;
@property(nonatomic, retain) NSDictionary *scoreData;

@property(nonatomic, assign) id<ClauseHeadDelegate> delegate;
@property(nonatomic, assign) enum CLAUSE_HEAD_STATE headState;

- (void)showHeadState;
- (NSDictionary *)getHeadScore;
=======
- (void)clauseHeadScored:(id)sender;
- (void)clauseHeadExplained:(id)sender;

@end

@interface MR_ClauseHeadView : MR_RootView <MR_PopSelectListDelegate, ExplainViewDelegate, OperateDelegate>

@property(nonatomic, assign) BOOL readOnly;
@property(nonatomic, assign) BOOL isOpen;
@property(nonatomic, assign) int section;
@property(nonatomic, retain) NSString *clauseId;
@property(nonatomic, retain) NSDictionary *nodeDic;
@property(nonatomic, retain) NSDictionary *clauseData;
@property(nonatomic, retain) NSDictionary *scoreData;
@property(nonatomic, retain) NSArray *scoreArray;

@property(nonatomic, assign) id<ClauseHeadDelegate> delegate;

- (void)changeArrowState;
- (NSDictionary *)getScoreData;
- (void)changeScore:(int)index;
- (void)changeScoreWithValue:(NSString *)value;
- (int)getScoreSelectIndex;
- (NSString *)getScoreValue;
- (NSString *)getScoreExplain;
- (NSString *)getScoreWait;
>>>>>>> branch

@end
