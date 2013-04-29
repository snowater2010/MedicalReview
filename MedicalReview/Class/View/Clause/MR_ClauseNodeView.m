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

@implementation MR_ClauseNodeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor purpleColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSString *name = [_jsonData objectForKey:KEY_indexName];
    NSString *explain = [_jsonData objectForKey:KEY_wordExplan];
    
    //name
    float name_x = 0;
    float name_y = 0;
    float name_w = rect.size.width * 0.4;
    float name_h = rect.size.height;
    CGRect nameFrame = CGRectMake(name_x, name_y, name_w, name_h);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
    nameLabel.lineBreakMode = UILineBreakModeWordWrap;
    nameLabel.numberOfLines = 0;
    nameLabel.text = name;
    
    //explain
    float explain_x = name_x + name_w;
    float explain_y = 0;
    float explain_w = rect.size.width * 0.2;
    float explain_h = rect.size.height;
    CGRect explainFrame = CGRectMake(explain_x, explain_y, explain_w, explain_h);
    MR_ExplainView *explainView = [[MR_ExplainView alloc] initWithFrame:explainFrame];
    explainView.wordExplan = explain;
    
    [self addSubview:nameLabel];
    [self addSubview:explainView];
    [nameLabel release];
    [explainView release];
}

- (void)dealloc
{
    self.jsonData = nil;
    [super dealloc];
}

@end
