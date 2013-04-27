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
    //arrow
    CGRect arrowFrame = CGRectMake(10,
                                   (rect.size.height-ARROW_SIZE)/2,
                                   ARROW_SIZE * 2,
                                   ARROW_SIZE);
    UIView *arrowView = [[UIView alloc] initWithFrame:arrowFrame];
    
    //name
    CGRect nameFrame = CGRectMake(arrowFrame.origin.x + arrowFrame.size.width + 10,
                                  0,
                                  rect.size.width * 0.4,
                                  rect.size.height);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
    nameLabel.lineBreakMode = UILineBreakModeWordWrap;
    nameLabel.numberOfLines = 0;
    nameLabel.text = @"我的声活是sje个我的声活是sje个我的声活是sje个我的声活是sje个我的声";
    
    //explain
    CGRect explainFrame = CGRectMake(nameFrame.origin.x + nameFrame.size.width,
                                     0,
                                     rect.size.width * 0.2,
                                     rect.size.height);
    MR_ExplainView *explainView = [[MR_ExplainView alloc] initWithFrame:explainFrame];
    
    [self addSubview:arrowView];
    [self addSubview:nameLabel];
    [self addSubview:explainView];
    [arrowView release];
    [nameLabel release];
    [explainView release];
}

@end
