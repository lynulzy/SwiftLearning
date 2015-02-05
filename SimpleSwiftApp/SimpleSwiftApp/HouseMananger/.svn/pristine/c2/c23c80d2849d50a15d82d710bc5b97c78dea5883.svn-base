//
//  MineDataController.m
//  HouseMananger
//
//  Created by ZXH on 15/1/5.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "MineDataController.h"

#import "Utils.h"
#import "UserTmpParam.h"

@implementation MineDataController

- (void)mrSoftUpgrade {
        
    // Tag
    NSInteger iTag					= HTTP_CONTROLLER_UPGRADE;
    // HTTP
    NSString *url					= URL_BASE_TEST;
    HttpConnMethod httpMethod		= HttpConnMethod_POST;
    NSMutableDictionary	*getParam	= [[NSMutableDictionary alloc] init];
    NSMutableDictionary	*postParam	= [[NSMutableDictionary alloc] init];
    // Cache
    NSString *identifier			= [[NSString alloc] initWithFormat:@"UPGRADE"];
    NSString *path					= [[NSString alloc] initWithFormat:@"API"];
    NSString *fileName				= [[NSString alloc] initWithFormat:@"UPGRADE"];
    // Use cache
    UseCache useCache				= UseCache_NOUSE;
    
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    [bodyDic setObject:[UserTmpParam getSession]           forKey:@"session"];
    [bodyDic setObject:[UserTmpParam getUserId]            forKey:@"user_id"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:0 error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    NSString *dateStr = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    [postParam setObject:jsonStr                                forKey:@"data"];
    [postParam setObject:APP_ID                                 forKey:@"app_id"];
    [postParam setObject:APP_SECRET                             forKey:@"app_secret"];
    [postParam setObject:SESSION_KEY                            forKey:@"session_key"];
    [postParam setObject:URL_UPGRADE                            forKey:@"act"];
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

- (void)requestFinished:(NSInteger)tag retcode:(NSInteger)retcode receiveData:(NSDictionary *)data {
    
    if (HTTP_CONTROLLER_UPGRADE == tag) {
        if ([self.delegate respondsToSelector:@selector(onGetSoftUpgradeReceiveData:withReqTag:)]) {
            [self.delegate onGetSoftUpgradeReceiveData:data withReqTag:tag];
        }
    }
}

- (void)requestFailed:(NSInteger)tag error:(NSError *)error {
    
    if (HTTP_CONTROLLER_UPGRADE == tag) {
        
        if ([self.delegate respondsToSelector:@selector(onGetSoftUpgradeFailedWithError:withReqTag:)]) {
            [self.delegate onGetSoftUpgradeFailedWithError:error withReqTag:tag];
        }
    }
}

@end
