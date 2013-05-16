//
//  MR_ClauseView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ClauseView.h"

@interface MR_ClauseView ()


@property(nonatomic, retain) NSArray *headScoreArray;
@property(nonatomic, retain) NSArray *nodeScoreArray;
@property(nonatomic, retain) NSDictionary *updateScoreData;

@end

@implementation MR_ClauseView

- (id)initWithFrame:(CGRect)frame cellHeight:(float)cellHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        _clauseData = nil;
        _cellHeight = cellHeight;
//        _headState = CLAUSE_HEAD_STATE_CLOSE;
        
        self.headScoreArray = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", nil];
        self.nodeScoreArray = [NSArray arrayWithObjects:@"通过", @"不通过", nil];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame cellHeight:DEFAULT_CELL_HEIGHT];
}

- (void)drawRect:(CGRect)rect
{
    if (!_clauseData) {
        return;
    }
    
    //head view
    float head_x = 0;
    float head_y = 0;
    float head_w = rect.size.width;
    float head_h = _cellHeight;
    CGRect headFrame = CGRectMake(head_x, head_y, head_w, head_h);
    MR_ClauseHeadView *headView = [[MR_ClauseHeadView alloc] initWithFrame:headFrame];
    headView.delegate = self;
    headView.clauseData = _clauseData;
    headView.scoreData = _scoreData;
    headView.scoreArray = _headScoreArray;
    self.headView = headView;
    [headView release];
    
    //content view
    NSArray *pathPointList = [_nodeData objectForKey:KEY_pointList];
    NSArray *clausePointList = [_clauseData objectForKey:KEY_pointList];
    
    float content_x = 0;
    float content_y = head_y + head_h;
    float content_w = rect.size.width - content_x;
    float content_h = _cellHeight * pathPointList.count;
    CGRect contentFrame = CGRectMake(content_x, content_y, content_w, content_h);
    UIView *contentView = [[UIView alloc] initWithFrame:contentFrame];
    self.contentView = contentView;
    [contentView release];
    
    float contentY = 0.0f;
    for (int i = 0; i < pathPointList.count; i++) {
        NSDictionary *pointDic = [pathPointList objectAtIndex:i];
        NSString *pointId = [pointDic objectForKey:KEY_attrId];
        CGRect nodeFrame = CGRectMake(0, contentY, rect.size.width, _cellHeight);
        
        MR_ClauseNodeView *nodeView = [[MR_ClauseNodeView alloc] initWithFrame:nodeFrame];
        nodeView.clauseData = [self getPoint:clausePointList byid:pointId];
        nodeView.scoreData = [_scoreData objectForKey:pointId];
        nodeView.scoreArray = _nodeScoreArray;
        nodeView.delegate = self;
        
        if (i % 2 == 0) {
            nodeView.backgroundColor = [UIColor grayColor];
        } else {
            nodeView.backgroundColor = [UIColor lightGrayColor];
        }
        
        [_contentView addSubview:nodeView];
        [nodeView release];
        
        contentY += _cellHeight;
    }
    
    [self addSubview:_headView];
    [self addSubview:_contentView];
    
    [self showHeadState];
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

- (float)getAllHeight
{
    return _headView.frame.size.height + _contentView.frame.size.height;
}

- (void)dealloc
{
    self.clauseData = nil;
    self.scoreData = nil;
    self.nodeData = nil;
    self.updateScoreData = nil;
    self.headScoreArray = nil;
    self.nodeScoreArray = nil;
    self.headView = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark -- Utilities

- (NSDictionary *)getUpdateScoreData
{
    //head data
    NSDictionary *headScoreDic = [_headView getScoreData];
    if (!headScoreDic) {
        return nil;
    }
    
    NSMutableDictionary *allScoreDic = [[NSMutableDictionary alloc] initWithDictionary:headScoreDic];
    
    //node data
    for (MR_ClauseNodeView *nodeView in _contentView.subviews) {
        NSDictionary *scoreDic = [nodeView getScoreData];
        if (scoreDic)
            [allScoreDic addEntriesFromDictionary:scoreDic];
    }
    
    //combine data
    NSString *clauseId = [_clauseData objectForKey:KEY_clauseId];
    
    NSDictionary *result = [[[NSDictionary alloc] initWithObjectsAndKeys:allScoreDic, clauseId, nil] autorelease];
    
    [allScoreDic release];
    
    return result;
}

- (NSDictionary *)getScoreDataInSection:(int)section
{
    //head data
    NSDictionary *headScoreDic = [_headView getScoreData];
    if (!headScoreDic) {
        return nil;
    }
    
    NSMutableDictionary *allScoreDic = [[NSMutableDictionary alloc] initWithDictionary:headScoreDic];
    
    //node data
    for (MR_ClauseNodeView *nodeView in _contentView.subviews) {
        NSDictionary *scoreDic = [nodeView getScoreData];
        if (scoreDic)
            [allScoreDic addEntriesFromDictionary:scoreDic];
    }
    
    //combine data
    NSString *clauseId = [_clauseData objectForKey:KEY_clauseId];
    
    NSDictionary *result = [[[NSDictionary alloc] initWithObjectsAndKeys:allScoreDic, clauseId, nil] autorelease];
    
    [allScoreDic release];
    
    return result;
}

#pragma mark -
#pragma mark -- ClauseHead & ClauseNode delegate

- (void)clickClauseHead:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickClauseHead:)])
        [_delegate performSelector:@selector(clickClauseHead:) withObject:self];
}

