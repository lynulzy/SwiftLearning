//
//  ResetCodeDataController.m
//  MiShiClient-Pro
//
//  Created by ZSXJ on 14/10/21.
//  Copyright (c) 2014年 zsxj. All rights reserved.
//

#import "ResetCodeDataController.h"
#import "UserTmpParam.h"
#import "RC4.h"
#include "Utils.h"
#import "Base64.h"
#import "HTTPDefine.h"
#define URL_RESETPW         @"submit_user_reset_pw"

@implementation ResetCodeDataController
- (void)makeResetCodeRequest:(NSDictionary *)theParams
{
    //发送验证码用于重置
    // Tag
    NSInteger iTag					= HTTP_CONTROLLER_SMSCODE;
    // HTTP
    NSString *url					= [[NSString alloc] initWithFormat:@"%@", @""];
    HttpConnMethod httpMethod		= HttpConnMethod_POST;
    NSMutableDictionary	*getParam	= [[NSMutableDictionary alloc] init];
    NSMutableDictionary	*postParam	= [[NSMutableDictionary alloc] init];
    // Cache
    NSString *identifier			= [[NSString alloc] initWithFormat:@"REGITS"];
    NSString *path					= [[NSString alloc] initWithFormat:@"API"];
    NSString *fileName				= [[NSString alloc] initWithFormat:@"RESETPW"];
    // Use cache
    UseCache useCache				= UseCache_NOUSE;
    [postParam setObject:URL_RESETPW forKey:@"act"];
    [postParam setObject:[theParams objectForKey:@"mobile"] forKey:@"mobile"];
    //1128弃用
//    [postParam setObject:[Base64 base64EncodeData:[RC4 rc4:[[[theParams objectForKey:@"password"] dataUsingEncoding:NSUTF8StringEncoding] mutableCopy] key:RC4_SIGN_KEY]]
//                  forKey:@"password"];
//    [postParam setObject:[UserTmpParam getToken] forKey:@"token"];//1:注册  2:重置密码
    [postParam setObject:[Base64 base64EncodeData:[RC4 rc4:[[[theParams objectForKey:@"password"] dataUsingEncoding:NSUTF8StringEncoding] mutableCopy] key:RC4_SIGN_KEY]]
                  forKey:@"user_pwd"];;
    [postParam setObject:[theParams objectForKey:@"smsCode"] forKey:@"sms_code"];
    [postParam setObject:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]]
                  forKey:@"timestamp"];
    [postParam setObject:[Utils signWithParam3:postParam]
                  forKey:@"sig"];
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

- (void)requestFailed:(NSInteger)tag error:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(failedResetRequest:andTag:)])
    {
        [self.delegate failedResetRequest:error andTag:tag];
    }
}

- (void)requestFinished:(NSInteger)tag retcode:(NSInteger)retcode receiveData:(NSDictionary *)data
{
    if ([self.delegate respondsToSelector:@selector(onGetResetRequest:andTag:)])
    {
        [self.delegate onGetResetRequest:data andTag:tag];
    }
}




@end
