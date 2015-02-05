//
//  ReqManager.m
//  TaobaoShow
//
//  Created by TONG YU on 12-4-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReqManager.h"

#import "DataDefine.h"
#import "JSON.h"
#import "Utils.h"

#import "HTTPDefine.h"
#import "UserTmpParam.h"
#import "Base64.h"
#import "RC4.h"
#import "Param.h"
#import "Utils.h"
#import "Define.h" // 在define中添加了通知名称
#import "UserDefaults.h"

@implementation ReqManager

@synthesize delegate;
@synthesize params;
@synthesize useCache;
@synthesize hasExpireData;

- (void)dealloc {
	DDLog(@"ReqManager Dealloc")
    
	if (nil != params) {
        
		[HttpReqControllerQueue removeHttpReq:[[params objectForKey:@"tag"] intValue]];
    }
		
	[params release];
	
	[super dealloc];
}

- (void)sendRequest:(NSDictionary *)theParams delegate:(id)theDelegate useCache:(UseCache)theUseCache {
           
	// Clear 
	if (nil != params) {
		[params release];
		params = nil;
	}
	
	// Set params 
	if (theParams) {
		params = [[NSMutableDictionary alloc] initWithDictionary:theParams];
	}
	delegate = theDelegate;
	useCache = theUseCache;
	
	// Init params 
	hasExpireData = NO;
	
	if (UseCache_USE_NOEXPIRE == useCache ||
        UseCache_USE_EXPIRE == useCache ||
        UseCache_ONLY_CACHE == useCache) {
		
		// Use cache 
		NSDictionary *dic =
        [CacheReqController getDataFromCache:nil
                              useExpireCache:NO
                              withIdentifier:[[theParams objectForKey:@"cache"] objectForKey:@"identifier"]
                                    fromPath:[[theParams objectForKey:@"cache"] objectForKey:@"path"]
                                withFileName:[[theParams objectForKey:@"cache"] objectForKey:@"filename"]
                               hasExpireData:&hasExpireData];
		
		// Get data from cache successful/failed 
		if (nil != dic) {

            [self newRequestFinished:[[theParams objectForKey:@"tag"] intValue]
							 retcode:RET_CODE_OK
						 receiveData:[dic objectForKey:@"value"]];
			return;
		}
		
		// Dic is nil 
		if (UseCache_USE_NOEXPIRE == useCache ||
            UseCache_USE_EXPIRE == useCache) {
			
			// Get data from net 
			[self getDataFromNet:params];
			
		} else if (UseCache_ONLY_CACHE == useCache) {
			
			// Becauseof "UseCache_ONLY_CACHE", return error 
			[delegate requestFailed:[[theParams objectForKey:@"tag"] intValue] error:nil];
			return;
		}
	} else {
		
		// NO use cache, get data from net 
		[self getDataFromNet:params];
	}
}

- (void)getDataFromNet:(NSDictionary *)theParams {
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
        // HTTP
        NSString *url			= theParams[@"http"][@"url"];
        HttpConnMethod method	= [theParams[@"http"][@"method"] intValue];
        NSDictionary *getParam	= theParams[@"http"][@"getParam"];
        NSDictionary *postParam	= theParams[@"http"][@"postParam"];
        // Tag
        NSInteger tag			= [theParams[@"tag"] intValue];
        
        // Encode
        NSString *encodeURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        // Http request
        HttpReqController *httpReqCtrl = [[HttpReqController alloc] initWithURL:encodeURL
                                                                     withMethod:method
                                                                   withGetParam:getParam
                                                                  withPostParam:postParam
                                                                        withTag:tag
                                                                       delegate:self];
        BOOL IsAdd = [HttpReqControllerQueue addHttpReq:httpReqCtrl];
        [httpReqCtrl release];
        
        if (IsAdd) {
            [Utils showNetworkIndicator];
        }
        
    } else {
        if ([self.delegate respondsToSelector:@selector(requestFailed:error:)]) {
            NSError *err =
            [NSError errorWithDomain:ErrDom_Network
                                code:MSG_CODE_NET_NOT_REACHABLITY
                            userInfo:[NSDictionary dictionaryWithObject:ErrInfo_Network forKey:@"msg"]];
            
            [self.delegate requestFailed:[[params objectForKey:@"tag"] intValue] error:err];
        }
    }
}

