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

//#define SERVICE_URL         @"http://222.173.30.135:8088/ylpj/webif"
#define SERVICE_URL         @"http://124.133.27.146:8080/ylgl/webif"
//#define SERVICE_URL         @"http://192.168.1.107:8080/ylpj/webif"

#define CACHE_CLAUSE        @"cache_clause"         //条款缓存文件名
#define CACHE_SCORE         @"cache_score"          //打分缓存文件名
#define CACHE_SCORE_UPDATE  @"cache_score_update"   //打分缓存文件名，本地更新，待上传
#define CACHE_PATH          @"cache_path"           //路径数据缓存文件名
#define CACHE_CHAPTER       @"cache_chapter"       //章节数据缓存文件名

#define USER_DEFAULT_KEY    @"MR_User_Default"      //存储登陆信息

//获取屏幕高度
#define _DEVICE_STATEBAR_HEIGHT 20
#define _DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define _DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width - _DEVICE_STATEBAR_HEIGHT

//键盘
#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

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


//上锁，解锁
#define _lock       NSLock *lock = [[NSLock alloc] init];\
                    [lock lock];
#define _unlock     [lock unlock];\
                    [lock release];

//login
#define KEY_errCode             @"errCode"
#define KEY_errMsg              @"errMsg"

//all
#define KEY_allClause           @"allClause"
#define KEY_pathFormat          @"pathFormat"
#define KEY_chaptersFormat      @"chaptersFormat"
#define KEY_clauseScore         @"clauseScore"

//path data
#define KEY_pathName            @"pathName"
#define KEY_nodeList            @"nodeList"
#define KEY_nodeId              @"nodeId"
#define KEY_nodeName            @"nodeName"
#define KEY_totalCount          @"totalCount"
#define KEY_finishCount         @"finishCount"
#define KEY_interviewPeople     @"interviewPeople"
#define KEY_functionContent     @"functionContent"

//chapter data
#define KEY_chapterName         @"chapterName"
#define KEY_sectionList         @"sectionList"
#define KEY_sectionName         @"sectionName"

//clause data keys
#define KEY_clauseList          @"clauseList"
#define KEY_clauseId            @"clauseId"
#define KEY_clauseName          @"clauseName"
#define KEY_formulaType         @"formulaType"
#define KEY_attrId              @"attrId"
#define KEY_attrName            @"attrName"
#define KEY_pointList           @"pointList"
#define KEY_attrLevel           @"attrLevel"
#define KEY_datainSpection      @"datainSpection"
#define KEY_proofLink           @"proofLink"
#define KEY_wordExplan          @"wordExplan"
#define KEY_templateDisplay     @"templateDisplay"

//score data keys
#define KEY_scoreValue          @"scoreValue"
#define KEY_scoreExplain        @"scoreExplain"

//search key
#define KEY_searchName          @"searchName"
#define KEY_searchScored        @"searchScored"
#define KEY_searchCore          @"searchCore"

//user
#define KEY_loginName           @"loginName"
#define KEY_loginPassWord       @"loginPassWord"
#define KEY_loginIsRememberPw   @"loginIsRememberPw"

#define KEY_userExpertNod       @"expertNo"
#define KEY_userExpertName      @"expertName"
#define KEY_userReviewId        @"reviewId"
#define KEY_userGroupId         @"groupId"
#define KEY_userHospitalId      @"hospitalId"
#define KEY_userHospitalName    @"hospitalName"

//table
#define KEY_tableName           @"tableName"
#define KEY_tableWidth          @"tableWidth"

