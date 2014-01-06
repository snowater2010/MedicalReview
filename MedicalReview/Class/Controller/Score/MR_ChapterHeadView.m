//
//  MR_ChapterHeadView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-5-12.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ChapterHeadView.h"
#import "HMSegmentedControl.h"

@implementation MR_ChapterHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIFont *textFont = [UIFont systemFontOfSize:17];
    
    NSMutableArray *titleArray = [[NSMutableArray alloc] initWithCapacity:_chapterData.count];
    
    float maxWidth = 0.0;
    for (NSDictionary *chapterDic in _chapterData) {
        NSString *chapterName = [chapterDic objectForKey:KEY_chapterName];
        CGSize textSize = [chapterName sizeWithFont:textFont];
        
        maxWidth = maxWidth < textSize.width ? textSize.width : maxWidth;
        [titleArray addObject:chapterName];
    }
    
    //最大值
    maxWidth = maxWidth < MIN_TAB_WIDTH ? MIN_TAB_WIDTH : maxWidth;
    CGRect tabRect = CGRectMake(0, 0, (maxWidth+20)*titleArray.count, rect.size.height);
    
    if (titleArray && titleArray.count > 0) {
        HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:tabRect];
        [segmentedControl setSectionTitles:titleArray];
        [segmentedControl setFont:textFont];
        [segmentedControl setSelectionIndicatorLoc:HMSelectionIndicatorLocBottom];
        [segmentedControl setSelectionIndicatorMode:HMSelectionIndicatorFillsSegment];
        [segmentedControl setBackgroundColor:[Common colorWithR:214 withG:230 withB:255]];
        [segmentedControl setSelectionIndicatorColor:[UIColor flatDarkRedColor]];
        [segmentedControl setSelectionIndicatorHeight:3];
        [segmentedControl setTag:3];
        [segmentedControl setIndexChangeBlock:^(NSUInteger index) {
            [Common callDelegate:_delegate method:@selector(ChapterSelected:) withObject:[NSNumber numberWithInt:index]];
        }];
        [self addSubview:segmentedControl];
        [segmentedControl release];
    }
    [titleArray release];
}

- (void)dealloc
{
    self.chapterData = nil;
    [super dealloc];
}

@end
