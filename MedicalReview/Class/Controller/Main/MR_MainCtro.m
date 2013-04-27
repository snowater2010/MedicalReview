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
    
//    NSString *fileName = @"json_clause.txt";
//    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
//    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
//    NSDictionary *jsonDic = [jsonData objectFromJSONData];
//    NSString *pathName = [jsonDic objectForKey:KEY_pathName];
    
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

- (void)initView
{
    CGRect rootFrame = self.view.frame;
    
    //top
    CGRect topFrame = CGRectMake(0, 0, rootFrame.size.width, rootFrame.size.height*0.1);
    MR_TopPageView *topPageView = [[MR_TopPageView alloc] initWithFrame:topFrame];
    [self.view addSubview:topPageView];
    
    //main
    CGRect mainFrame = CGRectMake(0, topFrame.size.height, rootFrame.size.width, rootFrame.size.height-topFrame.size.height);
    UIView *mainPageView = [[UIView alloc] initWithFrame:mainFrame];
    mainPageView.tag = 100;
    mainPageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainPageView];
}

- (void)visitFunction:(int)index
{
    UIView *mainPageView = [self.view viewWithTag:100];
    CGRect mainFrame = mainPageView.bounds;
    
    switch (index) {
        case 0:
        {
            UIViewController *controller = [[MR_PathScoreCtro alloc] initWithFrame:mainFrame];
            self.mainController = controller;
            [controller release];
            break;
        } 
        default:
            break;
    }
    
    [mainPageView addSubview:_mainController.view];
}

@end
