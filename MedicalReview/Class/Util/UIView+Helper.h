//
//  UIView+UIView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-5-14.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAG_LOADING_DEFAULT 123456

@interface UIView (UIView)

- (void)showLoadingWithText:(NSString *)text;
- (void)showLoading;
- (void)hideLoading;

@end
