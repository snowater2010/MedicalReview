//
//  MR_PathScoreCtroViewController.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_PathScoreCtro.h"
#import "MR_LeftPageView.h"
#import "MR_MainPageView.h"
#import "MR_PathNodeView.h"
#import "MR_CollapseClauseView.h"
#import "MR_ExplainView.h"
#import "MR_PathCell.h"
#import "FileHelper.h"
#import "MR_ClauseTopView.h"

@interface MR_PathScoreCtro ()
{
    BOOL topShow;
    BOOL leftShow;
}

@property(nonatomic, retain) NSArray *jsonData;
@property(nonatomic, retain) NSArray *pathData;

@property(nonatomic, retain) MR_PathNodeView *pathNodeView;
@property(nonatomic, retain) MR_CollapseClauseView *clauseView;

@property(nonatomic, retain) MR_LeftPageView *leftPageView;
@property(nonatomic, retain) MR_ClauseTopView *topPageView;
@property(nonatomic, retain) MR_MainPageView *mainPageView;

@end

@implementation MR_PathScoreCtro

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        topShow = YES;
        leftShow = NO;
    }
    return self;
}

- (void)loadView
{
    [super loadRootView];
    [self initView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    _pathNodeView.jsonData = [NSArray arrayWithObjects:_jsonData, nil];
    _pathNodeView.pathData = _pathData;
    _pathNodeView.scoreData = _scoreData;
    
    //第一次取第一条数据
    NSDictionary *pathDic = [_pathData objectAtIndex:0];
    NSArray *nodeList = [pathDic objectForKey:KEY_nodeList];
    NSArray *nodeData = [[nodeList objectAtIndex:0] objectForKey:KEY_clauseList];
    _clauseView.jsonData = [self getClauseFrom:_jsonData byNode:nodeData];
    _clauseView.scoreData = _scoreData;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.pathNodeView = nil;
    self.clauseView = nil;
    self.jsonData = nil;
    self.scoreData = nil;
    self.pathData = nil;
    
    self.leftPageView = nil;
    self.mainPageView = nil;
    self.topPageView = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark -- init view

- (void)initView
{
    CGRect rootFrame = self.view.frame;
    
    //left
    float left_w = rootFrame.size.width*0.18;
    float left_h = rootFrame.size.height;
    float left_x = -left_h;
    float left_y = 0;
    CGRect leftFrame = CGRectMake(left_x, left_y, left_w, left_h);
    MR_LeftPageView *leftPageView = [[MR_LeftPageView alloc] initWithFrame:leftFrame];
    self.leftPageView = leftPageView;
    [leftPageView release];
    [self.view addSubview:_leftPageView];
    
    //path node
    MR_PathNodeView *pathNodeView = [[MR_PathNodeView alloc] initWithFrame:leftPageView.bounds];
    pathNodeView.delegate = self;
    self.pathNodeView = pathNodeView;
    [leftPageView addSubview:_pathNodeView];
    [pathNodeView release];
    
    //main
    float main_x = 0;
    float main_y = 0;
    float main_w = rootFrame.size.width;
    float main_h = rootFrame.size.height;
    CGRect mainFrame = CGRectMake(main_x, main_y, main_w, main_h);
    MR_MainPageView *mainPageView = [[MR_MainPageView alloc] initWithFrame:mainFrame];
    
    //top
    float top_x = 0;
    float top_y = 0;
    float top_w = main_w;
    float top_h = main_h * 0.1;
    CGRect topFrame = CGRectMake(top_x, top_y, top_w, top_h);
    MR_ClauseTopView *topView = [[MR_ClauseTopView alloc] initWithFrame:topFrame];
    topView.backgroundColor = [UIColor lightGrayColor];
    self.topPageView = topView;
    [topView release];
    [mainPageView addSubview:_topPageView];
    
    //clause table
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"评审条款", KEY_tableName,
                          @"0.45", KEY_tableWidth, nil];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"自评", KEY_tableName,
                          @"0.05", KEY_tableWidth, nil];
    NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"评测结果", KEY_tableName,
                          @"0.2", KEY_tableWidth, nil];
    NSDictionary *dic4 = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"评测说明", KEY_tableName,
                          @"0.2", KEY_tableWidth, nil];
    NSDictionary *dic5 = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"操作", KEY_tableName,
                          @"-1", KEY_tableWidth, nil];
    NSArray *tableHead = [NSArray arrayWithObjects:dic1, dic2, dic3, dic4, dic5, nil];
    
    float head_x = 0;
    float head_y = top_y + top_h;
    float head_w = main_w;
    float head_h = main_h * 0.05;
    CGRect headFrame = CGRectMake(head_x, head_y, head_w, head_h);
    MR_ClauseTable *headView = [[MR_ClauseTable alloc] initWithFrame:headFrame];
    headView.delegate = self;
    headView.backgroundColor = [UIColor blackColor];
    headView.jsonData = tableHead;
    [mainPageView addSubview:headView];
    [headView release];
    
    //clause
    float clause_x = 0;
    float clause_y = head_y + head_h;
    float clause_w = mainFrame.size.width;
    float clause_h = mainFrame.size.height - head_h - top_h;
    CGRect clauseFrame = CGRectMake(clause_x, clause_y, clause_w, clause_h);
    MR_CollapseClauseView *clauseView = [[MR_CollapseClauseView alloc] initWithFrame:clauseFrame];
    clauseView.scoredDelegate = self;
    self.clauseView = clauseView;
    [mainPageView addSubview:clauseView];
    [clauseView release];
    
    //menu control
    CGRect menuBtFrame = CGRectMake(head_x, head_y, head_h, head_h);
    UIButton *menuBt = [[UIButton alloc] initWithFrame:menuBtFrame];
    menuBt.backgroundColor = [UIColor redColor];
    [menuBt addTarget:self action:@selector(leftHider) forControlEvents:UIControlEventTouchUpInside];
    [mainPageView addSubview:menuBt];
    [menuBt release];
    
    self.mainPageView = mainPageView;
    [mainPageView release];
    [self.view addSubview:_mainPageView];
    
    [self.view bringSubviewToFront:_leftPageView];
}

