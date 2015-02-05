//
//  ReqManager.h
//  TaobaoShow
//
//  Created by TONG YU on 12-4-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Define.h"

#import "DataDefine.h"

#import "CacheReqController.h"
#import "HttpReqControllerQueue.h"
#import "HttpReqController.h"

@protocol ReqManagerDelegate <NSObject>

- (void)requestFinished:(NSInteger)tag retcode:(NSInteger)retcode receiveData:(NSDictionary *)data;
- (void)requestFailed:(NSInteger)tag error:(NSError *)error;

@end

@interface ReqManager : NSObject <HttpReqControllerDelegate> {
	
	id<ReqManagerDelegate> delegate;
	
	NSMutableDictionary *params;
	
	UseCache useCache;
	Boolean hasExpireData;
}

@property(nonatomic, retain) id<ReqManagerDelegate> delegate;

@property(nonatomic, retain) NSMutableDictionary *params;

@property(nonatomic) UseCache useCache;
@property(nonatomic) Boolean hasExpireData;

- (void)sendRequest:(NSDictionary *)theParams 
		   delegate:(id)theDelegate 
		   useCache:(UseCache)theUseCache;

@end
