//
//  MR_chapterScoreCtro.m
//  MedicalReview
//
//  Created by lipeng11 on 13-5-7.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ChapterScoreCtro.h"
#import "MR_LeftPageView.h"
#import "MR_MainPageView.h"
#import "MR_ClauseTable.h"
#import "MR_CollapseClauseView.h"
#import "MR_ChapterSearchView.h"
#import "FileHelper.h"

@interface MR_ChapterScoreCtro ()

@property(nonatomic, retain) NSArray *clauseData;
@property(nonatomic, retain) NSDictionary *scoreData;
@property(nonatomic, retain) NSArray *chapterData;
@property(nonatomic, retain) NSArray *sectionData;

@property(nonatomic, retain) MR_CollapseClauseView *clauseView;
@property(nonatomic, retain) MR_ChapterHeadView *chapterView;
@property(nonatomic, retain) UITableView *chapterTable;

@end

@implementation MR_ChapterScoreCtro

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    _chapterView.chapterData = _chapterData;
    [_chapterTable reloadData];
    
    //第一次取第一条数据
    NSDictionary *sectionDic = [_sectionData objectAtIndex:0];
    NSArray *nodeData = [sectionDic objectForKey:KEY_clauseList];
    _clauseView.nodeData = nodeData;
    _clauseView.clauseData = [self getClauseFrom:_clauseData byNode:nodeData];
    _clauseView.scoreData = _scoreData;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.clauseData = nil;
    self.chapterData = nil;
    self.scoreData = nil;
    self.sectionData = nil;
    
    self.clauseView = nil;
    self.chapterView = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark -- init view

- (void)initView
{
    CGRect rootFrame = self.view.frame;
    
    //top chapter head
    float chapter_x = 0;
    float chapter_y = 0;
    float chapter_w = rootFrame.size.width;
    float chapter_h = 30;
    CGRect chapterFrame = CGRectMake(chapter_x, chapter_y, chapter_w, chapter_h);
    MR_ChapterHeadView *chapterView = [[MR_ChapterHeadView alloc] initWithFrame:chapterFrame];
    chapterView.delegate = self;
    [self.view addSubview:chapterView];
    self.chapterView = chapterView;
    [chapterView release];
    
    //left
    float left_x = 0;
    float left_y = chapter_y + chapter_h;
    float left_w = rootFrame.size.width*0.18;
    float left_h = rootFrame.size.height - left_y;
    CGRect leftFrame = CGRectMake(left_x, left_y, left_w, left_h);
    MR_LeftPageView *leftPageView = [[MR_LeftPageView alloc] initWithFrame:leftFrame];
    [self.view addSubview:leftPageView];
    [leftPageView release];
    
    //chapter table
    UITableView *chapterTable = [[UITableView alloc] initWithFrame:leftPageView.bounds];
    chapterTable.delegate = self;
    chapterTable.dataSource = self;
    [leftPageView addSubview:chapterTable];
    [chapterTable release];
    self.chapterTable = chapterTable;
    
    //main
    float main_x = left_x + left_w;
    float main_y = chapter_y + chapter_h;
    float main_w = rootFrame.size.width - left_w;
    float main_h = rootFrame.size.height - main_y;
    CGRect mainFrame = CGRectMake(main_x, main_y, main_w, main_h);
    MR_MainPageView *mainPageView = [[MR_MainPageView alloc] initWithFrame:mainFrame];
    [self.view addSubview:mainPageView];
    [mainPageView release];
    
    //top
    float top_x = 0;
    float top_y = 0;
    float top_w = main_w;
    float top_h = main_h * 0.1;
    CGRect topFrame = CGRectMake(top_x, top_y, top_w, top_h);
    MR_ChapterSearchView *topView = [[MR_ChapterSearchView alloc] initWithFrame:topFrame];
    [mainPageView addSubview:topView];
    
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
}

#pragma mark -
#pragma mark -- Utilities

- (void)initData
{
    //clause
    if ([FileHelper ifHaveClauseCache])
        self.clauseData = [FileHelper readClauseDataFromCache];
    else {
        NSDictionary *allData = [FileHelper readDataFileWithName:@"json_loaddata.txt"];
        self.clauseData = [allData objectForKey:KEY_allClause];
    }
    
    //chapter
    if ([FileHelper ifHaveCacheFile:CACHE_CHAPTER]) {
        self.chapterData = [FileHelper readDataFromCache:CACHE_CHAPTER];
    }
    else {
        NSDictionary *allData = [FileHelper readDataFileWithName:@"json_loaddata.txt"];
        self.chapterData = [allData objectForKey:KEY_chaptersFormat];
    }
    
    //section
    if (_chapterData && _chapterData.count > 0) {
        self.sectionData = [[_chapterData objectAtIndex:0] objectForKey:KEY_sectionList];
    }
    
    self.scoreData = [self getInitScoreData];
}

- (NSDictionary *)getInitScoreData
{
    //score
    NSDictionary *scoreCache = [FileHelper readScoreDataFromCache];
    NSDictionary *updateScoreCache = [FileHelper readScoreUpdateDataFromCache];
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

#pragma mark -
#pragma mark UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sectionData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    static NSString *CellIdentifier = @"MR_chapterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
    }
    
    NSDictionary *sectionDic = [_sectionData objectAtIndex:row];
    NSString *sectionName = [sectionDic objectForKey:KEY_sectionName];
    
    cell.textLabel.text = sectionName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    NSDictionary *sectionDic = [_sectionData objectAtIndex:row];
    NSArray *nodeData = [sectionDic objectForKey:KEY_clauseList];
    _clauseView.clauseData = [self getClauseFrom:_clauseData byNode:nodeData];
    [_clauseView setNeedsDisplay];
}

#pragma mark -
#pragma mark ChapterHeadDelegate

- (void)ChapterSelected:(NSNumber *)chapterIndex
{
    self.sectionData = [[_chapterData objectAtIndex:chapterIndex.integerValue] objectForKey:KEY_sectionList];
    [_chapterTable reloadData];
    
    //选取第一个
    [_chapterTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    NSDictionary *sectionDic = [_sectionData objectAtIndex:0];
    NSArray *nodeData = [sectionDic objectForKey:KEY_clauseList];
    _clauseView.clauseData = [self getClauseFrom:_clauseData byNode:nodeData];
    [_clauseView setNeedsDisplay];
}



@end
