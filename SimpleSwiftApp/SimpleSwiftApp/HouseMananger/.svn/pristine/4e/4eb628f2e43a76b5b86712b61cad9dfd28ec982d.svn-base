//
//  PublishDataController.m
//  MiShiClient-Pro
//
//  Created by ZXH on 14/11/10.
//  Copyright (c) 2014年 zsxj. All rights reserved.
//

#import "PublishDataController.h"

#import "Utils.h"
#import "UserTmpParam.h"

#define HTTP_CONTROLLER_PUBLISH     12345678

@implementation PublishDataController

- (void)mrPublishQuestion:(NSDictionary *)theParams {
    
    // Tag
    NSInteger iTag					= HTTP_CONTROLLER_PUBLISH;
    // HTTP
    NSString *url					= URL_BASE_TEST;
    HttpConnMethod httpMethod		= HttpConnMethod_POST;
    NSMutableDictionary	*getParam	= [[NSMutableDictionary alloc] init];
    NSMutableDictionary	*postParam	= [[NSMutableDictionary alloc] init];
    // Cache
    NSString *identifier			= [[NSString alloc] initWithFormat:@"GET_PUBLISH_QUESTION"];
    NSString *path					= [[NSString alloc] initWithFormat:@"API"];
    NSString *fileName				= [[NSString alloc] initWithFormat:@"GET_PUBLISH_QUESTION"];
    // Use cache
    UseCache useCache				= UseCache_NOUSE;
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    [bodyDic setObject:[UserTmpParam getUserId]                 forKey:@"user_id"];
    [bodyDic setObject:[UserTmpParam getSession]                forKey:@"session"];
    [bodyDic setObject:[theParams objectForKey:@"content"]      forKey:@"content"];
    [bodyDic setObject:[theParams objectForKey:@"build_id"]     forKey:@"build_id"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:0 error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    NSString *dateStr = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    [postParam setObject:[theParams objectForKey:@"fname[]"]    forKey:@"fname[]"];
    [postParam setObject:jsonStr                                forKey:@"data"];
    [postParam setObject:APP_ID                                 forKey:@"app_id"];
    [postParam setObject:APP_SECRET                             forKey:@"app_secret"];
    [postParam setObject:SESSION_KEY                            forKey:@"session_key"];
    [postParam setObject:@"submit_say"                          forKey:@"act"];
    [postParam setObject:dateStr                                forKey:@"timestamp"];
    [postParam setObject:[Utils signWithParam3:postParam]       forKey:@"sig"];

    
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
    // End
}

#pragma mark ReqManagerDelegate
- (void)requestFinished:(NSInteger)tag retcode:(NSInteger)retcode receiveData:(NSDictionary *)data {
    
    if (HTTP_CONTROLLER_PUBLISH == tag) {
        
        DDLog(@"%@",data);
        NSMutableDictionary *dic = [data objectForKey:@"content"];
        [self.delegate onGetPublishData:tag receiveData:dic];
    }
}

- (void)requestFailed:(NSInteger)tag error:(NSError *)error {
    
    if (HTTP_CONTROLLER_PUBLISH == tag) {
        
        [self.delegate onGetPublishRequestError:tag error:error];
    }
}

@end
