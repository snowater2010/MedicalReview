//
//  MR_ClauseNodeView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ClauseNodeView.h"
#import "MR_ClauseHeadView.h"
#import "MR_ExplainView.h"
#import "MR_TableClauseView.h"

@interface MR_ClauseNodeView ()
{
    CGRect readOnlyRect;
    int lastSelectIndex;
}
@property(nonatomic, retain) UILabel *nameLabel;
@property(nonatomic, retain) UISegmentedControl *scoreView;
@property(nonatomic, retain) MR_ExplainView *explainView;
@property(nonatomic, retain) UILabel *selfView;
@property(nonatomic, retain) MR_OperateView *operateView;
@end

@implementation MR_ClauseNodeView

- (id)initWithFrame:(CGRect)frame withScoreArray:(NSArray *)scoreArray
{
    self.scoreArray = scoreArray;
    return [self initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        lastSelectIndex = NO_SELECT_VALUE;
        [self buildViewInRect:frame];
    }
    return self;
}

- (void)buildViewInRect:(CGRect)rect
{
    CGColorRef borderColor = [[Common colorWithR:221 withG:221 withB:221] CGColor];
    
    //name
    float name_x = ARROW_MARGIN * 2 + ARROW_SIZE;
    float name_y = 0;
    float name_w = rect.size.width * 0.45 - name_x;
    float name_h = rect.size.height;
    CGRect nameFrame = CGRectMake(name_x, name_y, name_w, name_h);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
    nameLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    nameLabel.numberOfLines = 0;
    nameLabel.font = [UIFont systemFontOfSize:NAME_TEXT_SIZE];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.layer.borderWidth = 0.5;
    nameLabel.layer.borderColor = borderColor;
    self.nameLabel = nameLabel;
    
    //----------------------
    //self score
    float self_x = name_x + name_w;
    float self_y = 0;
    float self_w = rect.size.width * 0.05;
    float self_h = rect.size.height;
    CGRect selfFrame = CGRectMake(self_x, self_y, self_w, self_h);
    UILabel *selfView = [[UILabel alloc] initWithFrame:selfFrame];
    selfView.text = @"";
    selfView.textAlignment = NSTextAlignmentCenter;
    selfView.backgroundColor = [UIColor clearColor];
    selfView.layer.borderWidth = 0.5;
    selfView.layer.borderColor = borderColor;
    self.selfView = selfView;
    
    //score
    float score_margin = 10;
    float score_x = self_x + self_w + score_margin;
    float score_y = score_margin;
    float score_w = rect.size.width * 0.18 - score_margin * 2;
    float score_h = rect.size.height - score_margin * 2;
    if (score_h > 40) {
        score_h = 40;
        score_y = (rect.size.height - score_h) / 2;
    }
    CGRect scoreFrame = CGRectMake(score_x, score_y, score_w, score_h);
//    UISegmentedControl *scoreSeg = [[UISegmentedControl alloc] initWithFrame:scoreFrame];
    UISegmentedControl *scoreSeg = [[UISegmentedControl alloc] initWithItems:_scoreArray];
    scoreSeg.frame = scoreFrame;
    scoreSeg.segmentedControlStyle = UISegmentedControlStyleBordered;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor,  [UIFont systemFontOfSize:NAME_TEXT_SIZE],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [scoreSeg setTitleTextAttributes:dic forState:UIControlStateNormal];
    [scoreSeg addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.scoreView = scoreSeg;
    [scoreSeg release];
    
    //explain
    float explain_x = score_x + score_w + score_margin;
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
    operateView.layer.borderWidth = 0.5;
    operateView.layer.borderColor = borderColor;
    self.operateView = operateView;
    
    [self addSubview:nameLabel];
    [self addSubview:selfView];
    [self addSubview:_scoreView];
    [self addSubview:_explainView];
    [self addSubview:operateView];
    [nameLabel release];
    [selfView release];
    [operateView release];
    
    readOnlyRect = CGRectMake(self_x, 0, rect.size.width - self_x, rect.size.height);
}

- (void)drawRect:(CGRect)rect
{
    NSString *name = [_clauseData objectForKey:KEY_attrName];
    NSString *selfLevel = [_nodeDic objectForKey:KEY_selfLevel];
    NSString *scoreValue = [_scoreData objectForKey:KEY_scoreValue];
    NSString *scoreExplain = [_scoreData objectForKey:KEY_scoreExplain];
    
    _nameLabel.text = name;
    _selfView.text = selfLevel;
    
    if ([Common isEmptyString:scoreValue])
    {
        [self changeScoreWithIndex:NO_SELECT_VALUE];
    }
    else {
        switch (scoreValue.intValue) {
            case 0:
                [self changeScoreWithIndex:1];
                break;
            case 1:
                [self changeScoreWithIndex:0];
                break;
            default:
                [self changeScoreWithIndex:NO_SELECT_VALUE];
                break;
        }
    }
    
    if ([Common isEmptyString:scoreExplain])
        [_explainView setExplain:@""];
    else
        [_explainView setExplain:scoreExplain];
    
    NSString *hasYs = [_clauseData objectForKey:KEY_hasYs];
    _operateView.isHasLink = hasYs.boolValue;
    _operateView.clauseData = _clauseData;
    [_operateView refreshPage];
    
    if (_readOnly) {
        UIView *coverView = [[UIView alloc] initWithFrame:readOnlyRect];
        [self addSubview:coverView];
        [coverView release];
    }
}

- (void)dealloc
{
    self.attrId = nil;
    self.clauseId = nil;
    self.nodeDic = nil;
    self.clauseData = nil;
    self.scoreData = nil;
    self.scoreView = nil;
    self.nameLabel = nil;
    self.scoreArray = nil;
    self.explainView = nil;
    self.selfView = nil;
    self.operateView = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Utilities

- (NSDictionary *)getScoreData
{
    NSString *key = [NSString stringWithFormat:@"%d", _scoreView.selectedSegmentIndex];
    if (key) {
        NSString *explain = [_explainView getExplain];
        
        NSDictionary *scoreDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   key, KEY_scoreValue,
                                   explain, KEY_scoreExplain,
                                   nil];
        NSDictionary *result = [[[NSDictionary alloc] initWithObjectsAndKeys:scoreDic, _attrId, nil] autorelease];
        [scoreDic release];
        return result;
    }
    else {
        return nil;
    }
}

- (int)getScoreSelectIndex
{
    return _scoreView.selectedSegmentIndex;
}

- (NSString *)getScoreValue
{
    int index = _scoreView.selectedSegmentIndex;
    if (index == 0) {
        return @"1";
    }
    else if(index == 1) {
        return @"0";
    }
    return @"";
}

- (NSString *)getScoreExplain
{
    return [_explainView getExplain];
}

- (void)changeScoreWithIndex:(int)index
{
    lastSelectIndex = index;
    _scoreView.selectedSegmentIndex = index;
}

- (void)changeScoreWithValue:(NSString *)value
{
    int index = NO_SELECT_VALUE;
    if ([value isEqualToString:@"1"]) {
        index = 0;
    }
    else if([value isEqualToString:@"0"]) {
        index = 1;
    }
    [self changeScoreWithIndex:index];
}

#pragma mark -
#pragma mark segment action
- (void)segmentAction:(UISegmentedControl *)seg
{
    _ALERT_SELECT_(_GET_LOCALIZED_STRING_(@"alert_change_point_score"), self, seg.selectedSegmentIndex);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        _scoreView.selectedSegmentIndex = lastSelectIndex;
    }
    if (buttonIndex == 1) {
        lastSelectIndex = _scoreView.selectedSegmentIndex;
        [Common callDelegate:_delegate method:@selector(clauseNodeScored:) withObject:self];
    }
}

#pragma mark -
#pragma mark ExplainViewDelegate
- (void)explainChanged
{
    [Common callDelegate:_delegate method:@selector(clauseNodeExplained:) withObject:self];
}

#pragma mark -
#pragma mark OperateDelegate

- (void)doDelete
{
    [self changeScoreWithIndex:NO_SELECT_VALUE];
    [_explainView setExplain:@""];
    [Common callDelegate:_delegate method:@selector(clauseNodeScored:) withObject:self];
}
- (void)doLink
{
    _LOG_(@"doLink");
}

@end
