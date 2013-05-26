//
//  MR_ScoreListView.m
//  popviewtest
//
//  Created by lipeng11 on 13-5-9.
//  Copyright (c) 2013年 medical.revyst. All rights reserved.
//

#import "MR_PopSelectListView.h"

@interface MR_PopSelectListView ()

@property (nonatomic, assign) int selectIndex;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UIPopoverController *viewPopover;

@end

@implementation MR_PopSelectListView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self doInit];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self doInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

- (void)doInit
{
    self.backgroundColor = [UIColor clearColor];
    
    self.selectIndex = NO_SELECT_INDEX;
    self.backgroundColor = [UIColor whiteColor];
    self.textColor = [UIColor blackColor];
    self.scoreArray = nil;
    self.cellHeight = CELL_HEIGHT;
    self.popListWidth = POP_LIST_WIDTH;
    self.popListHeight = POP_LIST_HEIGHT;
}

- (void)drawRect:(CGRect)rect
{
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    NSString *defaultTitle = @"";
    if (_selectIndex != NO_SELECT_INDEX) {
        defaultTitle = [_scoreArray objectAtIndex:_selectIndex];
    }
    [button setTitle:defaultTitle forState:UIControlStateNormal];
    [button setTitleColor:_textColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showPopover:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    self.button = button;
    [button release];
    [self addSubview:_button];
    
    if (_popListHeight == POP_LIST_HEIGHT) {
        _popListHeight = CELL_HEIGHT * _scoreArray.count;
    }
    
    CGSize popViewSize = CGSizeMake(_popListWidth, _popListHeight);
    
    MR_ScoreListTableCtro *content = [[MR_ScoreListTableCtro alloc] initWithStyle:UITableViewStylePlain];
    content.popSelectDelegate = self;
    content.scoreArray = _scoreArray;
    content.parentSize = popViewSize;
    content.cellHeight = _cellHeight;
    
    self.viewPopover = [[UIPopoverController alloc] initWithContentViewController:content];
    self.viewPopover.popoverContentSize = popViewSize;
    self.viewPopover.delegate = self;
    
    [content release];
}

- (void)dealloc
{
    self.scoreArray = nil;
    self.viewPopover = nil;
    self.button = nil;
    [super dealloc];
}

- (void)showPopover:(id)sender {
	// Set the sender to a UIButton.
	UIButton *tappedButton = (UIButton *)sender;
	
	// Present the popover from the button that was tapped in the detail view.
	[self.viewPopover presentPopoverFromRect:tappedButton.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)selectedAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndex = indexPath.row;
    
    NSString *selectName = [_scoreArray objectAtIndex:indexPath.row];
    
    [_button setTitle:selectName forState:UIControlStateNormal];
    
    [_viewPopover dismissPopoverAnimated:YES];
    
    if ([_delegate respondsToSelector:@selector(selectedAtIndexPath:)]) {
        [_delegate selectedAtIndexPath:indexPath];
    }
}

- (void)selectAtIndex:(int)index
{
    self.selectIndex = index;
    
    NSString *defaultTitle = @"";
    if (_selectIndex != NO_SELECT_INDEX) {
        defaultTitle = [_scoreArray objectAtIndex:_selectIndex];
    }
    [self.button setTitle:defaultTitle forState:UIControlStateNormal];
}

- (int)getSelectedIndex
{
    return self.selectIndex;
}

- (NSString *)getSelectedValue
{
    if (_selectIndex == NO_SELECT_INDEX)
        return @"";
    
    NSString *selectedValue = [_scoreArray objectAtIndex:_selectIndex];
    NSString *result = [[[NSString alloc] initWithString:selectedValue] autorelease];
    return result;
}

@end


@implementation MR_ScoreListTableCtro

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _scoreArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"CellTableIdentifier ";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier] autorelease];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _parentSize.width, _cellHeight)];
        label.tag = 100;
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        [label release];
    }
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    label.text = [_scoreArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_popSelectDelegate respondsToSelector:@selector(selectedAtIndexPath:)]) {
        [_popSelectDelegate selectedAtIndexPath:indexPath];
    }
}

- (void)dealloc
{
    self.scoreArray = nil;
    [super dealloc];
}

@end
