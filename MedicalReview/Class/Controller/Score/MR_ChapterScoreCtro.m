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
#import "MR_TableClauseView.h"
#import "CFinishChart.h"

@interface MR_ChapterScoreCtro ()
{
    int _totalCount;
    int _finishCount;
}

@property(nonatomic, retain) NSDictionary *clauseData;
@property(nonatomic, retain) NSArray *chapterData;
@property(nonatomic, retain) NSArray *sectionData;
@property(nonatomic, retain) NSDictionary *scoreData;

@property(nonatomic, retain) MR_TableClauseView *clauseView;
@property(nonatomic, retain) MR_ChapterHeadView *chapterHeadView;
@property(nonatomic, retain) UITableView *chapterTable;
@property(nonatomic, retain) UILabel *finishLabel;
@property(nonatomic, retain) CFinishChart *finishChart;

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
    
    //finish percent
    [self computeFinishPercent];
    
    NSString *finishStr = [NSString stringWithFormat:_GET_LOCALIZED_STRING_(@"page_score_percent"), _totalCount, _finishCount];
    
    _finishLabel.text = finishStr;
    
    _finishChart.strActualValue = _finishCount;
    _finishChart.strDesiredValue = _totalCount;
    [_finishChart setNeedsDisplay];
    
    _chapterHeadView.chapterData = _chapterData;
    [_chapterTable reloadData];
    
    //第一次取第一条数据
    NSDictionary *sectionDic = [_sectionData objectAtIndex:0];
    NSArray *nodeData = [sectionDic objectForKey:KEY_clauseList];
    _clauseView.nodeData = nodeData;
    _clauseView.clauseData = [self getClauseFrom:_clauseData byNode:nodeData];
    _clauseView.scoreData = _scoreData;
    
    //默认选中第一个节点
    if ([_sectionData count] > 0) {
        [_chapterTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewRowAnimationTop];
    }
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
    self.chapterHeadView = nil;
    self.finishLabel = nil;
    self.finishChart = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark -- init view

- (void)initView
{
    CGRect rootFrame = self.view.frame;
    
    //compute finish coiunt
    
    //percent
    float percent_x = 0;
    float percent_y = 0;
    float percent_w = rootFrame.size.width;
    float percent_h = 30;
    CGRect percentFrame = CGRectMake(percent_x, percent_y, percent_w, percent_h);
    UIView *percentView = [[UIView alloc] initWithFrame:percentFrame];
    [self.view addSubview:percentView];
    [percentView release];
    
    NSString *finishStr = _GET_LOCALIZED_STRING_(@"page_score_percent");
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize textSize = [finishStr sizeWithFont:font];
    
    UILabel *finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, textSize.width, percent_h)];
    finishLabel.backgroundColor = [UIColor clearColor];
    finishLabel.font = font;
    self.finishLabel = finishLabel;
    [percentView addSubview:finishLabel];
    [finishLabel release];
    
    CFinishChart *finishChart = [[CFinishChart alloc] initWithFrame:CGRectMake(10 + textSize.width, 5, 200, percent_h - 10)];
    finishChart.textColor = [UIColor blueColor];
    self.finishChart = finishChart;
    [percentView addSubview:finishChart];
    [finishChart release];
    
    //top chapter head
    float chapter_x = 0;
    float chapter_y = percent_y + percent_h;
    float chapter_w = rootFrame.size.width;
    float chapter_h = 30;
    CGRect chapterFrame = CGRectMake(chapter_x, chapter_y, chapter_w, chapter_h);
    MR_ChapterHeadView *chapterHeadView = [[MR_ChapterHeadView alloc] initWithFrame:chapterFrame];
    chapterHeadView.backgroundColor = [Common colorWithR:214 withG:230 withB:255];
    chapterHeadView.delegate = self;
    [self.view addSubview:chapterHeadView];
    self.chapterHeadView = chapterHeadView;
    [chapterHeadView release];
    
    //left
    float left_x = 0;
    float left_y = chapter_y + chapter_h;
    float left_w = rootFrame.size.width*0.15;
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
    self.chapterTable = chapterTable;
    [chapterTable release];
    
    //main
    float main_x = left_x + left_w;
    float main_y = chapter_y + chapter_h;
    float main_w = rootFrame.size.width - left_w;
    float main_h = rootFrame.size.height - main_y;
    CGRect mainFrame = CGRectMake(main_x, main_y, main_w, main_h);
    MR_MainPageView *mainPageView = [[MR_MainPageView alloc] initWithFrame:mainFrame];
    [self.view addSubview:mainPageView];
    
    //top
    float top_x = 0;
    float top_y = 0;
    float top_w = main_w;
    float top_h = main_h * 0.1;
    CGRect topFrame = CGRectMake(top_x, top_y, top_w, top_h);
    MR_ChapterSearchView *topView = [[MR_ChapterSearchView alloc] initWithFrame:topFrame];
    topView.delegate = self;
    topView.layer.borderWidth = 1;
    topView.layer.borderColor = [[Common colorWithR:153 withG:187 withB:232] CGColor];
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
    headView.jsonData = tableHead;
    [mainPageView addSubview:headView];
    [headView release];
    
    //clause
    float clause_x = 0;
    float clause_y = head_y + head_h;
    float clause_w = mainFrame.size.width;
    float clause_h = mainFrame.size.height - head_h - top_h;
    CGRect clauseFrame = CGRectMake(clause_x, clause_y, clause_w, clause_h);
    MR_TableClauseView *clauseView = [[MR_TableClauseView alloc] initWithFrame:clauseFrame];
    clauseView.readOnly = _readOnly;
    clauseView.scoredDelegate = self;
    self.clauseView = clauseView;
    [mainPageView addSubview:clauseView];
    [clauseView release];
    
    [mainPageView release];
}

