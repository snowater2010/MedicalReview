//
//  MR_ExplainView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"
#import "MR_RootController.h"

#define DEFAULT_TEXT_SIZE   14
#define BUTTON_TEXT_SIZE    16

@interface MR_ExplainView : MR_RootView

@property(nonatomic, retain) NSString *wordExplan;
@property(nonatomic, assign) float textSize;
@property(nonatomic, assign) BOOL readOnly;

- (NSString *)getExplain;

@end

//explain editor

@interface MR_ExplainCtro : MR_RootController

- (NSString *)getExplain;
- (void)setExplain:(NSString *)explain;

@end

//fast explain

@interface MR_FastExplainCtro : MR_RootController

- (NSString *)getExplain;

@end
