//
//  MyLog.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-22.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyLog : NSObject

#define _MODE_DEBUG_    1

#define _LOG_(x)  if(_MODE_DEBUG_) _LOG_FORMAT_(@"---LogPrint:%@---", x);

#define _LOG_FORMAT_(FORMAT, PARM...)  if(_MODE_DEBUG_) \
                                        NSLog(FORMAT, ##PARM);\

#define _LOG_ERROR_(err)\
            if(err && _MODE_DEBUG_)\
                NSLog((@"---------error:%@-------\n[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n"), err, __FILE__, __FUNCTION__, __LINE__);

@end
