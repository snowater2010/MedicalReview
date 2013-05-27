//
//  CGradientRect.m
//  SJJFRicher
//
//  Created by lipeng11 on 11-12-14.
//  Copyright 2011 ailk. All rights reserved.
//

#import "CGradientRect.h"

@implementation CGradientRect

@synthesize mAlpha, mDirection, mRate, mCornerRadius;
@synthesize m3Dtype, m3Dsize, m3Dangle;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		[self init];
    }
    return self;
}

- (id)init
{
	//背景设置为无色
	self.backgroundColor = [UIColor clearColor];
	
	//非3D
	m3Dtype = FALSE;
	m3Dsize = 0;
	m3Dangle = 0;
	
	//默认底色为黑色，可以通过方法重新设置
	lowR = 0;
	lowG = 0;
	lowB = 0;
	
	//默认蓝色高亮
	highR = 0;
	highG = 0;
	highB = 255;
	
	//默认透明度为1，不透明
	mAlpha = 1;
	mRate = 0.5;
	mDirection = left_right;
	
	//默认直角
	mCornerRadius = 0.0;
	
    return self;
}

//设置3D属性
-(void) setType3D:(bool)type3D size3D:(float)size3D angle3D:(float)angle3D
{
	m3Dtype = type3D;
	m3Dsize = size3D;
	m3Dangle = angle3D;
}

//设置色彩属性，高亮色，渐变方向，渐变速度
-(void) setColorHex:(NSString*)hexstring direction:(int)direction rate:(float)rate
{
	NSArray *rgb = [Common HexString2RGB:hexstring];	
	unsigned int r = [[rgb objectAtIndex:0] intValue];
	unsigned int g = [[rgb objectAtIndex:1] intValue];
	unsigned int b = [[rgb objectAtIndex:2] intValue];
	
	[self setColorR:r colorG:g colorB:b direction:direction rate:rate];
}

//设置色彩属性，高亮色，渐变方向，渐变速度
-(void) setColorR:(int)r colorG:(int)g colorB:(int)b direction:(int)direction rate:(float)rate
{	
	highR = r;
	highG = g;
	highB = b;
	
	mDirection = direction;
	mRate = rate;
}

