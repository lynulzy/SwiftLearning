//
//  ReplyDataController.m
//  HouseMananger
//
//  Created by ZXH on 15/1/19.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "ReplyDataController.h"
#import "Utils.h"

@implementation ReplyDataController

- (void)mrReply:(NSDictionary *)theParams {
    // Tag
    NSInteger iTag					= HTTP_CONTROLLER_REPLY;
    // HTTP
    NSString *url					= URL_BASE_TEST;
    HttpConnMethod httpMethod		= HttpConnMethod_POST;
    NSMutableDictionary	*getParam	= [[NSMutableDictionary alloc] init];
    NSMutableDictionary	*postParam	= [[NSMutableDictionary alloc] init];
    // Cache
    NSString *identifier			= [[NSString alloc] initWithFormat:@"REPLY"];
    NSString *path					= [[NSString alloc] initWithFormat:@"API"];
    NSString *fileName				= [[NSString alloc] initWithFormat:@"REPLY"];
    // Use cache
    UseCache useCache				= UseCache_NOUSE;
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    [bodyDic setObject:[theParams objectForKey:@"user_id"]      forKey:@"user_id"];
    [bodyDic setObject:[theParams objectForKey:@"user_id_2"]    forKey:@"user_id_2"];
    [bodyDic setObject:[theParams objectForKey:@"session"]      forKey:@"session"];
    [bodyDic setObject:[theParams objectForKey:@"content"]      forKey:@"content"];
    [bodyDic setObject:[theParams objectForKey:@"flag"]         forKey:@"flag"];
    [bodyDic setObject:[theParams objectForKey:@"build_id"]     forKey:@"build_id"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:0 error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    NSString *dateStr = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    [postParam setObject:jsonStr                            forKey:@"data"];
    [postParam setObject:APP_ID                             forKey:@"app_id"];
    [postParam setObject:APP_SECRET                         forKey:@"app_secret"];
    [postParam setObject:SESSION_KEY                        forKey:@"session_key"];
    [postParam setObject:URL_TALKING_REPLY                  forKey:@"act"];
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
    
    if (HTTP_CONTROLLER_REPLY == tag) {
        
        if ([self.delegate respondsToSelector:@selector(onGetReplyReceiveData:withReqTag:)]) {
            [self.delegate onGetReplyReceiveData:data withReqTag:tag];
        }
    }
}

- (void)requestFailed:(NSInteger)tag error:(NSError *)error {
    
    if (HTTP_CONTROLLER_REPLY == tag) {
        
        if ([self.delegate respondsToSelector:@selector(onGetReplyFailedWithError:withReqTag:)]) {
            [self.delegate onGetReplyFailedWithError:error withReqTag:tag];
        }
    }
}

@end
