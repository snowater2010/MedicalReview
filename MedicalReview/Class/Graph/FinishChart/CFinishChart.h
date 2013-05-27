//
//  CFinishChart.h
//  SJJFRicher
//
//  Created by Carl Shen on 11-11-12.
//  Copyright 2011 ailk. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

enum GradientDirection {
    DIRECTION_INIT = -1,    //初始值
	LEFT_RIGHT, //从左到右
	RIGHT_LEFT, //从右到左
	UP_DOWN,    //从上到下
	DOWN_UP,    //从下到上
	CENTER_H,   //中间到两边横向
	CENTER_V    //中间到两边竖向
};

@interface CFinishChart : UIView 
{	
	int iWidth;
	int iHeight;
	
	float strActualValue;
	float strDesiredValue;
}

@property(nonatomic,assign) int iWidth;
@property(nonatomic,assign) int iHeight;

@property(nonatomic,assign) float strActualValue;
@property(nonatomic,assign) float strDesiredValue;

@end