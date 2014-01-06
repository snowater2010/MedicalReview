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
<<<<<<< HEAD
- (void)nodeSelected:(NSArray *)nodeData;

=======
- (void)nodeSelected:(NSDictionary *)nodeDic;
>>>>>>> branch
@end

@interface MR_PathNodeView : MR_RootView <NIDropDownDelegate, UITableViewDataSource, UITableViewDelegate>

<<<<<<< HEAD
@property(nonatomic, retain) NSArray *jsonData;
@property(nonatomic, assign) id<PathNodeDelegate> delegate;
=======
@property(nonatomic, retain) NSArray *pathData;
@property(nonatomic, retain) NSDictionary *scoreData;
@property(nonatomic, assign) id<PathNodeDelegate> delegate;

- (void)updateFinishCount:(NSDictionary *)scoredData;
>>>>>>> branch

@end
