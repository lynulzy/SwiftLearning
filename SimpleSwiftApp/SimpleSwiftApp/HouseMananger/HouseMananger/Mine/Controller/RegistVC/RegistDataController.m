//
//  RegistDataController.m
//  MiShiClient-Pro
//
//  Created by ZXH on 14-10-16.
//  Copyright (c) 2014年 ZSXJ. All rights reserved.
//

#import "RegistDataController.h"
#import "Utils.h"
#import "Param.h"
#import "HTTPDefine.h"

@implementation RegistDataController
// 注册
- (void)makeRegistRequest:(NSDictionary *)theParams {
    // Tag
    NSInteger iTag					= HTTP_CONTROLLER_REGIST;
    // HTTP
    NSString *url					= URL_BASE_TEST;
    HttpConnMethod httpMethod		= HttpConnMethod_POST;
    NSMutableDictionary	*getParam	= [[NSMutableDictionary alloc] init];
    NSMutableDictionary	*postParam	= [[NSMutableDictionary alloc] init];
    // Cache
    NSString *identifier			= [[NSString alloc] initWithFormat:@"REGIST"];
    NSString *path					= [[NSString alloc] initWithFormat:@"API"];
    NSString *fileName				= [[NSString alloc] initWithFormat:@"REGIST"];
    // Use cache
    UseCache useCache				= UseCache_NOUSE;
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:theParams options:0 error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    NSString *dateStr = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    [postParam setObject:jsonStr          forKey:@"data"];
    [postParam setObject:APP_ID           forKey:@"app_id"];
    [postParam setObject:APP_SECRET       forKey:@"app_secret"];
    [postParam setObject:SESSION_KEY      forKey:@"session_key"];
    [postParam setObject:URL_REGITST      forKey:@"act"];
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

#pragma mark ReqManagerDelegate
- (void)requestFinished:(NSInteger)tag retcode:(NSInteger)retcode receiveData:(NSDictionary *)data {
    
    if (HTTP_CONTROLLER_REGIST == tag) {
        
        if ([self.delegate respondsToSelector:@selector(onGetRegistData:withReqTag:)]) {
            
            [self.delegate onGetRegistData:data withReqTag:tag];
        }
    }
}

- (void)requestFailed:(NSInteger)tag error:(NSError *)error {
    
    if (HTTP_CONTROLLER_REGIST == tag) {
        if ([self.delegate respondsToSelector:@selector(onFailedGetRegistData:witReqTag:)]) {
            
            [self.delegate onFailedGetRegistData:error witReqTag:tag];
        }
    }
}

@end
