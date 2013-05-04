//
//  MR_RootController.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MR_RootController : UIViewController <ASIHTTPRequestDelegate, UITextFieldDelegate>

- (id)initWithFrame:(CGRect)frame;
- (void)loadRootView;

@end
