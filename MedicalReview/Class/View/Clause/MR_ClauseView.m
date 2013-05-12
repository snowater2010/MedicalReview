//
//  MR_ClauseView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ClauseView.h"
#import "FileHelper.h"

@interface MR_ClauseView ()

@property(nonatomic, retain) NSDictionary *updateScoreData;

@end

@implementation MR_ClauseView

- (id)initWithFrame:(CGRect)frame cellHeight:(float)cellHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        _jsonData = nil;
        _cellHeight = cellHeight;
        _headState = CLAUSE_HEAD_STATE_CLOSE;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame cellHeight:DEFAULT_CELL_HEIGHT];
}

- (void)drawRect:(CGRect)rect
{
    if (!_jsonData) {
        return;
    }
    
    NSArray *pointList = [_jsonData objectForKey:KEY_pointList];
    
    //head view
    float head_x = 0;
    float head_y = 0;
    float head_w = rect.size.width;
    float head_h = _cellHeight;
    CGRect headFrame = CGRectMake(head_x, head_y, head_w, head_h);
    MR_ClauseHeadView *headView = [[MR_ClauseHeadView alloc] initWithFrame:headFrame];
    headView.delegate = self;
    headView.jsonData = _jsonData;
    headView.scoreData = _scoreData;
    self.headView = headView;
    [headView release];
    
    //content view
    float content_x = 0;
    float content_y = head_y + head_h;
    float content_w = rect.size.width - content_x;
    float content_h = _cellHeight*pointList.count;
    CGRect contentFrame = CGRectMake(content_x, content_y, content_w, content_h);
    UIView *contentView = [[UIView alloc] initWithFrame:contentFrame];
    self.contentView = contentView;
    [contentView release];
    
    float contentY = 0.0f;
    for (NSDictionary *pointDic in pointList) {
        NSDictionary *pointId = [pointDic objectForKey:KEY_attrId];
        CGRect nodeFrame = CGRectMake(0, contentY, rect.size.width, _cellHeight);
        
        MR_ClauseNodeView *nodeView = [[MR_ClauseNodeView alloc] initWithFrame:nodeFrame];
        nodeView.jsonData = pointDic;
        nodeView.scoreData = [_scoreData objectForKey:pointId];
        nodeView.delegate = self;
        
        [_contentView addSubview:nodeView];
        [nodeView release];
        
        contentY += _cellHeight;
    }

    [self addSubview:_headView];
    [self addSubview:_contentView];
    
    
    [self showHeadState];
}

- (float)getAllHeight
{
    return _headView.frame.size.height + _contentView.frame.size.height;
}

- (void)dealloc
{
    self.jsonData = nil;
    self.scoreData = nil;
    self.updateScoreData = nil;
    self.headView = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark -- user method

- (NSDictionary *)getUpdateScoreData
{
    //head data
    NSDictionary *headScoreDic = [_headView getHeadScore];
    if (!headScoreDic) {
        return nil;
    }
    
    NSMutableDictionary *allScoreDic = [[NSMutableDictionary alloc] initWithDictionary:headScoreDic];
    
    //node data
    for (MR_ClauseNodeView *nodeView in _contentView.subviews) {
        NSDictionary *scoreDic = [nodeView getNodeScore];
        if (scoreDic)
            [allScoreDic addEntriesFromDictionary:scoreDic];
    }
    
    //combine data
    NSString *clauseId = [_jsonData objectForKey:KEY_clauseId];
    
    NSDictionary *result = [[[NSDictionary alloc] initWithObjectsAndKeys:allScoreDic, clauseId, nil] autorelease];
    
    [allScoreDic release];
    
    return result;
}

#pragma mark -
#pragma mark -- ClauseHeadDelegate

- (void)clickClauseHead:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickClauseHead:)])
        [_delegate performSelector:@selector(clickClauseHead:) withObject:self];
}

- (void)showHeadState
{
    self.headView.headState = _headState;
    [self.headView showHeadState];
}

- (void)clauseHeadScored:(NSString *)score
{
    self.updateScoreData = [self getUpdateScoreData];
    if (_updateScoreData)
        [self doReaquestUpdateScoreData];
}

#pragma mark -- ClauseNodeDelegate

- (void)clauseNodeScored:(NSString *)score
{
    _LOG_FORMAT_(@"Node Scored___%@", score);
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
        NSString *clauseId = [_jsonData objectForKey:KEY_clauseId];
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
        NSString *clauseId = [_jsonData objectForKey:KEY_clauseId];
        [_scoredDelegate performSelector:@selector(clauseScored:) withObject:clauseId];
    }
}

@end
