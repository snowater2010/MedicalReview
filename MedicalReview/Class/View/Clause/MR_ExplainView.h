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

@protocol ExplainViewDelegate <NSObject>

@optional
- (void)explainChanged;

@end

@interface MR_ExplainView : MR_RootView

@property(nonatomic, retain) NSString *wordExplan;
@property(nonatomic, assign) float textSize;
@property(nonatomic, assign) BOOL readOnly;
@property(nonatomic, assign) id<ExplainViewDelegate> delegate;

- (NSString *)getExplain;
- (void)setExplain:(NSString *)explain;

@end

//explain editor
@protocol EditExplainDelegate <NSObject>
@optional
- (void)getEditExplain:(NSString *)explain;
@end
@interface MR_ExplainCtro : MR_RootController

@property(nonatomic, assign) id<EditExplainDelegate> delegate;

- (NSString *)getExplain;
- (void)setExplain:(NSString *)explain;

@end

//fast explain
@protocol FastExplainDelegate <NSObject>
@optional
- (void)getFastExplain:(NSString *)explain;
@end
@interface MR_FastExplainCtro : MR_RootController

@property(nonatomic, assign) id<FastExplainDelegate> delegate;

@end
