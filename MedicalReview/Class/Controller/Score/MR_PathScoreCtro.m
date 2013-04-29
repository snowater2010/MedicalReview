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

@interface MR_PathScoreCtro ()

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
    
    MR_MainPageView *mainPageView = (MR_MainPageView *)[self.view viewWithTag:TAG_VIEW_MAIN];
    MR_CollapseClauseView *clauseView = (MR_CollapseClauseView *)[mainPageView viewWithTag:TAG_VIEW_CLAUSE];
    
    NSArray *nodeList = [_jsonData objectForKey:KEY_nodeList];
    NSArray *clauseList = [[nodeList objectAtIndex:0] objectForKey:KEY_clauseList];
    clauseView.jsonData = clauseList;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark -- init view

- (void)initView
{
    CGRect rootFrame = self.view.frame;
    
    //left
    CGRect leftFrame = CGRectMake(0, 0, rootFrame.size.width*0.2, rootFrame.size.height);
    MR_LeftPageView *leftPageView = [[MR_LeftPageView alloc] initWithFrame:leftFrame];
    leftPageView.tag = TAG_VIEW_LEFT;
    [self.view addSubview:leftPageView];
    
    MR_PathNodeView *pathNodeView = [[MR_PathNodeView alloc] initWithFrame:leftPageView.bounds];
    [leftPageView addSubview:pathNodeView];
    
    //main
    CGRect mainFrame = CGRectMake(leftFrame.size.width, 0, rootFrame.size.width-leftFrame.size.width, rootFrame.size.height);
    MR_MainPageView *mainPageView = [[MR_MainPageView alloc] initWithFrame:mainFrame];
    mainPageView.tag = TAG_VIEW_MAIN;
    [self.view addSubview:mainPageView];
    
    CGRect clauseFrame = CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.height/2);
    MR_CollapseClauseView *clauseView = [[MR_CollapseClauseView alloc] initWithFrame:clauseFrame];
    clauseView.tag = TAG_VIEW_CLAUSE;
    [mainPageView addSubview:clauseView];
}

- (void)initData
{
    NSString *fileName = @"json_clause.txt";
    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    self.jsonData = [jsonData objectFromJSONData];
}

@end
