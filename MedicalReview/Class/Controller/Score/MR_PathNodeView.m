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
<<<<<<< HEAD
        self.backgroundColor = [UIColor orangeColor];
        _jsonData = nil;
=======
        self.backgroundColor = [UIColor clearColor];
        _pathData = nil;
>>>>>>> branch
        _nodeData = nil;
        _dropDown = nil;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
<<<<<<< HEAD
    if (!_jsonData || _jsonData.count <= 0) {
        return;
    }
    NSDictionary *dic = [_jsonData objectAtIndex:0];
=======
    if (!_pathData || _pathData.count <= 0) {
        return;
    }
    NSDictionary *dic = [_pathData objectAtIndex:0];
>>>>>>> branch
    NSString *pathName = [dic objectForKey:KEY_pathName];
    [self setNodeDataAtIndex:0];
    
    //dropdown list
<<<<<<< HEAD
    float select_x = 10;
    float select_y = 10;
    float select_w = rect.size.width - 20;
=======
    float select_x = 5;
    float select_y = 10;
    float select_w = rect.size.width - 10;
>>>>>>> branch
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
<<<<<<< HEAD
    float tree_x = 10;
    float tree_y = select_y + select_h;
    float tree_w = rect.size.width - 20;
=======
    float tree_x = 5;
    float tree_y = select_y + select_h + 10;
    float tree_w = rect.size.width - 10;
>>>>>>> branch
    float tree_h = rect.size.height - (select_y + select_h) -10;
    CGRect treeFrame = CGRectMake(tree_x, tree_y, tree_w, tree_h);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:treeFrame];
    tableView.dataSource = self;
    tableView.delegate = self;
<<<<<<< HEAD
=======
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewRowAnimationTop];
>>>>>>> branch
    self.tableView = tableView;
    
    [self addSubview:btnSelect];
    [self addSubview:_tableView];
    [self bringSubviewToFront:btnSelect];
    
    [btnSelect release];
    [tableView release];
}

- (IBAction)selectClicked:(id)sender {
    
<<<<<<< HEAD
    NSMutableArray *pathArr = [[NSMutableArray alloc] initWithCapacity:_jsonData.count];
    for (NSDictionary *dic in _jsonData) {
=======
    NSMutableArray *pathArr = [[NSMutableArray alloc] initWithCapacity:_pathData.count];
    for (NSDictionary *dic in _pathData) {
>>>>>>> branch
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

- (void)setNodeDataAtIndex:(int)index
{
    NSArray *nodeList = [[_jsonData objectAtIndex:index] objectForKey:KEY_nodeList];
    if (nodeList) {
        self.nodeData = nodeList;
    }
    else {
        self.nodeData = nil;
    }
}

-(void)rel{
    self.dropDown = nil;
}

- (void)dealloc
{
<<<<<<< HEAD
    self.jsonData = nil;
=======
    self.pathData = nil;
    self.scoreData = nil;
>>>>>>> branch
    self.dropDown = nil;
    self.nodeData = nil;
    self.tableView = nil;
    [super dealloc];
}

<<<<<<< HEAD
#pragma mark -------------------
=======
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
>>>>>>> branch
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
<<<<<<< HEAD
    }
    //config the cell
    //cell.textLabel.text = [[self.realData objectAtIndex:indexPath.row] objectForKey:@"nodeName"];
    //cell.model = [[self.realData objectAtIndex:indexPath.row] objectForKey:@"nodeName"];
    cell.cellModel = [self.nodeData objectAtIndex:indexPath.row];
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    //取消边框线
    
    [cell setBackgroundView:[[UIView alloc] init]];    //取消边框线
    cell.backgroundColor = [UIColor clearColor];
=======
        
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease]; 
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing2.jpg"]];
    }
    
    cell.cellModel = [self.nodeData objectAtIndex:indexPath.row];
    
    [cell refreshPageData];
>>>>>>> branch
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MR_PathCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
<<<<<<< HEAD
    _LOG_([[self.nodeData objectAtIndex:indexPath.row] objectForKey:@"nodeName"]);
    
    NSDictionary *dic = [_nodeData objectAtIndex:indexPath.row];
    NSArray *clauseList = [dic objectForKey:KEY_clauseList];
    
    if ([_delegate respondsToSelector:@selector(nodeSelected:)]) {
        [_delegate performSelector:@selector(nodeSelected:) withObject:clauseList];
=======
    NSDictionary *dic = [_nodeData objectAtIndex:indexPath.row];
    
    if ([_delegate respondsToSelector:@selector(nodeSelected:)]) {
        [_delegate performSelector:@selector(nodeSelected:) withObject:dic];
>>>>>>> branch
    }
    
}

@end