//填充rect区域
-(void) drawRect:(CGRect)rect inContext:(CGContextRef)context
{
	//由rate换算渐变结果色
	float rateR = (highR-mRate*(highR-lowR))/255;
	float rateG = (highG-mRate*(highG-lowG))/255;
	float rateB = (highB-mRate*(highB-lowB))/255;
	
	NSArray *mHighColor = [NSArray arrayWithObjects:
						   [NSNumber numberWithFloat:(float)highR/255],
						   [NSNumber numberWithFloat:(float)highG/255],
						   [NSNumber numberWithFloat:(float)highB/255],nil];
	NSArray *mLowColor = [NSArray arrayWithObjects:
						  [NSNumber numberWithFloat:rateR],
						  [NSNumber numberWithFloat:rateG],
						  [NSNumber numberWithFloat:rateB],nil];
	
	NSMutableArray *colors = [[NSMutableArray alloc] init];
	[colors insertObject:mHighColor atIndex:0];
	[colors insertObject:mLowColor atIndex:1];
	
	CGPoint startPoint;
	CGPoint endPoint;
	switch (mDirection) {
		case center_h:
			[colors insertObject:mLowColor atIndex:0];
		case left_right:
			startPoint = CGPointMake(rect.origin.x, rect.origin.y);
			endPoint = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
			break;
		case right_left:
			startPoint = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
			endPoint = CGPointMake(rect.origin.x, rect.origin.y);
			break;
		case center_v:
			[colors insertObject:mLowColor atIndex:0];
		case up_down:
			startPoint = CGPointMake(rect.origin.x, rect.origin.y);
			endPoint = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height);
			break;
		case down_up:
			startPoint = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height);
			endPoint = CGPointMake(rect.origin.x, rect.origin.y);
			break;
		default:
			startPoint = CGPointMake(rect.origin.x, rect.origin.y);
			endPoint = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
			break;
	}
	
	//
	int item = [colors count];
    CGFloat colorComponents[item * 4];
    for (int i = 0; i < item; i++) {
		NSArray *color = [colors objectAtIndex:i];
		//三色值，float型
		for (int j = 0; j < 3; j++) {
            colorComponents[i * 4 + j] = [[color objectAtIndex:j] doubleValue];
        }
		//透明度
		colorComponents[i * 4 + 3] = mAlpha;
    }
	
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGGradientRef colorGradient = CGGradientCreateWithColorComponents(rgb, colorComponents, NULL, item);  
    CGColorSpaceRelease(rgb); 
	
	CGContextSaveGState(context);
	CGContextClipToRect(context, rect);
	CGContextDrawLinearGradient(context, colorGradient, startPoint, endPoint, 0);
	CGContextRestoreGState(context);
	
	if (m3Dtype) {
		//3D顶点
		float x3D = m3Dsize*cos(m3Dangle);
		float y3D = m3Dsize*sin(m3Dangle);
		CGPoint point3D = CGPointMake(rect.origin.x+rect.size.width+x3D, rect.origin.y-y3D);
		
		//顶面(渐变从右上到左下)
		startPoint = CGPointMake(point3D.x, point3D.y);
		endPoint = CGPointMake(rect.origin.x, rect.origin.y);
		
		CGContextBeginPath (context);
		CGContextMoveToPoint (context, endPoint.x, endPoint.y);
		CGContextAddLineToPoint (context, endPoint.x+x3D, point3D.y);
		CGContextAddLineToPoint(context, point3D.x, point3D.y);
		CGContextAddLineToPoint(context, point3D.x-x3D, endPoint.y);
		CGContextAddLineToPoint (context, endPoint.x, endPoint.y);
		CGContextClosePath (context);
		
		CGContextSaveGState(context);
		CGContextClip(context);
		CGContextDrawLinearGradient(context, colorGradient, startPoint, endPoint, 0);
		CGContextRestoreGState(context);
		
		//侧面(不需要渐变)
		CGContextBeginPath (context);
		CGContextMoveToPoint (context, point3D.x, point3D.y);
		CGContextAddLineToPoint (context, point3D.x, point3D.y+rect.size.height);
		CGContextAddLineToPoint(context, point3D.x-x3D, endPoint.y+rect.size.height);
		CGContextAddLineToPoint(context, point3D.x-x3D, endPoint.y);
		CGContextAddLineToPoint (context, point3D.x, point3D.y);
		CGContextClosePath (context);
		CGContextSetFillColorWithColor(context, [UIColor colorWithRed:rateR green:rateG blue:rateB alpha:1].CGColor);
		CGContextFillPath(context);
	}
	
	CGGradientRelease(colorGradient);
	[colors release];
	
	//四角的圆度
	self.layer.cornerRadius = mCornerRadius;
	self.layer.masksToBounds = YES;
}

