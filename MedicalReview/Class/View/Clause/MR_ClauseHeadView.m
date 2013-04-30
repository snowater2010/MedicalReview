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

@interface MR_ClauseHeadView ()

@property(nonatomic, retain) MR_ArrowView *arrowView;

@end

@implementation MR_ClauseHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor brownColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSString *name = [_jsonData objectForKey:KEY_indexName];
    NSString *explain = [_jsonData objectForKey:KEY_wordExplan];
    
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
    
    //name
    float name_x = arrowFrame.origin.x + arrowFrame.size.width + ARROW_MARGIN;
    float name_y = 0;
    float name_w = rect.size.width * 0.4;
    float name_h = rect.size.height;
    CGRect nameFrame = CGRectMake(name_x, name_y, name_w, name_h);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
    nameLabel.lineBreakMode = UILineBreakModeWordWrap;
    nameLabel.numberOfLines = 0;
    nameLabel.text = name;
    
    //cover view -- click event
    float cover_x = 0;
    float cover_y = 0;
    float cover_w = name_x + name_w;
    float cover_h = rect.size.height;
    CGRect coverFrame = CGRectMake(cover_x, cover_y, cover_w, cover_h);
    UIControl *coverControl = [[UIControl alloc] initWithFrame:coverFrame];
    coverControl.backgroundColor = [UIColor clearColor];
    [coverControl addTarget:self action:@selector(clickClauseHead) forControlEvents:UIControlEventTouchUpInside];
    
    //score
    float score_x = nameFrame.origin.x + nameFrame.size.width;
    float score_y = 0;
    float score_w = rect.size.width * 0.25;
    float score_h = rect.size.height;
    CGRect scoreFrame = CGRectMake(score_x, score_y, score_w, score_h);
    MR_ScoreRadioView *scoreView = [[MR_ScoreRadioView alloc] initWithFrame:scoreFrame];
    
    NSMutableArray *choiceData = [[NSMutableArray alloc] initWithCapacity:3];
    NSDictionary *dicA = [[NSDictionary alloc] initWithObjectsAndKeys:@"A", @"key", @" A", @"name", nil];
    [choiceData addObject:dicA];
    [dicA release];
    NSDictionary *dicB = [[NSDictionary alloc] initWithObjectsAndKeys:@"B", @"key", @" B", @"name", nil];
    [choiceData addObject:dicB];
    [dicB release];
    NSDictionary *dicC = [[NSDictionary alloc] initWithObjectsAndKeys:@"C", @"key", @" C", @"name", nil];
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
    
    [self addSubview:_arrowView];
    [self addSubview:nameLabel];
    [self addSubview:coverControl];
    [self addSubview:scoreView];
    [self addSubview:explainView];
    
    [nameLabel release];
    [explainView release];
    [coverControl release];
    [scoreView release];
    
    [self showHeadState];
}

- (void)dealloc
{
    self.jsonData = nil;
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

- (void)radioButtonGroupTaped:(NSString *)radioKey
{
    _LOG_(radioKey);
}

@end
