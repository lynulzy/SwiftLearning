//
//  PushNotification.m
//  MiShiClient-Pro
//
//  Created by zhangmeng on 14/12/3.
//  Copyright (c) 2014年 zsxj. All rights reserved.
//

#import "PushNotification.h"
#import "UserTmpParam.h"
#import <CommonCrypto/CommonDigest.h>

#define kRemoNoti    UIApplicationLaunchOptionsRemoteNotificationKey
#define kLocalNoti   UIApplicationLaunchOptionsLocalNotificationKey
#define keyX         self.currentViewController.view.bounds.origin.x
#define keyY         self.currentViewController.view.bounds.origin.y + 20
#define keyWidth     self.currentViewController.view.bounds.size.width

@interface PushNotification ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong)UILabel *alertView;
@property (nonatomic)BOOL isForeGround;
@property (nonatomic)BOOL isUnregister;
@property (nonatomic, strong)UITabBarController *currentViewController;
@property (nonatomic, strong)NSDictionary *pushNotiDic;//用来存储当前接受到的推送消息的字典
@property (nonatomic, strong)UIButton *cancleBtn;//取消弹窗
- (void)checkTheAppLaunchedWithlaunchOptions:(NSDictionary *)launchOptions;
- (void)checkTheAppBadgeNumberWithApplication:(UIApplication *)application withLaunchOptions:(NSDictionary *)launchOptions;
- (void)handleTapAction;
@end

@implementation PushNotification

//lazy loading 弹窗
- (UILabel *)alertView {
    if (_alertView == nil) {
        self.alertView = [[UILabel alloc] initWithFrame:CGRectMake(keyX, keyY, keyWidth, 30)];
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.cornerRadius = 8;
        _alertView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        _alertView.textColor = [UIColor whiteColor];
        _alertView.textAlignment = NSTextAlignmentCenter;
        _alertView.text = @"您有一条新消息，点击查看！";
        _alertView.font = [UIFont systemFontOfSize:11];
        _alertView.userInteractionEnabled = YES;
    }
    return _alertView;
}

- (NSDictionary *)pushNotiDic {
    if (_pushNotiDic == nil) {
        self.pushNotiDic = [NSDictionary dictionary];
    }
    return _pushNotiDic;
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static PushNotification *_pushNo = nil;
    dispatch_once(&onceToken, ^{
        _pushNo = [[PushNotification alloc] init];
    });
    return _pushNo;
}
- (UIButton *)cancleBtn {
    if (_cancleBtn == nil) {
        self.cancleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _cancleBtn.frame = CGRectMake(self.alertView.frame.size.width - 40, self.alertView.frame.origin.y-16.8, 25, 25);
        _cancleBtn.layer.cornerRadius = 12.5;
        _cancleBtn.layer.masksToBounds = YES;
        _cancleBtn.layer.borderWidth = 0.8;
        _cancleBtn.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:0.8] CGColor];
        //        _cancleBtn.backgroundColor = [UIColor redColor];
        [_cancleBtn setBackgroundImage:[UIImage imageNamed:[[NSBundle mainBundle] pathForResource:@"btn.comment.cancel" ofType:@"png"]] forState:(UIControlStateNormal)];
        [_cancleBtn addTarget:self action:@selector(handleCancelBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancleBtn;
}

#pragma mark 对外的接口
/**
 *  注册极光推送
 *
 *  @param launchOptions 当前应用启动原因
 */
-(void)registerForRemoteNotificationWithLaunchOptions:(NSDictionary *)launchOptions application:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
    // register JPush
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    [APService setupWithOption:launchOptions];
//    [APService setBadge:+1];
    // self.pushNotiDic = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    [self checkTheAppLaunchedWithlaunchOptions:launchOptions];
}

//处理远程消息
- (void)handleRemoteNotificationWithApplication:(UIApplication *)application userInfo:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    self.pushNotiDic = userInfo;
    if (IOS7Later) {
        completionHandler(UIBackgroundFetchResultNewData);
    }
    
    if (application.applicationState == UIApplicationStateActive) {
        
        [self putAlertViewOfNotification];// 前台弹窗
    } else if (application.applicationState == UIApplicationStateInactive) {
        
        [self handleTapAction];//当前应用不活跃状态时，不显示弹框
    } else if (application.applicationState == UIApplicationStateBackground) {
        
        [self handleTapAction];
    }
}

- (void)registerDeviceToken:(NSData *)deviceToken {
    [APService registerDeviceToken:deviceToken];
}

// 设置别名，当用户重新登录时需要恢复远程推送，方法：重新注册
- (void)setAliasWithloginedUserID:(NSString *)userID session:(NSString *)session {
    
    if (_isUnregister) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            
            //可以添加自定义categories
            [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                           UIUserNotificationTypeSound |
                                                           UIUserNotificationTypeAlert)
                                               categories:nil];
        } else {
            //categories 必须为nil
            [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                           UIRemoteNotificationTypeSound |
                                                           UIRemoteNotificationTypeAlert)
                                               categories:nil];
        }
#else
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
#endif
    }

    NSString *alias = [NSString stringWithFormat:@"house_%@",userID];
    [APService setAlias:alias callbackSelector:nil object:nil];
}

// 账号退出时，停止接收远程消息
- (void)cancleAlias {
    
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    _isUnregister = YES;
}

#pragma mark  私有方法
/**
 *  判断当前应用启动的原因
 *
 *  @param launchOptions 启动应用的参数
 */
