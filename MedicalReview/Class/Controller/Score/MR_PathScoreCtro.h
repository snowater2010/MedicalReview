//
//  MR_PathScoreCtroViewController.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootController.h"

#define TAG_VIEW_LEFT       0201
#define TAG_VIEW_MAIN       0202
#define TAG_VIEW_CLAUSE     020201

@interface MR_PathScoreCtro : MR_RootController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain) NSDictionary *jsonData;

@property(nonatomic,retain) NSMutableArray *realData;
@end
