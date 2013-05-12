//
//  MR_ClauseNodeView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"
#import "MR_OperateView.h"

@protocol ClauseNodeDelegate <NSObject>

@optional
- (void)clauseNodeScored:(NSString *)score;

@end

@interface MR_ClauseNodeView : MR_RootView <OperateDelegate>

@property(nonatomic, retain) NSDictionary *jsonData;
@property(nonatomic, retain) NSDictionary *scoreData;
@property(nonatomic, assign) id<ClauseNodeDelegate> delegate;

- (NSDictionary *)getNodeScore;

@end
