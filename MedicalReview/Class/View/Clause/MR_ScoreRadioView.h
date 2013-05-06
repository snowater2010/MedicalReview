//
//  MR_ScoreRadioView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-30.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"
#import "RadioButton.h"

#define RADIO_SIZE 20
#define GROUP_NAME @"score"
#define DEFAULT_TEXT_SIZE 14

@protocol RadioButtonViewDelegate <NSObject>
-(void)radioButtonGroupTaped:(NSString *)radioKey;
@end

@interface MR_ScoreRadioView : MR_RootView <RadioButtonDelegate>

@property(nonatomic, retain) NSArray *choiceData;
@property(nonatomic, assign) int choiceIndex;
@property(nonatomic, retain) NSMutableArray *rb_instances;
@property(nonatomic, retain) NSMutableDictionary *rb_observers;
@property(nonatomic, assign) id<RadioButtonViewDelegate> delegate;
@property(nonatomic, assign) float textSize;

- (NSString *)getCheckedKey;

@end
