//
//  AppDelegate.m
//  HouseMananger
//
//  Created by 王晗 on 14-12-30.
//  Copyright (c) 2014年 王晗. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "GuideViewController.h"
#import "Param.h"

#import "PushNotification.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "MessageFullView.h"
#import "UMSocial.h"
@interface AppDelegate ()
{
    MessageFullView *_messageFullView;
    GuideViewController *_guideVC;
    PushNotification *_push;
}
@end

@implementation AppDelegate
//程序是否是第一次启动
#define LAST_RUN_VERSION_KEY        @"last_run_version_of_application"
- (BOOL) isFirstLoad{
    NSString *currentVersion = [Param getVersion];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastRunVersion = [defaults objectForKey:LAST_RUN_VERSION_KEY];
    // 版本信息为空
    if (nil == lastRunVersion) {
        
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
    }
    // 版本升级后
    if (nil != lastRunVersion && ![lastRunVersion isEqualToString:currentVersion]) {
        
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
    }
    return NO;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[MainTabBarController alloc] init];
    
    // 分享
    [UMSocialData openLog:NO];
    [UMSocialData setAppKey:@"54631cf3fd98c5daa1004413"];
    [UMSocialWechatHandler setWXAppId:@"wx52f9030eeca71d16" appSecret:@"87e8f1b5ad7ac5f586f3c12b57f56edb" url:@"http://www.vpubao.cn"];
    NSString * urlStr = [NSString stringWithFormat:@"http://wshop.diandianle.cn/?shop_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"shop_id"]];
    [UMSocialQQHandler setQQWithAppId:@"1103485513" appKey:@"Z5UIzj2OTBYYibWe" url:urlStr];
    
    // Push
    _push = [PushNotification shareInstance];
    [_push registerForRemoteNotificationWithLaunchOptions:launchOptions application:application];
    
    // Window  width & height
    origin_x = 0.0F;
    origin_y = 0.0F;
    size_width = self.window.frame.size.width;
    size_height = self.window.frame.size.height - 20.0F;
    
    
    
    // 判断是否是 第一次启动
    if ([self isFirstLoad]) {
        // 自动 设置地区
        [[NSUserDefaults standardUserDefaults] setObject:@"北京" forKey:@"cityName"];
        [[NSUserDefaults standardUserDefaults] setObject:@"52" forKey:@"cityId"];
        [[NSUserDefaults standardUserDefaults] setObject:@"朝阳区" forKey:@"regionName"];
        [[NSUserDefaults standardUserDefaults] setObject:@"503" forKey:@"regionId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 引导页
        _guideVC = [[GuideViewController alloc] initWithFrame:CGRectMake(0, 0, size_width, size_height + 20)];
        [self.window addSubview:_guideVC.view];
    }
    
    // 加载时 的 提示框（类MBHUD）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFullScreenMessageView:) name:NOTI_NAME_APPEAR_FULL_SCREEN_MSG_VIEW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissFullScreenMessageView:) name:NOTI_NAME_DISAPPEAR_FULL_SCREEN_MSG_VIEW object:nil];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return  [UMSocialSnsService handleOpenURL:url];
}

#pragma mark - Show/Dismiss full screen message view
- (void)showFullScreenMessageView:(NSNotification*)aNotification {
    
    DLOG(@"showFullScreenMessageView");
    
    if (nil == aNotification.userInfo)
        return;
    
    if (nil == [aNotification.userInfo objectForKey:@"type"]        ||
        nil == [aNotification.userInfo objectForKey:@"message"]     ||
        nil == [aNotification.userInfo objectForKey:@"auto_close"]  ||
        nil == [aNotification.userInfo objectForKey:@"time"])
        return;
    
    NSNumber *type = [aNotification.userInfo objectForKey:@"type"];
    NSString *message = [aNotification.userInfo objectForKey:@"message"];
    NSNumber *autoClose = [aNotification.userInfo objectForKey:@"auto_close"];
    NSNumber *time = [aNotification.userInfo objectForKey:@"time"];
    
    if (nil == _messageFullView) {
        
        _messageFullView = [[MessageFullView alloc] initWithType:[type intValue]
                                                    withMessage:message];
    }
    [self.window addSubview:_messageFullView];
    [self.window makeKeyAndVisible];

    if (1 == [autoClose intValue]) {
        [NSTimer scheduledTimerWithTimeInterval:[time floatValue]
                                         target:self
                                       selector:@selector(dismissFullScreenMessageView:)
                                       userInfo:nil
                                        repeats:NO];
    }
}

- (void)dismissFullScreenMessageView:(NSNotification*)aNotification {
    
    DLOG(@"dismissFullScreenMessageView");
    if (nil != _messageFullView) {
        [_messageFullView removeFromSuperview];
        _messageFullView = nil;
    }
}

#pragma mark - Push
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [_push registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [_push handleRemoteNotificationWithApplication:application
                                          userInfo:userInfo
                            fetchCompletionHandler:nil];
}

// iOS 7 Later Support
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [_push handleRemoteNotificationWithApplication:application
                                          userInfo:userInfo
                            fetchCompletionHandler:completionHandler];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
