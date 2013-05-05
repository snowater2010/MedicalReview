//
//  MR_ClauseTable.m
//  MedicalReview
//
//  Created by lipeng11 on 13-5-5.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ClauseTable.h"

@implementation MR_ClauseTable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor purpleColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (_jsonData) {
        float label_x = 0.0f;
        for (NSDictionary *headDic in _jsonData) {
            NSString *tableName = [headDic objectForKey:KEY_tableName];
            float tableWidth = [[headDic objectForKey:KEY_tableWidth] floatValue];
            
            float label_y = 0;
            float label_w = tableWidth == -1 ? (rect.size.width - label_x) : (rect.size.width * tableWidth);
            float label_h = rect.size.height;
            CGRect headFrame = CGRectMake(label_x, label_y, label_w, label_h);
            UILabel *labelView = [[UILabel alloc] initWithFrame:headFrame];
            labelView.text = tableName;
            labelView.textAlignment = UITextAlignmentCenter;
            labelView.font = [UIFont systemFontOfSize:TABLE_TEXT_SIZE];
            labelView.layer.borderWidth = 1;
            labelView.layer.borderColor = [[UIColor blackColor] CGColor];
            [self addSubview:labelView];
            [labelView release];
            
            label_x += label_w;
        }
    }
}

@end
