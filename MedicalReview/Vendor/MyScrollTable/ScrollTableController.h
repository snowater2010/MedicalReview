//
//  ScrollTableController.h
//  SJJFRicher
//
//  Created by lipeng11 on 12-1-4.
//  Copyright 2012 ailk. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScrollTableTag 1111
#define ScrollTableViewTag 2222

@protocol ScrollTableDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ScrollTableController : UIView
<UITableViewDelegate, UITableViewDataSource> {
	
	NSArray* drTableHead;
	NSArray* drTableData;
	
	float titleHeight;
	float cellHeight;
	float fontSize;
	
	id <ScrollTableDelegate> delegate;
}

@property(nonatomic,retain) NSArray* drTableHead;
@property(nonatomic,retain) NSArray* drTableData;

@property(nonatomic,assign) float titleHeight;
@property(nonatomic,assign) float cellHeight;
@property(nonatomic,assign) float fontSize;

@property(assign) id<ScrollTableDelegate> delegate;

- (void)refreshView;

@end