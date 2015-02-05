//
//  EditMyInfoDataController.m
//  HouseMananger
//
//  Created by ZXH on 15/1/14.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "EditMyInfoDataController.h"

#import "Utils.h"
#import "UserTmpParam.h"

@implementation EditMyInfoDataController

// 修改头像
- (void)mrEditPortrait:(NSDictionary *)theParams {
    // Tag
    NSInteger iTag					= HTTP_CONTROLLER_EDIT_PORTRAIT;
    // HTTP
    NSString *url					= URL_BASE_TEST;
    HttpConnMethod httpMethod		= HttpConnMethod_POST;
    NSMutableDictionary	*getParam	= [[NSMutableDictionary alloc] init];
    NSMutableDictionary	*postParam	= [[NSMutableDictionary alloc] init];
    // Cache
    NSString *identifier			= [[NSString alloc] initWithFormat:@"EDIT_PORTRAIT"];
    NSString *path					= [[NSString alloc] initWithFormat:@"API"];
    NSString *fileName				= [[NSString alloc] initWithFormat:@"EDIT_PORTRAIT"];
    // Use cache
    UseCache useCache				= UseCache_NOUSE;
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    [bodyDic setObject:[UserTmpParam getUserId]                 forKey:@"user_id"];
    [bodyDic setObject:[UserTmpParam getSession]                forKey:@"session"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:0 error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    NSString *dateStr = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    [postParam setObject:[theParams objectForKey:@"portrait"]   forKey:@"portrait"];
    [postParam setObject:jsonStr                                forKey:@"data"];
    [postParam setObject:APP_ID                                 forKey:@"app_id"];
    [postParam setObject:APP_SECRET                             forKey:@"app_secret"];
    [postParam setObject:SESSION_KEY                            forKey:@"session_key"];
    [postParam setObject:URL_EDIT_PORTRAIT                      forKey:@"act"];
    [postParam setObject:dateStr                                forKey:@"timestamp"];
    [postParam setObject:[Utils signWithParam3:postParam]		forKey:@"sig"];
    
    [self sendRequest:iTag
              withUrl:url
           withMethod:httpMethod
         withGetParam:getParam
        withPostParam:postParam
       withIdentifier:identifier
             withPath:path
         withFileName:fileName
         withUseCache:useCache];
    
    url = nil;
    identifier = nil;
    path = nil;
    fileName = nil;
    getParam = nil;
    postParam = nil;
}

// 修改姓名
- (void)mrEditUser:(NSDictionary *)theParams {
    // Tag
    NSInteger iTag					= HTTP_CONTROLLER_EDIT_USER;
    // HTTP
    NSString *url					= URL_BASE_TEST;
    HttpConnMethod httpMethod		= HttpConnMethod_POST;
    NSMutableDictionary	*getParam	= [[NSMutableDictionary alloc] init];
    NSMutableDictionary	*postParam	= [[NSMutableDictionary alloc] init];
    // Cache
    NSString *identifier			= [[NSString alloc] initWithFormat:@"EDIT_USER"];
    NSString *path					= [[NSString alloc] initWithFormat:@"API"];
    NSString *fileName				= [[NSString alloc] initWithFormat:@"EDIT_USER"];
    // Use cache
    UseCache useCache				= UseCache_NOUSE;
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    [bodyDic setObject:[theParams objectForKey:@"username"]         forKey:@"username"];
    [bodyDic setObject:[UserTmpParam getUserId]                     forKey:@"user_id"];
    [bodyDic setObject:[UserTmpParam getSession]                    forKey:@"session"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:0 error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    NSString *dateStr = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    [postParam setObject:jsonStr            forKey:@"data"];
    [postParam setObject:APP_ID             forKey:@"app_id"];
    [postParam setObject:APP_SECRET         forKey:@"app_secret"];
    [postParam setObject:SESSION_KEY        forKey:@"session_key"];
    [postParam setObject:URL_EDIT_USER      forKey:@"act"];
    [postParam setObject:dateStr            forKey:@"timestamp"];
    [postParam setObject:[Utils signWithParam3:postParam]		forKey:@"sig"];
    
    [self sendRequest:iTag
              withUrl:url
           withMethod:httpMethod
         withGetParam:getParam
        withPostParam:postParam
       withIdentifier:identifier
             withPath:path
         withFileName:fileName
         withUseCache:useCache];
    
    url = nil;
    identifier = nil;
    path = nil;
    fileName = nil;
    getParam = nil;
    postParam = nil;
}

// 退出登录
- (void)mrSignOut {
    
    // Tag
    NSInteger iTag					= HTTP_CONTROLLER_LOGOUT;
    // HTTP
    NSString *url					= URL_BASE_TEST;
    HttpConnMethod httpMethod		= HttpConnMethod_POST;
    NSMutableDictionary	*getParam	= [[NSMutableDictionary alloc] init];
    NSMutableDictionary	*postParam	= [[NSMutableDictionary alloc] init];
    // Cache
    NSString *identifier			= [[NSString alloc] initWithFormat:@"SIGN_OUT"];
    NSString *path					= [[NSString alloc] initWithFormat:@"API"];
    NSString *fileName				= [[NSString alloc] initWithFormat:@"SIGN_OUT"];
    // Use cache
    UseCache useCache				= UseCache_NOUSE;
    
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    [bodyDic setObject:[UserTmpParam getSession]           forKey:@"session"];
    [bodyDic setObject:[UserTmpParam getUserId]            forKey:@"user_id"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:0 error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    NSString *dateStr = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    [postParam setObject:jsonStr          forKey:@"data"];
    [postParam setObject:APP_ID           forKey:@"app_id"];
    [postParam setObject:APP_SECRET       forKey:@"app_secret"];
    [postParam setObject:SESSION_KEY      forKey:@"session_key"];
    [postParam setObject:URL_SIGN_OUT        forKey:@"act"];
    [postParam setObject:dateStr          forKey:@"timestamp"];
    [postParam setObject:[Utils signWithParam3:postParam]		forKey:@"sig"];
    
    [self sendRequest:iTag
              withUrl:url
           withMethod:httpMethod
         withGetParam:getParam
        withPostParam:postParam
       withIdentifier:identifier
             withPath:path
         withFileName:fileName
         withUseCache:useCache];
    
    url = nil;
    identifier = nil;
    path = nil;
    fileName = nil;
    getParam = nil;
    postParam = nil;
}

- (void)requestFinished:(NSInteger)tag retcode:(NSInteger)retcode receiveData:(NSDictionary *)data {
    
    if (HTTP_CONTROLLER_EDIT_PORTRAIT == tag) {
        
        if ([self.delegate respondsToSelector:@selector(onGetEditPortraitReceiveData:withReqTag:)]) {
            [self.delegate onGetEditPortraitReceiveData:data withReqTag:tag];
        }
    }
    
    if (HTTP_CONTROLLER_EDIT_USER == tag) {
        
        if ([self.delegate respondsToSelector:@selector(onGetEditUserReceiveData:withReqTag:)]) {
            [self.delegate onGetEditUserReceiveData:data withReqTag:tag];
        }
    }
    
    if (HTTP_CONTROLLER_LOGOUT == tag) {
        if ([self.delegate respondsToSelector:@selector(onGetSignOutFailedWithError:withReqTag:)]) {
            [self.delegate onGetSignOutReceiveData:data withReqTag:tag];
        }
    }
}

- (void)requestFailed:(NSInteger)tag error:(NSError *)error {
    
    if (HTTP_CONTROLLER_EDIT_PORTRAIT == tag) {
        
        if ([self.delegate respondsToSelector:@selector(onGetEditPortraitFailedWithError:withReqTag:)]) {
            [self.delegate onGetEditPortraitFailedWithError:error withReqTag:tag];
        }
    }
    
    if (HTTP_CONTROLLER_EDIT_USER == tag) {
        
        if ([self.delegate respondsToSelector:@selector(onGetEditUserFailedWithError:withReqTag:)]) {
            [self.delegate onGetEditUserFailedWithError:error withReqTag:tag];
        }
    }
    
    if (HTTP_CONTROLLER_LOGOUT == tag) {
        
        if ([self.delegate respondsToSelector:@selector(onGetSignOutFailedWithError:withReqTag:)]) {
            [self.delegate onGetSignOutFailedWithError:error withReqTag:tag];
        }
    }
}

@end
