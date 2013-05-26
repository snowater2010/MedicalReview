//
//  MR_OperateView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-30.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_OperateView.h"

@implementation MR_OperateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isHasLink = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    float delete_x = 0.0f;
    float delete_y = 0.0f;
    float delete_w = _isHasLink ? rect.size.width * 0.4 : rect.size.width;
    float delete_h = rect.size.height;
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
        float link_x = delete_x + delete_w;
        float link_y = 0.0f;
        float link_w = rect.size.width * 0.6;
        float link_h = rect.size.height;
        CGRect linkRect = CGRectMake(link_x, link_y, link_w, link_h);
        UIButton *linkBt = [[UIButton alloc] initWithFrame:linkRect];
        [linkBt setTitle:_GET_LOCALIZED_STRING_(@"button_link") forState:UIControlStateNormal];
        linkBt.titleLabel.font = [UIFont systemFontOfSize:OPERATE_TEXT_SIZE];
        [linkBt addTarget:_delegate action:@selector(doLink) forControlEvents:UIControlEventTouchUpInside];
        [linkBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [linkBt setBackgroundImage:[UIImage imageNamed:@"btn_img.png"] forState:UIControlStateNormal];
        [self addSubview:linkBt];
        [linkBt release];
    }
}

- (void)doDelete
{
    _ALERT_SELECT_(_GET_LOCALIZED_STRING_(@"alert_delete_score"), self, 0);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [Common callDelegate:_delegate method:@selector(doDelete)];
    }
}

@end