#pragma mark - HttpReqControllerDelegate
- (void)httpReqFinished:(NSInteger)tag receiveData:(NSData *)data {
	
    [HttpReqControllerQueue removeHttpReq:tag];
	[Utils dismissNetworkIndicator];
	
	if (tag == [[params objectForKey:@"tag"] intValue]) {
        
		[self newRequestFinished:tag retcode:RET_CODE_OK receiveData:data];
		
		// Set cache 
		if ( UseCache_USE_NOEXPIRE == useCache 
			|| UseCache_USE_EXPIRE == useCache 
			|| UseCache_ONLY_CACHE == useCache ) {
			
			// Write data to cache 
			Boolean rSucc =
            [CacheReqController setDataToCache:nil
                                withIdentifier:params[@"cache"][@"identifier"]
                                        toPath:params[@"cache"][@"path"]
                                  withFileName:params[@"cache"][@"filename"]
                                      withData:@{@"value" : data}];
			if (!rSucc) {
				NSError *err = [NSError errorWithDomain:ErrDom_Data
												   code:MSG_CODE_DATA_WRITE_CACHE_FAILED
											   userInfo:[NSDictionary dictionaryWithObject:ErrInfo_Data forKey:@"msg"]];
				[delegate requestFailed:tag error:err];
			}
		}
	} else {
		
		NSError *err = [NSError errorWithDomain:ErrDom_ClientUnCatched
										   code:MSG_CODE_CLIENT_UNCATCHED
									   userInfo:[NSDictionary dictionaryWithObject:ErrInfo_ClientUnCatched forKey:@"msg"]];
		[delegate requestFailed:tag error:err];
	}
}

- (void)httpReqFailed:(NSInteger)tag error:(NSError *)error {
	
	[HttpReqControllerQueue removeHttpReq:tag];
	
	[Utils dismissNetworkIndicator];
	
	DDLog(@"request failed  error=%@", error);
	
	// Get data from net failed
	// Than get from cache with expire data, if useCache is UseCache_USE_EXPIRE 
	if (hasExpireData && UseCache_USE_EXPIRE == useCache) {
		
		// Use cache 
		NSDictionary *dic = [CacheReqController getDataFromCache:nil 
												  useExpireCache:(UseCache_USE_EXPIRE == useCache) 
												  withIdentifier:[[params objectForKey:@"cache"] objectForKey:@"identifier"] 
														fromPath:[[params objectForKey:@"cache"] objectForKey:@"path"] 
													withFileName:[[params objectForKey:@"cache"] objectForKey:@"filename"] 
												   hasExpireData:&hasExpireData];
		
		// Get data from cache successful 
		if (nil != dic) {
			
			[self newRequestFinished:tag retcode:RET_CODE_OK receiveData:[dic objectForKey:@"value"]];

            return;
		}
	}
	
	[delegate requestFailed:tag error:error];
}

