//
//  BaseDataController.h
//  TaobaoShow
//
//  Created by TONG YU on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Define.h"

#import "ReqManager.h"


@interface BaseDataController : NSObject {
	
	NSMutableArray *reqMgrArr;	
}

@property(nonatomic, retain) NSMutableArray *reqMgrArr;

// Http 
- (void)sendRequest:(NSInteger)theTag 
			withUrl:(NSString *)theUrl 
		 withMethod:(NSInteger)theHttpMethod
	   withGetParam:(NSDictionary *)theGetParam
	  withPostParam:(NSDictionary *)thePostParam 
	 withIdentifier:(NSString *)theIdentifier 
		   withPath:(NSString *)thePath 
	   withFileName:(NSString *)theFileName 
	   withUseCache:(UseCache)theUseCache;

// Pic 
//- (NSData *)sendPicRequest:(NSInteger)theTag 
//				withPicUrl:(NSString *)thePicUrl 
//			withIdentifier:(NSString *)theIdentifier 
//				  withPath:(NSString *)thePath 
//			  withFileName:(NSString *)theFileName 
//			  withUseCache:(UseCache)theUseCache;

@end
