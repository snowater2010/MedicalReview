//
//  MR_LoginCtro.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-24.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_LoginCtro.h"
#import "MR_User.h"
#import "MR_PathScoreCtro.h"
#import "MR_PathScoreCtro.h"

@interface MR_LoginCtro ()
{
    BOOL isRememberPw;  //is remember password
}
@property (retain, nonatomic) ASIHTTPRequest *request;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //init view
    isRememberPw = NO;
    [self showRememberPic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    //must do request release
    [_request doRelease];
    
    [super dealloc];
}

#pragma mark -
#pragma mark -- page actions

- (IBAction)clickRememberIv:(id)sender
{
    isRememberPw = !isRememberPw;
    [self showRememberPic];
}

- (IBAction)doLogin:(id)sender
{
    [self doRequest];
}

#pragma mark -
#pragma mark -- ASIHTTPRequest
//获取网络数据
-(void)doRequest
{
    _GET_APP_DELEGATE_(appDelegate);
    NSString *serverUrl = appDelegate.globalinfo.serverInfo.strWebServiceUrl;
    
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:serverUrl]];
    _request.persistentConnectionTimeoutSeconds = 5;
    _request.delegate = self;
    [_request startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    request.responseEncoding = NSUTF8StringEncoding;
    NSString *responseData = [request responseString];
    
    NSDictionary* retDic = [responseData objectFromJSONString];
    _LOG_(retDic)
    
    //init user info
    NSString *uId = [retDic objectForKey:@""];
    NSString *uName = [retDic objectForKey:@""];
    
    MR_User *user = [[MR_User alloc] initWithId:uId name:uName];
    [self initUserInfo:user];
    [user release];
    
    [self visitMainPage];
}

#pragma mark -
#pragma mark -- user method

- (void)showRememberPic
{
    if (isRememberPw) {
        _ibRemember.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"choose_pressed.png"]];
    }
    else {
        _ibRemember.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"choose_normal.png"]];
    }
}

- (void)initUserInfo:(MR_User *)user
{
    _GET_APP_DELEGATE_(appDelegate);
    appDelegate.globalinfo.userInfo.user = user;
}

- (void)visitMainPage
{
    MR_PathScoreCtro *score = [[MR_PathScoreCtro alloc] init];
    [self presentModalViewController:score animated:YES];
    [score release];
}

@end
