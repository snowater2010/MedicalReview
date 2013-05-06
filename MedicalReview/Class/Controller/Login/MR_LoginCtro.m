//
//  MR_LoginCtro.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-24.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_LoginCtro.h"
#import "MR_User.h"
#import "MR_MainCtro.h"
#import "FileHelper.h"

@interface MR_LoginCtro ()
{
    BOOL isRememberPw;  //is remember password
    float loginViewY;
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
    
    _ibName.delegate = self;
    
    isRememberPw = NO;
    
    //取上次登陆者信息
    MR_User *defaultUser = [self loadUserByName:USER_DEFAULT_KEY];
    if (defaultUser) {
        self.ibName.text = defaultUser.uName;
        if (defaultUser.isRememberPw) {
            self.ibPassWord.text = defaultUser.uPassWord;
            isRememberPw = YES;
        }
    }
    
    //init view
    [self showRememberPic];
    
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
    
    //判断网络连接情况
    
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
    
    //remove keyboard notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
    NSString *uId = @"abc";
    NSString *name = self.ibName.text;
    NSString *password = self.ibPassWord.text;
    
    if ([Common isEmptyString:name]) {
        _ALERT_SIMPLE_(_GET_LOCALIZED_STRING_(@"alert_login_name_empty"));
        return;
    }
    
    if ([Common isEmptyString:password]) {
        _ALERT_SIMPLE_(_GET_LOCALIZED_STRING_(@"alert_login_password_empty"));
        return;
    }
    
    MR_User *user = [[MR_User alloc] init];
    user.uId = uId;
    user.uName = name;
    user.uPassWord = password;
    user.isRememberPw = isRememberPw;
    [self initUserInfo:user];
    [user release];
    
    [self visitMainPage];
    
//    [self doRequest];
}

- (void)nameChanged
{
    NSString *name = self.ibName.text;
    NSString *password = @"";
    isRememberPw = NO;
    
    MR_User *defaultUser = [self loadUserByName:name];
    if (defaultUser) {
        if (defaultUser.isRememberPw) {
            password = defaultUser.uPassWord;
            isRememberPw = YES;
        }
    }
    
    self.ibPassWord.text = password;
    [self showRememberPic];
}

#pragma mark -
#pragma mark -- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self nameChanged];
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
    MR_User *user = [[MR_User alloc] initWithData:retDic];
    user.isRememberPw = isRememberPw;
    [self initUserInfo:user];
    [user release];
    
    //clause cache，1 or 0
    BOOL updateClause = [[retDic objectForKey:@"updateClause"] boolValue];
    if (!updateClause) {
        //如果服务器没有更新，取本地缓存
        BOOL ifClauseCache = [FileHelper ifHaveClauseCache];
        if (!ifClauseCache) {
            //如果没有本地缓存，向服务器请求（同步请求，显示进度条）
            
        }
    }
    
    //取分数
    
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
    //default info
    [self saveUserForName:user];
    [self saveUser:user forKey:USER_DEFAULT_KEY];
    
    //global info
    _GET_APP_DELEGATE_(appDelegate);
    appDelegate.globalinfo.userInfo.user = user;
}

- (void)visitMainPage
{
    MR_MainCtro *score = [[MR_MainCtro alloc] init];
    [self presentModalViewController:score animated:YES];
    [score release];
}

#pragma mark -
#pragma mark -- UserDefaults

//移出用户信息
-(void)removeUserWithId:(NSString *)userName
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:userName];
}

//保存用户信息
-(void)saveUser:(MR_User *)user forKey:(NSString *)key
{
    if(user){
        NSDictionary *userDic = [user user2Data];
        if (userDic) {
            NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:userDic forKey:key];
        }
    }
}
//保存用户信息，名字作为key
-(void)saveUserForName:(MR_User *)user
{
    if(user){
        [self saveUser:user forKey:user.uName];
    }
}

//加载用户信息
-(MR_User *)loadUserByName:(NSString *)userName
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDefault dictionaryForKey:userName];
    
    if(userDic)
    {
        MR_User *user = [[[MR_User alloc] initWithData:userDic] autorelease];
        return user;
    }  
    else {
        return nil;
    }  
}

#pragma mark -
#pragma mark -- keyboard notifation

//键盘事件
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect loginFrame = _ibLoginView.frame;
    loginViewY = loginFrame.origin.y;
    
    _ANIMATIONS_INIT_BEGIN_(0.25f);
    
    loginFrame.origin.y = 100;
    _ibLoginView.frame = loginFrame;
    
    _ANIMATIONS_INIT_END_;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGRect loginFrame = _ibLoginView.frame;
    
    _ANIMATIONS_INIT_BEGIN_(0.25f);
    
    loginFrame.origin.y = loginViewY;
    _ibLoginView.frame = loginFrame;
    
    _ANIMATIONS_INIT_END_;
}

@end
