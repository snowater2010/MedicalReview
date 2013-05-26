//
//  MR_ClauseTopView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-5-11.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ClauseTopView.h"

@implementation MR_ClauseTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    float topLeft_x = 0;
    float topLeft_y = 0;
    float topLeft_w = rect.size.width * 0.1;
    float topLeft_h = rect.size.height;
    CGRect topLeftFrame = CGRectMake(topLeft_x, topLeft_y, topLeft_w, topLeft_h);
    UILabel *topLeftView = [[UILabel alloc] initWithFrame:topLeftFrame];
    topLeftView.backgroundColor = [Common colorWithR:239 withG:255 withB:255];
    topLeftView.layer.borderWidth = 0.5;
    topLeftView.layer.borderColor = [[Common colorWithR:153 withG:187 withB:232] CGColor];
    [self addSubview:topLeftView];
    [topLeftView release];
    
    float topLeft_x2 = topLeft_x + topLeft_w;
    float topLeft_y2 = 0;
    float topLeft_w2 = rect.size.width * 0.4;
    float topLeft_h2 = rect.size.height;
    CGRect topLeftFrame2 = CGRectMake(topLeft_x2, topLeft_y2, topLeft_w2, topLeft_h2);
    UITextView *topLeftView2 = [[UITextView alloc] initWithFrame:topLeftFrame2];
    topLeftView2.layer.borderWidth = 0.5;
    topLeftView2.layer.borderColor = [[Common colorWithR:153 withG:187 withB:232] CGColor];
    topLeftView2.editable = NO;
    [self addSubview:topLeftView2];
    [topLeftView2 release];
    
    float topRight_x = topLeft_x2 + topLeft_w2;
    float topRight_y = 0;
    float topRight_w = rect.size.width * 0.1;
    float topRight_h = rect.size.height;
    CGRect topRighFrame = CGRectMake(topRight_x, topRight_y, topRight_w, topRight_h);
    UILabel *topRighView = [[UILabel alloc] initWithFrame:topRighFrame];
    topRighView.backgroundColor = [Common colorWithR:239 withG:255 withB:255];
    topRighView.layer.borderWidth = 0.5;
    topRighView.layer.borderColor = [[Common colorWithR:153 withG:187 withB:232] CGColor];
    [self addSubview:topRighView];
    [topRighView release];

    float topRight_x2 = topRight_x + topRight_w;
    float topRight_y2 = 0;
    float topRight_w2 = rect.size.width  * 0.4;
    float topRight_h2 = rect.size.height;
    CGRect topRighFrame2 = CGRectMake(topRight_x2, topRight_y2, topRight_w2, topRight_h2);
    UITextView *topRighView2 = [[UITextView alloc] initWithFrame:topRighFrame2];
    topRighView2.layer.borderWidth = 0.5;
    topRighView2.layer.borderColor = [[Common colorWithR:153 withG:187 withB:232] CGColor];
    topRighView2.editable = NO;
    [self addSubview:topRighView2];
    [topRighView2 release];
}

@end
