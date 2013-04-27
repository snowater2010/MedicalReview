//
//  MR_ClauseView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ClauseView.h"
#import "MR_ClauseHeadView.h"
#import "MR_ClauseNodeView.h"

@implementation MR_ClauseView

- (id)initWithFrame:(CGRect)frame cellHeight:(float)cellHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        _jsonData = nil;
        _cellHeight = cellHeight;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame cellHeight:DEFAULT_CELL_HEIGHT];
}

- (void)drawRect:(CGRect)rect
{
    if (!_jsonData) {
        return;
    }
    
//    NSString *indexName = [_jsonData objectForKey:KEY_indexName];
    NSArray *pointList = [_jsonData objectForKey:KEY_pointList];
    
    CGRect headFrame = CGRectMake(0, 0, rect.size.width, _cellHeight);
    MR_ClauseHeadView *headView = [[MR_ClauseHeadView alloc] initWithFrame:headFrame];
    
    CGRect contentFrame = CGRectMake(0, headFrame.origin.y+headFrame.size.height, rect.size.width, _cellHeight*pointList.count);
    UIView *contentView = [[UIView alloc] initWithFrame:contentFrame];
    
    float contentY = 0.0f;
    for (NSDictionary *pointDic in pointList) {
        //NSString *indexName = [pointDic objectForKey:KEY_indexName];
        
        CGRect nodeFrame = CGRectMake(0, contentY, rect.size.width, _cellHeight);
        
        MR_ClauseNodeView *nodeView = [[MR_ClauseNodeView alloc] initWithFrame:nodeFrame];
        
        [contentView addSubview:nodeView];
        [nodeView release];
        
        contentY += _cellHeight;
    }
    
    
//    CollapseClick *collapseClickView = [[CollapseClick alloc] initWithFrame:rect];
//    collapseClickView.CollapseClickDelegate = self;
//    [collapseClickView reloadCollapseClick];
//    [self addSubview:collapseClickView];
//    [collapseClickView release];
//    

    [self addSubview:headView];
    [self addSubview:contentView];
    [headView release];
    [contentView release];
}
- (float)getAllHeight
{
    return _cellHeight * ([[_jsonData objectForKey:KEY_nodeList] count] + 1);
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
    MR_ClauseNodeView *view = [[[MR_ClauseNodeView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, _cellHeight)] autorelease];
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
