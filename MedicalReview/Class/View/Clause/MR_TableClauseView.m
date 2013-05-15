//
//  MR_TableClauseView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-5-15.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_TableClauseView.h"
#import "MR_ClauseView.h"
#import "MR_ClauseHeadView.h"

@interface MR_TableClauseView ()

@property(nonatomic, assign) CGSize selfSize;
@property(nonatomic, retain) UITableView *tableview;
@property(nonatomic, retain) NSMutableArray *sectionArray;

@end

@implementation MR_TableClauseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sectionArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //content view

    self.selfSize = rect.size;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableview.backgroundColor = [UIColor purpleColor];
    tableview.delegate = self;
    tableview.dataSource = self;
    self.tableview = tableview;
    [tableview release];
    [self addSubview:_tableview];
}

- (void)dealloc
{
    self.clauseData = nil;
    self.scoreData = nil;
    self.nodeData = nil;
    self.tableview = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Utilities
- (void)reloadData
{
    [_tableview reloadData];
}

//临时的，等json格式调整后就可以直接取得了
- (NSDictionary *)getPoint:(NSArray *)pointList byid:(NSString *)attrId
{
    for (NSDictionary *dic in pointList) {
        if ([attrId isEqualToString:[dic objectForKey:KEY_attrId]]) {
            return dic;
        }
    }
    return nil;
}

#pragma mark -
#pragma mark ClauseHeadDelegate

- (void)clickClauseHead:(id)sender
{
    MR_ClauseHeadView *clauseHeadView = (MR_ClauseHeadView *)sender;
    int tag = clauseHeadView.tag;
    
    NSArray* rowToInsert = [[NSMutableArray alloc] initWithObjects:[NSIndexPath indexPathForRow:0 inSection:tag], nil];
    
    if ([Common isValue:tag inNumberArray:_sectionArray]) {
        [Common removeValue:tag inNumberArray:&_sectionArray];
        [_tableview deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        [Common addValue:tag inNumberArray:&_sectionArray];
        [_tableview insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark -
#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _nodeData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return DEFAULT_CELL_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *clauseDic = [_clauseData objectAtIndex:section];
    NSDictionary *nodeDic = [_nodeData objectAtIndex:section];
    NSString *clauseId = [nodeDic objectForKey:KEY_clauseId];
    NSDictionary *scoreDic = [_scoreData objectForKey:clauseId];
    
    float head_x = 0;
    float head_y = 0;
    float head_w =  _selfSize.width;
    float head_h = DEFAULT_CELL_HEIGHT;
    CGRect headFrame = CGRectMake(head_x, head_y, head_w, head_h);
    MR_ClauseHeadView *headView = [[[MR_ClauseHeadView alloc] initWithFrame:headFrame] autorelease];
    headView.tag = section;
    headView.delegate = self;
    headView.jsonData = clauseDic;
    headView.scoreData = scoreDic;
    headView.scoreArray = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", nil];
    
    return headView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([Common isValue:section inNumberArray:_sectionArray]) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    NSDictionary *nodeDic = [_nodeData objectAtIndex:section];
    NSArray *pathPointList = [nodeDic objectForKey:KEY_pointList];
    
    return DEFAULT_CELL_HEIGHT * pathPointList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    
    NSDictionary *clauseDic = [_clauseData objectAtIndex:section];
    NSDictionary *nodeDic = [_nodeData objectAtIndex:section];
    
    NSArray *pathPointList = [nodeDic objectForKey:KEY_pointList];
    NSArray *clausePointList = [clauseDic objectForKey:KEY_pointList];
    
    static NSString *CellTableIdentifier = @"CellTableClauseIdentifier ";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    float contentY = 0.0f;
    for (int i = 0; i < pathPointList.count; i++) {
        NSDictionary *pointDic = [pathPointList objectAtIndex:i];
        NSString *pointId = [pointDic objectForKey:KEY_attrId];
        CGRect nodeFrame = CGRectMake(0, contentY, _selfSize.width, DEFAULT_CELL_HEIGHT);

        MR_ClauseNodeView *nodeView = [[MR_ClauseNodeView alloc] initWithFrame:nodeFrame];
        nodeView.jsonData = [self getPoint:clausePointList byid:pointId];
        nodeView.scoreData = [_scoreData objectForKey:pointId];
        nodeView.scoreArray = [NSArray arrayWithObjects:@"通过", @"不通过", nil];
//        nodeView.delegate = self;

        if (i % 2 == 0) {
            nodeView.backgroundColor = [UIColor grayColor];
        } else {
            nodeView.backgroundColor = [UIColor lightGrayColor];
        }

        [cell.contentView addSubview:nodeView];
        [nodeView release];
        
        contentY += DEFAULT_CELL_HEIGHT;
    }
    
    return cell;
}

@end
