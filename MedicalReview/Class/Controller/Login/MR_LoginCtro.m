//
//  MR_LoginCtro.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-24.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_LoginCtro.h"
#import "MR_Doctor.h"
#import "MR_MainCtro.h"
<<<<<<< HEAD
#import "FileHelper.h"
#import "ASIFormDataRequest.h"

@interface MR_LoginCtro ()
{
    BOOL isRememberPw;  //is remember password
    float loginViewY;
}
=======
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface MR_LoginCtro ()
{
    float loginViewY;
}

@property(nonatomic, retain) NSString *loginName;
@property(nonatomic, retain) NSString *loginPassWord;
@property(nonatomic, assign) BOOL isRememberPw;
>>>>>>> branch

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
    
<<<<<<< HEAD
    _ibName.delegate = self;
    
    isRememberPw = NO;
    
    //取上次登陆者信息
    MR_User *defaultUser = [self loadUserByName:USER_DEFAULT_KEY];
    if (defaultUser) {
        self.ibName.text = defaultUser.uName;
        if (defaultUser.isRememberPw) {
            self.ibPassWord.text = defaultUser.uPassWord;
            isRememberPw = YES;
=======
    _ibLoginView.layer.cornerRadius = 15.0;
    _ibLoginView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.7];
    
    _ibName.delegate = self;
    
    _isRememberPw = NO;
    
    //取上次登陆者信息
    ///Users/lipeng11/Library/Application Support/iPhone Simulator/6.0/Applications/249297C9-8767-4474-ADFA-96AA5A5C3466/Documents
    MR_Doctor *defaultUser = [self loadUserByName:USER_DEFAULT_KEY];
    if (defaultUser) {
        self.ibName.text = defaultUser.loginName;
        if (defaultUser.loginIsRememberPw) {
            self.ibPassWord.text = defaultUser.loginPassWord;
            _isRememberPw = YES;
>>>>>>> branch
        }
    }
    
    //init view
    [self showRememberPic];
    
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
<<<<<<< HEAD
    
    //判断网络连接情况
    
=======
>>>>>>> branch
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    //remove keyboard notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.loginName = nil;
    self.loginPassWord = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark -- page actions

- (IBAction)clickRememberIv:(id)sender
{
    _isRememberPw = !_isRememberPw;
    [self showRememberPic];
}

- (IBAction)doLogin:(id)sender
{
<<<<<<< HEAD
    NSString *uId = @"abc";
    NSString *name = self.ibName.text;
    NSString *password = self.ibPassWord.text;
    
    if ([Common isEmptyString:name]) {
=======
    self.loginName = self.ibName.text;
    self.loginPassWord = self.ibPassWord.text;
    
    if ([Common isEmptyString:_loginName]) {
>>>>>>> branch
        _ALERT_SIMPLE_(_GET_LOCALIZED_STRING_(@"alert_login_name_empty"));
        return;
    }
    
<<<<<<< HEAD
    if ([Common isEmptyString:password]) {
=======
    if ([Common isEmptyString:_loginPassWord]) {
>>>>>>> branch
        _ALERT_SIMPLE_(_GET_LOCALIZED_STRING_(@"alert_login_password_empty"));
        return;
    }
    
<<<<<<< HEAD
    MR_User *user = [[MR_User alloc] init];
    user.uId = uId;
    user.uName = name;
    user.uPassWord = password;
    user.isRememberPw = isRememberPw;
    [self initUserInfo:user];
    [user release];
    
//    [self doRequestLogin];
    
    NSString *responseData = @"{\"errCode\":\"0\",\"expertName\":\"zjgxy\",\"expertNo\":\"201207000000355\",\"hospitalId\":\"1047000\",\"hospitalName\":\"山东医院\"}";
    NSDictionary *loginDic = [responseData objectFromJSONString];
    [self requestResult:loginDic tag:TAG_REQUEST_LOGIN];
=======
    //取消输入状态，隐藏键盘
    [_ibName resignFirstResponder];
    [_ibPassWord resignFirstResponder];
    
    if ([self.loginName isEqualToString:TEST_USER_NAME]) {
        [self visitMainPage];
    }
    else {
        [self doRequestLogin];
    }
>>>>>>> branch
}

- (void)nameChanged
{
    NSString *name = self.ibName.text;
    NSString *password = @"";
<<<<<<< HEAD
    isRememberPw = NO;
    
    MR_User *defaultUser = [self loadUserByName:name];
    if (defaultUser) {
        if (defaultUser.isRememberPw) {
            password = defaultUser.uPassWord;
            isRememberPw = YES;
=======
    _isRememberPw = NO;
    
    MR_Doctor *defaultUser = [self loadUserByName:name];
    if (defaultUser) {
        if (defaultUser.loginIsRememberPw) {
            password = defaultUser.loginPassWord;
            _isRememberPw = YES;
>>>>>>> branch
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
//登陆请求
- (void)doRequestLogin
{
    [self.view showLoadingWithText:_GET_LOCALIZED_STRING_(@"request_msg_wait_login")];
    
    _GET_APP_DELEGATE_(appDelegate);
    NSString *serverUrl = appDelegate.globalinfo.serverInfo.strWebServiceUrl;
    
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:serverUrl]];
    self.request.tag = TAG_REQUEST_LOGIN;
    
    [self.request setPostValue:@"login" forKey:@"module"];
<<<<<<< HEAD
    [self.request setPostValue:@"psgxy" forKey:@"uid"];
    [self.request setPostValue:@"zjgxy_01" forKey:@"pwd"];
=======
    [self.request setPostValue:@"login" forKey:@"module2"];
    [self.request setPostValue:_loginName forKey:@"uid"];
    [self.request setPostValue:_loginPassWord forKey:@"pwd"];
>>>>>>> branch
    
    self.request.delegate = self;
    [self.request startAsynchronous];
    
}

//上传本地数据，获得服务器最新数据
- (void)doRequestData
{
<<<<<<< HEAD
    _GET_APP_DELEGATE_(appDelegate);
    NSString *serverUrl = appDelegate.globalinfo.serverInfo.strWebServiceUrl;
    
    //是否有条款缓存
    BOOL isClauseCache = [FileHelper ifHaveClauseCache];
    BOOL isScoreUpdateCache = [FileHelper ifHaveScoreUpdateCache];
    
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:serverUrl]];
    self.request.tag = TAG_REQUEST_DATA;
    
    [self.request setPostValue:@"getData" forKey:@"module"];
    [self.request setPostValue:[NSNumber numberWithBool:isClauseCache] forKey:@"clauseCache"];
    [self.request setPostValue:[NSNumber numberWithBool:isScoreUpdateCache] forKey:@"scoreCache"];
    if (isScoreUpdateCache) {
        NSDictionary *scoreUpdateCache = [FileHelper readScoreUpdateDataFromCache];
        NSString *strscoreUpdateCache = [scoreUpdateCache JSONString];
        
        [self.request appendPostData:[strscoreUpdateCache dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
    }
    
    self.request.delegate = self;
    [self.request startAsynchronous];
    
}

//处理所有请求的结果
- (void)requestResult:(NSDictionary *)dataDic tag:(int)tag
{
    if (tag == TAG_REQUEST_LOGIN) {
        //登陆
        
        //init user info
        MR_User *user = [[MR_User alloc] initWithData:dataDic];
        user.isRememberPw = isRememberPw;
        [self initUserInfo:user];
        [user release];
        
//        [self doRequestData];
    }
    else if (tag == TAG_REQUEST_DATA) {
        //获取数据
        
        //clause cache，1 or 0
        BOOL updateClause = [[dataDic objectForKey:@"updateClause"] boolValue];
        if (updateClause) {
            //如果服务器有更新，覆盖本地缓存
            NSDictionary *clauseCache = [dataDic objectForKey:@"clauseData"];
            BOOL result = [FileHelper writeClauseDataToCache:clauseCache];
        }
        else {
            //如果服务器没有更新，取本地缓存
            NSDictionary *clauseCache = [FileHelper readClauseDataFromCache];
        }
    }
    
    //取分数
=======
    [self.view showLoadingWithText:_GET_LOCALIZED_STRING_(@"request_msg_wait_loaddata")];
    
    _GET_APP_DELEGATE_(appDelegate);
    NSString *serverUrl = appDelegate.globalinfo.serverInfo.strWebServiceUrl;
    
    //是否有条款缓存
    BOOL isClauseCache = [FileHelper ifHaveClauseCache];
    BOOL isScoreUpdateCache = [FileHelper ifHaveScoreUpdateCache];
    
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:serverUrl]];
    self.request.tag = TAG_REQUEST_DATA;
>>>>>>> branch
    
    [self.request setPostValue:@"loadData" forKey:@"module"];
    [self.request setDefaultPostValue];
    [self.request setPostValue:[NSNumber numberWithBool:isClauseCache] forKey:@"clauseCache"];
    [self.request setPostValue:[NSNumber numberWithBool:isScoreUpdateCache] forKey:@"scoreCache"];
    if (isScoreUpdateCache) {
        NSDictionary *scoreUpdateCache = [FileHelper readScoreUpdateDataFromCache];
        NSString *strscoreUpdateCache = [scoreUpdateCache JSONString];
        if (strscoreUpdateCache)
            [self.request setPostValue:strscoreUpdateCache forKey:@"postData"];
    }
    
    self.request.timeOutSeconds = 3000;
    self.request.delegate = self;
    [self.request startAsynchronous];
}

//处理所有请求的结果
- (void)responseSuccess:(NSDictionary *)dataDic tag:(int)tag
{
    if (tag == TAG_REQUEST_LOGIN) {
        //登陆
        
        //init user info
        [self initUserInfo:dataDic];
        
        //request data
        [self doRequestData];
//        [self visitMainPage];
    }
    else if (tag == TAG_REQUEST_DATA) {
        //获取数据
        if (dataDic) {
            //clause cache，1 or 0
            NSArray *allClause = [dataDic objectForKey:KEY_allClause];
            NSArray *pathFormat = [dataDic objectForKey:KEY_pathFormat];
            NSArray *chaptersFormat = [dataDic objectForKey:KEY_chaptersFormat];
            NSArray *clauseScore = [dataDic objectForKey:KEY_clauseScore];
            NSArray *statementData = [dataDic objectForKey:KEY_statementData];
            //条款
            if (allClause) {
                BOOL result = [FileHelper writeData:allClause toCacheFile:CACHE_CLAUSE];
//                BOOL result = [FileHelper writeClauseDataToCache:allClause];
                if (!result)
                    _ALERT_SIMPLE_(_GET_LOCALIZED_STRING_(@"alert_clause_cache_update_error"));
            }
            //快捷评论
            if (statementData) {
                BOOL result = [FileHelper writeShareData:statementData toCacheFile:CACHE_STATEMENT];
                if (!result)
                    _ALERT_SIMPLE_(_GET_LOCALIZED_STRING_(@"alert_statement_cache_update_error"));
            }
            //路径
            if (pathFormat) {
                BOOL result = [FileHelper writeData:pathFormat toCacheFile:CACHE_PATH];
                if (!result)
                    _ALERT_SIMPLE_(_GET_LOCALIZED_STRING_(@"alert_path_cache_update_error"));
            }
            //章节
            if (chaptersFormat) {
                BOOL result = [FileHelper writeData:chaptersFormat toCacheFile:CACHE_CHAPTER];
                if (!result)
                    _ALERT_SIMPLE_(_GET_LOCALIZED_STRING_(@"alert_chapter_cache_update_error"));
            }
            //打分
            if (clauseScore) {
                BOOL result = [FileHelper writeData:clauseScore toCacheFile:CACHE_SCORE];
                if (!result)
                    _ALERT_SIMPLE_(_GET_LOCALIZED_STRING_(@"alert_score_cache_update_error"));
            }
        }
        
        //同步成功后，清除本地更新缓存
        [FileHelper removeScoreUpdateCacheFile];
        
        [self.view hideLoading];
        
        //进入主页
        [self visitMainPage];
    }
}
//处理失败请求的结果
- (void)responseFailed:(int)tag
{
    [self.view hideLoading];
}

#pragma mark -
#pragma mark -- Utilities

- (void)showRememberPic
{
    if (_isRememberPw) {
        _ibRemember.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"choose_pressed.png"]];
    }
    else {
        _ibRemember.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"choose_normal.png"]];
    }
}

