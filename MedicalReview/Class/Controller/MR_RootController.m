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
        [self responseSuccess:retDic tag:request.tag];
    }
    else {
        [self responseFailed:request.tag];
        if (message) {
            _ALERT_SIMPLE_(message);
        }
        else {
            _ALERT_SIMPLE_(_GET_LOCALIZED_STRING_(@"request_data_error"));
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
//    NSError *error = [request error];
    [self responseFailed:request.tag];
    _ALERT_SIMPLE_(_GET_LOCALIZED_STRING_(@"request_error"));
}

- (void)responseSuccess:(NSDictionary *)dataDic tag:(int)tag
{
}

- (void)responseFailed:(int)tag
{
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

- (NSArray *)getClauseFrom:(NSDictionary *)allClause byNode:(NSArray *)nodeData
{
    if (!allClause)
        return nil;
    
    NSArray *keyArr = [allClause allKeys];
    NSMutableArray *clauseArr = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    for (NSDictionary *nodeDic in nodeData) {
        NSString *nodeId = [nodeDic objectForKey:KEY_clauseId];
        if ([keyArr containsObject:nodeId]) {
            NSDictionary *clauseDic = [allClause objectForKey:nodeId];
            if (clauseDic)
                [clauseArr addObject:clauseDic];
        }
    }
    return clauseArr;
}

- (NSDictionary *)getScoreFrom:(NSDictionary *)allScore byNode:(NSArray *)nodeData
{
    if (!allScore)
        return nil;
    
    //score
    NSArray *scoreKeys = [allScore allKeys];
    NSMutableDictionary *scoreNodeDic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    
    for (NSDictionary *nodeDic in nodeData)
    {
        NSString *nodeId = [nodeDic objectForKey:KEY_clauseId];
        
        if ([scoreKeys containsObject:nodeId])
        {
            NSDictionary *scoreDic = [allScore objectForKey:nodeId];
            if (scoreDic)
                [scoreNodeDic setValue:scoreDic forKey:nodeId];
        }
    }
    return scoreNodeDic;
}

- (NSDictionary *)getInitScoreData
{
    //score
    NSDictionary *scoreCache = [FileHelper readScoreDataFromCache];
    NSDictionary *updateScoreCache = [FileHelper readScoreUpdateDataFromCache];
    if (scoreCache || updateScoreCache) {
        NSMutableDictionary *allScore = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
        if (scoreCache)
            [allScore addEntriesFromDictionary:scoreCache];
        if (updateScoreCache)
            [allScore addEntriesFromDictionary:updateScoreCache];
        
        return allScore;
    }
    else {
        return nil;
    }
}

@end
