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
	if(strActualValue >= strDesiredValue){
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
	CGRect finishRect = CGRectMake(fLeft, fTop, fMiddle-fLeft, iFinishBarHeight);
	[gradientRect setHighColorHex:@"#0000FF"];
	[gradientRect drawRect:finishRect inContext:context];
	
	//	UIColor *finishColor = [UIColor blueColor];
	//	CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
	//	CGContextAddRect(context, finishRect);
	//	CGContextSetFillColorWithColor(context, finishColor.CGColor);
	//	CGContextFillPath(context);
	
	if(fMiddle != fRight){
		//画未完成部分
		CGRect notfinishRect = CGRectMake(fMiddle, fTop, fRight-fMiddle, iFinishBarHeight);
		
		[gradientRect setHighColorHex:@"#00FF00"];
		[gradientRect drawRect:notfinishRect inContext:context];
		
		//		UIColor *notfinishColor = [UIColor greenColor];
		//		CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
		//		CGContextAddRect(context, notfinishRect);
		//		CGContextSetFillColorWithColor(context, notfinishColor.CGColor);
		//		CGContextFillPath(context);
	}
	
	[gradientRect release];
	
	//画文字部分
	CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);
	NSString* strFinishText = [NSString stringWithFormat:@"目标完成率：%.2f%%", iFinishValue];
	[strFinishText drawAtPoint:CGPointMake(fLeft, fTop-20) withFont:[UIFont systemFontOfSize:10]];
}


- (void)dealloc {
    [super dealloc];
}

@end

