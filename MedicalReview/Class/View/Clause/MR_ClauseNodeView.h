//
//  MR_ClauseNodeView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"
#import "MR_OperateView.h"
#import "MR_ExplainView.h"

#define NO_SELECT_VALUE UISegmentedControlNoSegment

@protocol ClauseNodeDelegate <NSObject>

@optional
- (void)clauseNodeScored:(id)sender;
- (void)clauseNodeExplained:(id)sender;
@end

@interface MR_ClauseNodeView : MR_RootView <OperateDelegate, ExplainViewDelegate>

@property(nonatomic, assign) BOOL readOnly;
@property(nonatomic, assign) int section;
@property(nonatomic, retain) NSString *attrId;
@property(nonatomic, retain) NSString *clauseId;
@property(nonatomic, retain) NSDictionary *nodeDic;
@property(nonatomic, retain) NSDictionary *clauseData;
@property(nonatomic, retain) NSDictionary *scoreData;
@property(nonatomic, retain) NSArray *scoreArray;
@property(nonatomic, assign) id<ClauseNodeDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withScoreArray:(NSArray *)scoreArray;
- (NSDictionary *)getScoreData;
- (void)changeScoreWithIndex:(int)index;
- (void)changeScoreWithValue:(NSString *)value;
- (NSString *)getScoreValue;
- (NSString *)getScoreExplain;
- (int)getScoreSelectIndex;

@end
