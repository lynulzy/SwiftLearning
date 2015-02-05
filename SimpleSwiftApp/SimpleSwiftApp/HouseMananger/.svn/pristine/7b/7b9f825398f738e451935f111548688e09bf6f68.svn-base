//
//  UserSuggestDataController.m
//  MiShiClient-Pro
//
//  Created by ZXH on 14/12/23.
//  Copyright (c) 2014年 ZSXJ. All rights reserved.
//

#import "UserSuggestDataController.h"

#import "Define.h"
#import "DataDefine.h"
#import "JSON.h"
#import "Param.h"
#import "Utils.h"
#import "MD5.h"
#import "UIDevice+IdentifierAddition.h"
#import "HTTPDefine.h"

@implementation UserSuggestDataController

- (void)mrUserSuggest:(NSDictionary *)theParams {
    
    // Tag
    NSInteger iTag					= HTTP_CONTROLLER_USER_FEEDBACK;
    // HTTP
    NSString *url					= URL_BASE_TEST;
    HttpConnMethod httpMethod		= HttpConnMethod_POST;
    NSMutableDictionary	*getParam	= [[NSMutableDictionary alloc] init];
    NSMutableDictionary	*postParam	= [[NSMutableDictionary alloc] init];
    // Cache
    NSString *identifier			= [[NSString alloc] initWithFormat:@"GET_USER_FEEDBACK"];
    NSString *path					= [[NSString alloc] initWithFormat:@"API"];
    NSString *fileName				= [[NSString alloc] initWithFormat:@"GET_USER_FEEDBACK"];
    // Use cache
    UseCache useCache				= UseCache_NOUSE;
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:theParams options:0 error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    NSString *dateStr = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    [postParam setObject:jsonStr            forKey:@"data"];
    [postParam setObject:APP_ID             forKey:@"app_id"];
    [postParam setObject:APP_SECRET         forKey:@"app_secret"];
    [postParam setObject:SESSION_KEY        forKey:@"session_key"];
    [postParam setObject:URL_USER_FEEDBACK  forKey:@"act"];
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
    // End
}

#pragma mark ReqManagerDelegate
- (void)requestFinished:(NSInteger)tag retcode:(NSInteger)retcode receiveData:(NSDictionary *)data {
    
    if (HTTP_CONTROLLER_USER_FEEDBACK == tag) {
        
        DDLog(@"%@",data);
        NSMutableDictionary *dic = [data objectForKey:@"content"];
        [self.delegate onSendUserSuggestData:tag receiveData:dic];
    }
}

- (void)requestFailed:(NSInteger)tag error:(NSError *)error {
    
    if (HTTP_CONTROLLER_USER_FEEDBACK == tag) {
        
        [self.delegate onSendUserSuggestRequestError:tag error:error];
    }
}

@end
