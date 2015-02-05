//
//  CacheReqController.h
//  TaobaoShow
//
//  Created by TONG YU on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Define.h"

typedef enum {
	UseCache_NOUSE = 0,		// Donot use cache
	UseCache_USE_NOEXPIRE,	// Use cache, but donot use the expired cache
	UseCache_USE_EXPIRE,	// Use cache, use all cache
	UseCache_ONLY_CACHE		// Only use cache
} UseCache;

@interface CacheReqController : NSObject {
	
}

+ (NSDictionary *)getDataFromCache:(NSDictionary *)theParams 
					useExpireCache:(Boolean)theUseExpireCache 
					withIdentifier:(NSString *)theIdentifier 
						  fromPath:(NSString *)thePath 
					  withFileName:(NSString *)theFileName 
					 hasExpireData:(Boolean *)theHasExpireData;

+ (Boolean)setDataToCache:(NSDictionary *)theParams 
		   withIdentifier:(NSString *)theIdentifier 
				   toPath:(NSString *)thePath 
			 withFileName:(NSString *)theFileName 
				 withData:(NSDictionary *)theData;

@end
