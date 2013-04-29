//
//  MR_ArrowView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-29.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ArrowView.h"

@implementation MR_ArrowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.arrowColor = [UIColor whiteColor];
    }
    return self;
}

-(void)drawWithColor:(UIColor *)color {
    self.arrowColor = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *arrow = [UIBezierPath bezierPath];
    [self.arrowColor setFill];
    [arrow moveToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2)];
    [arrow addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [arrow addLineToPoint:CGPointMake(0, 0)];
    [arrow addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2)];
    [arrow fill];
}


@end
