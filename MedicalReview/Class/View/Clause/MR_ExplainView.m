//
//  MR_ExplainView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-27.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ExplainView.h"

@interface MR_ExplainView () <UIPopoverControllerDelegate, FastExplainDelegate, EditExplainDelegate>
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
        fastExplainPopSize = CGSizeMake(200, 500);
        
        MR_ExplainCtro *explainCtro = [[MR_ExplainCtro alloc] initWithFrame:CGRectMake(0, 0, explainPopSize.width, explainPopSize.height)];
        explainCtro.delegate = self;
        self.explainCtro = explainCtro;
        [explainCtro release];
        
        MR_FastExplainCtro *fastExplainCtro = [[MR_FastExplainCtro alloc] initWithFrame:CGRectMake(0, 0, fastExplainPopSize.width, fastExplainPopSize.height)];
        fastExplainCtro.delegate = self;
        self.fastExplainCtro = fastExplainCtro;
        [fastExplainCtro release];
        
        self.viewPop = [UIPopoverController alloc];
        _viewPop.delegate = self;
        
        //view
        CGRect rect = frame;
        CGRect textFrame = CGRectMake(0, 0, rect.size.width*0.75, rect.size.height);
        UITextView *explainView = [[UITextView alloc] initWithFrame:textFrame];
        explainView.backgroundColor = [UIColor clearColor];
        explainView.font = [UIFont systemFontOfSize:_textSize];
        explainView.font = [UIFont systemFontOfSize:DEFAULT_TEXT_SIZE];
        explainView.editable = NO;
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doEditExplain:)];//添加点击事件
        [explainView addGestureRecognizer:tapGesture];
        [tapGesture release];
        self.explainTextView = explainView;
        [self addSubview:explainView];
        [explainView release];
        
        fastButtonFrame = CGRectMake(rect.size.width*0.75, 5, rect.size.width*0.25 - 5, rect.size.height - 10);
        UIButton *button = [[UIButton alloc] initWithFrame:fastButtonFrame];
        [button addTarget:self action:@selector(doFastExplain:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:_GET_LOCALIZED_STRING_(@"button_shortcut") forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:BUTTON_TEXT_SIZE];
        button.enabled = !_readOnly;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_img.png"] forState:UIControlStateNormal];
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
#pragma mark Utilities

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
    
    self.tempExplainText = _explainTextView.text;
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
#pragma mark UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    //do nothing
//    NSString *text = [_explainCtro getExplain];
//    if (![_tempExplainText isEqualToString:text]) {
//        _explainTextView.text = text;
//        [Common callDelegate:_delegate method:@selector(explainChanged)];
//    }
}

#pragma mark-
#pragma mark FastExplainDelegate EditExplainDelegate

- (void)getFastExplain:(NSString *)explain
{
    [_viewPop dismissPopoverAnimated:YES];
    
    if (![_tempExplainText isEqualToString:explain]) {
        _explainTextView.text = explain;
        [Common callDelegate:_delegate method:@selector(explainChanged)];
    }
}

- (void)getEditExplain:(NSString *)explain
{
    [_viewPop dismissPopoverAnimated:YES];
    
    if (![_tempExplainText isEqualToString:explain]) {
        _explainTextView.text = explain;
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
    
    float titleHeight = 60;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, titleHeight)];
    titleLabel.text = _GET_LOCALIZED_STRING_(@"title_explain_page");
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [Common colorWithR:214 withG:230 withB:255];
    [self.view addSubview:titleLabel];
    [titleLabel release];
    
    float buttonWidth = 60;
    float buttonHeight = 40;
    UIButton *closeBt = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - buttonWidth - 10, (titleHeight-buttonHeight)/2, buttonWidth, buttonHeight)];
    [closeBt setBackgroundImage:[UIImage imageNamed:@"btn_img.png"] forState:UIControlStateNormal];
    [closeBt setTitle:@"确定" forState:UIControlStateNormal];
    [closeBt setTitleColor:[UIColor blackColor] forState:UIScrollViewDecelerationRateNormal];
    [closeBt addTarget:self action:@selector(doEditExplain:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBt];
    
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

- (void)doEditExplain:(id)sender
{
    [Common callDelegate:_delegate method:@selector(getEditExplain:) withObject:_textView.text];
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
@interface MR_FastExplainCtro () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain) NSArray *statementData;
@property(nonatomic, retain) UITableView *fastExplain;

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
    
    UITableView *fastExplain = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    fastExplain.dataSource = self;
    fastExplain.delegate = self;
    self.fastExplain = fastExplain;
    [self.view addSubview:fastExplain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _GET_APP_DELEGATE_(appDelegate);
	self.statementData = appDelegate.globalinfo.shareData.statementData;
    [_fastExplain reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.statementData = nil;
    self.fastExplain = nil;
    [super dealloc];
}

#pragma mark
#pragma tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _statementData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *FastExplainCellWithIdentifier = @"FastExplainCellWithIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FastExplainCellWithIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FastExplainCellWithIdentifier];
    }
    
    NSString *fastExplain = [_statementData objectAtIndex:indexPath.row];
    cell.textLabel.text = fastExplain;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fastExplain = [_statementData objectAtIndex:indexPath.row];
    [Common callDelegate:_delegate method:@selector(getFastExplain:) withObject:fastExplain];
}

@end