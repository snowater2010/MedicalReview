    //
//  ScrollTableController.m
//  SJJFRicher
//
//  Created by lipeng11 on 12-1-4.
//  Copyright 2012 ailk. All rights reserved.
//

#import "ScrollTableController.h"
#import "UILabel+Helper.h"

@implementation ScrollTableController

@synthesize drTableHead;
@synthesize drTableData;

@synthesize titleHeight;
@synthesize cellHeight;
@synthesize fontSize;

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //标题栏高度
        titleHeight = 40;
        //列表单元高度默认值28
        cellHeight = 40;
        //字体默认值12
        fontSize = 18;
    }
    return self;
}

- (void)refreshView
{
	UITableView *scroller = (UITableView *)[self viewWithTag:ScrollTableViewTag];
	[scroller reloadData];
}

- (void)drawRect:(CGRect)rect
{
	//表头
	float tableWidth = 0;
	float tableHeight = 0;
	float unitHeight = titleHeight;
	
	UIView *titleBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, titleHeight)];
	titleBG.backgroundColor = [UIColor lightGrayColor];
	[self addSubview:titleBG];
	[titleBG release];
	
	CGRect titleRect;
	for (NSDictionary *titleIter in drTableHead) {
		NSString *tableName = [titleIter valueForKey:@"tableName"];
		NSString *tableType = [titleIter valueForKey:@"tableType"];
		float unitWidth = [[titleIter valueForKey:@"tableWidth"] floatValue];
		unitWidth = rect.size.width * unitWidth;
        
		titleRect = CGRectMake(tableWidth, tableHeight, unitWidth, unitHeight);
		
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleRect];
		titleLabel.text = tableName;
        titleLabel.font = [UIFont systemFontOfSize:fontSize];
		[self addSubview:titleLabel];
		[titleLabel release];
		
		tableWidth += unitWidth;
	}
	
	//滚动列表
	CGRect scrollerRect = CGRectMake(0, titleHeight, rect.size.width, rect.size.height-titleHeight);
	UITableView *scroller = [[UITableView alloc] initWithFrame:scrollerRect];
	scroller.backgroundColor = [UIColor clearColor];
	scroller.tag = ScrollTableViewTag;
	scroller.delegate = self;
	scroller.dataSource = self;
	[self addSubview:scroller];
	
}

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [self.drTableData count];
}

- (CGFloat )tableView:(UITableView  *)tableView heightForRowAtIndexPath:(NSIndexPath  *)indexPath
{
	return cellHeight;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	
	static NSString *CellTableIdentifier = @"ScrollTableCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
	
	//构造cell结构
	if (cell == nil) {
		CGRect cellFrame = CGRectMake(0, 0, self.frame.size.width, cellHeight);
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
		
		CGRect rect = cell.frame;
		float tableWidth = rect.origin.x;
		float tableHeight = rect.origin.y;
		float unitHeight = cellHeight;
		
		CGRect dataRect;
		int index = 1;
		for (NSDictionary *headIter in drTableHead) {
			float unitWidth = [[headIter valueForKey:@"tableWidth"] floatValue];
            unitWidth = cellFrame.size.width * unitWidth;
			
			dataRect = CGRectMake(tableWidth, tableHeight, unitWidth, unitHeight);
			
			UILabel *dataLabel = [[UILabel alloc] initWithFrame:dataRect];
			dataLabel.tag = index;
			
			dataLabel.backgroundColor = [UIColor clearColor];
			dataLabel.font = [UIFont boldSystemFontOfSize:fontSize-2];
			[cell.contentView addSubview:dataLabel];
			[dataLabel release];
			
			tableWidth += unitWidth;
			index++;
		}
	}
	
	//填入值
    int index = 1;
    bool flag = false;//add by chenkun 2012-3-26 加入“合计”列颜色处理
	NSDictionary *cellData = [drTableData objectAtIndex:row];
    index = 1;
	for (NSDictionary *headIter in drTableHead) {
		NSString *tableCode = [headIter valueForKey:@"tableCode"];
        NSString *tableType = [headIter valueForKey:@"tableType"];
        
		NSString *data = [cellData valueForKey:tableCode];
		UILabel *dataLabel = (UILabel *)[cell.contentView viewWithTag:index];
		dataLabel.textColor = [UIColor blackColor];
        [dataLabel setData:data type:tableType.intValue font:[UIFont systemFontOfSize:fontSize]];
        //start add by chenkun 2012-3-26 加入“合计”列颜色处理
        if (index == 1) {
            NSRange range = [data rangeOfString:@"合计"];
            if (range.location != NSNotFound) {
                flag = true;
            }
        }
        if (flag) {
            dataLabel.textColor = [UIColor blueColor];
        }

        //end add by chenkun 2012-3-26 加入“合计”列颜色处理
        index++;
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)dealloc {
	[drTableHead release];
	[drTableData release];
    [super dealloc];
}

@end
