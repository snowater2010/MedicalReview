//
//  MR_PathScoreCtroViewController.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_PathScoreCtro.h"
#import "MR_LeftPageView.h"
#import "MR_TopPageView.h"
#import "MR_MainPageView.h"
#import "MR_PathNodeView.h"
#import "MR_CollapseClauseView.h"
#import "MR_ExplainView.h"
#import "MR_PathCell.h"
#import "FileHelper.h"
#import "MR_ClauseTable.h"

@interface MR_PathScoreCtro ()
{
    BOOL menuShow;
}

@property(nonatomic, retain) MR_PathNodeView *pathNodeView;
@property(nonatomic, retain) MR_CollapseClauseView *clauseView;

@property(nonatomic, retain) MR_LeftPageView *leftPageView;
@property(nonatomic, retain) MR_MainPageView *mainPageView;

@end

@implementation MR_PathScoreCtro

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        menuShow = NO;
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
    
    NSArray *nodeList = [_jsonData objectForKey:KEY_nodeList];
    NSArray *clauseList = [[nodeList objectAtIndex:0] objectForKey:KEY_clauseList];
    _clauseView.jsonData = clauseList;
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
    
    self.leftPageView = nil;
    self.mainPageView = nil;
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
    float top_h = main_h * 0.15;
    CGRect topFrame = CGRectMake(top_x, top_y, top_w, top_h);
    UIView *topView = [[UIView alloc] initWithFrame:topFrame];
    topView.backgroundColor = [UIColor lightGrayColor];
    [mainPageView addSubview:topView];
    [topView release];
    
    //clause table
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"评审条款", KEY_tableName,
                          @"0.45", KEY_tableWidth, nil];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"自评", KEY_tableName,
                          @"0.05", KEY_tableWidth, nil];
    NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"评测结果", KEY_tableName,
                          @"0.18", KEY_tableWidth, nil];
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
    self.clauseView = clauseView;
    [mainPageView addSubview:clauseView];
    [clauseView release];
    
    //menu control
    CGRect menuBtFrame = CGRectMake(head_x, head_y, head_h, head_h);
    UIButton *menuBt = [[UIButton alloc] initWithFrame:menuBtFrame];
    menuBt.backgroundColor = [UIColor redColor];
    [menuBt addTarget:self action:@selector(menuTrigger:) forControlEvents:UIControlEventTouchUpInside];
    [mainPageView addSubview:menuBt];
    
    self.mainPageView = mainPageView;
    [mainPageView release];
    [self.view addSubview:_mainPageView];
    
    [self.view bringSubviewToFront:_leftPageView];
}

- (void)initData
{
    //从缓存读取数据
    self.jsonData = [FileHelper readClauseDataFromFile];
    self.scoreData = [FileHelper readScoreDataFromFile];
    
//    self.jsonData = [FileHelper readClauseDataFromCache];
//    self.scoreData = [FileHelper readScoreDataFromCache];
    
//    //合并打分数据
//    NSDictionary *score = [FileHelper readScoreDataFromCache];
//    NSDictionary *scoreUpdate = [FileHelper readScoreUpdateDataFromCache];
//    NSMutableDictionary *scoreAll = [[NSMutableDictionary alloc] initWithDictionary:score];
//    [scoreAll addEntriesFromDictionary:scoreUpdate];
//    self.scoreData = scoreAll;
//    [scoreAll release];
}

- (void)menuTrigger:(id)sender
{
    menuShow = !menuShow;
    
    _ANIMATIONS_INIT_BEGIN_(0.25);
    
    CGRect leftFrame = _leftPageView.frame;
    CGRect mainFrame = _mainPageView.frame;
    if (menuShow) {
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
        _clauseView.jsonData = nodeData;
        [_clauseView setNeedsDisplay];
    }
}

@end
