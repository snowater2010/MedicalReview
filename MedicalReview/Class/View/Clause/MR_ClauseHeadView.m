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
#import "MR_TableClauseView.h"

@interface MR_ClauseHeadView ()
{
    CGRect readOnlyRect;
}

@property(nonatomic, retain) UIView *bgView;
@property(nonatomic, retain) UILabel *nameLabel;
@property(nonatomic, retain) MR_ArrowView *arrowView;
@property(nonatomic, retain) MR_ExplainView *explainView;
@property(nonatomic, retain) MR_PopSelectListView *scoreView;

@end

@implementation MR_ClauseHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isOpen = NO;
        
        //view
        CGRect rect = frame;
        CGColorRef borderColor = [[Common colorWithR:221 withG:221 withB:221] CGColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:rect];
        bgView.backgroundColor = [Common colorWithR:193 withG:202 withB:202];
        self.bgView = bgView;
        [self addSubview:bgView];
        
        //name view
        float nameView_x = 0;
        float nameView_y = 0;
        float nameView_w = rect.size.width * 0.45;
        float nameView_h = rect.size.height;
        CGRect nameViewFrame = CGRectMake(nameView_x, nameView_y, nameView_w, nameView_h);
        UIView *nameView = [[UIView alloc] initWithFrame:nameViewFrame];
        nameView.layer.borderWidth = 0.5;
        nameView.layer.borderColor = borderColor;
        
        //arrow
        float arrow_x = ARROW_MARGIN;
        float arrow_y = (rect.size.height-ARROW_SIZE)/2;
        float arrow_w = ARROW_SIZE;
        float arrow_h = ARROW_SIZE;
        CGRect arrowFrame = CGRectMake(arrow_x, arrow_y, arrow_w, arrow_h);
        MR_ArrowView *arrowView = [[MR_ArrowView alloc] initWithFrame:arrowFrame];
        [arrowView drawWithColor:[UIColor blueColor]];
        self.arrowView = arrowView;
        [arrowView release];
        [nameView addSubview:_arrowView];
        [self changeHeadState];
        
        //name label
        float name_x = arrow_x + arrow_w + ARROW_MARGIN;
        float name_y = 0;
        float name_w = nameView_w - name_x;
        float name_h = rect.size.height;
        CGRect nameFrame = CGRectMake(name_x, name_y, name_w, name_h);
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
        nameLabel.numberOfLines = 0;
        nameLabel.font = [UIFont systemFontOfSize:NAME_TEXT_SIZE];
        [nameView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        [nameLabel release];
        
        //cover view -- click event
        UIControl *coverControl = [[UIControl alloc] initWithFrame:nameViewFrame];
        coverControl.backgroundColor = [UIColor clearColor];
        [coverControl addTarget:self action:@selector(clickClauseHead) forControlEvents:UIControlEventTouchUpInside];
        
        //----------------------------------------------------------
        //self score
        float self_x = name_x + name_w;
        float self_y = 0;
        float self_w = rect.size.width * 0.05;
        float self_h = rect.size.height;
        CGRect selfFrame = CGRectMake(self_x, self_y, self_w, self_h);
        UILabel *selfView = [[UILabel alloc] initWithFrame:selfFrame];
        selfView.backgroundColor = [UIColor clearColor];
        selfView.layer.borderWidth = 0.5;
        selfView.layer.borderColor = borderColor;
        
        //score
        float score_x = self_x + self_w;
        float score_y = 0;
        float score_w = rect.size.width * 0.18;
        float score_h = rect.size.height;
        
        MR_PopSelectListView *scoreView = [[MR_PopSelectListView alloc] initWithFrame:CGRectMake(score_x, score_y, score_w, score_h)];
        scoreView.backgroundColor = [UIColor clearColor];
        scoreView.delegate = self;
        scoreView.layer.borderWidth = 0.5;
        scoreView.layer.borderColor = borderColor;
        self.scoreView = scoreView;
        [scoreView release];
        
        //explain
        float explain_x = score_x + score_w;
        float explain_y = 0;
        float explain_w = rect.size.width * 0.2;
        float explain_h = rect.size.height;
        CGRect explainFrame = CGRectMake(explain_x, explain_y, explain_w, explain_h);
        MR_ExplainView *explainView = [[MR_ExplainView alloc] initWithFrame:explainFrame];
        explainView.delegate = self;
        explainView.layer.borderWidth = 0.5;
        explainView.layer.borderColor = borderColor;
        self.explainView = explainView;
        [explainView release];
        
        //operate
        float operate_x = explain_x + explain_w;
        float operate_y = 0;
        float operate_w = rect.size.width - operate_x;
        float operate_h = rect.size.height;
        CGRect operateFrame = CGRectMake(operate_x, operate_y, operate_w, operate_h);
        MR_OperateView *operateView = [[MR_OperateView alloc] initWithFrame:operateFrame];
        operateView.delegate = self;
        operateView.isHasLink = YES;
        operateView.layer.borderWidth = 0.5;
        operateView.layer.borderColor = borderColor;
        
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
        
        readOnlyRect = CGRectMake(self_x, 0, rect.size.width - self_x, rect.size.height);
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSString *name = [_clauseData objectForKey:KEY_clauseName];
    NSString *scoreValue  = [_scoreData objectForKey:KEY_scoreValue];
    NSString *scoreExplain = [_scoreData objectForKey:KEY_scoreExplain];
    
    //name data
    _nameLabel.text = name;
    
    //init data
    _scoreView.scoreArray = _scoreArray;
    if (![Common isEmptyString:scoreValue])
    {
        for (int i = 0, j = _scoreArray.count; i < j; i++) {
            NSString *score = [_scoreArray objectAtIndex:i];
            if ([scoreValue isEqualToString:score]) {
                [_scoreView selectAtIndex:i];
                break;
            }
        }
    }
    
    if (![Common isEmptyString:scoreExplain])
        [_explainView setExplain:scoreExplain];
    
    [self changeBackgroundColor];
    
    if (_readOnly) {
        UIView *coverView = [[UIView alloc] initWithFrame:readOnlyRect];
        [self addSubview:coverView];
        [coverView release];
    }
}

