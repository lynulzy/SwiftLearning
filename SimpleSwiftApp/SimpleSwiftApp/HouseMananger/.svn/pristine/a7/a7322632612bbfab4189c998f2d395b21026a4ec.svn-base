//
//  ResetPasswordDataController.m
//  HouseMananger
//
//  Created by ZXH on 15/1/9.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "ResetPasswordDataController.h"

#import "Utils.h"
#import "HTTPDefine.h"

@implementation ResetPasswordDataController

- (void)mrResetPassword:(NSDictionary *)theParams {
    // Tag
    NSInteger iTag					= HTTP_CONTROLLER_RESET_PSW;
    // HTTP
    NSString *url					= URL_BASE_TEST;
    HttpConnMethod httpMethod		= HttpConnMethod_POST;
    NSMutableDictionary	*getParam	= [[NSMutableDictionary alloc] init];
    NSMutableDictionary	*postParam	= [[NSMutableDictionary alloc] init];
    // Cache
    NSString *identifier			= [[NSString alloc] initWithFormat:@"RESET_PSW"];
    NSString *path					= [[NSString alloc] initWithFormat:@"API"];
    NSString *fileName				= [[NSString alloc] initWithFormat:@"RESET_PSW"];
    // Use cache
    UseCache useCache				= UseCache_NOUSE;
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:theParams options:0 error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    NSString *dateStr = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    [postParam setObject:jsonStr          forKey:@"data"];
    [postParam setObject:APP_ID           forKey:@"app_id"];
    [postParam setObject:APP_SECRET       forKey:@"app_secret"];
    [postParam setObject:SESSION_KEY      forKey:@"session_key"];
    [postParam setObject:URL_RESET_PSW    forKey:@"act"];
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

#pragma mark - RequestManagerDelegate
- (void)requestFinished:(NSInteger)tag retcode:(NSInteger)retcode receiveData:(NSDictionary *)data {
    
    if ( HTTP_CONTROLLER_RESET_PSW == tag && [self.delegate respondsToSelector:@selector(onGetResetPSWRequest:withTag:)]) {
        
        [self.delegate onGetResetPSWRequest:data withTag:tag];
    }
}

- (void)requestFailed:(NSInteger)tag error:(NSError *)error {
    
    if (HTTP_CONTROLLER_RESET_PSW == tag && [self.delegate respondsToSelector:@selector(failedGetResetPSWRequest:withTag:)]) {
        
        [self.delegate failedGetResetPSWRequest:error withTag:tag];
    }
}

@end

