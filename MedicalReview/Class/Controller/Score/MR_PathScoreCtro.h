//
//  MR_PathScoreCtroViewController.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootController.h"
#import "MR_PathNodeView.h"
#import "MR_ClauseView.h"

@interface MR_PathScoreCtro : MR_RootController <PathNodeDelegate, ClauseScoredDelegate>

@property(nonatomic, retain) NSDictionary *scoreData;
@property(nonatomic, retain) NSDictionary *localData;       //本地存储

@end
