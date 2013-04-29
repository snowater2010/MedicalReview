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

@interface MR_PathScoreCtro ()

@end

@implementation MR_PathScoreCtro
    @synthesize realData=_realData;
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
    [self parseJson];
    CGRect tableViewFrame = CGRectMake(0,80, leftFrame.size.width, leftFrame.size.height-80);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [leftPageView addSubview:tableView];
    
    //MR_PathNodeView *pathNodeView = [[MR_PathNodeView alloc] initWithFrame:leftPageView.bounds];
    //[leftPageView addSubview:pathNodeView];
    [leftPageView addSubview:tableView];
    
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

#pragma mark -------------------
#pragma mark UITableViewDataSource
//委托里 @required 的必须实现

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return [self.realData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     static NSString *CellIdentifier = @"MR_PathCell";
     MR_PathCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
          cell = [[MR_PathCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
         }
     //config the cell
     //cell.textLabel.text = [[self.realData objectAtIndex:indexPath.row] objectForKey:@"nodeName"];
     //cell.model = [[self.realData objectAtIndex:indexPath.row] objectForKey:@"nodeName"];
     cell.cellModel = [self.realData objectAtIndex:indexPath.row];
     UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
     cell.selectedBackgroundView = backView;
     cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
     //取消边框线
    
     [cell setBackgroundView:[[UIView alloc] init]];    //取消边框线
     cell.backgroundColor = [UIColor clearColor];
     return cell;
}


#pragma mark -------------------
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return [MR_PathCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     NSLog(@"%@", [[self.realData objectAtIndex:indexPath.row] objectForKey:@"nodeName"]);
}





- (void)parseJson{
     NSString *dataJsonPath = [[NSBundle mainBundle] pathForResource:@"json_clause" ofType:@"txt"];
     NSLog(@"dataxml file url:%@",dataJsonPath);
     NSData *jsonData = [NSData dataWithContentsOfFile:dataJsonPath];
     /*
         * json格式解码
         */
     JSONDecoder *jd=[[JSONDecoder alloc] init];
    
     //针对NSData数据
    
     NSDictionary *ret = [jd objectWithData: jsonData];
     NSMutableArray *nodeList =[ret objectForKey:@"nodeList"];
     /*for (int i=0; i<nodeList.count; i++) {
         NSDictionary *item = [nodeList objectAtIndex:i];
         NSLog(@"name: %@",[item objectForKey:@"nodeName"]);
         }*/
     
     self.realData = nodeList;
     //NSLog(@"res= %@", [ret objectForKey:@"nodeList"]);
}


@end
