//
//  MR_SectionScoreCtro.h
//  MedicalReview
//
//  Created by lipeng11 on 13-5-7.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootController.h"
#import "MR_ChapterHeadView.h"
#import "MR_ChapterSearchView.h"

@interface MR_ChapterScoreCtro : MR_RootController <ChapterHeadDelegate, ChapterSearchDelegate, UITableViewDelegate, UITableViewDataSource>

@end
