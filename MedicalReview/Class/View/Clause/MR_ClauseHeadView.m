//
//  MR_ClauseHeadView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ClauseHeadView.h"
#import "MR_ArrowView.h"
#import "MR_ExplainView.h"
#import "MR_ClauseView.h"

@interface MR_ClauseHeadView ()

@property(nonatomic, retain) MR_ArrowView *arrowView;
@property(nonatomic, retain) MR_ScoreRadioView *scoreView;
@property(nonatomic, retain) MR_ExplainView *explainView;

@end

@implementation MR_ClauseHeadView

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
    NSString *scoreValue = [_scoreData objectForKey:KEY_scoreValue];
    NSString *scoreExplain = [_scoreData objectForKey:KEY_scoreExplain];
    
    //name view
    float nameView_x = 0;
    float nameView_y = 0;
    float nameView_w = rect.size.width * 0.45;
    float nameView_h = rect.size.height;
    CGRect nameViewFrame = CGRectMake(nameView_x, nameView_y, nameView_w, nameView_h);
    UIView *nameView = [[UIView alloc] initWithFrame:nameViewFrame];
    
    //arrow
    float arrow_x = ARROW_MARGIN;
    float arrow_y = (rect.size.height-ARROW_SIZE)/2;
    float arrow_w = ARROW_SIZE;
    float arrow_h = ARROW_SIZE;
    CGRect arrowFrame = CGRectMake(arrow_x, arrow_y, arrow_w, arrow_h);
    MR_ArrowView *arrowView = [[MR_ArrowView alloc] initWithFrame:arrowFrame];
    [arrowView drawWithColor:[UIColor redColor]];
    self.arrowView = arrowView;
    [arrowView release];
    [nameView addSubview:_arrowView];
    
    //name label
    float name_x = arrow_x + arrow_w + ARROW_MARGIN;
    float name_y = 0;
    float name_w = nameView_w - name_x;
    float name_h = rect.size.height;
    CGRect nameFrame = CGRectMake(name_x, name_y, name_w, name_h);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
    nameLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    nameLabel.numberOfLines = 0;
    nameLabel.text = name;
    nameLabel.font = [UIFont systemFontOfSize:NAME_TEXT_SIZE];
    [nameView addSubview:nameLabel];
    [nameLabel release];
    
    //cover view -- click event
    UIControl *coverControl = [[UIControl alloc] initWithFrame:nameViewFrame];
    coverControl.backgroundColor = [UIColor clearColor];
    [coverControl addTarget:self action:@selector(clickClauseHead) forControlEvents:UIControlEventTouchUpInside];
    
    //----------------------
    //self score
    float self_x = name_x + name_w;
    float self_y = 0;
    float self_w = rect.size.width * 0.05;
    float self_h = rect.size.height;
    CGRect selfFrame = CGRectMake(self_x, self_y, self_w, self_h);
    UILabel *selfView = [[UILabel alloc] initWithFrame:selfFrame];
    selfView.backgroundColor = [UIColor purpleColor];
    
    //score
    float score_x = self_x + self_w;
    float score_y = 0;
    float score_w = rect.size.width * 0.18;
    float score_h = rect.size.height;
    CGRect scoreFrame = CGRectMake(score_x, score_y, score_w, score_h);
    MR_ScoreRadioView *scoreView = [[MR_ScoreRadioView alloc] initWithFrame:scoreFrame];
    self.scoreView = scoreView;
    [scoreView release];
    
    NSMutableArray *choiceData = [[NSMutableArray alloc] initWithCapacity:3];
    NSDictionary *dicA = [[NSDictionary alloc] initWithObjectsAndKeys:@"0", @"key", @" A", @"name", nil];
    [choiceData addObject:dicA];
    [dicA release];
    NSDictionary *dicB = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"key", @" B", @"name", nil];
    [choiceData addObject:dicB];
    [dicB release];
    NSDictionary *dicC = [[NSDictionary alloc] initWithObjectsAndKeys:@"2", @"key", @" C", @"name", nil];
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
    
    [self addSubview:nameView];
    [self addSubview:coverControl];
    [self addSubview:selfView];
    [self addSubview:_scoreView];
    [self addSubview:_explainView];
    [self addSubview:operateView];
    
    [nameView release];
    [coverControl release];
    [selfView release];
    [operateView release];
    
    [self showHeadState];
}

- (void)dealloc
{
    self.jsonData = nil;
    self.scoreData = nil;
    self.arrowView = nil;
    [super dealloc];
}

- (void)clickClauseHead
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickClauseHead:)])
        [_delegate performSelector:@selector(clickClauseHead:) withObject:self];
}

- (void)showHeadState
{
    switch (_headState) {
        case CLAUSE_HEAD_STATE_OPEN:
        {
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
            _arrowView.transform = transform;
            break;
        }
        case CLAUSE_HEAD_STATE_CLOSE:
        {
            CGAffineTransform transform = CGAffineTransformMakeRotation(0);
            _arrowView.transform = transform;
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark --- user method
- (NSDictionary *)getHeadScore
{
    NSString *key = [_scoreView getCheckedKey];
    if (key) {
        NSString *explain = [_explainView getExplain];
        
        NSDictionary *scoreDic = [[[NSDictionary alloc] initWithObjectsAndKeys:
                                  key, KEY_scoreValue,
                                  explain, KEY_scoreExplain,
                                  nil] autorelease];
        return scoreDic;
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
    if(_delegate && [_delegate respondsToSelector:@selector(clauseHeadScored:)])
        [_delegate performSelector:@selector(clauseHeadScored:) withObject:radioKey];
}

@end
