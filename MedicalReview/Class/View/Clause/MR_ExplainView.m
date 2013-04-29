//
//  MR_ExplainView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ExplainView.h"

@implementation MR_ExplainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _readOnly = NO;
        _textSize = 17;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect textFrame = CGRectMake(0, 0, rect.size.width*0.7, rect.size.height);
    UITextView *explainView = [[UITextView alloc] initWithFrame:textFrame];
    explainView.tag = TAG_VIEW_EXPLAIN;
    explainView.font = [UIFont systemFontOfSize:_textSize];
    explainView.backgroundColor = [UIColor greenColor];
    
    CGRect buttonFrame = CGRectMake(rect.size.width*0.7, 0, rect.size.width*0.3, rect.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button addTarget:self action:@selector(btPressed) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"快捷" forState:UIControlStateNormal];
    
    explainView.editable = !_readOnly;
    button.enabled = !_readOnly;
    
    [self addSubview:explainView];
    [self addSubview:button];
    [explainView release];
    [button release];
}

- (void)btPressed
{
    UITextView *explainView = (UITextView *)[self viewWithTag:TAG_VIEW_EXPLAIN];
    explainView.text = @"select something";
    _LOG_(@"MR_ExplainView btPressed!");
}

- (NSString *)getExplain
{
    UITextView *explainView = (UITextView *)[self viewWithTag:TAG_VIEW_EXPLAIN];
    return explainView.text;
}

@end
