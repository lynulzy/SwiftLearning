//
//  LoginDataController.m
//  HouseMananger
//
//  Created by ZXH on 15/1/5.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "LoginDataController.h"

#import "DataDefine.h"
#import "HTTPDefine.h"

#import "UserDefaults.h"
#import "UserTmpParam.h"

#import "UIDevice+IdentifierAddition.h"
#import "JSON.h"
#import "Utils.h"
#import "Param.h"
#import "MD5.h"
#import "RC4.h"
#import "Base64.h"

@interface LoginDataController ()

@property (nonatomic, copy) NSString *thePassWord;

@end


@implementation LoginDataController

- (void)makeLoginRequest:(NSDictionary *)theParams {

    self.thePassWord = [theParams objectForKey:@"password"];
    
    // Tag
    NSInteger iTag					= HTTP_CONTROLLER_LOGIN;
    // HTTP
    NSString *url					= URL_BASE_TEST;
    HttpConnMethod httpMethod		= HttpConnMethod_POST;
    NSMutableDictionary	*getParam	= [[NSMutableDictionary alloc] init];
    NSMutableDictionary	*postParam	= [[NSMutableDictionary alloc] init];
    // Cache
    NSString *identifier			= [[NSString alloc] initWithFormat:@"LOGIN"];
    NSString *path					= [[NSString alloc] initWithFormat:@"API"];
    NSString *fileName				= [[NSString alloc] initWithFormat:@"LOGIN"];
    // Use cache
    UseCache useCache				= UseCache_NOUSE;
    
    NSString *thePassword = [Base64 base64EncodeData:[RC4 rc4:[[[theParams objectForKey:@"password"] dataUsingEncoding:NSUTF8StringEncoding] mutableCopy] key:RC4_SIGN_KEY]];
    NSString *theDeviceID = [Param getDeviceId];
    NSString *mobileModelStr = [[UIDevice currentDevice] model];// 手机型号
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    [bodyDic setObject:[theParams objectForKey:@"mobile"]   forKey:@"mobile"];
    [bodyDic setObject:thePassword                          forKey:@"password"];
    [bodyDic setObject:theDeviceID                          forKey:@"deviceid"];
    [bodyDic setObject:@"2"                                 forKey:@"pingtai"];
    [bodyDic setObject:mobileModelStr                       forKey:@"ext"];
    [bodyDic setObject:@"AppStore"                          forKey:@"utm"];
    [bodyDic setObject:@"1.0"                               forKey:@"ver"];// 软件版本

    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:0 error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    NSString *dateStr = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    [postParam setObject:jsonStr          forKey:@"data"];
    [postParam setObject:APP_ID           forKey:@"app_id"];
    [postParam setObject:APP_SECRET       forKey:@"app_secret"];
    [postParam setObject:SESSION_KEY      forKey:@"session_key"];
    [postParam setObject:URL_LOGIN        forKey:@"act"];
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
    
    if (HTTP_CONTROLLER_LOGIN == tag) {
        //保存用户名--自动登录
        [UserDefaults setPassword:self.thePassWord];
        [UserDefaults setMobile:[[data objectForKey:@"content"] objectForKey:@"mobile"]];
        
        [UserTmpParam setUserId:[[data objectForKey:@"content"] objectForKey:@"user_id"]];
        [UserTmpParam setSession:[[data objectForKey:@"content"] objectForKey:@"session"]];
        
        if ([self.delegate respondsToSelector:@selector(onGetLoginReceiveData:withReqTag:)]) {
            [self.delegate onGetLoginReceiveData:data withReqTag:tag];
        }
    }
}

- (void)requestFailed:(NSInteger)tag error:(NSError *)error {
    
    if (HTTP_CONTROLLER_LOGIN == tag) {
        
        if ([self.delegate respondsToSelector:@selector(onGetLoginFailedWithError:withReqTag:)]) {
            [self.delegate onGetLoginFailedWithError:error withReqTag:tag];
        }
    }
}

@end
