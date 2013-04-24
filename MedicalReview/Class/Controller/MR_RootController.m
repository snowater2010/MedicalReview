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

#pragma mark -
#pragma mark -- ASIHTTPRequestDelegate

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    _LOG_(error);
    _ALERT_SIMPLE_(_GET_LOCALIZED_STRING_(@"request_error"));
}

@end
