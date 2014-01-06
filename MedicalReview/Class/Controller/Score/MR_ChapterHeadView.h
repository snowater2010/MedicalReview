//
//  MR_ChapterHeadView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-5-12.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"

#define MIN_TAB_WIDTH 80

@protocol ChapterHeadDelegate <NSObject>

- (void)ChapterSelected:(NSNumber *)chapterIndex;

@end

@interface MR_ChapterHeadView : MR_RootView

@property(nonatomic, retain) NSArray *chapterData;
@property(nonatomic, assign) id<ChapterHeadDelegate> delegate;

@end
