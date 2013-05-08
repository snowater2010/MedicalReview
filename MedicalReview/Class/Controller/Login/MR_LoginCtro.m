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
#import "ASIFormDataRequest.h"

@interface MR_LoginCtro ()
{
    BOOL isRememberPw;  //is remember password
    float loginViewY;
}

@property(nonatomic, retain) MR_User *loginUser;

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
    //remove keyboard notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.loginUser = nil;
    
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
    NSString *name = self.ibName.text;
    NSString *password = self.ibPassWord.text;
    
    MR_User *user = [[MR_User alloc] init];
    user.uName = name;
    user.uPassWord = password;
    user.isRememberPw = isRememberPw;
    self.loginUser = user;
    [user release];
    
    if ([Common isEmptyString:name]) {
        _ALERT_SIMPLE_(_GET_LOCALIZED_STRING_(@"alert_login_name_empty"));
        return;
    }
    
    if ([Common isEmptyString:password]) {
        _ALERT_SIMPLE_(_GET_LOCALIZED_STRING_(@"alert_login_password_empty"));
        return;
    }
    
//    [self doRequestLogin];
    
    NSString *responseData = @"{\"errCode\":\"0\",\"expertName\":\"zjgxy\",\"expertNo\":\"201207000000355\",\"hospitalId\":\"1047000\",\"hospitalName\":\"山东医院\"}";
    NSDictionary *loginDic = [responseData objectFromJSONString];
    [self requestResult:loginDic tag:TAG_REQUEST_LOGIN];
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
//登陆请求
- (void)doRequestLogin
{
    _GET_APP_DELEGATE_(appDelegate);
    NSString *serverUrl = appDelegate.globalinfo.serverInfo.strWebServiceUrl;
    
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:serverUrl]];
    self.request.tag = TAG_REQUEST_LOGIN;
    
    [self.request setPostValue:@"login" forKey:@"module"];
    [self.request setPostValue:@"psgxy" forKey:@"uid"];         //loginUser.uName
    [self.request setPostValue:@"zjgxy_01" forKey:@"pwd"];      //loginUser.uPassWord
    
    self.request.delegate = self;
    [self.request startAsynchronous];
    
}

//上传本地数据，获得服务器最新数据
- (void)doRequestData
{
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
        [self initUserInfo:dataDic];
        
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
            if (!result)
                _ALERT_SIMPLE_(_GET_LOCALIZED_STRING_(@"alert_clause_cache_update_error"));
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

- (void)initUserInfo:(NSDictionary *)dataDic
{
    NSString *userId = [dataDic objectForKey:KEY_userId];
    _loginUser.uId = userId;
    
    //default info
    [self saveUserForName:_loginUser];
    [self saveUser:_loginUser forKey:USER_DEFAULT_KEY];
    
    //global info
    _GET_APP_DELEGATE_(appDelegate);
    appDelegate.globalinfo.userInfo.user = _loginUser;
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
