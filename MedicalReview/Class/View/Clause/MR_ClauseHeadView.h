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

#define ARROW_SIZE 12
#define ARROW_MARGIN 2

@class MR_ArrowView;

@protocol ClauseHeadDelegate <NSObject>

@optional
- (void)clickClauseHead:(id)sender;
- (void)clauseHeadScored:(id)sender;

@end

@interface MR_ClauseHeadView : MR_RootView <MR_PopSelectListDelegate>

@property(nonatomic, assign) BOOL isOpen;
@property(nonatomic, retain) NSString *clauseId;
@property(nonatomic, retain) NSDictionary *clauseData;
@property(nonatomic, retain) NSDictionary *scoreData;
@property(nonatomic, retain) NSArray *scoreArray;

@property(nonatomic, assign) id<ClauseHeadDelegate> delegate;

- (void)changeHeadState;
- (NSDictionary *)getScoreData;
- (void)changeNodeScore:(int)index;
- (int)getScoreSelectIndex;
- (NSString *)getScoreValue;
- (NSString *)getScoreExplain;

@end
