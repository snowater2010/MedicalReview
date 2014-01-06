//
//  MR_ProgressCheckCtro.m
//  MedicalReview
//
//  Created by lipeng11 on 13-5-30.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ProgressCheckCtro.h"
#import "ScrollTableController.h"

@interface MR_ProgressCheckCtro ()

@property(nonatomic, retain) ScrollTableController *mTableView;

@property(nonatomic, retain) NSArray *tableHead;
@property(nonatomic, retain) NSArray *tableData;

@end

@implementation MR_ProgressCheckCtro

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
    
    _GET_APP_DELEGATE_(appDelegate);
    NSString *hospitalName = appDelegate.globalinfo.userInfo.user.hospitalName;
    
    CGRect frame = self.view.frame;
    
    //大标题
    float title_x = 0;
    float title_y = 0;
    float title_w = frame.size.width;
    float title_h = 30;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(title_x, title_y, title_w, title_h)];
    titleLabel.text = hospitalName;
    titleLabel.textAlignment = _ALIGN_CENTER;
    titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:titleLabel];
    
    float table_x = 0;
    float table_y = title_y + title_h;
    float table_w = frame.size.width;
    float table_h = frame.size.height - title_h;
    ScrollTableController *tableView = [[ScrollTableController alloc] initWithFrame:CGRectMake(table_x, table_y, table_w, table_h)];
    self.mTableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    [tableView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _GET_APP_DELEGATE_(appDelegate);
    MR_User *user = appDelegate.globalinfo.userInfo.user;
    if (user.userType == USER_TYPE_TEST) {
        //demo data
        NSDictionary *data2 = [FileHelper readDataFileWithName:@"progress.txt"];
        self.tableHead = [data2 objectForKey:KEY_tableHead];
        self.tableData = [data2 objectForKey:KEY_tableData];
        _mTableView.drTableHead = _tableHead;
        _mTableView.drTableData = _tableData;
        [_mTableView refreshView];
    }
    else if (user.userType == USER_TYPE_NORMAL) {
        [self.view showLoadingWithText:_GET_LOCALIZED_STRING_(@"request_msg_wait_login")];
        
        NSString *serverUrl = appDelegate.globalinfo.serverInfo.strWebServiceUrl;
        
        self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:serverUrl]];
        self.request.tag = TAG_REQUEST_LOGIN;
        
        [self.request setPostValue:@"loadProgress" forKey:@"module"];
        [self.request setDefaultPostValue];
        
        self.request.delegate = self;
        [self.request startAsynchronous];
    } 
}

- (void)responseSuccess:(NSDictionary *)data tag:(int)tag
{
    self.tableHead = [data objectForKey:KEY_tableHead];
    self.tableData = [data objectForKey:KEY_tableData];
    _mTableView.drTableHead = _tableHead;
	_mTableView.drTableData = _tableData;
    
    [_mTableView refreshView];
    [self.view hideLoading];
}

//处理失败请求的结果
- (void)responseFailed:(int)tag
{
    [self.view hideLoading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.mTableView = nil;
    self.tableHead = nil;
    self.tableData = nil;
    [super dealloc];
}

@end
