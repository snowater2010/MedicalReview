//
//  UITextView+Helper.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-22.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "UITextView+Helper.h"

@implementation UITextView(Helper)

-(void)setHtmlString:(NSString*)_strHtml
{
    [self performSelector:@selector(setContentToHTMLString:) withObject:_strHtml];
}

@end
