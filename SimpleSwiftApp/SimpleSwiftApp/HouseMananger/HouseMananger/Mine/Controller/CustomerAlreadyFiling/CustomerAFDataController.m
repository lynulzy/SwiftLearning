//
//  CustomerAFDataController.m
//  HouseMananger
//
//  Created by ZXH on 15/1/26.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "CustomerAFDataController.h"

#import "Utils.h"
#import "UserTmpParam.h"

@implementation CustomerAFDataController

- (void)mrCustomerAF:(NSDictionary *)theParams {
    
    // Tag
    NSInteger iTag					= HTTP_CONTROLLER_CUSTOMER_AF;
    // HTTP
    NSString *url					= URL_BASE_TEST;
    HttpConnMethod httpMethod		= HttpConnMethod_POST;
    NSMutableDictionary	*getParam	= [[NSMutableDictionary alloc] init];
    NSMutableDictionary	*postParam	= [[NSMutableDictionary alloc] init];
    // Cache
    NSString *identifier			= [[NSString alloc] initWithFormat:@"CustomerAF"];
    NSString *path					= [[NSString alloc] initWithFormat:@"API"];
    NSString *fileName				= [[NSString alloc] initWithFormat:@"CustomerAF"];
    // Use cache
    UseCache useCache				= UseCache_NOUSE;
    
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    [bodyDic setObject:[theParams objectForKey:@"page"]         forKey:@"page"];
    [bodyDic setObject:[theParams objectForKey:@"page_size"]    forKey:@"page_size"];
    [bodyDic setObject:[UserTmpParam getSession]                forKey:@"session"];
    [bodyDic setObject:[UserTmpParam getUserId]                 forKey:@"user_id"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:0 error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    
    NSString *dateStr = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    [postParam setObject:jsonStr                                forKey:@"data"];
    [postParam setObject:APP_ID                                 forKey:@"app_id"];
    [postParam setObject:APP_SECRET                             forKey:@"app_secret"];
    [postParam setObject:SESSION_KEY                            forKey:@"session_key"];
    [postParam setObject:URL_CUSTOMER_AF                        forKey:@"act"];
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
    
    if (HTTP_CONTROLLER_CUSTOMER_AF == tag) {
        if ([self.delegate respondsToSelector:@selector(onGetCustomerAFReceiveData:withReqTag:)]) {
            [self.delegate onGetCustomerAFReceiveData:data withReqTag:tag];
        }
    }
}

- (void)requestFailed:(NSInteger)tag error:(NSError *)error {
    
    if (HTTP_CONTROLLER_CUSTOMER_AF == tag) {
        
        if ([self.delegate respondsToSelector:@selector(onGetCustomerAFFailedWithError:withReqTag:)]) {
            [self.delegate onGetCustomerAFFailedWithError:error withReqTag:tag];
        }
    }
}


@end
