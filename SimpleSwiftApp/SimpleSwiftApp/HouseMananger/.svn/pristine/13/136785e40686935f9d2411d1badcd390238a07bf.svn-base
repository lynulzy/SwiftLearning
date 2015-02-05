//
//  TalkingDetailDataController.m
//  HouseMananger
//
//  Created by ZXH on 15/1/16.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "TalkingDetailDataController.h"

#import "Utils.h"

@implementation TalkingDetailDataController

- (void)mrTalkingDetail:(NSDictionary *)theParams {
    // Tag
    NSInteger iTag					= HTTP_CONTROLLER_TALKING_DETAIL;
    // HTTP
    NSString *url					= URL_BASE_TEST;
    HttpConnMethod httpMethod		= HttpConnMethod_POST;
    NSMutableDictionary	*getParam	= [[NSMutableDictionary alloc] init];
    NSMutableDictionary	*postParam	= [[NSMutableDictionary alloc] init];
    // Cache
    NSString *identifier			= [[NSString alloc] initWithFormat:@"MY_TALKING_DETAIL"];
    NSString *path					= [[NSString alloc] initWithFormat:@"API"];
    NSString *fileName				= [[NSString alloc] initWithFormat:@"MY_TALKING_DETAIL"];
    // Use cache
    UseCache useCache				= UseCache_NOUSE;
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    [bodyDic setObject:[theParams objectForKey:@"say_id"]       forKey:@"say_id"];
    [bodyDic setObject:[theParams objectForKey:@"build_id"]     forKey:@"build_id"];
    [bodyDic setObject:[theParams objectForKey:@"page"]         forKey:@"page"];
    [bodyDic setObject:[theParams objectForKey:@"page_size"]    forKey:@"page_size"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:0 error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    NSString *dateStr = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    [postParam setObject:jsonStr                            forKey:@"data"];
    [postParam setObject:APP_ID                             forKey:@"app_id"];
    [postParam setObject:APP_SECRET                         forKey:@"app_secret"];
    [postParam setObject:SESSION_KEY                        forKey:@"session_key"];
    [postParam setObject:URL_TALKING_DETAIL                 forKey:@"act"];
    [postParam setObject:dateStr                            forKey:@"timestamp"];
    [postParam setObject:[Utils signWithParam3:postParam]   forKey:@"sig"];
    
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
    
    if (HTTP_CONTROLLER_TALKING_DETAIL == tag) {
        
        if ([self.delegate respondsToSelector:@selector(onGetTalkingDetailReceiveData:withReqTag:)]) {
            [self.delegate onGetTalkingDetailReceiveData:data withReqTag:tag];
        }
    }
}

- (void)requestFailed:(NSInteger)tag error:(NSError *)error {
    
    if (HTTP_CONTROLLER_TALKING_DETAIL == tag) {
        
        if ([self.delegate respondsToSelector:@selector(onGetTalkingDetailFailedWithError:withReqTag:)]) {
            [self.delegate onGetTalkingDetailFailedWithError:error withReqTag:tag];
        }
    }
}

@end
