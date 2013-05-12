//
//  MR_RootController.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootController.h"

@interface MR_RootController ()
{
    BOOL customFrame;
}

@property(nonatomic, assign) CGRect initViewFrame;
//@property(nonatomic, retain) UIView *nowEditView;

@end

@implementation MR_RootController

- (id)init
{
    if (self = [super init]) {
        customFrame = NO;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super init]) {
        customFrame = YES;
        self.initViewFrame = frame;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadRootView
{
    if (customFrame) {
        UIView *selfView = [[UIView alloc] initWithFrame:_initViewFrame];
        self.view = selfView;
        [selfView release];
    }
    else {
        CGRect fullFrame = CGRectMake(0, 0, _DEVICE_HEIGHT, _DEVICE_WIDTH);
        UIView *fullView = [[UIView alloc] initWithFrame:fullFrame];
        self.view = fullView;
        [fullView release];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    //键盘监听
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//ios6 orientation默认是Portrait， 这个方法必须要设置，光靠plist里面的设置不足够
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)dealloc
{
    //must do request release
    if (_request) {
        [_request doRelease];
    }
    [super dealloc];
}

#pragma mark -
#pragma mark -- ASIHTTPRequestDelegate

-(void)requestFinished:(ASIHTTPRequest *)request
{
    request.responseEncoding = NSUTF8StringEncoding;
    NSString *responseData = [request responseString];
    
    //demo
//    responseData = @"{\"errCode\":\"0\",\"expertName\":\"zjgxy\",\"expertNo\":\"201207000000355\",\"hospitalId\":\"1047000\",\"hospitalName\":\"山东医院\"}";
//    responseData = @"{\"errCode\":\"2\",\"errMsg\":\"密码错误\"}";
    
    BOOL ok = YES;
    NSString *message = nil;
    NSDictionary* retDic = nil;
    
    if ([Common isEmptyString:responseData]) {
        ok = NO;
    }
    else {
        retDic = [responseData objectFromJSONString];
        if (retDic) {
            NSString *errCode = [retDic objectForKey:KEY_errCode];
            if (![errCode isEqualToString:@"0"]) {
                ok = NO;
                message = [retDic objectForKey:KEY_errMsg];
            }
        }
        else {
            ok = NO;
        }
    }
    
    if (ok) {
        [self requestResult:retDic tag:request.tag];
    }
    else {
        if (message) {
            _ALERT_SIMPLE_(message);
        }
        else {
            _ALERT_SIMPLE_(_GET_LOCALIZED_STRING_(@"request_data_error"));
        }
    }
}

- (void)requestResult:(NSDictionary *)dataDic tag:(int)tag
{
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    _LOG_(error);
    _ALERT_SIMPLE_(_GET_LOCALIZED_STRING_(@"request_error"));
}

////键盘事件
//- (void)keyboardWillShow:(NSNotification *)notification
//{
//    
//    NSDictionary* info = [notification userInfo];
//    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    
//    CGRect editFrame = [_nowEditView convertRect:_nowEditView.frame toView:self.view];
//    CGRect windowFrame = self.view.frame;
//    
//    //如果被键盘遮挡
//    float editOffset = (editFrame.origin.y + editFrame.size.height) - (windowFrame.size.width - kbSize.width);
//    if (editOffset > 0) {
//        windowFrame.origin.x = _DEVICE_STATEBAR_HEIGHT - editOffset;
//    }
//    
//    self.view.frame = windowFrame;
//}
//
//- (void)keyboardWillHide:(NSNotification *)notification
//{
//    CGRect windowFrame = self.view.frame;
//    windowFrame.origin.x = _DEVICE_STATEBAR_HEIGHT;
//    
//    self.view.frame = windowFrame;
//}
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    self.nowEditView = textField;
//}

- (NSArray *)getClauseFrom:(NSArray *)allClause byNode:(NSArray *)nodeData
{
    NSMutableArray *clauseArr = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    for (NSDictionary *nodeDic in nodeData) {
        NSString *nodeId = [nodeDic objectForKey:KEY_clauseId];
        for (NSDictionary *clauseDic in allClause) {
            NSString *clauseId = [clauseDic objectForKey:KEY_clauseId];
            if ([nodeId isEqualToString:clauseId]) {
                [clauseArr addObject:clauseDic];
            }
        }
    }
    return clauseArr;
}

@end