#pragma mark -
#pragma mark -- Utilities

- (void)initData
{
    //clause
    if ([FileHelper ifHaveClauseCache])
        self.clauseData = [FileHelper readClauseDataFromCache];
//    else {
//        NSDictionary *allData = [FileHelper readDataFileWithName:@"json_loaddata.txt"];
//        self.clauseData = [allData objectForKey:KEY_allClause];
//    }
    
    //chapter
    if ([FileHelper ifHaveCacheFile:CACHE_CHAPTER])
        self.chapterData = [FileHelper readDataFromCache:CACHE_CHAPTER];
//    else {
//        NSDictionary *allData = [FileHelper readDataFileWithName:@"json_loaddata.txt"];
//        self.chapterData = [allData objectForKey:KEY_chaptersFormat];
//    }
    
    //section
    if (_chapterData && _chapterData.count > 0) {
        self.sectionData = [[_chapterData objectAtIndex:0] objectForKey:KEY_sectionList];
    }
    
    self.scoreData = [self getInitScoreData];
}

- (void)computeFinishPercent
{
    int totalCount = 0;
    int finishCount = 0;
    for (NSDictionary *chapterDic in _chapterData) {
        NSArray *sectionList = [chapterDic objectForKey:KEY_sectionList];
        for (NSDictionary *sectionDic in sectionList) {
            NSArray *clauseList = [sectionDic objectForKey:KEY_clauseList];
            for (NSDictionary *clauseDic in clauseList) {
                NSString *clauseId = [clauseDic objectForKey:KEY_clauseId];
                NSDictionary *scoreDic = [_scoreData objectForKey:clauseId];
                NSString *scoreValue = [scoreDic objectForKey:KEY_scoreValue];
                if ([Common isNotEmptyString:scoreValue])
                    finishCount++;
                totalCount++;
            }
        }
    }
    
    _totalCount = totalCount;
    _finishCount = finishCount;
}

//选择左边节点时，clauseviewtable初始化
- (void)selecteLeftNodeAtIndex:(int)index
{
    //重新读取数据（可以优化，不必每次以重新读取来更新数据）
    self.scoreData = [self getInitScoreData];
    
    NSDictionary *sectionDic = [_sectionData objectAtIndex:index];
    NSArray *nodeData = [sectionDic objectForKey:KEY_clauseList];
    _clauseView.nodeData = nodeData;
    _clauseView.clauseData = [self getClauseFrom:_clauseData byNode:nodeData];
    _clauseView.scoreData = [self getScoreFrom:_scoreData byNode:nodeData];
    [_clauseView reloadData];
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
        
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing2.jpg"]];
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        cell.textLabel.numberOfLines = 0;
    }
    
    NSDictionary *sectionDic = [_sectionData objectAtIndex:row];
    NSString *sectionName = [sectionDic objectForKey:KEY_sectionName];
    cell.textLabel.text = sectionName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selecteLeftNodeAtIndex:indexPath.row];
}

