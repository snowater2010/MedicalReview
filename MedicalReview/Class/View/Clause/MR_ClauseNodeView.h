//
//  MR_ClauseNodeView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"
#import "MR_OperateView.h"

#define NO_SELECT_VALUE UISegmentedControlNoSegment

@protocol ClauseNodeDelegate <NSObject>

@optional
- (void)clauseNodeScored:(id)sender;
@end

@interface MR_ClauseNodeView : MR_RootView <OperateDelegate>

@property(nonatomic, retain) NSString *attrId;
@property(nonatomic, retain) NSDictionary *clauseData;
@property(nonatomic, retain) NSDictionary *scoreData;
@property(nonatomic, retain) NSArray *scoreArray;
@property(nonatomic, assign) id<ClauseNodeDelegate> delegate;

- (NSDictionary *)getScoreData;
- (void)changeScore:(int)index;
- (void)changeScoreWithValue:(NSString *)value;
- (NSString *)getScoreValue;
- (NSString *)getScoreExplain;
- (int)getScoreSelectIndex;

@end
