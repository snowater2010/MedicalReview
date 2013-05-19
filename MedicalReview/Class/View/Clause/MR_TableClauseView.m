//
//  MR_TableClauseView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-5-15.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_TableClauseView.h"
#import "MR_ClauseHeadView.h"
#import "NSArray+Helper.h"

@interface MR_TableClauseView ()

@property(nonatomic, assign) CGSize selfSize;
@property(nonatomic, retain) UITableView *tableview;
@property(nonatomic, retain) NSMutableArray *sectionArray;

@property(nonatomic, retain) NSArray *headScoreArray;
@property(nonatomic, retain) NSArray *nodeScoreArray;
@property(nonatomic, retain) NSDictionary *updateScoreData;

@end

@implementation MR_TableClauseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sectionArray = [NSMutableArray arrayWithCapacity:0];
        self.headScoreArray = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", nil];
        self.nodeScoreArray = [NSArray arrayWithObjects:@"通过", @"不通过", nil];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [_sectionArray removeAllObjects];
    
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
    [super dealloc];
}

#pragma mark -
#pragma mark Utilities
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

- (NSDictionary *)getScoreDataWithHeaderView:(MR_ClauseHeadView *)clauseHeadView
{
    int section = clauseHeadView.tag;
    
    NSDictionary *headScoreDic = [clauseHeadView getScoreData];
    if (!headScoreDic) {
        return nil;
    }
    
    NSMutableDictionary *allScoreDic = [[NSMutableDictionary alloc] initWithDictionary:headScoreDic];
    
    //node data
    if ([_tableview numberOfRowsInSection:section] > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        UITableViewCell *cell = [_tableview cellForRowAtIndexPath:indexPath];
        for (UIView *nodeView in cell.contentView.subviews) {
            if (nodeView.class == [MR_ClauseNodeView class]) {
                NSDictionary *scoreDic = [(MR_ClauseNodeView *)nodeView getScoreData];
                if (scoreDic)
                    [allScoreDic addEntriesFromDictionary:scoreDic];
            }
        }
    }
    
    //combine data
    NSString *clauseId = clauseHeadView.clauseId;
    
    NSDictionary *result = [[[NSDictionary alloc] initWithObjectsAndKeys:allScoreDic, clauseId, nil] autorelease];
    
    [allScoreDic release];
    
    return result;
}


#pragma mark -
#pragma mark ClauseHeadDelegate + ClauseNodeDelegate

