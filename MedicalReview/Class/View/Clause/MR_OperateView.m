//
//  MR_OperateView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-30.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_OperateView.h"
<<<<<<< HEAD
=======
#import "MR_ClauseDetailCtro.h"

@interface MR_OperateView () <UIPopoverControllerDelegate>

@property(nonatomic, retain) UIPopoverController *viewPop;
@property(nonatomic, retain) MR_ClauseDetailCtro *detailCtro;
@property(nonatomic, retain) UIButton *linkBt;

@end
>>>>>>> branch

@implementation MR_OperateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
<<<<<<< HEAD
        self.isHasLink = NO;
=======
        self.backgroundColor = [UIColor clearColor];
        
        UIPopoverController *viewPop = [UIPopoverController alloc];
        MR_ClauseDetailCtro *detailCtro = [[MR_ClauseDetailCtro alloc] initWithNibName:@"MR_ClauseDetailCtro" bundle:nil];
        self.viewPop = viewPop;
        self.detailCtro = detailCtro;
        [_viewPop initWithContentViewController:detailCtro];
        _viewPop.popoverContentSize = CGSizeMake(800, 560);
        [detailCtro release];
        [viewPop release];
>>>>>>> branch
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
<<<<<<< HEAD
    float delete_x = 0.0f;
    float delete_y = 0.0f;
    float delete_w = _isHasLink ? rect.size.width * 0.4 : rect.size.width;
=======
    [self refreshPage];
}

- (void)refreshPage
{
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [obj removeFromSuperview];
    }];
    
    CGRect rect = self.bounds;
    
    UIFont *font = [UIFont systemFontOfSize:OPERATE_TEXT_SIZE];
    NSString *delTitle = _GET_LOCALIZED_STRING_(@"button_delete");
    
    float delWidth = [delTitle sizeWithFont:font].width;
    
    float padding = _isHasLink || _isHasWait ? (rect.size.width-delWidth*3)*0.33 : (rect.size.width-delWidth)*0.5;
    float delete_x = padding;
    float delete_y = 0;
    float delete_w = delWidth;
>>>>>>> branch
    float delete_h = rect.size.height;
    CGRect deleteRect = CGRectMake(delete_x, delete_y, delete_w, delete_h);
    UIButton *deleteBt = [[UIButton alloc] initWithFrame:deleteRect];
    [deleteBt setTitle:_GET_LOCALIZED_STRING_(@"button_delete") forState:UIControlStateNormal];
<<<<<<< HEAD
    deleteBt.titleLabel.font = [UIFont systemFontOfSize:OPERATE_TEXT_SIZE];
    deleteBt.backgroundColor = [UIColor orangeColor];
    [deleteBt addTarget:_delegate action:@selector(doDelete) forControlEvents:UIControlEventTouchUpInside];
=======
    deleteBt.titleLabel.font = font;
    [deleteBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [deleteBt setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [deleteBt addTarget:self action:@selector(doDelete) forControlEvents:UIControlEventTouchUpInside];
>>>>>>> branch
    [self addSubview:deleteBt];
    [deleteBt release];
    
    if (_isHasLink) {
<<<<<<< HEAD
        float link_x = delete_x + delete_w;
        float link_y = 0.0f;
        float link_w = rect.size.width * 0.6;
=======
        float link_x = CGRectGetMaxX(deleteRect) + padding;
        float link_y = 0;
        float link_w = delWidth*2;
>>>>>>> branch
        float link_h = rect.size.height;
        CGRect linkRect = CGRectMake(link_x, link_y, link_w, link_h);
        UIButton *linkBt = [[UIButton alloc] initWithFrame:linkRect];
        [linkBt setTitle:_GET_LOCALIZED_STRING_(@"button_link") forState:UIControlStateNormal];
<<<<<<< HEAD
        linkBt.titleLabel.font = [UIFont systemFontOfSize:OPERATE_TEXT_SIZE];
        linkBt.backgroundColor = [UIColor purpleColor];
        [linkBt addTarget:_delegate action:@selector(doLink) forControlEvents:UIControlEventTouchUpInside];
=======
        linkBt.titleLabel.font = font;
        [linkBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [linkBt setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [linkBt addTarget:self action:@selector(doLink:) forControlEvents:UIControlEventTouchUpInside];
>>>>>>> branch
        [self addSubview:linkBt];
        [linkBt release];
    }
    
<<<<<<< HEAD
=======
    if (_isHasWait) {
        float link_x = CGRectGetMaxX(deleteRect) + padding;
        float link_y = 0;
        float link_w = delWidth*2;
        float link_h = rect.size.height;
        CGRect linkRect = CGRectMake(link_x, link_y, link_w, link_h);
        UIButton *linkBt = [[UIButton alloc] initWithFrame:linkRect];
        linkBt.titleLabel.font = font;
        [linkBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [linkBt setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [linkBt addTarget:self action:@selector(doWait:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:linkBt];
        self.linkBt = linkBt;
        [self changeTitleByWait:_isWait];
        [linkBt release];
    }
}

- (void)dealloc
{
    self.viewPop = nil;
    self.clauseData = nil;
    self.detailCtro = nil;
    [super dealloc];
}

- (void)doDelete
{
    _ALERT_SELECT_(_GET_LOCALIZED_STRING_(@"alert_delete_score"), self, 0);
}

- (void)doLink:(id)sender
{
    _detailCtro.clauseData = _clauseData;
    
    UIButton *linkButton = (UIButton *)sender;
    [_viewPop presentPopoverFromRect:linkButton.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (void)doWait:(id)sender
{
    self.isWait = !_isWait;
    
    [self changeTitleByWait:_isWait];
    
    [Common callDelegate:_delegate method:@selector(doWait:) withObject:(id)_isWait];
}

- (void)changeTitleByWait:(BOOL)isWait
{
    if (_isWait) {
        [_linkBt setTitle:_GET_LOCALIZED_STRING_(@"button_nowait") forState:UIControlStateNormal];
    }
    else {
        [_linkBt setTitle:_GET_LOCALIZED_STRING_(@"button_wait") forState:UIControlStateNormal];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [Common callDelegate:_delegate method:@selector(doDelete)];
    }
>>>>>>> branch
}

@end