- (void)showHeadState
{
//    self.headView.headState = _headState;
    [self.headView showHeadState];
}

- (void)clauseHeadScored:(NSNumber *)index
{
    //change node
    switch (index.intValue) {
        case 0:
            [self refreshNodeScore:0];
            break;
        case 1:
            [self refreshNodeScore:1];
            break;
        default:
            [self refreshNodeScore:NO_SELECT_VALUE];
            break;
    }
    
    //update score
    self.updateScoreData = [self getUpdateScoreData];
    if (_updateScoreData)
        [self doReaquestUpdateScoreData];
}

- (void)clauseNodeScored:(id)sender
{
    MR_ClauseNodeView *nodeView = (MR_ClauseNodeView *)sender;
    
    NSString *attrId = [nodeView getNodeAttrId];
    NSDictionary *scoreDic = [nodeView getNodeScore];
    
    //更新score data
    [_scoreData setValue:scoreDic forKey:attrId];
    
    int headScoreIndex = [self computeScore];
    [_headView changeNodeScore:headScoreIndex];
    
    //update score
    
}

//根据node打分，计算score分数
- (int)computeScore
{
    //change head score
    NSArray *clausePointList = [_clauseData objectForKey:KEY_pointList];
    
    NSArray *allKeys = [_scoreData allKeys];
    
    BOOL passA = YES;
    BOOL passB = YES;
    BOOL passC = YES;
    BOOL unPassA = NO;
    BOOL unPassB = NO;
    BOOL unPassC = NO;
    for (NSDictionary *clauseDic in clausePointList) {
        NSString *attrId = [clauseDic objectForKey:KEY_attrId];
        int nodeType = 1;
        
        //如果该级别已经为NO，则不需要再进行判断了
        switch (nodeType) {
            case 0:
                if (unPassA) continue;
                break;
            case 1:
                if (unPassB) continue;
                break;
            case 2:
                if (unPassC) continue;
                break;
            default:
                break;
        }
        
        //如果没有打分，则设置为NO
        if (![allKeys containsObject:attrId]) {
            if (nodeType == 0)
                passA = NO;
            else if (nodeType == 1)
                passB = NO;
            else if (nodeType == 2)
                passC = NO;
            continue;
        }
        
        //如果打了“不通过”，则设置为NO
        NSString *scoreValue = [[_scoreData objectForKey:attrId] objectForKey:KEY_scoreValue];
        if ([Common isNotEmptyString:scoreValue] && scoreValue.intValue == 1) {
            if (nodeType == 0)
            {
                passA = NO;
                unPassA = YES;
            }
            else if (nodeType == 1)
            {
                passB = NO;
                unPassB = YES;
            } 
            else if (nodeType == 2)
            {
                passC = NO;
                unPassC = YES;
            }
            continue;
        }
    }
    
    //乱
    if (unPassA) {
        if (passB && passC) {
            return 1;
        } else {
            if (unPassB) {
                
            }
        }
        
    } else {
        
    }
    
    if (unPassA && passB && passC) {
        return 1;
    }
    
    if (passA && passB && passC) {
        return 0;
    }
    if (passB && passC)
    {
        return 1;
    }
    if (passC)
    {
        return 2;
    }
    return 3;
}

- (void)refreshNodeScore:(int)index
{
    for (UIView *subView in _contentView.subviews) {
        if (subView.class == [MR_ClauseNodeView class]) {
            [(MR_ClauseNodeView *)subView changeNodeScore:index];
        }
    }
}

- (void)refreshHeadScore:(int)index
{
    
}

#pragma mark -
#pragma mark -- request to update data

- (void)doReaquestUpdateScoreData
{
    //异步请求服务器更新数据
    _GET_APP_DELEGATE_(appDelegate);
    NSString *serverUrl = appDelegate.globalinfo.serverInfo.strWebServiceUrl;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:serverUrl]];
    
    [request setPostValue:@"updateScore" forKey:@"module"];
    [request setDefaultPostValue];
    
    if (_updateScoreData) {
        NSString *strscoreCache = [_updateScoreData JSONString];
        if (strscoreCache)
            [request appendPostData:[strscoreCache dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
    }
    
    request.delegate = self;
    [request startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    request.responseEncoding = NSUTF8StringEncoding;
    NSString *responseData = [request responseString];
    
    BOOL ok = YES;
    NSDictionary* retDic = nil;
    
    if ([Common isEmptyString:responseData]) {
        ok = NO;
    }
    else {
        retDic = [responseData objectFromJSONString];
        if (retDic) {
            NSString *errCode = [retDic objectForKey:KEY_errCode];
            if (![errCode isEqualToString:@"0"]) {
                ok = NO;
            }
        }
        else {
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
    if ([_scoredDelegate respondsToSelector:@selector(clauseScored:)])
    {
        NSString *clauseId = [_clauseData objectForKey:KEY_clauseId];
        [_scoredDelegate performSelector:@selector(clauseScored:) withObject:clauseId];
    }
}

- (void)doRequestUpdateFailed
{
    //更新“打分更新”缓存
    [FileHelper asyWriteScoreUpdateDataToCache:_updateScoreData];

    //通知打分完成
    if ([_scoredDelegate respondsToSelector:@selector(clauseScored:)])
    {
        NSString *clauseId = [_clauseData objectForKey:KEY_clauseId];
        [_scoredDelegate performSelector:@selector(clauseScored:) withObject:clauseId];
    }
}

@end
