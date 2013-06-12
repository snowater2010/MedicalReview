//
//  MR_ClauseLinkWebCtro.h
//  MedicalReview
//
//  Created by lipeng11 on 13-6-11.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootController.h"

@interface MR_ClauseLinkWebCtro : MR_RootController

@property(nonatomic, retain) IBOutlet UIWebView *webView;

- (IBAction)doClose:(id)sender;

@end