//填充rect区域
//-(void) drawRect:(CGRect)rect inContext:(CGContextRef)context
-(void) drawRect:(CGRect)rect
{
	//删除所有subview
	
	UIView* view;
	for(view in [self subviews]){
		[view removeFromSuperview];
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
	CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
	
	//由rate换算渐变结果色
	float rateR = (highR-mRate*(highR-lowR))/255;
	float rateG = (highG-mRate*(highG-lowG))/255;
	float rateB = (highB-mRate*(highB-lowB))/255;
	
	NSArray *mHighColor = [NSArray arrayWithObjects:
						   [NSNumber numberWithFloat:(float)highR/255],
						   [NSNumber numberWithFloat:(float)highG/255],
						   [NSNumber numberWithFloat:(float)highB/255],nil];
	NSArray *mLowColor = [NSArray arrayWithObjects:
						  [NSNumber numberWithFloat:rateR],
						  [NSNumber numberWithFloat:rateG],
						  [NSNumber numberWithFloat:rateB],nil];
	
	NSMutableArray *colors = [[NSMutableArray alloc] init];
	[colors insertObject:mHighColor atIndex:0];
	[colors insertObject:mLowColor atIndex:1];
	
	CGPoint startPoint;
	CGPoint endPoint;
	switch (mDirection) {
		case center_h:
			[colors insertObject:mLowColor atIndex:0];
		case left_right:
			startPoint = CGPointMake(rect.origin.x, rect.origin.y);
			endPoint = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
			break;
		case right_left:
			startPoint = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
			endPoint = CGPointMake(rect.origin.x, rect.origin.y);
			break;
		case center_v:
			[colors insertObject:mLowColor atIndex:0];
		case up_down:
			startPoint = CGPointMake(rect.origin.x, rect.origin.y);
			endPoint = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height);
			break;
		case down_up:
			startPoint = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height);
			endPoint = CGPointMake(rect.origin.x, rect.origin.y);
			break;
		default:
			startPoint = CGPointMake(rect.origin.x, rect.origin.y);
			endPoint = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
			break;
	}
	
	//
	int item = [colors count];
    CGFloat colorComponents[item * 4];
    for (int i = 0; i < item; i++) {
		NSArray *color = [colors objectAtIndex:i];
		//三色值，float型
		for (int j = 0; j < 3; j++) {
            colorComponents[i * 4 + j] = [[color objectAtIndex:j] doubleValue];
        }
		//透明度
		colorComponents[i * 4 + 3] = mAlpha;
    }
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGGradientRef colorGradient = CGGradientCreateWithColorComponents(rgb, colorComponents, NULL, item);
    CGColorSpaceRelease(rgb);
	
	CGContextSaveGState(context);
	CGContextClipToRect(context, rect);
	CGContextDrawLinearGradient(context, colorGradient, startPoint, endPoint, 0);
	
	CGContextRestoreGState(context);
	
	if (m3Dtype) {
		//3D顶点
		float x3D = m3Dsize*cos(m3Dangle);
		float y3D = m3Dsize*sin(m3Dangle);
		CGPoint point3D = CGPointMake(rect.origin.x+rect.size.width+x3D, rect.origin.y-y3D);
		
		//顶面(渐变从右上到左下)
		startPoint = CGPointMake(point3D.x, point3D.y);
		endPoint = CGPointMake(rect.origin.x, rect.origin.y);
		
		CGContextBeginPath (context);
		CGContextMoveToPoint (context, endPoint.x, endPoint.y);
		CGContextAddLineToPoint (context, endPoint.x+x3D, point3D.y);
		CGContextAddLineToPoint(context, point3D.x, point3D.y);
		CGContextAddLineToPoint(context, point3D.x-x3D, endPoint.y);
		CGContextAddLineToPoint (context, endPoint.x, endPoint.y);
		CGContextClosePath (context);
		
		CGContextSaveGState(context);
		CGContextClip(context);
		CGContextDrawLinearGradient(context, colorGradient, startPoint, endPoint, 0);
		CGContextRestoreGState(context);
		
		//侧面(不需要渐变)
		CGContextBeginPath (context);
		CGContextMoveToPoint (context, point3D.x, point3D.y);
		CGContextAddLineToPoint (context, point3D.x, point3D.y+rect.size.height);
		CGContextAddLineToPoint(context, point3D.x-x3D, endPoint.y+rect.size.height);
		CGContextAddLineToPoint(context, point3D.x-x3D, endPoint.y);
		CGContextAddLineToPoint (context, point3D.x, point3D.y);
		CGContextClosePath (context);
		CGContextSetFillColorWithColor(context, [UIColor colorWithRed:rateR green:rateG blue:rateB alpha:1].CGColor);
		CGContextFillPath(context);
	}
	
	CGGradientRelease(colorGradient);
	[colors release];
	
	CGContextStrokePath(context);
	
	//四角的圆度
	self.layer.cornerRadius = mCornerRadius;
	self.layer.masksToBounds = YES;
}

//设置主色
-(void) setHighColorR:(int)r colorG:(int)g colorB:(int)b
{
	highR = r;
	highG = g;
	highB = b;
}

//设置底色
-(void) setLowColorR:(int)r colorG:(int)g colorB:(int)b
{
	lowR = r;
	lowG = g;
	lowB = b;
}

-(void) setHighColorHex:(NSString*)hexstring
{
	NSArray *rgb = [Common HexString2RGB:hexstring];
	
	highR = [[rgb objectAtIndex:0] intValue];
	highG = [[rgb objectAtIndex:1] intValue];
	highB = [[rgb objectAtIndex:2] intValue]; 
}

-(void) setLowColorHex:(NSString*)hexstring
{
	NSArray *rgb = [Common HexString2RGB:hexstring];
	
	lowR = [[rgb objectAtIndex:0] intValue];
	lowG = [[rgb objectAtIndex:1] intValue];
	lowB = [[rgb objectAtIndex:2] intValue];
}

-(int) left_right
{
	return left_right;
}
-(int) right_left
{
	return right_left;
}
-(int) up_down
{
	return up_down;
}
-(int) down_up
{
	return down_up;
}
-(int) center_h
{
	return center_h;
}
-(int) center_v
{
	return center_v;
}

- (void)dealloc {
	[super dealloc];
}

@end
