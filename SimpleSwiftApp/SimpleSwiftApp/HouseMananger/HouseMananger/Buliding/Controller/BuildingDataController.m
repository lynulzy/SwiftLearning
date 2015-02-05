//
//  BuildingDataController.m
//  HouseMananger
//
//  Created by 王晗 on 15/1/27.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "BuildingDataController.h"

#import "Utils.h"

#define HTTP_CONTROLLER_BUILD   12356
#define URL_BUILD               @"build_customer"

@implementation BuildingDataController

- (void)mrBuilding:(NSDictionary *)theParams {
    // Tag
    NSInteger iTag					= HTTP_CONTROLLER_BUILD;
    // HTTP
    NSString *url					= URL_BASE_TEST;
    HttpConnMethod httpMethod		= HttpConnMethod_POST;
    NSMutableDictionary	*getParam	= [[NSMutableDictionary alloc] init];
    NSMutableDictionary	*postParam	= [[NSMutableDictionary alloc] init];
    // Cache
    NSString *identifier			= [[NSString alloc] initWithFormat:@"MY_ADD_CUS_LIST"];
    NSString *path					= [[NSString alloc] initWithFormat:@"API"];
    NSString *fileName				= [[NSString alloc] initWithFormat:@"MY_ADD_CUS_LIST"];
    // Use cache
    UseCache useCache				= UseCache_NOUSE;
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    [bodyDic setObject:[theParams objectForKey:@"customers"]      forKey:@"customers"];
    [bodyDic setObject:[theParams objectForKey:@"session"]         forKey:@"session"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:0 error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    NSString *dateStr = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    [postParam setObject:jsonStr                            forKey:@"data"];
    [postParam setObject:APP_ID                             forKey:@"app_id"];
    [postParam setObject:APP_SECRET                         forKey:@"app_secret"];
    [postParam setObject:SESSION_KEY                        forKey:@"session_key"];
    [postParam setObject:URL_BUILD                          forKey:@"act"];
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
    
    if (HTTP_CONTROLLER_BUILD == tag) {
        
        if ([self.delegate respondsToSelector:@selector(onGetBuildingReceiveData:withReqTag:)]) {
            [self.delegate onGetBuildingReceiveData:data withReqTag:tag];
        }
    }
}

- (void)requestFailed:(NSInteger)tag error:(NSError *)error {
    
    if (HTTP_CONTROLLER_BUILD == tag) {
        
        if ([self.delegate respondsToSelector:@selector(onGetBuildingFailedWithError:withReqTag:)]) {
            [self.delegate onGetBuildingFailedWithError:error withReqTag:tag];
        }
    }
}

@end
