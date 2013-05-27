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
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    float padding = 10;
    
    float chapter_x = padding;
    float chapter_y = 0;
    float chapter_w = 0;
    float chapter_h = rect.size.height;
    
    UIFont *textFont = [UIFont systemFontOfSize:17];
    
    int i = 0;
    for (NSDictionary *chapterDic in _chapterData) {
        NSString *chapterName = [chapterDic objectForKey:KEY_chapterName];
        CGSize textSize = [chapterName sizeWithFont:textFont];
        
        chapter_w = textSize.width;
        
        CGRect chapterFrame = CGRectMake(chapter_x, chapter_y, chapter_w, chapter_h);
        UIButton *chapterButton = [[UIButton alloc] initWithFrame:chapterFrame];
        chapterButton.tag = i;
        [chapterButton addTarget:self action:@selector(chapterSelected:) forControlEvents:UIControlEventTouchUpInside];
        [chapterButton setTitle:chapterName forState:UIControlStateNormal];
        if (i == 0) {
            chapterButton.backgroundColor = [UIColor whiteColor];
            [chapterButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        else {
            chapterButton.backgroundColor = [UIColor clearColor];
            [chapterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        chapterButton.titleLabel.font = textFont;
        [self addSubview:chapterButton];
        
        chapter_x += chapter_w + padding;
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
    
    for (UIView *subview in self.subviews) {
        if (subview.class == [UIButton class]) {
            if (subview == sender) {
                subview.backgroundColor = [UIColor whiteColor];
                [(UIButton *)subview setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
            else {
                subview.backgroundColor = [UIColor clearColor];
                [(UIButton *)subview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }
    
    [Common callDelegate:_delegate method:@selector(ChapterSelected:) withObject:[NSNumber numberWithInt:tag]];
}

@end