- (void)dealloc
{
    self.bgView = nil;
    self.clauseId = nil;
    self.clauseData = nil;
    self.scoreData = nil;
    self.scoreArray = nil;
    self.arrowView = nil;
    self.scoreView = nil;
    self.nameLabel = nil;
    [super dealloc];
}

- (void)clickClauseHead
{
    _isOpen = !_isOpen;
    [self changeHeadState];
    
    if(_delegate && [_delegate respondsToSelector:@selector(clickClauseHead:)])
        [_delegate performSelector:@selector(clickClauseHead:) withObject:self];
}

- (void)changeHeadState
{
    if (_isOpen) {
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
        _arrowView.transform = transform;
    }
    else {
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        _arrowView.transform = transform;
    }
}

#pragma mark -
#pragma mark Utilities
- (void)changeBackgroundColor
{
    NSString *scoreValue = [self getScoreValue];
    
    if ([Common isEmptyString:scoreValue]) {
        _bgView.backgroundColor = [Common colorWithR:193 withG:202 withB:202];
    }
    else {
        _bgView.backgroundColor = [Common colorWithR:153 withG:255 withB:255];
    }
}

- (NSDictionary *)getScoreData
{
    if ([_scoreView getSelectedIndex] == NO_SELECT_INDEX)
        return nil;
    
    NSString *score = [_scoreView getSelectedValue];
    NSString *explain = [_explainView getExplain];
    
    NSDictionary *scoreDic = [[[NSDictionary alloc] initWithObjectsAndKeys:
                               score, KEY_scoreValue,
                               explain, KEY_scoreExplain,
                               nil] autorelease];
    return scoreDic;
}

- (int)getScoreSelectIndex
{
    return [_scoreView getSelectedIndex];
}

- (NSString *)getScoreValue
{
    return [_scoreView getSelectedValue];
}

- (NSString *)getScoreExplain
{
    return [_explainView getExplain];
}

- (void)changeScore:(int)index
{
    [_scoreView selectAtIndex:index];
    
    [self changeBackgroundColor];
}

- (void)changeScoreWithValue:(NSString *)value
{
    int index = [_scoreArray getIndexWithString:value];
    if (index == NO_STRING_INDEX)
        index = NO_SELECT_INDEX;
    [self changeScore:index];
}

#pragma mark -
#pragma mark MR_PopSelectListDelegate
- (void)selectedAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_scoreView getSelectedIndex] == NO_SELECT_INDEX)
        return;
    
    [self changeBackgroundColor];
    
    [Common callDelegate:_delegate method:@selector(clauseHeadScored:) withObject:self];
}

#pragma mark -
#pragma mark ExplainViewDelegate
- (void)explainChanged
{
    [Common callDelegate:_delegate method:@selector(clauseHeadExplained:) withObject:self];
}

#pragma mark -
#pragma mark OperateDelegate
- (void)doDelete
{
    [self changeScore:NO_SELECT_INDEX];
    [Common callDelegate:_delegate method:@selector(clauseHeadScored:) withObject:self];
    
}
- (void)doLink{
    
}

@end
