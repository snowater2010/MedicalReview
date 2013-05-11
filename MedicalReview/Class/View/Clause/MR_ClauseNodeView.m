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
#import "MR_ClauseView.h"

@interface MR_ClauseNodeView ()
@property(nonatomic, retain) MR_ScoreRadioView *scoreView;
@property(nonatomic, retain) MR_ExplainView *explainView;
@end

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
    NSString *name = [_jsonData objectForKey:KEY_attrName];
    NSString *scoreValue = [_scoreData objectForKey:KEY_scoreValue];
    NSString *scoreExplain = [_scoreData objectForKey:KEY_scoreExplain];
    
    //name
    float name_x = ARROW_MARGIN * 2 + ARROW_SIZE;
    float name_y = 0;
    float name_w = rect.size.width * 0.45 - name_x;
    float name_h = rect.size.height;
    CGRect nameFrame = CGRectMake(name_x, name_y, name_w, name_h);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
    nameLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    nameLabel.numberOfLines = 0;
    nameLabel.text = name;
    nameLabel.font = [UIFont systemFontOfSize:NAME_TEXT_SIZE];
    
    //----------------------
    //self score
    float self_x = name_x + name_w;
    float self_y = 0;
    float self_w = rect.size.width * 0.05;
    float self_h = rect.size.height;
    CGRect selfFrame = CGRectMake(self_x, self_y, self_w, self_h);
    UILabel *selfView = [[UILabel alloc] initWithFrame:selfFrame];
    selfView.backgroundColor = [UIColor lightGrayColor];
    
    //score
    float score_x = self_x + self_w;
    float score_y = 0;
    float score_w = rect.size.width * 0.2;
    float score_h = rect.size.height;
    CGRect scoreFrame = CGRectMake(score_x, score_y, score_w, score_h);
    MR_ScoreRadioView *scoreView = [[MR_ScoreRadioView alloc] initWithFrame:scoreFrame];
    self.scoreView = scoreView;
    [scoreView release];
    
    NSMutableArray *choiceData = [[NSMutableArray alloc] initWithCapacity:3];
    NSDictionary *dicA = [[NSDictionary alloc] initWithObjectsAndKeys:@"0", @"key", @"通过", @"name", nil];
    [choiceData addObject:dicA];
    [dicA release];
    NSDictionary *dicB = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"key", @"不通过", @"name", nil];
    [choiceData addObject:dicB];
    [dicB release];
    NSDictionary *dicC = [[NSDictionary alloc] initWithObjectsAndKeys:@"2", @"key", @"不适用", @"name", nil];
    [choiceData addObject:dicC];
    [dicC release];
    _scoreView.choiceData = choiceData;
    if (![Common isEmptyString:scoreValue])
        _scoreView.choiceIndex = scoreValue.intValue;
    _scoreView.delegate = self;
    
    //explain
    float explain_x = score_x + score_w;
    float explain_y = 0;
    float explain_w = rect.size.width * 0.2;
    float explain_h = rect.size.height;
    CGRect explainFrame = CGRectMake(explain_x, explain_y, explain_w, explain_h);
    MR_ExplainView *explainView = [[MR_ExplainView alloc] initWithFrame:explainFrame];
    self.explainView = explainView;
    [explainView release];
    if (![Common isEmptyString:scoreExplain])
        _explainView.wordExplan = scoreExplain;
    
    //operate
    float operate_x = explain_x + explain_w;
    float operate_y = 0;
    float operate_w = rect.size.width - operate_x;
    float operate_h = rect.size.height;
    CGRect operateFrame = CGRectMake(operate_x, operate_y, operate_w, operate_h);
    MR_OperateView *operateView = [[MR_OperateView alloc] initWithFrame:operateFrame];
    operateView.isHasLink = YES;
    
    [self addSubview:nameLabel];
    [self addSubview:selfView];
    [self addSubview:_scoreView];
    [self addSubview:_explainView];
    [self addSubview:operateView];
    [nameLabel release];
    [selfView release];
    [operateView release];
}

- (void)dealloc
{
    self.jsonData = nil;
    self.scoreData = nil;
    self.scoreView = nil;
    self.explainView = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark --- user method
- (NSDictionary *)getNodeScore
{
    NSString *key = [_scoreView getCheckedKey];
    if (key) {
        NSString *attrId = [_jsonData objectForKey:KEY_attrId];
        NSString *explain = [_explainView getExplain];
        
        NSDictionary *scoreDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   key, KEY_scoreValue,
                                   explain, KEY_scoreExplain,
                                   nil];
        NSDictionary *result = [[[NSDictionary alloc] initWithObjectsAndKeys:scoreDic, attrId, nil] autorelease];
        [scoreDic release];
        return result;
    }
    else {
        return nil;
    }
}

#pragma mark -
#pragma mark --- RadioButtonViewDelegate

- (void)radioButtonGroupTaped:(NSString *)radioKey
{
    _LOG_(radioKey);
    if(_delegate && [_delegate respondsToSelector:@selector(clauseNodeScored:)])
        [_delegate performSelector:@selector(clauseNodeScored:) withObject:radioKey];
}

#pragma mark -
#pragma mark --- OperateDelegate

- (void)doDelete
{
    _LOG_(@"doDelete");
}
- (void)doLink
{
    _LOG_(@"doLink");
}

@end
