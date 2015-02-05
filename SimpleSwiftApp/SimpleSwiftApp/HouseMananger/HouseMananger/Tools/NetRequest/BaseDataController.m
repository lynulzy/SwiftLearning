//
//  BaseDataController.m
//  TaobaoShow
//
//  Created by TONG YU on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseDataController.h"

@implementation BaseDataController

@synthesize reqMgrArr;

- (void)dealloc {
	
	[reqMgrArr release];	
	
	[super dealloc];
}

- (void)sendRequest:(NSInteger)theTag
			withUrl:(NSString *)theUrl 
		 withMethod:(NSInteger)theHttpMethod
	   withGetParam:(NSDictionary *)theGetParam
	  withPostParam:(NSDictionary *)thePostParam 
	 withIdentifier:(NSString *)theIdentifier 
		   withPath:(NSString *)thePath 
	   withFileName:(NSString *)theFileName 
	   withUseCache:(UseCache)theUseCache {
	
	// Tag 
	NSNumber *tag = [NSNumber numberWithInteger:theTag];
	// Http 设置网络请求参数
	NSMutableDictionary *http = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								 theUrl,									@"url", 
								 [NSNumber numberWithInteger:theHttpMethod],@"method",
								 theGetParam,								@"getParam",
								 thePostParam,								@"postParam", 
								 nil];
	// Cache 设置缓存
	NSMutableDictionary *cache = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  theIdentifier,	@"identifier", 
								  thePath,			@"path", 
								  theFileName,		@"fileName", 
								  nil];
	// Params 
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   tag,				@"tag", 
								   http,			@"http", 
								   cache,			@"cache", 
								   nil];
	
	// Request array 
	if (nil == reqMgrArr) {
		reqMgrArr = [[NSMutableArray alloc] init];
	}
    
	// Request manager 
	ReqManager *reqMgr = [[ReqManager alloc] init];
    [reqMgr sendRequest:params
			   delegate:self 
			   useCache:theUseCache];
	[reqMgrArr addObject:reqMgr];
	[reqMgr release];
}

@end
