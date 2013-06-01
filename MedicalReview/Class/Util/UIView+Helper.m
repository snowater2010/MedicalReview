//
//  UIView+UIView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-5-14.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "UIView+Helper.h"
#import "MBProgressHUD.h"

@implementation UIView (UIView)

- (void)showLoadingWithText:(NSString *)text
{
    MBProgressHUD *loadingView = (MBProgressHUD *)[self viewWithTag:TAG_LOADING_DEFAULT];
    if (!loadingView) {
        loadingView = [[MBProgressHUD alloc] initWithView:self];
        loadingView.tag = TAG_LOADING_DEFAULT;
        [self addSubview:loadingView];
        [loadingView release];
    }
    if (text)
        loadingView.labelText = text;
    else
        loadingView.labelText = @"";
    [loadingView show:YES];
}

- (void)showLoading
{
    [self showLoadingWithText:@""];
}

- (void)hideLoading
{
    MBProgressHUD *loadingView = (MBProgressHUD *)[self viewWithTag:TAG_LOADING_DEFAULT];
    if (loadingView) {
        [loadingView hide:YES];
    }
}

- (void)setBorderWidth:(float)width color:(CGColorRef)color corner:(float)cornor
{
    self.layer.borderWidth = width;
    self.layer.borderColor = color;
    self.layer.cornerRadius = cornor;
}

@end