#pragma mark -
#pragma mark ChapterHeadDelegate

- (void)ChapterSelected:(NSNumber *)chapterIndex
{
    self.sectionData = [[_chapterData objectAtIndex:chapterIndex.integerValue] objectForKey:KEY_sectionList];
    [_chapterTable reloadData];
    
    //选取第一个
    [_chapterTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    //换章节的时候，初始化第一个节点
    [self selecteLeftNodeAtIndex:0];
}

#pragma mark -
#pragma mark ChapterSearchDelegate

- (void)doSearch:(NSDictionary *)searchDic
{
    //取消选取
    [_chapterTable selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    //重新读取数据（可以优化，不必每次以重新读取来更新数据）
    self.scoreData = [self getInitScoreData];
    
    //过滤数据
    NSString *name = [searchDic objectForKey:KEY_searchName];
    int scoredIndex = [[searchDic objectForKey:KEY_searchScored] intValue];
    BOOL isCore = [[searchDic objectForKey:KEY_searchCore] boolValue];
    BOOL isWait = [[searchDic objectForKey:KEY_searchWait] boolValue];
    
    NSMutableArray *nodeData = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *clauseData = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *sectionDic in _sectionData) {
        NSArray *nodeList = [sectionDic objectForKey:KEY_clauseList];
        for (NSDictionary *nodeDic in nodeList) {
            NSString *clauseId = [nodeDic objectForKey:KEY_clauseId];
            NSDictionary *clauseDic = [_clauseData objectForKey:clauseId];
            
            if ([Common isNotEmptyString:name]) {
                NSString *clauseName = [clauseDic objectForKey:KEY_clauseName];
                if (![clauseName isContainsString:name]) {
                    continue;
                }
            }
            
            if (scoredIndex != 0) {
                NSDictionary *scoreDic = [_scoreData objectForKey:clauseId];
                NSString *scoreValue = [scoreDic objectForKey:KEY_scoreValue];
                if (scoredIndex == 1) {
                    if ([Common isEmptyString:scoreValue]) {
                        continue;
                    }
                }
                else if (scoredIndex == 2) {
                    if ([Common isNotEmptyString:scoreValue]) {
                        continue;
                    }
                }
            }
            
            if (isCore) {
                NSString *formulaType = [clauseDic objectForKey:KEY_formulaType];
                if (formulaType.intValue != 2) {
                    continue;
                }
            }
            
            if (isWait) {
                NSDictionary *scoreDic = [_scoreData objectForKey:clauseId];
                NSString *completeFlag = [scoreDic objectForKey:KEY_completeFlag];
                if (completeFlag.intValue != 1) {
                    continue;
                }
            }
            
            [nodeData addObject:nodeDic];
            [clauseData addObject:clauseDic];
            
        }
    }
    
    _clauseView.nodeData = nodeData;
    _clauseView.clauseData = clauseData;
    _clauseView.scoreData = [self getScoreFrom:_scoreData byNode:nodeData];
    [_clauseView reloadData];
}

#pragma mark -
#pragma mark TableClauseViewDelegate
- (void)clauseScored:(NSDictionary *)scoredData
{
    if (scoredData && scoredData.count > 0){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:_scoreData];
        [dic addEntriesFromDictionary:scoredData];
        self.scoreData = dic;
        
        [self computeFinishPercent];
        NSString *finishStr = [NSString stringWithFormat:_GET_LOCALIZED_STRING_(@"page_score_percent"), _totalCount, _finishCount];
        _finishLabel.text = finishStr;
        _finishChart.strActualValue = _finishCount;
        _finishChart.strDesiredValue = _totalCount;
        [_finishChart setNeedsDisplay];
    }
}

@end
