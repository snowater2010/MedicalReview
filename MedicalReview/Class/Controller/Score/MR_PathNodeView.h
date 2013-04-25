//
//  MR_PathNodeView.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-25.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"
#import "NIDropDown.h"

@interface MR_PathNodeView : MR_RootView <NIDropDownDelegate>

@property(nonatomic, retain) NSArray *nodeData;

@end
