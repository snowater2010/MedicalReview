//
//  MR_ClauseView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ClauseView.h"

@implementation MR_ClauseView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        _jsonData = nil;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CollapseClick *collapseClickView = [[CollapseClick alloc] initWithFrame:rect];
    collapseClickView.CollapseClickDelegate = self;
    [collapseClickView reloadCollapseClick];
    [self addSubview:collapseClickView];
    [collapseClickView release];
    
    if (_jsonData) {
        NSString *indexName = [_jsonData objectForKey:KEY_indexName];
        
    }
    
}

#pragma mark - Collapse Click Delegate

// Required Methods
-(int)numberOfCellsForCollapseClick {
    return 3;
}

-(NSString *)titleForCollapseClickAtIndex:(int)index {
    switch (index) {
        case 0:
            return @"Login To CollapseClick";
            break;
        case 1:
            return @"Create an Account";
            break;
        case 2:
            return @"Terms of Service";
            break;
            
        default:
            return @"";
            break;
    }
}

-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)] autorelease];
    view.backgroundColor = [UIColor purpleColor];
    switch (index) {
        case 0:
            return view;
            break;
        case 1:
            return view;
            break;
        case 2:
            return view;
            break;
            
        default:
            return view;
            break;
    }
}


// Optional Methods

-(UIColor *)colorForCollapseClickTitleViewAtIndex:(int)index {
    return [UIColor colorWithRed:223/255.0f green:47/255.0f blue:51/255.0f alpha:1.0];
}


-(UIColor *)colorForTitleLabelAtIndex:(int)index {
    return [UIColor colorWithWhite:1.0 alpha:0.85];
}

-(UIColor *)colorForTitleArrowAtIndex:(int)index {
    return [UIColor colorWithWhite:0.0 alpha:0.25];
}

-(void)didClickCollapseClickCellAtIndex:(int)index isNowOpen:(BOOL)open {
    NSLog(@"%d and it's open:%@", index, (open ? @"YES" : @"NO"));
}

@end
