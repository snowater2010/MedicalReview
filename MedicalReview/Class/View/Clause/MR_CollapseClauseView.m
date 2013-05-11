//
//  MR_CollapseClauseView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-29.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_CollapseClauseView.h"
#import "MR_ClauseView.h"

@implementation MR_CollapseClauseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)dealloc
{
    self.jsonData = nil;
    self.scoreData = nil;
    [super dealloc];
}

#pragma mark - Load Data
- (void)drawRect:(CGRect)rect
{
    // Set Up: Height
    float totalHeight = 0;
    
    // Remove all subviews
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    // Add cells
    for (int i = 0; i < _jsonData.count; i++) {
        
        NSDictionary *clauseDic = [_jsonData objectAtIndex:i];
        
        NSString *clauseId = [clauseDic objectForKey:KEY_clauseId];
        NSDictionary *scoreDic = [_scoreData objectForKey:clauseId];
        
        CGRect cellFrame = CGRectMake(0,
                                      totalHeight,
                                      rect.size.width,
                                      DEFAULT_CELL_HEIGHT);
        
        MR_ClauseView * clauseView = [[MR_ClauseView alloc] initWithFrame:cellFrame cellHeight:DEFAULT_CELL_HEIGHT];
        clauseView.tag = i;
        clauseView.delegate = self;
        clauseView.jsonData = clauseDic;
        clauseView.scoreData = scoreDic;
        
        // Add cell
        [self addSubview:clauseView];
        
        // Calculate totalHeight
        totalHeight += DEFAULT_CELL_HEIGHT + CELL_MARGIN;
    }
    
    // Set self's ContentSize and ContentOffset
    [self setContentSize:CGSizeMake(self.frame.size.width, totalHeight)];
    [self setContentOffset:CGPointZero];
}

#pragma mark -
#pragma mark -- ClauseHeadDelegate

- (void)clickClauseHead:(id)sender
{
    MR_ClauseView *clasue = (MR_ClauseView *)sender;
    if (clasue.headState == CLAUSE_HEAD_STATE_CLOSE) {
        clasue.headState = CLAUSE_HEAD_STATE_OPEN;
        [self openCollapseClickCell:clasue animated:YES];
    }
    else if(clasue.headState == CLAUSE_HEAD_STATE_OPEN){
        clasue.headState = CLAUSE_HEAD_STATE_CLOSE;
        [self closeCollapseClickCell:clasue animated:YES];
    }
}

#pragma mark - Open CollapseClickCell
-(void)openCollapseClickCell:(MR_ClauseView *)clauseView animated:(BOOL)animated 
{
    float duration = 0;
    if (animated) {
        duration = 0.25;
    }
    [UIView animateWithDuration:duration animations:^{
        // Resize Cell
        float contentHeight = clauseView.contentView.frame.size.height;
        
        CGRect openFrame = clauseView.frame;
        openFrame.size.height = openFrame.size.height + contentHeight;
        clauseView.frame = openFrame;
        
        //change header state
        [clauseView showHeadState];
        
        // Reposition all CollapseClickCells below Cell
        [self repositionCollapseClickCellsBelowIndex:clauseView.tag withOffset:contentHeight];
    }];
}

#pragma mark - Close CollapseClickCell
-(void)closeCollapseClickCell:(MR_ClauseView *)clauseView animated:(BOOL)animated
{
    float duration = 0;
    if (animated) {
        duration = 0.25;
    }
    [UIView animateWithDuration:duration animations:^{
        // Resize Cell
        float contentHeight = clauseView.contentView.frame.size.height;
        
        CGRect openFrame = clauseView.frame;
        openFrame.size.height = openFrame.size.height - contentHeight;
        clauseView.frame = openFrame;
        
        //change header state
        [clauseView showHeadState];
        
        // Reposition all CollapseClickCells below Cell
        [self repositionCollapseClickCellsBelowIndex:clauseView.tag withOffset:-contentHeight];
    }];
}


#pragma mark - Reposition Cells
-(void)repositionCollapseClickCellsBelowIndex:(int)index withOffset:(float)offset {
    
    for (int yy = index+1; yy < _jsonData.count; yy++) {
        MR_ClauseView *clauseView = (MR_ClauseView *)[self viewWithTag:yy];
        CGRect frame = clauseView.frame;
        frame.origin.y = frame.origin.y + offset;
        clauseView.frame = frame;
    }
    
    // Resize self.ContentSize
    [self setContentSize:CGSizeMake(self.frame.size.width, self.contentSize.height + offset)];
}

@end