- (void)clickClauseHead:(id)sender
{
    MR_ClauseHeadView *clauseHeadView = (MR_ClauseHeadView *)sender;
    int tag = clauseHeadView.tag;
    
    NSArray* rowToInsert = [[NSMutableArray alloc] initWithObjects:[NSIndexPath indexPathForRow:0 inSection:tag], nil];
    
    [_tableview beginUpdates];
    if ([_sectionArray containsObject:[NSNumber numberWithInt:tag]]) {
        [_sectionArray removeObject:[NSNumber numberWithInt:tag]];
        [_tableview deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    else {
        [_sectionArray addObject:[NSNumber numberWithInt:tag]];
        [_tableview insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    [_tableview endUpdates];
}

- (void)clauseHeadScored:(MR_ClauseHeadView *)sender
{
    int headSection = sender.tag;
    
    int scoreIndex = [sender getScoreSelectIndex];
    NSString *scoreValue = [sender getScoreValue];
    NSString *scoreExplain = [sender getScoreExplain];
    NSString *clauseId = sender.clauseId;
    
    NSDictionary *scoreDic = [self getScoreDataDic:clauseId inSection:headSection];
    [scoreDic setValue:scoreValue forKey:KEY_scoreValue];
    [scoreDic setValue:scoreExplain forKey:KEY_scoreExplain];
    
    NSMutableDictionary *scorePoints = [scoreDic objectForKey:KEY_pointList];
    NSArray *scoreKeys = [scorePoints allKeys];
    
    for (NSString *pointKey in scoreKeys)
    {
        NSDictionary *pointDic = [scorePoints objectForKey:pointKey];
        NSString *attrLevel = [pointDic objectForKey:KEY_attrLevel];
        
        int levelIndex = [_headScoreArray getIndexWithString:attrLevel];
        if (levelIndex >= scoreIndex) {
            [pointDic setValue:@"1" forKey:KEY_scoreValue];
        }
        else {
            if (scoreIndex == _headScoreArray.count-1)
                [pointDic setValue:@"2" forKey:KEY_scoreValue];
            else
                [pointDic setValue:@"3" forKey:KEY_scoreValue];
        }
    }
    [_tableview reloadData];
    
    //update score
    self.updateScoreData = [NSDictionary dictionaryWithObjectsAndKeys:scoreDic, clauseId, nil];
    if (_updateScoreData)
        [self doReaquestUpdateScoreData];
}

- (void)clauseNodeScored:(MR_ClauseNodeView *)sender
{
    int section = sender.tag;
    NSString *value = sender.getScoreValue;
    NSString *attrId = sender.attrId;
    
    //clause points
    NSDictionary *nodeDic = [_nodeData objectAtIndex:section];
    NSString *clauseId = [nodeDic objectForKey:KEY_clauseId];
    
    NSDictionary *clausePoints = [[_clauseData objectAtIndex:section] objectForKey:KEY_pointList];
    int pointCount = clausePoints.count;
    NSString *clauseKeys[pointCount];
    NSDictionary *clauseObjects[pointCount];
    [clausePoints getObjects:clauseObjects andKeys:clauseKeys];
    
    //score
    NSDictionary *scoreDic = [self getScoreDataDic:clauseId inSection:section];
    NSDictionary *pointsDic = [scoreDic objectForKey:KEY_pointList];
    [[pointsDic objectForKey:attrId] setValue:value forKey:KEY_scoreValue];
    
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
        int value = [Common isEmptyString:scoreValue] ? UISegmentedControlNoSegment : scoreValue.intValue;
        
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
    else if(passC)
    {
        if (noPassB)
        {
            result = @"C";
        }
        else if(passB)
        {
            if (noPassA)
            {
                result = @"B";
            }
            else if(passA)
            {
                result = @"A";
            }
        }
    }
    
    [scoreDic setValue:result forKey:KEY_scoreValue];
    [_tableview reloadData];
    
    //update score
    self.updateScoreData = [NSDictionary dictionaryWithObjectsAndKeys:scoreDic, clauseId, nil];
    if (_updateScoreData)
        [self doReaquestUpdateScoreData];
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
#pragma mark -- request to update data

- (void)doReaquestUpdateScoreData
{
    //异步请求服务器更新数据
    _GET_APP_DELEGATE_(appDelegate);
    NSString *serverUrl = appDelegate.globalinfo.serverInfo.strWebServiceUrl;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:serverUrl]];
    
    [request setPostValue:@"upLoadData" forKey:@"module"];
    [request setPostValue:@"upLoadData" forKey:@"module2"];
    [request setDefaultPostValue];
    
    if (_updateScoreData) {
        NSString *strscoreCache = [_updateScoreData JSONString];
        if (strscoreCache)
            [request appendPostData:[strscoreCache dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
    }
    
//    //debug message
//    NSString *url = [NSString stringWithFormat:@"%@［%@］", serverUrl, @"upLoadData"];
//    _ALERT_SIMPLE_(url);
//    
//    NSString *postData = [[NSString alloc] initWithData:request.postBody encoding:NSNonLossyASCIIStringEncoding];
//    NSString *post = [NSString stringWithFormat:@"postBody:%@", postData];
//    _ALERT_SIMPLE_(post);
//    [postData release];
//    //debug message
    
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
    
    if (ok) {
        [self doRequestUpdateSucess];
    }
    else {
        [self doRequestUpdateFailed];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self doRequestUpdateFailed];
}

- (void)doRequestUpdateSucess
{
    //更新打分缓存
    [FileHelper asyWriteScoreDataToCache:_updateScoreData];
    
    //通知打分完成
    [Common callDelegate:_scoredDelegate method:@selector(clauseScored:) withObject:_updateScoreData];
}

- (void)doRequestUpdateFailed
{
    //更新“打分更新”缓存
    [FileHelper asyWriteScoreUpdateDataToCache:_updateScoreData];
    
    //通知打分完成
    [Common callDelegate:_scoredDelegate method:@selector(clauseScored:) withObject:_updateScoreData];
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
    headView.clauseId = clauseId;
    headView.clauseData = clauseDic;
    headView.scoreData = scoreDic;
    headView.scoreArray = _headScoreArray;
    headView.isOpen = [_sectionArray containsObject:[NSNumber numberWithInt:section]];
    
    return headView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_sectionArray containsObject:[NSNumber numberWithInt:section]]) {
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
    }
    
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    float contentY = 0.0f;
    for (int i = 0; i < pointList.count; i++) {
        NSDictionary *pointDic = [pointList objectAtIndex:i];
        NSString *attrId = [pointDic objectForKey:KEY_attrId];
        CGRect nodeFrame = CGRectMake(0, contentY, _selfSize.width, DEFAULT_CELL_HEIGHT);

        MR_ClauseNodeView *nodeView = [[MR_ClauseNodeView alloc] initWithFrame:nodeFrame];
        nodeView.attrId = attrId;
        nodeView.clauseData = [clauseDic objectForKey:attrId];
        nodeView.scoreData = [scoreDic objectForKey:attrId];
        nodeView.scoreArray = _nodeScoreArray;
        nodeView.delegate = self;
        nodeView.tag = section;

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
