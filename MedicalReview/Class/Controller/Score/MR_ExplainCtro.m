//
//  MR_ExplainCtro.m
//  MedicalReview
//
//  Created by lipeng11 on 13-5-19.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ExplainCtro.h"

@interface MR_ExplainCtro ()

@end

@implementation MR_ExplainCtro

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
    
    CGRect frame = self.view.frame;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
