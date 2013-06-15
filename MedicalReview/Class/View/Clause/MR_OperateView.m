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
    
    float delete_x = 0.0f;
    float delete_y = 5.0f;
    float delete_w = _isHasLink ? rect.size.width * 0.4 : rect.size.width;
    float delete_h = rect.size.height - 10;
    CGRect deleteRect = CGRectMake(delete_x, delete_y, delete_w, delete_h);
    UIButton *deleteBt = [[UIButton alloc] initWithFrame:deleteRect];
    [deleteBt setTitle:_GET_LOCALIZED_STRING_(@"button_delete") forState:UIControlStateNormal];
    deleteBt.titleLabel.font = [UIFont systemFontOfSize:OPERATE_TEXT_SIZE+2];
    [deleteBt addTarget:self action:@selector(doDelete) forControlEvents:UIControlEventTouchUpInside];
    [deleteBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteBt setBackgroundImage:[UIImage imageNamed:@"btn_img.png"] forState:UIControlStateNormal];
    [self addSubview:deleteBt];
    [deleteBt release];
    
    if (_isHasLink) {
        float link_x = delete_x + delete_w + 5;
        float link_y = 5.0f;
        float link_w = rect.size.width * 0.6 - 10;
        float link_h = rect.size.height - 10;
        CGRect linkRect = CGRectMake(link_x, link_y, link_w, link_h);
        UIButton *linkBt = [[UIButton alloc] initWithFrame:linkRect];
        [linkBt setTitle:_GET_LOCALIZED_STRING_(@"button_link") forState:UIControlStateNormal];
        linkBt.titleLabel.font = [UIFont systemFontOfSize:OPERATE_TEXT_SIZE];
        [linkBt addTarget:self action:@selector(doLink:) forControlEvents:UIControlEventTouchUpInside];
        [linkBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [linkBt setBackgroundImage:[UIImage imageNamed:@"btn_img.png"] forState:UIControlStateNormal];
        [self addSubview:linkBt];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [Common callDelegate:_delegate method:@selector(doDelete)];
    }
}

@end
