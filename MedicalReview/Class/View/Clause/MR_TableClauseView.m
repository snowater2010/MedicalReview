//
//  MR_TableClauseView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-5-15.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_TableClauseView.h"
#import "MR_ClauseHeadView.h"

@interface MR_TableClauseView ()

@property(nonatomic, assign) CGSize selfSize;
@property(nonatomic, retain) UITableView *tableview;
@property(nonatomic, retain) NSMutableArray *sectionArray;

@property(nonatomic, retain) NSArray *headScoreArray;
@property(nonatomic, retain) NSArray *nodeScoreArray;
@property(nonatomic, retain) NSDictionary *updateScoreData;

@property(nonatomic, retain) NSMutableArray *tableHadeViews;

@end

@implementation MR_TableClauseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sectionArray = [NSMutableArray arrayWithCapacity:0];
        self.tableHadeViews = [NSMutableArray arrayWithCapacity:0];
        self.headScoreArray = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", nil];
        self.nodeScoreArray = [NSArray arrayWithObjects:@"通过", @"不通过", nil];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [_sectionArray removeAllObjects];
    [_tableHadeViews removeAllObjects];
    
    NSMutableDictionary *mScoreData;
    if (_scoreData) {
        mScoreData = [NSMutableDictionary dictionaryWithDictionary:_scoreData];
    }
    else {
        mScoreData = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    self.scoreData = mScoreData;
    
    //content view
    self.selfSize = rect.size;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    self.sectionArray = nil;
    self.headScoreArray = nil;
    self.nodeScoreArray = nil;
    self.updateScoreData = nil;
    self.tableHadeViews = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Utilities

- (void)reSizeTable:(CGRect)frame
{
    _tableview.frame = frame;
}

- (void)reloadData
{
    [_sectionArray removeAllObjects];
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

//根据条款，获得打分数据，包括所有要点
- (NSDictionary *)getScoreDataDic:(NSString *)clauseId inSection:(int)section
{
    NSDictionary *scoreDic = [_scoreData objectForKey:clauseId];
    NSMutableDictionary *mScoreDic;
    if (scoreDic) {
        mScoreDic = [NSMutableDictionary dictionaryWithDictionary:scoreDic];
    }
    else {
        mScoreDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", KEY_scoreValue, @"", KEY_scoreExplain, nil];
    }
    [_scoreData setValue:mScoreDic forKey:clauseId];
    
    NSDictionary *scorePointDic = [mScoreDic objectForKey:KEY_pointList];
    NSMutableDictionary *mScorePointDic;
    if (scorePointDic) {
        mScorePointDic = [NSMutableDictionary dictionaryWithDictionary:scorePointDic];
    }
    else {
        mScorePointDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    [mScoreDic setValue:mScorePointDic forKey:KEY_pointList];
    
    //clause points
    NSDictionary *clausePoints = [[_clauseData objectAtIndex:section] objectForKey:KEY_pointList];
    int pointCount = clausePoints.count;
    NSString *clauseKeys[pointCount];
    NSDictionary *clauseObjects[pointCount];
    [clausePoints getObjects:clauseObjects andKeys:clauseKeys];
    
    for (int i = 0; i < pointCount; i++)
    {
        NSString *clauseKey = clauseKeys[i];
        NSDictionary *clauseInfo = clauseObjects[i];
        NSString *attrLevel = [clauseInfo objectForKey:KEY_attrLevel];
        
        NSDictionary *point = [mScorePointDic objectForKey:clauseKey];
        NSMutableDictionary *mPoint;
        if (point) {
            mPoint = [NSMutableDictionary dictionaryWithDictionary:point];
            [mPoint setValue:attrLevel forKey:KEY_attrLevel];
        }
        else {
            mPoint = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", KEY_scoreValue, @"", KEY_scoreExplain, attrLevel, KEY_attrLevel, nil];
        }
        [mScorePointDic setValue:mPoint forKey:clauseKey];
    }
    return mScoreDic;
}

#pragma mark -
#pragma mark ClauseHeadDelegate + ClauseNodeDelegate

- (void)clickClauseHead:(id)sender
{
    MR_ClauseHeadView *clauseHeadView = (MR_ClauseHeadView *)sender;
    int sectioin = clauseHeadView.section;
    
    int rowNumber = 0;
    NSArray *pointsArr = [[_nodeData objectAtIndex:sectioin] objectForKey:KEY_pointList];
    if (pointsArr)
        rowNumber = pointsArr.count;
    
    NSMutableArray* rowToDo = [[NSMutableArray alloc] initWithCapacity:rowNumber];
    for (int i = 0; i < rowNumber; i++) {
        [rowToDo addObject:[NSIndexPath indexPathForRow:i inSection:sectioin]];
    }
    
    [_tableview beginUpdates];
    if ([_sectionArray containsObject:[NSNumber numberWithInt:sectioin]]) {
        [_sectionArray removeObject:[NSNumber numberWithInt:sectioin]];
        [_tableview deleteRowsAtIndexPaths:rowToDo withRowAnimation:UITableViewRowAnimationTop];
    }
    else {
        [_sectionArray addObject:[NSNumber numberWithInt:sectioin]];
        [_tableview insertRowsAtIndexPaths:rowToDo withRowAnimation:UITableViewRowAnimationTop];
    }
    [_tableview endUpdates];
    
    [rowToDo release];
}

- (void)clauseHeadScored:(MR_ClauseHeadView *)sender
{
    int section = sender.section;
    
    int scoreIndex = [sender getScoreSelectIndex];
    NSString *scoreValue = [sender getScoreValue];
    NSString *scoreExplain = [sender getScoreExplain];
    NSString *clauseId = sender.clauseId;
    
    NSDictionary *scoreDic = [self getScoreDataDic:clauseId inSection:section];
    [scoreDic setValue:scoreValue forKey:KEY_scoreValue];
    [scoreDic setValue:scoreExplain forKey:KEY_scoreExplain];
    
    NSMutableDictionary *scorePoints = [scoreDic objectForKey:KEY_pointList];
    NSArray *scoreKeys = [scorePoints allKeys];
    
    for (NSString *pointKey in scoreKeys)
    {
        NSDictionary *pointDic = [scorePoints objectForKey:pointKey];
        NSString *attrLevel = [pointDic objectForKey:KEY_attrLevel];
        
        int levelIndex = [_headScoreArray getIndexWithString:attrLevel];
        if (scoreIndex == NO_SELECT_INDEX) {
            [pointDic setValue:@"" forKey:KEY_scoreValue];
        }
        else if (levelIndex >= scoreIndex) {
            [pointDic setValue:@"1" forKey:KEY_scoreValue];
        }
        else {
            if (scoreIndex == _headScoreArray.count-1)
                [pointDic setValue:@"2" forKey:KEY_scoreValue];
            else
                [pointDic setValue:@"3" forKey:KEY_scoreValue];
        }
    }
    
    //refresh node score on page
    [self updateNodeViewScore:scoreDic inSectioin:section];
    
    //update score
    NSDictionary *newScoreData = [NSDictionary dictionaryWithObjectsAndKeys:scoreDic, clauseId, nil];
    self.updateScoreData = newScoreData;
    if (newScoreData)
        [self doReaquestUpdateScoreData:newScoreData];
}

//update head explain
- (void)clauseHeadExplained:(MR_ClauseHeadView *)sender
{
    int section = sender.section;
    
    NSString *scoreExplain = [sender getScoreExplain];
    NSString *clauseId = sender.clauseId;
    
    NSDictionary *scoreDic = [self getScoreDataDic:clauseId inSection:section];
    [scoreDic setValue:scoreExplain forKey:KEY_scoreExplain];
    
    //update score
    NSDictionary *newScoreData = [NSDictionary dictionaryWithObjectsAndKeys:scoreDic, clauseId, nil];
    self.updateScoreData = newScoreData;
    if (newScoreData)
        [self doReaquestUpdateScoreData:newScoreData];
}

- (void)clauseNodeScored:(MR_ClauseNodeView *)sender
{
    int section = sender.section;
    NSString *value = [sender getScoreValue];
    NSString *scoreExplain = [sender getScoreExplain];
    NSString *attrId = sender.attrId;
    NSString *clauseId = sender.clauseId;
    
    NSDictionary *clausePoints = [[_clauseData objectAtIndex:section] objectForKey:KEY_pointList];
    int pointCount = clausePoints.count;
    NSString *clauseKeys[pointCount];
    NSDictionary *clauseObjects[pointCount];
    [clausePoints getObjects:clauseObjects andKeys:clauseKeys];
    
    //score
    NSDictionary *scoreDic = [self getScoreDataDic:clauseId inSection:section];
    NSDictionary *pointsDic = [scoreDic objectForKey:KEY_pointList];
    [[pointsDic objectForKey:attrId] setValue:value forKey:KEY_scoreValue];
    [[pointsDic objectForKey:attrId] setValue:scoreExplain forKey:KEY_scoreExplain];
    
    //可以抽取单独方法，防止分组数改变
    BOOL passA = YES;
    BOOL passB = YES;
    BOOL passC = YES;
    BOOL noPassA = NO;
    BOOL noPassB = NO;
    BOOL noPassC = NO;
    for (int i = 0; i < pointCount; i++)
    {
        NSString *clauseKey = clauseKeys[i];
        NSDictionary *clauseInfo = clauseObjects[i];
        NSString *attrLevel = [clauseInfo objectForKey:KEY_attrLevel];
        
        NSDictionary *pointScoreDic = [pointsDic objectForKey:clauseKey];
        NSString *scoreValue = [pointScoreDic objectForKey:KEY_scoreValue];
        int value = [Common isEmptyString:scoreValue] ? NO_SELECT_VALUE : scoreValue.intValue;
        
        if ([attrLevel isEqualToString:@"A"]) {
            if (value != 1) {
                passA = NO;
            }
            if (value == 0) {
                noPassA = YES;
            }
        }
        else if ([attrLevel isEqualToString:@"B"]) {
            if (value != 1) {
                passB = NO;
            }
            if (value == 0) {
                noPassB = YES;
            }
        }
        else if ([attrLevel isEqualToString:@"C"]) {
            if (value != 1) {
                passC = NO;
            }
            if (value == 0) {
                noPassC = YES;
            }
        }
    }
    
    //可以抽取个递归方法
    NSString *result = @"";
    if (noPassC)
    {
        result = @"D";
    }
    else if (noPassB)
    {
        result = @"C";
    }
    else if (noPassA)
    {
        result = @"B";
    }
    else if(passA && passB && passC)
    {
        result = @"A";
    }
    
    [scoreDic setValue:result forKey:KEY_scoreValue];
    
    //refresh head score on page
    [self updateHeadViewScore:scoreDic inSectioin:section];
    
    //update score
    NSDictionary *newScoreData = [NSDictionary dictionaryWithObjectsAndKeys:scoreDic, clauseId, nil];
    self.updateScoreData = newScoreData;
    if (newScoreData)
        [self doReaquestUpdateScoreData:newScoreData];
}

//update node explain text
- (void)clauseNodeExplained:(MR_ClauseNodeView *)sender
{
    int section = sender.section;
    NSString *explain = [sender getScoreExplain];
    NSString *attrId = sender.attrId;
    NSString *clauseId = sender.clauseId;
    
    //score
    NSDictionary *scoreDic = [self getScoreDataDic:clauseId inSection:section];
    NSDictionary *pointsDic = [scoreDic objectForKey:KEY_pointList];
    [[pointsDic objectForKey:attrId] setValue:explain forKey:KEY_scoreExplain];
    
    //update score
    NSDictionary *newScoreData = [NSDictionary dictionaryWithObjectsAndKeys:scoreDic, clauseId, nil];
    self.updateScoreData = newScoreData;
    if (newScoreData)
        [self doReaquestUpdateScoreData:newScoreData];
}

//更新head界面打分
- (void)updateHeadViewScore:(NSDictionary *)scoreDic inSectioin:(int)section
{
    if (_tableHadeViews.count > section)
    {
        MR_ClauseHeadView *headView = (MR_ClauseHeadView *)[_tableHadeViews objectAtIndex:section];
        NSString *headScore = [scoreDic objectForKey:KEY_scoreValue];
        [headView changeScoreWithValue:headScore];
    }
}

//如果展开node节点，更新界面打分
- (void)updateNodeViewScore:(NSDictionary *)scoreDic inSectioin:(int)section
{
    NSDictionary *pointsDic = [scoreDic objectForKey:KEY_pointList];
    
    for (int i = 0, j = [_tableview numberOfRowsInSection:section]; i < j; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        UITableViewCell *cell = [_tableview cellForRowAtIndexPath:indexPath];
        
        MR_ClauseNodeView *nodeView = (MR_ClauseNodeView *)[cell viewWithTag:TAG_CELL_NODE_VIEW];
        NSString *attrId = nodeView.attrId;
        NSDictionary *pointScore = [pointsDic objectForKey:attrId];
        NSString *scoreValue = [pointScore objectForKey:KEY_scoreValue];
        [nodeView changeScoreWithValue:scoreValue];
    }
}

#pragma mark -
#pragma mark -- request to update data

- (void)doReaquestUpdateScoreData:(NSDictionary *)newScoreData
{
    if (!newScoreData)
        return;
    
    //异步请求服务器更新数据
    _GET_APP_DELEGATE_(appDelegate);
    NSString *serverUrl = appDelegate.globalinfo.serverInfo.strWebServiceUrl;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:serverUrl]];
    
    request.userInfo = newScoreData;
    
    [request setPostValue:@"upLoadData" forKey:@"module"];
    [request setPostValue:@"upLoadData" forKey:@"module2"];
    [request setDefaultPostValue];
    
    NSString *strscoreCache = [newScoreData JSONString];
    if (strscoreCache)
        [request setPostValue:strscoreCache forKey:@"postData"];
    
    request.delegate = self;
    [request startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    request.responseEncoding = NSUTF8StringEncoding;
    NSString *responseData = [request responseString];
    
    BOOL ok = YES;
    NSDictionary* retDic = [responseData objectFromJSONString];
    if (retDic) {
        NSString *errCode = [retDic objectForKey:KEY_errCode];
        if (![errCode isEqualToString:@"0"]) {
            ok = NO;
        }
    }
    
    NSDictionary *newScoreData = request.userInfo;
    
    if (ok) {
        [self doRequestUpdateSucess:newScoreData];
    }
    else {
        [self doRequestUpdateFailed:newScoreData];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSDictionary *newScoreData = request.userInfo;
    [self doRequestUpdateFailed:newScoreData];
}

- (void)doRequestUpdateSucess:(NSDictionary *)newScoreData
{
    _LOG_(@"UpdateSucess");
    
    //更新打分缓存
    [FileHelper asyWriteScoreDataToCache:newScoreData];
    
    //通知打分完成
    [Common callDelegate:_scoredDelegate method:@selector(clauseScored:) withObject:newScoreData];
}

- (void)doRequestUpdateFailed:(NSDictionary *)newScoreData
{
    _LOG_(@"UpdateFailed");
    
    //更新“打分更新”缓存
    [FileHelper asyWriteScoreUpdateDataToCache:newScoreData];
    
    //通知打分完成
    [Common callDelegate:_scoredDelegate method:@selector(clauseScored:) withObject:newScoreData];
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
    float head_w = _selfSize.width;
    float head_h = DEFAULT_CELL_HEIGHT;
    CGRect headFrame = CGRectMake(head_x, head_y, head_w, head_h);
    MR_ClauseHeadView *headView = [[[MR_ClauseHeadView alloc] initWithFrame:headFrame] autorelease];
    headView.section = section;
    headView.delegate = self;
    headView.clauseId = clauseId;
    headView.nodeDic = nodeDic;
    headView.clauseData = clauseDic;
    headView.scoreData = scoreDic;
    headView.scoreArray = _headScoreArray;
    headView.isOpen = [_sectionArray containsObject:[NSNumber numberWithInt:section]];
    headView.readOnly = _readOnly;
    
    //save in a array
    if (_tableHadeViews.count > section && [_tableHadeViews objectAtIndex:section])
        [_tableHadeViews replaceObjectAtIndex:section withObject:headView];
    else
        [_tableHadeViews insertObject:headView atIndex:section];
    
    return headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowNumber = 0;
    if ([_sectionArray containsObject:[NSNumber numberWithInt:section]]) {
        NSArray *pointsArr = [[_nodeData objectAtIndex:section] objectForKey:KEY_pointList];
        if (pointsArr)
            rowNumber = pointsArr.count;
    }
    return rowNumber;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DEFAULT_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    
    NSDictionary *nodeDic = [_nodeData objectAtIndex:section];
    NSString *clauseId = [nodeDic objectForKey:KEY_clauseId];
    NSArray *pointList = [nodeDic objectForKey:KEY_pointList];
    
    NSDictionary *clauseDic = [[_clauseData objectAtIndex:section] objectForKey:KEY_pointList];
    NSDictionary *scoreDic = [[_scoreData objectForKey:clauseId] objectForKey:KEY_pointList];
    
    static NSString *CellTableIdentifier = @"TableClauseCellIdentifier ";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGRect nodeFrame = CGRectMake(0, 0, _selfSize.width, DEFAULT_CELL_HEIGHT);
        MR_ClauseNodeView *nodeView = [[MR_ClauseNodeView alloc] initWithFrame:nodeFrame withScoreArray:_nodeScoreArray];
        nodeView.backgroundColor = [Common colorWithR:238 withG:238 withB:238];
        nodeView.layer.borderColor = [[Common colorWithR:221 withG:221 withB:221] CGColor];
        nodeView.layer.borderWidth = 0.5;
        nodeView.delegate = self;
        nodeView.tag = TAG_CELL_NODE_VIEW;
        nodeView.readOnly = _readOnly;
        [cell.contentView addSubview:nodeView];
        [nodeView release];
    }
    
    NSDictionary *pointDic = [pointList objectAtIndex:row];
    NSString *attrId = [pointDic objectForKey:KEY_attrId];
    
    MR_ClauseNodeView *nodeView = (MR_ClauseNodeView *)[cell.contentView viewWithTag:TAG_CELL_NODE_VIEW];
    nodeView.section = section;
    nodeView.attrId = attrId;
    nodeView.clauseId = clauseId;
    nodeView.nodeDic = nodeDic;
    nodeView.clauseData = [clauseDic objectForKey:attrId];
    nodeView.scoreData = [scoreDic objectForKey:attrId];
    [nodeView setNeedsDisplay];
    
    return cell;
}

@end
