//
//  MR_PathNodeView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-25.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_PathNodeView.h"
#import "MR_PathCell.h"

@interface MR_PathNodeView()

@property(nonatomic, retain) NIDropDown *dropDown;
@property(nonatomic, retain) NSArray *nodeData;
@property(nonatomic, retain) UITableView *tableView;

@end

@implementation MR_PathNodeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _pathData = nil;
        _nodeData = nil;
        _dropDown = nil;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (!_pathData || _pathData.count <= 0) {
        return;
    }
    NSDictionary *dic = [_pathData objectAtIndex:0];
    NSString *pathName = [dic objectForKey:KEY_pathName];
    [self setNodeDataAtIndex:0];
    
    //dropdown list
    float select_x = 5;
    float select_y = 10;
    float select_w = rect.size.width - 10;
    float select_h = 40;
    CGRect btnSelectFrame = CGRectMake(select_x, select_y, select_w, select_h);
    UIButton *btnSelect = [[UIButton alloc] initWithFrame:btnSelectFrame];
    btnSelect.layer.borderWidth = 1;
    btnSelect.layer.borderColor = [[UIColor blackColor] CGColor];
    btnSelect.layer.cornerRadius = 5;
    
    [btnSelect addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnSelect.tag = 100;
    
    [btnSelect setTitle:pathName forState:UIControlStateNormal];
    [btnSelect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //tree node List
    float tree_x = 5;
    float tree_y = select_y + select_h;
    float tree_w = rect.size.width - 10;
    float tree_h = rect.size.height - (select_y + select_h) -10;
    CGRect treeFrame = CGRectMake(tree_x, tree_y, tree_w, tree_h);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:treeFrame];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UITableViewRowAnimationTop];
    self.tableView = tableView;
    
    [self addSubview:btnSelect];
    [self addSubview:_tableView];
    [self bringSubviewToFront:btnSelect];
    
    [btnSelect release];
    [tableView release];
}

- (IBAction)selectClicked:(id)sender {
    
    NSMutableArray *pathArr = [[NSMutableArray alloc] initWithCapacity:_pathData.count];
    for (NSDictionary *dic in _pathData) {
        NSString *pathName = [dic objectForKey:KEY_pathName];
        [pathArr addObject:pathName];
    }
    
    if(_dropDown == nil) {
        CGFloat f = 200;
        _dropDown = [[NIDropDown alloc]showDropDown:sender :&f :pathArr :nil :@"down"];
        _dropDown.delegate = self;
    }
    else {
        [_dropDown hideDropDown:sender];
        [self rel];
    }
    
    [pathArr release];
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    int index = sender.selectIndex;
    [self setNodeDataAtIndex:index];
    [_tableView reloadData];
    [self rel];
    
    //选取第一个
    if ([_nodeData count] > 0) {
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        NSDictionary *dic = [_nodeData objectAtIndex:0];
        [Common callDelegate:_delegate method:@selector(nodeSelected:) withObject:dic];
    }
}

- (void)setNodeDataAtIndex:(int)index
{
    NSArray *nodeList = [[_pathData objectAtIndex:index] objectForKey:KEY_nodeList];
    if (!nodeList)
    {
        self.nodeData = nil;
        return;
    }
    
    NSMutableArray *nodes = [[NSMutableArray alloc] initWithCapacity:nodeList.count];
    
    //计算总数和完成数
    for (NSDictionary *pathDic in nodeList) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:pathDic];
        
        int total = 0;
        int finish = 0;
        NSArray *clauseArr = [pathDic objectForKey:KEY_clauseList];
        if (clauseArr) {
            for (NSDictionary *clauseDic in clauseArr) {
                NSString *clauseId = [clauseDic objectForKey:KEY_clauseId];
                NSDictionary *scoreDic = [_scoreData objectForKey:clauseId];
                NSString *scoreValue = [scoreDic objectForKey:KEY_scoreValue];
                if ([Common isNotEmptyString:scoreValue]) {
                    finish ++;
                }
            }
            total = clauseArr.count;
        }
        
        [dic setValue:[NSNumber numberWithInt:total] forKey:KEY_totalCount];
        [dic setValue:[NSNumber numberWithInt:finish] forKey:KEY_finishCount];
        [nodes addObject:dic];
        [dic release];
    }
    
    self.nodeData = nodes;
    [nodes release];
}

-(void)rel{
    self.dropDown = nil;
}

- (void)dealloc
{
    self.pathData = nil;
    self.scoreData = nil;
    self.dropDown = nil;
    self.nodeData = nil;
    self.tableView = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Utilities

- (void)updateFinishCount:(NSDictionary *)scoredData
{
    NSString *scoredClauseId = nil;
    if (scoredData && scoredData.count > 0) {
        scoredClauseId = [[scoredData allKeys] objectAtIndex:0];
    }
    
    if ([Common isEmptyString:scoredClauseId])
        return;
    
    //修改打分
    for (NSMutableDictionary *pathDic in self.nodeData) {
        NSArray *clauseArr = [pathDic objectForKey:KEY_clauseList];
        if (clauseArr) {
            for (NSDictionary *clauseDic in clauseArr) {
                NSString *clauseId = [clauseDic objectForKey:KEY_clauseId];
                if ([scoredClauseId isEqualToString:clauseId]) {
                    NSString *newScore = [[scoredData objectForKey:clauseId] objectForKey:KEY_scoreValue];
                    NSString *oldScore = [[_scoreData objectForKey:clauseId] objectForKey:KEY_scoreValue];
                    
                    int addNum = 0;
                    if ([Common isNotEmptyString:oldScore]) {
                        if ([Common isEmptyString:newScore]) {
                            addNum = -1;
                        }
                    } else {
                        if ([Common isNotEmptyString:newScore]) {
                            addNum = 1;
                        }
                    }
                    
                    if (addNum != 0) {
                        int finish = [[pathDic objectForKey:KEY_finishCount] intValue];
                        finish += addNum;
                        [pathDic setValue:[NSNumber numberWithInt:finish] forKey:KEY_finishCount];
                    }
                }
            }
        }
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    //更新数据
    NSMutableDictionary *newScoreData = [NSMutableDictionary dictionaryWithDictionary:_scoreData];
    [newScoreData addEntriesFromDictionary:scoredData];
    self.scoreData = newScoreData;
}

#pragma mark -
#pragma mark UITableView delegate
//委托里 @required 的必须实现

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_nodeData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MR_PathCell";
    MR_PathCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MR_PathCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.cellModel = [self.nodeData objectAtIndex:indexPath.row];
    
    [cell refreshPageData];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MR_PathCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = [_nodeData objectAtIndex:indexPath.row];
    
    if ([_delegate respondsToSelector:@selector(nodeSelected:)]) {
        [_delegate performSelector:@selector(nodeSelected:) withObject:dic];
    }
    
}

@end
