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
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, titleHeight)];
    bgView.backgroundColor = [Common colorWithR:153 withG:187 withB:232];
    [self addSubview:bgView];
    [bgView release];
    
	//表头
	float tableWidth = 0;
	float tableHeight = 0;
	float unitHeight = titleHeight;
	
	CGRect titleRect;
	for (NSDictionary *titleIter in drTableHead) {
		NSString *tableName = [titleIter valueForKey:KEY_tableName];
		float unitWidth = [[titleIter valueForKey:KEY_tableWidth] floatValue];
		unitWidth = rect.size.width * unitWidth;
        
		titleRect = CGRectMake(tableWidth, tableHeight, unitWidth, unitHeight);
		
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleRect];
		titleLabel.text = tableName;
        titleLabel.font = [UIFont systemFontOfSize:fontSize];
        titleLabel.textAlignment = _ALIGN_CENTER;
        [titleLabel setBorderWidth:0.5 color:[[UIColor lightGrayColor] CGColor] corner:0];
        titleLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:titleLabel];
		[titleLabel release];
		
		tableWidth += unitWidth;
	}
	
	//滚动列表
	CGRect scrollerRect = CGRectMake(0, titleHeight, rect.size.width, rect.size.height-titleHeight);
	UITableView *scroller = [[UITableView alloc] initWithFrame:scrollerRect];
    scroller.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
		
		CGRect rect = cell.frame;
		float tableWidth = rect.origin.x;
		float tableHeight = rect.origin.y;
		float unitHeight = cellHeight;
		
		CGRect dataRect;
		int index = 1;
		for (NSDictionary *headIter in drTableHead) {
            int alignment = [[headIter objectForKey:KEY_alignment] intValue];
			float unitWidth = [[headIter valueForKey:KEY_tableWidth] floatValue];
            unitWidth = cellFrame.size.width * unitWidth;
			
			dataRect = CGRectMake(tableWidth, tableHeight, unitWidth, unitHeight);
			
			UILabel *dataLabel = [[UILabel alloc] initWithFrame:dataRect];
			dataLabel.tag = index;
			[dataLabel setBorderWidth:0.5 color:[[UIColor lightGrayColor] CGColor] corner:0];
			dataLabel.backgroundColor = [UIColor clearColor];
			dataLabel.font = [UIFont italicSystemFontOfSize:(fontSize-2)];
            switch (alignment) {
                case 0:
                    dataLabel.textAlignment = _ALIGN_LEFT;
                    break;
                case 1:
                    dataLabel.textAlignment = _ALIGN_CENTER;
                    break;
                case 2:
                    dataLabel.textAlignment = _ALIGN_RIGHT;
                    break;
                default:
                    break;
            }
			[cell.contentView addSubview:dataLabel];
			[dataLabel release];
			
			tableWidth += unitWidth;
			index++;
		}
	}
	
	//填入值
    int index = 1;
	NSDictionary *cellData = [drTableData objectAtIndex:row];
	for (NSDictionary *headIter in drTableHead) {
		NSString *tableCode = [headIter valueForKey:KEY_tableCode];
        NSString *tableType = [headIter valueForKey:KEY_tableType];
        
		NSString *data = [cellData valueForKey:tableCode];
		UILabel *dataLabel = (UILabel *)[cell.contentView viewWithTag:index];
		dataLabel.textColor = [UIColor blackColor];
        [dataLabel setData:data type:tableType.intValue font:nil];
        
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
