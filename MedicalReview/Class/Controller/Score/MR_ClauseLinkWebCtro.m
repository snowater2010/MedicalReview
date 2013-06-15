//
//  MR_ClauseLinkWebCtro.m
//  MedicalReview
//
//  Created by lipeng11 on 13-6-11.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ClauseLinkWebCtro.h"

@interface MR_ClauseLinkWebCtro ()

@end

@implementation MR_ClauseLinkWebCtro

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
    NSString *urlString = @"http://www.baidu.com/";
    NSURL *url =[NSURL URLWithString:urlString];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"webViewContent" ofType:@"html"];
//	NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
//    
//	NSString *htmlString = [[NSString alloc] initWithData:
//                            [readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
//	[_webView loadHTMLString:htmlString baseURL:nil];
//	[htmlString release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doClose:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
