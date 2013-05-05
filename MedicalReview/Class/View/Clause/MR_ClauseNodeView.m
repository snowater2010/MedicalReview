//
//  MR_ClauseNodeView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ClauseNodeView.h"
#import "MR_ClauseHeadView.h"
#import "MR_ScoreRadioView.h"
#import "MR_ExplainView.h"

@implementation MR_ClauseNodeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSString *name = [_jsonData objectForKey:KEY_indexName];
    NSString *explain = [_jsonData objectForKey:KEY_wordExplan];
    
    //name
    float name_x = ARROW_MARGIN * 2 + ARROW_SIZE;
    float name_y = 0;
    float name_w = rect.size.width * 0.4 - name_x;
    float name_h = rect.size.height;
    CGRect nameFrame = CGRectMake(name_x, name_y, name_w, name_h);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
    nameLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    nameLabel.numberOfLines = 0;
    nameLabel.text = name;
    nameLabel.font = [UIFont systemFontOfSize:NAME_TEXT_SIZE];
    
    //score
    float score_x = name_x + name_w;
    float score_y = 0;
    float score_w = rect.size.width * 0.25;
    float score_h = rect.size.height;
    CGRect scoreFrame = CGRectMake(score_x, score_y, score_w, score_h);
    MR_ScoreRadioView *scoreView = [[MR_ScoreRadioView alloc] initWithFrame:scoreFrame];
    
    NSMutableArray *choiceData = [[NSMutableArray alloc] initWithCapacity:3];
    NSDictionary *dicA = [[NSDictionary alloc] initWithObjectsAndKeys:@"A", @"key", @"通过", @"name", nil];
    [choiceData addObject:dicA];
    [dicA release];
    NSDictionary *dicB = [[NSDictionary alloc] initWithObjectsAndKeys:@"B", @"key", @"不通过", @"name", nil];
    [choiceData addObject:dicB];
    [dicB release];
    NSDictionary *dicC = [[NSDictionary alloc] initWithObjectsAndKeys:@"C", @"key", @"不适应", @"name", nil];
    [choiceData addObject:dicC];
    [dicC release];
    scoreView.choiceData = choiceData;
    scoreView.delegate = self;
    
    //explain
    float explain_x = score_x + score_w;
    float explain_y = 0;
    float explain_w = rect.size.width * 0.2;
    float explain_h = rect.size.height;
    CGRect explainFrame = CGRectMake(explain_x, explain_y, explain_w, explain_h);
    MR_ExplainView *explainView = [[MR_ExplainView alloc] initWithFrame:explainFrame];
    explainView.wordExplan = explain;
    
    //operate
    float operate_x = explain_x + explain_w;
    float operate_y = 0;
    float operate_w = rect.size.width - operate_x;
    float operate_h = rect.size.height;
    CGRect operateFrame = CGRectMake(operate_x, operate_y, operate_w, operate_h);
    MR_OperateView *operateView = [[MR_OperateView alloc] initWithFrame:operateFrame];
    operateView.isHasLink = YES;
    
    [self addSubview:nameLabel];
    [self addSubview:scoreView];
    [self addSubview:explainView];
    [self addSubview:operateView];
    [nameLabel release];
    [scoreView release];
    [explainView release];
    [operateView release];
}

- (void)dealloc
{
    self.jsonData = nil;
    [super dealloc];
}

- (void)radioButtonGroupTaped:(NSString *)radioKey
{
    _LOG_(radioKey);
}

- (void)doDelete
{
    _LOG_(@"doDelete");
}
- (void)doLink
{
    _LOG_(@"doLink");
}

@end
