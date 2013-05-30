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
    
    ScrollTableController *tableView = [[ScrollTableController alloc] initWithFrame:self.view.bounds];
    self.mTableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    [tableView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *data = [FileHelper readDataFileWithName:@"progress.txt"];
    self.tableHead = [data objectForKey:KEY_tableHead];
    self.tableData = [data objectForKey:KEY_tableData];
	
    _mTableView.drTableHead = _tableHead;
	_mTableView.drTableData = _tableData;
    //[_mTableView refreshView];
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
