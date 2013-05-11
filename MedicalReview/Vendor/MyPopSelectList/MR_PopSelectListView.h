//
//  MR_ScoreListView.h
//  popviewtest
//
//  Created by lipeng11 on 13-5-9.
//  Copyright (c) 2013年 medical.revyst. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_HEIGHT 50

#define POP_LIST_WIDTH 100
#define POP_LIST_HEIGHT -1
#define NO_SELECT_INDEX -1

@protocol MR_PopSelectListDelegate <NSObject>

@optional
- (void)selectedAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MR_PopSelectListView : UIView <UIPopoverControllerDelegate, UITableViewDelegate, UITableViewDataSource, MR_PopSelectListDelegate>

@property(nonatomic, retain) UIColor *textColor;
@property(nonatomic, assign) float popListWidth;
@property(nonatomic, assign) float popListHeight;
@property(nonatomic, assign) BOOL popListAutoHeight;
@property(nonatomic, assign) int cellHeight;
@property(nonatomic, retain) NSArray *scoreArray;
@property(nonatomic, assign) id<MR_PopSelectListDelegate> delegate;

- (void)selectAtIndex:(int)index;
- (int)getSelectedIndex;
- (NSString *)getSelectedValue;

@end

@interface MR_ScoreListTableCtro : UITableViewController

@property(nonatomic, assign) int cellHeight;
@property(nonatomic, assign) CGSize parentSize;
@property(nonatomic, retain) NSArray *scoreArray;
@property(nonatomic, assign) id<MR_PopSelectListDelegate> popSelectDelegate;

@end
