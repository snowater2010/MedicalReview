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
#import "FileHelper.h"
#import "ASIFormDataRequest.h"

@interface MR_LoginCtro ()
{
    float loginViewY;
}

@property(nonatomic, retain) NSString *loginName;
@property(nonatomic, retain) NSString *loginPassWord;
@property(nonatomic, assign) BOOL isRememberPw;

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
        }
    }
    
    //init view
    [self showRememberPic];
    
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil]; 
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
    self.loginName = self.ibName.text;
    self.loginPassWord = self.ibPassWord.text;
    
    if ([Common isEmptyString:_loginName]) {
        _ALERT_SIMPLE_(_GET_LOCALIZED_STRING_(@"alert_login_name_empty"));
        return;
    }
    
    if ([Common isEmptyString:_loginPassWord]) {
        _ALERT_SIMPLE_(_GET_LOCALIZED_STRING_(@"alert_login_password_empty"));
        return;
    }
    
    [self doRequestLogin];
    
//    NSString *responseData = @"{\"errCode\":\"0\",\"expertName\":\"zjgxy\",\"expertNo\":\"201207000000355\",\"hospitalId\":\"1047000\",\"hospitalName\":\"山东医院\"}";
//    NSDictionary *loginDic = [responseData objectFromJSONString];
//    [self requestResult:loginDic tag:TAG_REQUEST_LOGIN];
}

- (void)nameChanged
{
    NSString *name = self.ibName.text;
    NSString *password = @"";
    _isRememberPw = NO;
    
    MR_Doctor *defaultUser = [self loadUserByName:name];
    if (defaultUser) {
        if (defaultUser.loginIsRememberPw) {
            password = defaultUser.loginPassWord;
            _isRememberPw = YES;
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
    [self.request setPostValue:_loginName forKey:@"uid"];
    [self.request setPostValue:_loginPassWord forKey:@"pwd"];
    
    self.request.delegate = self;
    [self.request startAsynchronous];
    
}

//上传本地数据，获得服务器最新数据
- (void)doRequestData
{
    //ylpj/webif?module=loadData&uid=zj0311&reviewId=2012000000000000819&expertNo=201207000000328&groupId=1
    
    _GET_APP_DELEGATE_(appDelegate);
    NSString *serverUrl = appDelegate.globalinfo.serverInfo.strWebServiceUrl;
    
    //是否有条款缓存
    BOOL isClauseCache = [FileHelper ifHaveClauseCache];
    BOOL isScoreUpdateCache = [FileHelper ifHaveScoreUpdateCache];
    
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:serverUrl]];
    self.request.tag = TAG_REQUEST_DATA;
    
    [self.request setPostValue:@"loadData" forKey:@"module"];
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
        
        //request data
        [self doRequestData];
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
    MR_Doctor *doctor = [[MR_Doctor alloc] initWithData:dataDic];
    [doctor setLoginName:_loginName passWord:_loginPassWord isRememberPw:_isRememberPw];
    
    //default info
    [self saveUserForName:doctor];
    [self saveUser:doctor forKey:USER_DEFAULT_KEY];
    
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
-(void)saveUser:(MR_Doctor *)user forKey:(NSString *)key
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
-(void)saveUserForName:(MR_Doctor *)user
{
    if(user){
        [self saveUser:user forKey:user.loginName];
    }
}

//加载用户信息
-(MR_Doctor *)loadUserByName:(NSString *)userName
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDefault dictionaryForKey:userName];
    
    if(userDic)
    {
        MR_Doctor *user = [[[MR_Doctor alloc] initWithData:userDic] autorelease];
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