- (void)initUserInfo:(NSDictionary *)dataDic
{
<<<<<<< HEAD
    //default info
    [self saveUserForName:user];
    [self saveUser:user forKey:USER_DEFAULT_KEY];
=======
    MR_Doctor *doctor = [[MR_Doctor alloc] initWithData:dataDic];
    [doctor setLoginName:_loginName passWord:_loginPassWord isRememberPw:_isRememberPw];
    
    //default info
    [self saveUserForName:doctor];
    [self saveUser:doctor forKey:USER_DEFAULT_KEY];
>>>>>>> branch
    
    //global info
    _GET_APP_DELEGATE_(appDelegate);
    appDelegate.globalinfo.userInfo.user = doctor;
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
<<<<<<< HEAD
-(void)saveUser:(MR_User *)user forKey:(NSString *)key
=======
-(void)saveUser:(MR_Doctor *)user forKey:(NSString *)key
>>>>>>> branch
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
<<<<<<< HEAD
-(void)saveUserForName:(MR_User *)user
{
    if(user){
        [self saveUser:user forKey:user.uName];
=======
-(void)saveUserForName:(MR_Doctor *)user
{
    if(user){
        [self saveUser:user forKey:user.loginName];
>>>>>>> branch
    }
}

//加载用户信息
<<<<<<< HEAD
-(MR_User *)loadUserByName:(NSString *)userName
=======
-(MR_Doctor *)loadUserByName:(NSString *)userName
>>>>>>> branch
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDefault dictionaryForKey:userName];
    
    if(userDic)
    {
<<<<<<< HEAD
        MR_User *user = [[[MR_User alloc] initWithData:userDic] autorelease];
=======
        MR_Doctor *user = [[[MR_Doctor alloc] initWithData:userDic] autorelease];
>>>>>>> branch
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
