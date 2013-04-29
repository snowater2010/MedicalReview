//
//  MR_ArrowView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-29.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"

@interface MR_ArrowView : UIView

@property (nonatomic,retain) UIColor *arrowColor;

-(void)drawWithColor:(UIColor *)color;

@end
