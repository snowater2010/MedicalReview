//
//  MR_ExplainView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ExplainView.h"

@interface MR_ExplainView () <UIPopoverControllerDelegate>
{
    CGRect fastButtonFrame;
    CGSize explainPopSize;
    CGSize fastExplainPopSize;
}

@property(nonatomic, retain) NSString *tempExplainText;

@property(nonatomic, retain) UIPopoverController *viewPop;
@property(nonatomic, retain) MR_ExplainCtro *explainCtro;
@property(nonatomic, retain) MR_FastExplainCtro *fastExplainCtro;
@property(nonatomic, retain) UITextView *explainTextView;

@end

@implementation MR_ExplainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _readOnly = NO;
        _textSize = 17;
        
        explainPopSize = CGSizeMake(500, 500);
        fastExplainPopSize = CGSizeMake(300, 300);
        
        MR_ExplainCtro *explainCtro = [[MR_ExplainCtro alloc] initWithFrame:CGRectMake(0, 0, explainPopSize.width, explainPopSize.height)];
        self.explainCtro = explainCtro;
        [explainCtro release];
        
        MR_FastExplainCtro *fastExplainCtro = [[MR_FastExplainCtro alloc] initWithFrame:CGRectMake(0, 0, fastExplainPopSize.width, fastExplainPopSize.height)];
        self.fastExplainCtro = fastExplainCtro;
        [fastExplainCtro release];
        
        self.viewPop = [UIPopoverController alloc];
        _viewPop.delegate = self;
        
        //view
        CGRect rect = frame;
        CGRect textFrame = CGRectMake(0, 0, rect.size.width*0.75, rect.size.height);
        UITextView *explainView = [[UITextView alloc] initWithFrame:textFrame];
        explainView.font = [UIFont systemFontOfSize:_textSize];
        explainView.font = [UIFont systemFontOfSize:DEFAULT_TEXT_SIZE];
        explainView.editable = NO;
        self.explainTextView = explainView;
        [self addSubview:explainView];
        [explainView release];
        
        UIButton *textButon = [[UIButton alloc] initWithFrame:textFrame];
        [textButon addTarget:self action:@selector(doEditExplain:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:textButon];
        [textButon release];
        
        fastButtonFrame = CGRectMake(rect.size.width*0.75, 0, rect.size.width*0.25, rect.size.height);
        UIButton *button = [[UIButton alloc] initWithFrame:fastButtonFrame];
        [button addTarget:self action:@selector(doFastExplain:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:_GET_LOCALIZED_STRING_(@"button_shortcut") forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:BUTTON_TEXT_SIZE];
        button.enabled = !_readOnly;
        [self addSubview:button];
        [button release];
    }
    return self;
}

//- (void)drawRect:(CGRect)rect
//{
//    _explainTextView.text = _wordExplan;
//}

- (void)dealloc
{
    self.wordExplan = nil;
    self.viewPop = nil;
    self.explainCtro = nil;
    self.explainTextView = nil;
    self.fastExplainCtro = nil;
    self.tempExplainText = nil;
    [super dealloc];
}

#pragma mark-
#pragma Utilities

- (void)doEditExplain:(id)sender
{
    [_viewPop initWithContentViewController:_explainCtro];
    _viewPop.popoverContentSize = explainPopSize;
    
    self.tempExplainText = _explainTextView.text;
    [_explainCtro setExplain:_explainTextView.text];
    [_viewPop presentPopoverFromRect:_explainTextView.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (void)doFastExplain:(id)sender
{
    [_viewPop initWithContentViewController:_fastExplainCtro];
    _viewPop.popoverContentSize = fastExplainPopSize;
    
    [_viewPop presentPopoverFromRect:fastButtonFrame inView:self permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (NSString *)getExplain
{
    return _explainTextView.text;
}

- (void)setExplain:(NSString *)explain
{
    _explainTextView.text = explain;
}

#pragma mark-
#pragma UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSString *text = [_explainCtro getExplain];
    
    if (![_tempExplainText isEqualToString:text]) {
        _explainTextView.text = [_explainCtro getExplain];
        [Common callDelegate:_delegate method:@selector(explainChanged)];
    }
}

@end

//explain editor
@interface MR_ExplainCtro ()

@property(nonatomic, retain) UITextView *textView;

@end

@implementation MR_ExplainCtro

- (void)loadView
{
    [super loadRootView];
    
    CGRect frame = self.view.frame;
    
    float titleHeight = 50;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, titleHeight)];
    titleLabel.text = _GET_LOCALIZED_STRING_(@"title_explain_page");
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:titleLabel];
    [titleLabel release];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, titleHeight, frame.size.width, frame.size.height - titleHeight)];
    textView.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:textView];
    self.textView = textView;
    [textView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.textView = nil;
    [super dealloc];
}

- (NSString *)getExplain
{
    return _textView.text;
}

- (void)setExplain:(NSString *)explain
{
    _textView.text = explain;
}

@end

//fast explain
@interface MR_FastExplainCtro ()

@end

@implementation MR_FastExplainCtro

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
    
    self.view.backgroundColor = [UIColor purpleColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
}

- (NSString *)getExplain
{
    return @"";
}

@end