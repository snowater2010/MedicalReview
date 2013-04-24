//
//  macdefine.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-22.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"

#define MODE_DEBUG   1   //是否为开发模式:1为开发模式，0为打包模式

#define ENABLE_CACHE 0   //是否启用缓存,1为启用

#define SERVICE_URL  @"https://api.douban.com/v2/book/1220562"

//获取屏幕高度
#define _DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define _DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width - 20

#define _LOAD_ROOT_VIEW\
    CGRect fullFrame = CGRectMake(0, 0, _DEVICE_HEIGHT, _DEVICE_WIDTH);\
    UIView *fullView = [[UIView alloc] initWithFrame:fullFrame];\
    fullView.backgroundColor = [UIColor whiteColor];\
    self.view = fullView;\
    [fullView release];\

//排序类型
enum SORT_TYPE
{
    SORT_TYPE_NONE  = 0,    //默认状态，无排序
    SORT_TYPE_ASC   = 1,    //升序
    SORT_TYPE_DESC  = 2,    //降序
};

//对齐方式
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0 
    #define ALIGN_LEFT      UITextAlignmentLeft
    #define ALIGN_CENTER    UITextAlignmentCenter
    #define ALIGN_RIGHT     UITextAlignmentRight
#else
    #define ALIGN_LEFT      NSTextAlignmentLeft 
    #define ALIGN_CENTER    NSTextAlignmentCenter 
    #define ALIGN_RIGHT     NSTextAlignmentRight 
#endif

//获取国际化字符串
#define _GET_LOCALIZED_STRING_(key)\
        NSLocalizedString(key, @"")\

#define _GET_APP_DELEGATE_(appDelegate)\
        MR_AppDelegate* appDelegate = (MR_AppDelegate*)[UIApplication sharedApplication].delegate;

//set val for key in mutableDic
#define _SET_VALUE_KEY_FORDIC_(dic, val, key)\
        if(dic)\
        {\
            if(![Common IsStrEmpty:val]) \
                [dic setValue:val forKey:key];\
            else \
                [dic setValue:@"" forKey:key];\
        }\

/**********************动画宏部分****************************/
//动画声明
#define _ANIMATIONS_INIT_BEGIN_(time)       [UIView beginAnimations:@""context:nil];\
                                            [UIView setAnimationDuration:time]; \
                                            [UIView setAnimationDelegate:self];\
//动画结束语句
#define _ANIMATIONS_INIT_END_               [UIView commitAnimations];

//默认视图样式:圆角，边线宽度，颜色
#define _BOLDER_DEFAULT_STYLE_(__view, b_borderColor)\
        if([__view isKindOfClass:[UIView class]])\
        {\
            __view.layer.cornerRadius  = 8.0f;\
            __view.layer.borderWidth   = 2.0;\
            if(b_borderColor) \
                __view.layer.borderColor = b_borderColor;\
            else \
                __view.layer.borderColor = [UIColor lightGrayColor].CGColor;\
            __view.layer.masksToBounds = YES;\
        }\

//简单的警示框
#define _ALERT_SIMPLE_(_msg) \
        {\
            NSString* str_note   = _GET_LOCALIZED_STRING_(@"alert_note");\
            NSString* str_cancel = _GET_LOCALIZED_STRING_(@"alert_sure");\
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:str_note message:_msg delegate:nil cancelButtonTitle:str_cancel otherButtonTitles:nil, nil];\
            [alert show];\
            [alert release];\
        }\
//有确认的警示框(1个按钮)
#define _ALERT_CONFIRM_(_msg, _delegate, _tag) \
        {\
            NSString* str_note   = _GET_LOCALIZED_STRING_(@"alert_note");\
            NSString* str_cancel = _GET_LOCALIZED_STRING_(@"alert_sure");\
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:str_note message:_msg delegate:_delegate cancelButtonTitle:str_cancel otherButtonTitles:nil, nil];\
            alert.tag = _tag;    \
            [alert show];\
            [alert release];\
        }\
//有选择的警示框(2个按钮)
#define _ALERT_SELECT_(_msg, _delegate, _tag)\
        {\
            NSString* str_note   = _GET_LOCALIZED_STRING_(@"alert_note");\
            NSString* str_sure   = _GET_LOCALIZED_STRING_(@"alert_sure");\
            NSString* str_cancel   = _GET_LOCALIZED_STRING_(@"alert_cancel");\
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:str_note message:_msg delegate:_delegate cancelButtonTitle:str_cancel otherButtonTitles:str_sure, nil];\
            alert.tag = _tag;\
            [alert show];\
            [alert release];\
        }\
//移出所有子视图
#define _REMOVE_ALLSUBVIEWS_(_fatherView)\
        {\
            if(_fatherView)\
            {\
                for(UIView* subView in _fatherView.subviews)\
                {\
                    if(subView)\
                        [subView removeFromSuperview];\
                }\
            }\
        }\

//移出指定tag子视图
#define _REMOVE_VIEWWITHTAG_(_fatherView, _tag)\
        {\
            UIView* _subView = [_fatherView viewWithTag:_tag];\
            if(_subView)\
                [_subView removeFromSuperview];\
        }\

#define _SETGROUP_BGCOLOR_(desview)\
        if(desview)\
        {\
            CGRect bgtable_frame = desview.bounds;\
            _SETGROUP_BGCOLORWITHFRAME_(desview, bgtable_frame)\
        }\

#define _SETGROUP_BGCOLORWITHFRAME_(desview, __frame)\
        if(desview)\
        {\
            UITableView* bgTable = [[UITableView alloc]initWithFrame:__frame style:UITableViewStyleGrouped];\
            [desview insertSubview:bgTable atIndex:0];\
            [bgTable release];\
        }\