- (void)checkTheAppLaunchedWithlaunchOptions:(NSDictionary *)launchOptions {
    NSString *launchStr = [[launchOptions allKeys] firstObject];
    if([launchStr isEqualToString:kRemoNoti]) {
        
    }
    if([launchStr isEqualToString:kLocalNoti]) {
        
    }
}
/**
 *  设置接收到远程推送的角标
 *
 *  @param application 当前接收到推送消息的应用
 */
- (void)checkTheAppBadgeNumberWithApplication:(UIApplication *)application withLaunchOptions:(NSDictionary *)launchOptions
{
    NSInteger badgeNum = application.applicationIconBadgeNumber;
    if (nil == [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] && badgeNum != 0) {
//        [self putAlertViewOfNotification];        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒"
//                                                            message:@"医生给您有新回复！"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"取消"
//                                                  otherButtonTitles:@"确定", nil];
//        [alertView show];
    } else {
        
    }
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
}

- (void)checkTheAppBadgeNumberWithApplication:(UIApplication *)application {
    NSInteger badgeNum = application.applicationIconBadgeNumber;
    if (badgeNum != 0) {
//        [self putAlertViewOfNotification];
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒"
//                                                            message:@"医生给您有新回复！"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"取消"
//                                                  otherButtonTitles:@"确定", nil];
//        [alertView show];
    } else {
        [application cancelAllLocalNotifications];
    }
    application.applicationIconBadgeNumber = 0;
}

// 获得当前界面的视图控制器
- (UITabBarController *)getCurrentRootViewController {
    // 获得当前界面的视图
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows) {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    UITabBarController *result = [[UITabBarController alloc] init];
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
//    id nextResponder = [rootView nextResponder];
//    if ([nextResponder isKindOfClass:[UITabBarController class]]) {
//        
//        result = nextResponder;
//    } else if ([nextResponder isKindOfClass:[ChatDataController class]]) {
//        
//    } else {
//        
//        result = (UITabBarController *)topWindow.rootViewController;
//    }
    return result;
}

// 当应用处在前台时，收到推送通知时弹出的通知视图
- (void)putAlertViewOfNotification {
    //添加弹框
    self.currentViewController = [self getCurrentRootViewController];
    if (_isChatVC) {
        
        _isChatViewController = YES;
        if (![self.questionID isEqualToString:[self.pushNotiDic objectForKey:@"question_id"]]) {
            
            [self.alertView addSubview:self.cancleBtn];
            [self.currentViewController.view addSubview:self.alertView];
        }
    } else {
        
        [self.alertView addSubview:self.cancleBtn];
        [self.currentViewController.view addSubview:self.alertView];
    }
    _isForeGround = YES;
    //为弹窗添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction)];
    tap.delegate = self;
    [self.alertView addGestureRecognizer:tap];
}

//点击推送消息时时响应的方法
- (void)handleTapAction {
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
////    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    if (nil == self.currentViewController) {
//        self.currentViewController = [self getCurrentRootViewController];
//    }
//    self.currentViewController.selectedIndex = 1;
//    UINavigationController *navi = [self.currentViewController.viewControllers objectAtIndex:1];
//    UINavigationController *naviga = [self.currentViewController.viewControllers objectAtIndex:0];
//
//    //判断用户是否是点击弹窗
//    NSString *type  = [NSString stringWithFormat:@"%@",[self.pushNotiDic objectForKey:@"type"]];
//    if ([type isEqualToString:@"1"]) {
//        NSString *question_id = [self.pushNotiDic objectForKey:@"question_id"];
//        self.chatVC.portrit = [UserTmpParam getPortraitUrl];
//        self.chatVC.ask_name = [UserTmpParam getUserNick];
//        self.chatVC.user_id = [self.pushNotiDic objectForKey:@"user_id"];
//        self.chatVC.question_id = question_id;
//        if (_isChatVC) {
//            if (![self.questionID isEqualToString:question_id]) {
//                [navi popViewControllerAnimated:YES];
//                _isChatVC = NO;
//                _chatVC = nil;
//                self.chatVC.portrit = [UserTmpParam getPortraitUrl];
//                self.chatVC.ask_name = [UserTmpParam getUserNick];
//                self.chatVC.user_id = [self.pushNotiDic objectForKey:@"user_id"];
//                self.chatVC.question_id = question_id;
//            }
//        }
//        self.remoteNotifi = YES;
//        self.chatVC.hidesBottomBarWhenPushed = YES;
//        if (!_isChatVC) {
//            [navi pushViewController:self.chatVC animated:YES];
//        }
//    }else if([type isEqualToString:@"2"]){
//        self.currentViewController.selectedIndex = 0;
//        MyMessageInfoViewController *myInfoVC = [[MyMessageInfoViewController alloc] init];
//        MyMessageViewController *messageVC = [[MyMessageViewController alloc] init];
//        [naviga pushViewController:messageVC animated:NO];
//        myInfoVC.msg_id = [NSNumber numberWithInteger:[[self.pushNotiDic objectForKey:@"msg_id"] integerValue]];
//        myInfoVC.hidesBottomBarWhenPushed = YES;
//        [messageVC.navigationController pushViewController:myInfoVC animated:YES];
//    }
//    [self.alertView removeFromSuperview];
//    self.alertView = nil;
}
- (void)handleCancelBtn:(id)sender {
    [self.alertView removeFromSuperview];
    self.alertView = nil;
}

#pragma mark MD5加密算法
- (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}
@end