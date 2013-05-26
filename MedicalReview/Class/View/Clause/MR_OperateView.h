//
//  MR_OperateView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-30.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"

#define OPERATE_TEXT_SIZE 14

@protocol OperateDelegate <NSObject>

- (void)doDelete;
- (void)doLink;

@end

@interface MR_OperateView : MR_RootView <UIAlertViewDelegate>

@property(nonatomic, assign) BOOL isHasLink;
@property(nonatomic, assign) id<OperateDelegate> delegate;

@end
