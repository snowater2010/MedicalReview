//
//  CGradientRect.h
//  SJJFRicher
//
//  Created by lipeng11 on 11-12-14.
//  Copyright 2011 ailk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define K_PI 3.1415926

enum direction{
	left_right, //从左到右
	right_left, //从右到左
	up_down,    //从上到下
	down_up,    //从下到上
	center_h,   //中间到两边横向
	center_v    //中间到两边竖向
};

@interface CGradientRect : UIView {
	
	//高亮色
	int highR;
	int highG;
	int highB;
	//底色
	int lowR;
	int lowG;
	int lowB;
	
	float mAlpha;//透明度
	int mDirection;//渐变方向
	float mRate;//渐变程度
	float mCornerRadius;//矩形四角的圆度
	
	bool m3Dtype;
	float m3Dsize;
	float m3Dangle;
}

@property (nonatomic, assign) float mAlpha;
@property (nonatomic, assign) int mDirection;
@property (nonatomic, assign) float mRate;
@property (nonatomic, assign) float mCornerRadius;

@property (nonatomic, assign) bool m3Dtype;
@property (nonatomic, assign) float m3Dsize;
@property (nonatomic, assign) float m3Dangle;


-(id) init;

-(void) setType3D:(bool)type3D size3D:(float)size3D angle3D:(float)angle3D;

-(void) setColorHex:(NSString*)hexstring direction:(int)direction rate:(float)rate;

-(void) setColorR:(int)r colorG:(int)g colorB:(int)b direction:(int)direction rate:(float)rate;

-(void) drawRect:(CGRect)rect inContext:(CGContextRef)context;

-(void) setHighColorHex:(NSString*)hexstring;

-(void) setLowColorHex:(NSString*)hexstring;

-(void) setHighColorR:(int)r colorG:(int)g colorB:(int)b;

-(void) setLowColorR:(int)r colorG:(int)g colorB:(int)b;

-(int) left_right;
-(int) right_left;
-(int) up_down;
-(int) down_up;
-(int) center_h;
-(int) center_v;

@end
