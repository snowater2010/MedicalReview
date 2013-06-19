//
//  MR_OperateView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-30.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_OperateView.h"
#import "MR_ClauseDetailCtro.h"

@interface MR_OperateView () <UIPopoverControllerDelegate>

@property(nonatomic, retain) UIPopoverController *viewPop;
@property(nonatomic, retain) MR_ClauseDetailCtro *detailCtro;

@end

@implementation MR_OperateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.isHasLink = NO;
        
        UIPopoverController *viewPop = [UIPopoverController alloc];
        MR_ClauseDetailCtro *detailCtro = [[MR_ClauseDetailCtro alloc] initWithNibName:@"MR_ClauseDetailCtro" bundle:nil];
        self.viewPop = viewPop;
        self.detailCtro = detailCtro;
        [_viewPop initWithContentViewController:detailCtro];
        _viewPop.popoverContentSize = CGSizeMake(800, 560);
        [detailCtro release];
        [viewPop release];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self refreshPage];
}

- (void)refreshPage
{
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [obj removeFromSuperview];
    }];
    
    CGRect rect = self.bounds;
//    _isHasLink = YES;
    
    float delete_x = _isHasLink ? (rect.size.width-UNIT_BUTTON_SIZE*3)*0.3 : (rect.size.width-UNIT_BUTTON_SIZE)*0.5;
    float delete_y = (rect.size.height-UNIT_BUTTON_SIZE)*0.5;
    float delete_w = UNIT_BUTTON_SIZE;
    float delete_h = UNIT_BUTTON_SIZE;
    CGRect deleteRect = CGRectMake(delete_x, delete_y, delete_w, delete_h);
    UIButton *deleteBt = [[UIButton alloc] initWithFrame:deleteRect];
    [deleteBt setTitle:_GET_LOCALIZED_STRING_(@"button_delete") forState:UIControlStateNormal];
    deleteBt.titleLabel.font = [UIFont systemFontOfSize:OPERATE_TEXT_SIZE];
    [deleteBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [deleteBt setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [deleteBt addTarget:self action:@selector(doDelete) forControlEvents:UIControlEventTouchUpInside];
//    [deleteBt setBackgroundImage:[UIImage imageNamed:@"export.png"] forState:UIControlStateNormal];
    [self addSubview:deleteBt];
    [deleteBt release];
    
    if (_isHasLink) {
        float link_x = CGRectGetMaxX(deleteRect) + (rect.size.width-UNIT_BUTTON_SIZE*3)*0.3;
        float link_y = (rect.size.height-UNIT_BUTTON_SIZE)*0.5;
        float link_w = UNIT_BUTTON_SIZE*2;
        float link_h = UNIT_BUTTON_SIZE;
        CGRect linkRect = CGRectMake(link_x, link_y, link_w, link_h);
        UIButton *linkBt = [[UIButton alloc] initWithFrame:linkRect];
        [linkBt setTitle:_GET_LOCALIZED_STRING_(@"button_link") forState:UIControlStateNormal];
        linkBt.titleLabel.font = [UIFont systemFontOfSize:OPERATE_TEXT_SIZE];
        [linkBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [linkBt setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [linkBt addTarget:self action:@selector(doLink:) forControlEvents:UIControlEventTouchUpInside];
//        [linkBt setBackgroundImage:[UIImage imageNamed:@"detail.png"] forState:UIControlStateNormal];
        [self addSubview:linkBt];
        [linkBt release];
    }
    
//    if (_isHasLink) {
//        float link_x = CGRectGetMaxX(deleteRect) + (rect.size.width-UNIT_BUTTON_SIZE*3)*0.3;
//        float link_y = (rect.size.height-UNIT_BUTTON_SIZE)*0.5;
//        float link_w = UNIT_BUTTON_SIZE*2;
//        float link_h = UNIT_BUTTON_SIZE;
//        CGRect linkRect = CGRectMake(link_x, link_y, link_w, link_h);
//        UIButton *linkBt = [[UIButton alloc] initWithFrame:linkRect];
//        [linkBt setTitle:_GET_LOCALIZED_STRING_(@"button_link") forState:UIControlStateNormal];
//        linkBt.titleLabel.font = [UIFont systemFontOfSize:OPERATE_TEXT_SIZE];
//        [linkBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [linkBt addTarget:self action:@selector(doWait:) forControlEvents:UIControlEventTouchUpInside];
//        //        [linkBt setBackgroundImage:[UIImage imageNamed:@"detail.png"] forState:UIControlStateNormal];
//        [self addSubview:linkBt];
//        [linkBt release];
//        
////        [Common colorWithR:175 withG:139 withB:185];
//    }
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
    UIButton *button = (UIButton *)sender;
    
    [Common callDelegate:_delegate method:@selector(doWait)];
    
//    _isHasWait = YES;
//    if (_isHasWait) {
//        button.backgroundColor = [Common colorWithR:175 withG:139 withB:185];
//    }
//    else {
//        button.backgroundColor = [Common colorWithR:175 withG:139 withB:185];
//    }
    
//    _detailCtro.clauseData = _clauseData;
//    
//    UIButton *linkButton = (UIButton *)sender;
//    [_viewPop presentPopoverFromRect:linkButton.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [Common callDelegate:_delegate method:@selector(doDelete)];
    }
}

@end
