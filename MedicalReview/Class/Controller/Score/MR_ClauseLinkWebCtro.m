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
//    NSString *urlString = @"http://222.173.30.135:8088/ylpj/ylgl/indexPointFile/名词解释/对口支援.htm";
    self.urlString = [_urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url =[NSURL URLWithString:_urlString];
    
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

- (void)dealloc
{
    self.urlString = nil;
    self.webView = nil;
    [super dealloc];
}

- (IBAction)doClose:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
