//
//  MR_RootController.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAG_REQUEST_LOGIN       101
#define TAG_REQUEST_DATA        102

@interface MR_RootController : UIViewController <ASIHTTPRequestDelegate, UITextFieldDelegate>

@property (retain, nonatomic) ASIFormDataRequest *request;

- (id)initWithFrame:(CGRect)frame;
- (void)loadRootView;

- (NSArray *)getClauseFrom:(NSArray *)allClause byNode:(NSArray *)nodeData;

@end
