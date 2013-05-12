//
//  MR_ChapterHeadView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-5-12.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ChapterHeadView.h"

@implementation MR_ChapterHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    float chapter_x = 0.;
    float chapter_y = 0;
    float chapter_w = 200;
    float chapter_h = rect.size.height;
    
    int i = 0;
    for (NSDictionary *chapterDic in _chapterData) {
        NSString *chapterName = [chapterDic objectForKey:KEY_chapterName];
        
        CGRect chapterFrame = CGRectMake(chapter_x, chapter_y, chapter_w, chapter_h);
        UIButton *chapterButton = [[UIButton alloc] initWithFrame:chapterFrame];
        chapterButton.tag = i;
        [chapterButton addTarget:self action:@selector(chapterSelected:) forControlEvents:UIControlEventTouchUpInside];
        [chapterButton setTitle:chapterName forState:UIControlStateNormal];
        [chapterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:chapterButton];
        
        chapter_x += chapter_w;
        i++;
    }
}

- (void)dealloc
{
    self.chapterData = nil;
    [super dealloc];
}

- (void)chapterSelected:(id)sender
{
    UIButton *chapterButton = (UIButton *)sender;
    int tag = chapterButton.tag;
    
    [Common callDelegate:_delegate method:@selector(ChapterSelected:) withObject:[NSNumber numberWithInt:tag]];
}

@end