- (void)initData
{
    //clause
    if ([FileHelper ifHaveClauseCache])
        self.jsonData = [FileHelper readClauseDataFromCache];
    else {
        NSDictionary *allData = [FileHelper readDataFileWithName:@"json_loaddata.txt"];
        self.jsonData = [allData objectForKey:KEY_allClause];
    }
    
    //path
    if ([FileHelper ifHaveCacheFile:CACHE_PATH]) {
        self.pathData = [FileHelper readDataFromCache:CACHE_PATH];
    }
    else {
        NSDictionary *allData = [FileHelper readDataFileWithName:@"json_loaddata.txt"];
        self.pathData = [allData objectForKey:KEY_pathFormat];
    }
    
    self.scoreData = [self getInitScoreData];
}

- (NSDictionary *)getInitScoreData
{
    //score
    NSDictionary *scoreCache = [FileHelper readDataFromCache:CACHE_SCORE];
    NSDictionary *updateScoreCache = [FileHelper readDataFromCache:CACHE_SCORE_UPDATE];
    if (scoreCache || updateScoreCache) {
        NSMutableDictionary *allScore = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
        if (scoreCache)
            [allScore addEntriesFromDictionary:scoreCache];
        if (updateScoreCache)
            [allScore addEntriesFromDictionary:updateScoreCache];
        
        return allScore;
    }
    else {
        return nil;
    }
}

- (void)tableClicked
{
    topShow = !topShow;
    
    _ANIMATIONS_INIT_BEGIN_(0.25);
    
    CGRect topFrame = _topPageView.frame;
    CGRect mainFrame = _mainPageView.frame;
    CGRect clauseFrame = _clauseView.frame;
    if (topShow) {
        mainFrame.origin.y = 0;
        mainFrame.size.height = mainFrame.size.height - topFrame.size.height;
        clauseFrame.size.height = clauseFrame.size.height - topFrame.size.height;
    }
    else {
        mainFrame.origin.y = -topFrame.size.height;
        mainFrame.size.height = mainFrame.size.height + topFrame.size.height;
        clauseFrame.size.height = clauseFrame.size.height + topFrame.size.height;
    }
    _mainPageView.frame = mainFrame;
    _clauseView.frame = clauseFrame;
    
    _ANIMATIONS_INIT_END_;
}

- (void)leftHider
{
    leftShow = !leftShow;
    
    _ANIMATIONS_INIT_BEGIN_(0.25);
    
    CGRect leftFrame = _leftPageView.frame;
    CGRect mainFrame = _mainPageView.frame;
    if (leftShow) {
        leftFrame.origin.x = 0;
        mainFrame.origin.x = leftFrame.size.width;
    }
    else {
        leftFrame.origin.x = leftFrame.origin.x - leftFrame.size.width;
        mainFrame.origin.x = 0;
    }
    _leftPageView.frame = leftFrame;
    _mainPageView.frame = mainFrame;
    
    _ANIMATIONS_INIT_END_;
}

#pragma mark -
#pragma mark PathNodeDelegate
- (void)nodeSelected:(NSArray *)nodeData;
{
    if (nodeData) {
        _clauseView.jsonData = [self getClauseFrom:_jsonData byNode:nodeData];
        _clauseView.scoreData = [self getInitScoreData];
        [_clauseView setNeedsDisplay];
    }
}

#pragma mark -
#pragma mark ClauseScoredDelegate
- (void)clauseScored:(NSString *)scoredClauseId
{
    if (scoredClauseId)
        [_pathNodeView updateFinishCount:scoredClauseId];
}

@end
