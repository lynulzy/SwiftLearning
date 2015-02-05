//
//  PushNotification.h
//  MiShiClient-Pro
//
//  Created by zhangmeng on 14/12/3.
//  Copyright (c) 2014年 zsxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APService.h"

@interface PushNotification : NSObject
@property (nonatomic, assign)BOOL isChatVC;
@property (nonatomic)BOOL isChatViewController;//判断是否在聊天界面
@property (nonatomic, strong)NSString *questionID;//用于存储聊天界面当前的question_id
//@property (nonatomic,assign)BOOL isPublishVC;//判断是不是提交问题pop回来的界面
//@property (nonatomic,assign)BOOL isFromMyInfo;
//@property (nonatomic,assign)BOOL isFromFirstPage;
//@property (nonatomic, assign)BOOL isFromPicView;
//@property (nonatomic, assign)BOOL isFromDetail;
//@property (nonatomic, assign)BOOL isFromLogin;
//@property (nonatomic, assign)BOOL remoteNotifi;
//@property (nonatomic, assign)BOOL isFromModifiy;

//init
+ (instancetype)shareInstance;

//register
- (void)registerForRemoteNotificationWithLaunchOptions:(NSDictionary *)launchOptions application:(UIApplication *)application;

//handle Notification
- (void)handleRemoteNotificationWithApplication:(UIApplication *)application userInfo:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

//deviceToken
- (void)registerDeviceToken:(NSData *)deviceToken;

//set Alias
- (void)setAliasWithloginedUserID:(NSString *)userID session:(NSString *)session;

//cancle Alias
- (void)cancleAlias;
- (void)checkTheAppBadgeNumberWithApplication:(UIApplication *)application;

@end
