//
//  MR_MainCtro.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-24.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_MainCtro.h"
#import "MR_TopPageView.h"
#import "MR_PathScoreCtro.h"
#import "MR_ChapterScoreCtro.h"
#import "MR_ProgressCheckCtro.h"
#import "AHReach.h"

@interface MR_MainCtro ()
@end

@implementation MR_MainCtro

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
    
    [self loadShareData];
    
    //net reacher
    _GET_APP_DELEGATE_(appDelegate);
    NSString *serverUrl = appDelegate.globalinfo.serverInfo.strWebServiceUrl;
    AHReach *hostReach = [AHReach reachForHost:serverUrl];
	[hostReach startUpdatingWithBlock:^(AHReach *reach) {
		[self updateAvailabilityWithReach:reach];
	}];
    
    [self visitFunction:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.mainController = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark -- init view

- (void)loadShareData
{
    _GET_APP_DELEGATE_(appDelegate);
    appDelegate.globalinfo.shareData.statementData = [FileHelper readShareDataFromCacheFile:CACHE_STATEMENT];
}

- (void)initView
{
    CGRect rootFrame = self.view.frame;
    
    //top
    float top_x = 0;
    float top_y = 0;
    float top_w = rootFrame.size.width;
    float top_h = rootFrame.size.height*0.1;
    CGRect topFrame = CGRectMake(top_x, top_y, top_w, top_h);
    MR_TopPageView *topPageView = [[MR_TopPageView alloc] initWithFrame:topFrame];
    topPageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_bg.gif"]];
    [self.view addSubview:topPageView];
    [topPageView release];
    
    float buttonSize = MENU_BUTTON_SIZE;
    //退出
    float button1_h = buttonSize;
    float button1_w = buttonSize;
    float button1_x = top_w - buttonSize - MENU_BUTTON_MARGIN;
    float button1_y = top_h - buttonSize;
    CGRect button1Frame = CGRectMake(button1_x, button1_y, button1_w, button1_h);
    UIButton *button1 = [[UIButton alloc] initWithFrame:button1Frame];
    button1.tag = -1;
    [button1 setBackgroundImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topPageView addSubview:button1];
    [button1 release];
    
    //进度查看
    float button5_h = buttonSize;
    float button5_w = buttonSize;
    float button5_x = top_w - (buttonSize + MENU_BUTTON_MARGIN)*2;
    float button5_y = top_h - buttonSize;
    CGRect button5Frame = CGRectMake(button5_x, button5_y, button5_w, button5_h);
    UIButton *button5 = [[UIButton alloc] initWithFrame:button5Frame];
    button5.tag = 3;
    [button5 setBackgroundImage:[UIImage imageNamed:@"tiaokuanck_s.png"] forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topPageView addSubview:button5];
    [button5 release];
    
    //评审查看
    float button4_h = buttonSize;
    float button4_w = buttonSize;
    float button4_x = top_w - (buttonSize + MENU_BUTTON_MARGIN)*3;
    float button4_y = top_h - buttonSize;
    CGRect button4Frame = CGRectMake(button4_x, button4_y, button4_w, button4_h);
    UIButton *button4 = [[UIButton alloc] initWithFrame:button4Frame];
    button4.tag = 2;
    [button4 setBackgroundImage:[UIImage imageNamed:@"tiaokuanck_s.png"] forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topPageView addSubview:button4];
    [button4 release];
    
    //章节评审
    float button2_h = buttonSize;
    float button2_w = buttonSize;
    float button2_x = top_w - (buttonSize + MENU_BUTTON_MARGIN)*4;
    float button2_y = top_h - buttonSize;
    CGRect button2Frame = CGRectMake(button2_x, button2_y, button2_w, button2_h);
    UIButton *button2 = [[UIButton alloc] initWithFrame:button2Frame];
    button2.tag = 1;
    [button2 setBackgroundImage:[UIImage imageNamed:@"tiaokuanlr_s.png"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topPageView addSubview:button2];
    [button2 release];
    
    //路径评审
    float button3_h = buttonSize;
    float button3_w = buttonSize;
    float button3_x = top_w - (buttonSize + MENU_BUTTON_MARGIN)*5;
    float button3_y = top_h - buttonSize;
    CGRect button3Frame = CGRectMake(button3_x, button3_y, button3_w, button3_h);
    UIButton *button3 = [[UIButton alloc] initWithFrame:button3Frame];
    button3.tag = 0;
    [button3 setBackgroundImage:[UIImage imageNamed:@"lujing_s.png"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topPageView addSubview:button3];
    [button3 release];
    
    //main
    CGRect mainFrame = CGRectMake(0, topFrame.size.height, rootFrame.size.width, rootFrame.size.height-topFrame.size.height);
    UIView *mainPageView = [[UIView alloc] initWithFrame:mainFrame];
    mainPageView.tag = 100;
    mainPageView.backgroundColor = [UIColor whiteColor];
    mainPageView.clipsToBounds = YES;
    [self.view addSubview:mainPageView];
    [mainPageView release];
}

- (void)visitFunction:(int)index
{
    UIView *mainPageView = [self.view viewWithTag:100];
    CGRect mainFrame = mainPageView.bounds;
    
    switch (index) {
        case 0:
        {
            MR_PathScoreCtro *controller = [[MR_PathScoreCtro alloc] initWithFrame:mainFrame];
            self.mainController = controller;
            [controller release];
            break;
        }
        case 1:
        {
            MR_ChapterScoreCtro *controller = [[MR_ChapterScoreCtro alloc] initWithFrame:mainFrame];
            controller.readOnly = NO;
            self.mainController = controller;
            [controller release];
            break;
        }
        case 2:
        {
            MR_ChapterScoreCtro *controller = [[MR_ChapterScoreCtro alloc] initWithFrame:mainFrame];
            controller.readOnly = YES;
            self.mainController = controller;
            [controller release];
            break;
        }
        case 3:
        {
            MR_ProgressCheckCtro *controller = [[MR_ProgressCheckCtro alloc] initWithFrame:mainFrame];
            self.mainController = controller;
            [controller release];
            break;
        }
        case -1:
        {
            exit(0);
        }
        default:
            break;
    }
    
    //？？？
    for (UIView *subView in mainPageView.subviews) {
        [subView removeFromSuperview];
    }
    [mainPageView addSubview:_mainController.view];
}

- (void)menuButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self visitFunction:button.tag];
}

- (void)updateAvailabilityWithReach:(AHReach *)reach {
    BOOL isOnLine = NO;
    
	if([reach isReachableViaWiFi])
    {
        isOnLine = YES;
    }
	else if([reach isReachableViaWWAN])
    {
        isOnLine = YES;
    }
	else {
        isOnLine = NO;
    }
    
    BOOL isScoreUpdateCache = [FileHelper ifHaveScoreUpdateCache];
    if (isOnLine && isScoreUpdateCache) {
        [self doUploadLocalScoredData];
    }
}

//上传本地缓存打分数据
- (void)doUploadLocalScoredData
{    
    //异步请求服务器更新数据
    _GET_APP_DELEGATE_(appDelegate);
    NSString *serverUrl = appDelegate.globalinfo.serverInfo.strWebServiceUrl;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:serverUrl]];
    
    [request setPostValue:@"upLoadData" forKey:@"module"];
    [request setPostValue:@"upLoadData" forKey:@"module2"];
    [request setDefaultPostValue];
    
    NSDictionary *scoreUpdateCache = [FileHelper readScoreUpdateDataFromCache];
    NSString *strscoreUpdateCache = [scoreUpdateCache JSONString];
    if (strscoreUpdateCache)
        [request setPostValue:strscoreUpdateCache forKey:@"postData"];
    
    request.delegate = self;
    [request startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    request.responseEncoding = NSUTF8StringEncoding;
    NSString *responseData = [request responseString];
    
    BOOL ok = NO;
    NSString *message = nil;
    NSDictionary* retDic;
    if ([Common isNotEmptyString:responseData]) {
        retDic = [responseData objectFromJSONString];
        if (retDic) {
            NSString *errCode = [retDic objectForKey:KEY_errCode];
            if ([errCode isEqualToString:@"0"]) {
                ok = YES;
            } else {
                message = [retDic objectForKey:KEY_errMsg];
            }
        }
    }
    
    if (ok) {
        //将同步的缓存数据更新到score上
        NSDictionary *score = [FileHelper readScoreDataFromCache];
        NSDictionary *updateScore = [FileHelper readScoreUpdateDataFromCache];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:score];
        [dic addEntriesFromDictionary:updateScore];
        
        [FileHelper asyWriteScoreDataToCache:dic];
        
        //同步成功后，清除本地更新缓存
        [FileHelper removeScoreUpdateCacheFile];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
}

@end
