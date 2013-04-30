//
//  MR_ClauseNodeView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"
#import "MR_ScoreRadioView.h"
#import "MR_OperateView.h"

@interface MR_ClauseNodeView : MR_RootView <RadioButtonViewDelegate, OperateDelegate>

@property(nonatomic, retain) NSDictionary *jsonData;

@end
