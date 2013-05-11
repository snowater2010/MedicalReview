//
//  MR_ClauseTable.h
//  MedicalReview
//
//  Created by lipeng11 on 13-5-5.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootView.h"

#define TABLE_TEXT_SIZE 17

@protocol MR_ClauseTableDelegate <NSObject>
@optional
- (void)tableClicked;
@end

@interface MR_ClauseTable : MR_RootView

@property(nonatomic, retain) NSArray *jsonData;
@property(nonatomic, assign) id<MR_ClauseTableDelegate> delegate;

@end
