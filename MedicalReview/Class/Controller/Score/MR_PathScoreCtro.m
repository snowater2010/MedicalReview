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

@interface MR_PathScoreCtro ()

@end

@implementation MR_PathScoreCtro

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
    
	// Do any additional setup after loading the view.
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
    [self.view addSubview:leftPageView];
    
    MR_PathNodeView *pathNodeView = [[MR_PathNodeView alloc] initWithFrame:leftPageView.bounds];
    [leftPageView addSubview:pathNodeView];
    
    //main
    CGRect mainFrame = CGRectMake(leftFrame.size.width, 0, rootFrame.size.width-leftFrame.size.width, rootFrame.size.height);
    MR_MainPageView *mainPageView = [[MR_MainPageView alloc] initWithFrame:mainFrame];
    [self.view addSubview:mainPageView];
}

@end
