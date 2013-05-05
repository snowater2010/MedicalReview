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

@property(nonatomic, retain) MR_PathNodeView *pathNodeView;
@property(nonatomic, retain) MR_CollapseClauseView *clauseView;

@end

@implementation MR_PathScoreCtro

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization //test
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
    [super dealloc];
}

#pragma mark -
#pragma mark -- init view

- (void)initView
{
    CGRect rootFrame = self.view.frame;
    
    //left
    CGRect leftFrame = CGRectMake(0, 0, rootFrame.size.width*0.18, rootFrame.size.height);
    MR_LeftPageView *leftPageView = [[MR_LeftPageView alloc] initWithFrame:leftFrame];
    [self.view addSubview:leftPageView];
    [leftPageView release];
    
    //path node
    MR_PathNodeView *pathNodeView = [[MR_PathNodeView alloc] initWithFrame:leftPageView.bounds];
    pathNodeView.delegate = self;
    self.pathNodeView = pathNodeView;
    [leftPageView addSubview:_pathNodeView];
    [pathNodeView release];
    
    //main
    CGRect mainFrame = CGRectMake(leftFrame.size.width, 0, rootFrame.size.width-leftFrame.size.width, rootFrame.size.height);
    MR_MainPageView *mainPageView = [[MR_MainPageView alloc] initWithFrame:mainFrame];
    [self.view addSubview:mainPageView];
    [mainPageView release];
    
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
    float head_y = 0;
    float head_w = mainFrame.size.width;
    float head_h = mainFrame.size.height * 0.05;
    CGRect headFrame = CGRectMake(head_x, head_y, head_w, head_h);
    MR_ClauseTable *headView = [[MR_ClauseTable alloc] initWithFrame:headFrame];
    headView.backgroundColor = [UIColor blackColor];
    headView.jsonData = tableHead;
    [mainPageView addSubview:headView];
    [headView release];
    
    float clause_x = 0;
    float clause_y = head_y + head_h;
    float clause_w = mainFrame.size.width;
    float clause_h = mainFrame.size.height - head_h;
    CGRect clauseFrame = CGRectMake(clause_x, clause_y, clause_w, clause_h);
    MR_CollapseClauseView *clauseView = [[MR_CollapseClauseView alloc] initWithFrame:clauseFrame];
    self.clauseView = clauseView;
    [mainPageView addSubview:clauseView];
    [clauseView release];
}

- (void)initData
{
    //从缓存读取数据
    self.jsonData = [FileHelper readClauseDataFromCache];
    
//    NSString *fileName = @"json_clause.txt";
//    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
//    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
//    self.jsonData = [jsonData objectFromJSONData];
    
//    [FileHelper writeDataToCache:_jsonData];
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
