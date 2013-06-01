//
//  CFinishChart.m
//  SJJFRicher
//
//  Created by Carl Shen on 11-11-12.
//  Copyright 2011 ailk. All rights reserved.
//

#import "CFinishChart.h"
#import "CGradientRect.h"

@implementation CFinishChart
@synthesize strActualValue, strDesiredValue, iWidth, iHeight;

#define iScale 0.8
#define iFinishBarHeight 15

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		// Initialization code
		self.backgroundColor = [UIColor whiteColor];
		//四角的圆度
		self.layer.cornerRadius = 8;
		self.layer.masksToBounds = YES;
		
		iWidth = frame.size.width;
		iHeight = frame.size.height;
        
        self.textColor = [UIColor blackColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    // Drawing code here.
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//计算矩形尺寸
	float fLeft = 0;
	float fRight  = iWidth;
	float fTop = 0;
	float fMiddle;
	float iFinishValue;
    if (strDesiredValue == 0) {
        iFinishValue = 0;
		fMiddle = fLeft;
    }
	else if(strActualValue >= strDesiredValue){
		iFinishValue = 100;
		fMiddle = fRight;
	}else{
		iFinishValue = strActualValue*100/strDesiredValue;
		fMiddle = fLeft + (fRight-fLeft)*iFinishValue/100;
	}
	
	CGradientRect *gradientRect = [[CGradientRect alloc] init];
	gradientRect.mDirection = CENTER_V;
	gradientRect.mRate = 0.4;
	
	//画已完成部分
	CGRect finishRect = CGRectMake(fLeft, fTop, fMiddle-fLeft, iHeight);
	[gradientRect setHighColorHex:@"#FF9200"];
	[gradientRect drawRect:finishRect inContext:context];
	
	if(fMiddle != fRight){
		//画未完成部分
		CGRect notfinishRect = CGRectMake(fMiddle, fTop, fRight-fMiddle, iHeight);
		
		[gradientRect setHighColorHex:@"#FFFFFF"];
		[gradientRect drawRect:notfinishRect inContext:context];
	}
	
	[gradientRect release];
	
	//画文字部分
    NSString *strFinishText = [NSString stringWithFormat:@"%.1f%%", iFinishValue];
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize textSize = [strFinishText sizeWithFont:font];
    
    CGContextSetFillColorWithColor(context, [_textColor CGColor]);
	[strFinishText drawAtPoint:CGPointMake((iWidth-textSize.width)/2, (iHeight-textSize.height)/2) withFont:font];
}


- (void)dealloc {
    [super dealloc];
}

@end

