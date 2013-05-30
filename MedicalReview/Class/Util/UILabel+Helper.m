//
//  UILabel+Helper.m
//  SJJFRicher
//
//  Created by tie zhang on 12-7-25.
//  Copyright (c) 2012年 ailk. All rights reserved.
//

#import "UILabel+Helper.h"
#import "CFinishChart.h"
#import "macdefine.h"

@implementation UILabel(UILabel)

//根据服务端属性填充Label组件
- (void)setData:(NSString *)data type:(int)type font:(UIFont *)font
{
    switch (type) {
        case 0:
        {
            self.text = data;
            self.textAlignment = UITextAlignmentCenter;
            self.textColor = [UIColor blackColor];
            break;
        }
        case 1:
        {
            self.text = data;
            self.textAlignment = UITextAlignmentCenter;
            self.textColor = [UIColor blueColor];
            break;
        }
        case 2:
        {
            float labelWidth = self.frame.size.width;
            float labelHehght = self.frame.size.height;
            CGRect chartRect = CGRectMake(labelWidth * (1-0.8) * 0.5,
                                          labelHehght * (1-0.8) * 0.5,
                                          labelWidth*0.8,
                                          labelHehght*0.8);
            CFinishChart* chart = [[CFinishChart alloc] initWithFrame:chartRect];
            chart.strActualValue = data.floatValue;
            chart.strDesiredValue = 100;
            [self addSubview:chart];
            [chart release];
            break;
        }
        default:
            break;
    }
	if (font != nil) {
		self.font = font;
	}
	self.numberOfLines = 0;
}

@end
