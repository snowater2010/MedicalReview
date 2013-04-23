//
//  MR_LoginCtro.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_LoginCtro.h"
#import "MR_LeftPageView.h"
#import "MR_TopPageView.h"
#import "MR_MainPageView.h"

@interface MR_LoginCtro ()

- (void)initView;

@end

@implementation MR_LoginCtro

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    _LOAD_ROOT_VIEW;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
	
    //self.view.backgroundColor = [UIColor lightGrayColor];
    
    //init global info data
    _GET_APP_DELEGATE_(appDelegate);
    GlobalInfo *globoinfo = [[GlobalInfo alloc] init];
    //init
    appDelegate.globalinfo = globoinfo;
    [globoinfo release];
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
    
    //top
    CGRect topFrame = CGRectMake(0, 0, rootFrame.size.width, rootFrame.size.height*0.2);
    MR_TopPageView *topPageView = [[MR_TopPageView alloc] initWithFrame:topFrame];
    topPageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:topPageView];
    
    //left
    CGRect leftFrame = CGRectMake(0, topFrame.size.height, rootFrame.size.width*0.2, rootFrame.size.height-topFrame.size.height);
    MR_LeftPageView *leftPageView = [[MR_LeftPageView alloc] initWithFrame:leftFrame];
    leftPageView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:leftPageView];
    
    //main
    CGRect mainFrame = CGRectMake(leftFrame.size.width, topFrame.size.height, rootFrame.size.width-leftFrame.size.width, rootFrame.size.height-topFrame.size.height);
    MR_MainPageView *mainPageView = [[MR_MainPageView alloc] initWithFrame:mainFrame];
    mainPageView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:mainPageView];
}

@end