#pragma mark - New request return
- (void)newRequestFinished:(NSInteger)tag retcode:(NSInteger)retcode receiveData:(NSData *)data {
	
	// CHECK--return code
	if (RET_CODE_OK != retcode) {
		NSError *err =
        [NSError errorWithDomain:ErrDom_ClientUnCatched
                            code:MSG_CODE_CLIENT_UNCATCHED
                        userInfo:[NSDictionary dictionaryWithObject:ErrInfo_ClientUnCatched forKey:@"msg"]];
        
		[delegate requestFailed:tag error:err];
		return;
	}
    
	// GET--json data
	NSString *strJSON = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSDictionary *dicData = [strJSON JSONValue];
    DDLog(@"%@",dicData);
    DDLog(@"message = %@",dicData[@"message"])
	strJSON = nil;
	
	// CHECK--json data
	if (nil == dicData) {
		NSError *err = [NSError errorWithDomain:ErrDom_ClientUnCatched
										   code:MSG_CODE_CLIENT_UNCATCHED
									   userInfo:[NSDictionary dictionaryWithObject:ErrInfo_ClientUnCatched forKey:@"msg"]];
		[delegate requestFailed:tag error:err];
		return;
	}
	
	// CHECK--return construct
	if (nil == [dicData objectForKey:@"error"] ||
        ![[dicData objectForKey:@"error"] isKindOfClass:[NSNumber class]]) {
		
		// Server internal error
		NSError *err = [NSError errorWithDomain:ErrDom_ServerInternal
										   code:MSG_CODE_SERVER_INTERNAL
									   userInfo:[NSDictionary dictionaryWithObject:ErrInfo_ServerInternal forKey:@"msg"]];
		[delegate requestFailed:tag error:err];
		return;
	}
	
	// GET--return error code
	NSInteger errCode = [(NSNumber *)[dicData objectForKey:@"error"] integerValue];
	NSString *msg = [dicData objectForKey:@"message"];
    
	// CHECK--return error code
	if (0 != errCode) {
        
//        // 当捕获到会话超时的错误时应该重新登录并提交当前的请求
//        if (SESSIONID_INVALID == errCode) {
//            
//            // Record the Tag
//            if (INITIAL_TAG != formerTag_)
//            {
//                // 此时说明在当前这个请求之前已经有了至少一次的失败请求
//                formerTag_ = tag;
//            }
//            formerTag_ = tag;
//            
//            // 在这里重新登录，并自动重新请求出错前的那个请求
//            [self reLoginAndPriorReqTag:formerTag_];
//            
//            return;
//        }
        
		if (nil != msg) {
			// Data error
			NSError *err = [NSError errorWithDomain:ErrDom_Data
											   code:errCode
										   userInfo:[NSDictionary dictionaryWithObject:msg forKey:@"msg"]];
			[delegate requestFailed:tag error:err];
			return;
		} else {
			// Interface unknown error
			NSError *err = [NSError errorWithDomain:ErrDom_ServerInternal
											   code:MSG_CODE_SERVER_INTERNAL
										   userInfo:[NSDictionary dictionaryWithObject:ErrInfo_ServerInternal forKey:@"msg"]];
			[delegate requestFailed:tag error:err];
			return;
		}
	}
	
	// Success
	[delegate requestFinished:tag retcode:RET_CODE_OK receiveData:dicData];
	
	dicData = nil;
}

- (void)reLoginAndPriorReqTag:(NSInteger)theTag {

    // Tag
    NSInteger iTag					= HTTP_CONTROLLER_RELOGIN;
    // HTTP
    NSString *url					= URL_BASE_TEST;
    HttpConnMethod httpMethod		= HttpConnMethod_POST;
    NSMutableDictionary	*getParam	= [[NSMutableDictionary alloc] init];
    NSMutableDictionary	*postParam	= [[NSMutableDictionary alloc] init];
    
    NSString *thePassword = [Base64 base64EncodeData:[RC4 rc4:[[[UserDefaults getPassword] dataUsingEncoding:NSUTF8StringEncoding] mutableCopy] key:RC4_SIGN_KEY]];
    NSString *theDeviceID = [Param getDeviceId];
    NSString *mobileModelStr = [[UIDevice currentDevice] model];// 手机型号
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    [bodyDic setObject:[UserDefaults getUsername]           forKey:@"mobile"];
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
    
    HttpReqController *httpReqCtrl = [[HttpReqController alloc] initWithURL:url
                                                                 withMethod:httpMethod
                                                               withGetParam:getParam
                                                              withPostParam:postParam
                                                                    withTag:iTag
                                                                   delegate:self];
    
    [httpReqCtrl release];
}

@end
