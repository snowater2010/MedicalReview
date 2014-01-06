//
//  MR_ChapterSearchView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-5-12.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"

@protocol ChapterSearchDelegate <NSObject>

@optional
- (void)doSearch:(NSDictionary *)searchDic;

@end

@interface MR_ChapterSearchView : MR_RootView

@property(nonatomic, assign) id<ChapterSearchDelegate> delegate;

@end
