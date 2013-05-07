//
//  MR_AppDelegate.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-22.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_AppDelegate.h"
#import "MR_LoginCtro.h"
#import "MR_MainCtro.h"

@implementation MR_AppDelegate

- (void)dealloc
{
    self.globalinfo = nil;
    self.hostReach = nil;
    
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //.....
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    _hostReach = [[Reachability reachabilityWithHostName:@"www.google.com"] retain];//可以以多种形式初始化
    [_hostReach startNotifier];  //开始监听,会启动一个run loop
    [self updateInterfaceWithReachability: _hostReach];
    //.....
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    [self initApp];
    
    MR_LoginCtro *rootCtro = [[MR_LoginCtro alloc] initWithNibName:@"MR_LoginCtro" bundle:nil];
//    MR_MainCtro *rootCtro = [[MR_MainCtro alloc] init];
    self.window.rootViewController = rootCtro;
    [self.window makeKeyAndVisible];
    [rootCtro release];
    
    return YES;
}

// 连接改变
- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
}

//处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    //对连接改变做出响应的处理动作。
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {  //没有连接到网络就弹出提实况
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My App Name"
                                                        message:@"NotReachable"
                                                       delegate:nil
                                              cancelButtonTitle:@"YES" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)initApp
{
    //set server url
    self.globalinfo = [[GlobalInfo alloc] init];
    _globalinfo.serverInfo.strWebServiceUrl = SERVICE_URL;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
