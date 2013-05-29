//
//  MR_ClauseHeadView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"
#import "MR_OperateView.h"
#import "MR_PopSelectListView.h"
#import "MR_ExplainView.h"

#define ARROW_SIZE 12
#define ARROW_MARGIN 2

@class MR_ArrowView;

@protocol ClauseHeadDelegate <NSObject>

@optional
- (void)clickClauseHead:(id)sender;
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

- (void)changeHeadState;
- (NSDictionary *)getScoreData;
- (void)changeScore:(int)index;
- (void)changeScoreWithValue:(NSString *)value;
- (int)getScoreSelectIndex;
- (NSString *)getScoreValue;
- (NSString *)getScoreExplain;

@end
