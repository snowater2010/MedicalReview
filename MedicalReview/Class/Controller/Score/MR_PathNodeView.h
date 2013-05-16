//
//  MR_PathNodeView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-25.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"
#import "NIDropDown.h"

@protocol PathNodeDelegate <NSObject>

@optional
- (void)nodeSelected:(NSArray *)nodeData;
@end

@interface MR_PathNodeView : MR_RootView <NIDropDownDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain) NSArray *pathData;
@property(nonatomic, retain) NSDictionary *scoreData;
@property(nonatomic, assign) id<PathNodeDelegate> delegate;

- (void)updateFinishCount:(NSDictionary *)scoredData;

@end
