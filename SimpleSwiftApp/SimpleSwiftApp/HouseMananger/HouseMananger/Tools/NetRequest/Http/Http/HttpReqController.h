//
//  HttpReqController.h
//  TaobaoShow
//
//  Created by TONG YU on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Define.h"
#import "HTTPDefine.h"
#import "DataDefine.h"
#import "MD5.h"
#import "Utils.h"

typedef enum {
	HttpConnStatus_WAITING = 0, 
	HttpConnStatus_LOADING, 
	HttpConnStatus_STOPED, 
	HttpConnStatus_FINISHED, 
	HttpConnStatus_FAILED,
} HttpConnStatus;

typedef enum {
	HttpConnMethod_GET = 0, 
	HttpConnMethod_POST
} HttpConnMethod;


@protocol HttpReqControllerDelegate <NSObject>

- (void)httpReqFinished:(NSInteger)tag receiveData:(NSData *)data;
- (void)httpReqFailed:(NSInteger)tag error:(NSError *)error;

@end


@interface HttpReqController : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate> {
	
	NSString *requestURL;
	HttpConnMethod method;
	NSDictionary *getParam;
	NSDictionary *postParam;
	NSInteger tag;
	id<HttpReqControllerDelegate> delegate;
	
	NSURLConnection *_connection;
	NSMutableData *receiveData;
	
	HttpConnStatus httpConnStatus;
	NSTimer *timer;
}

@property(nonatomic, retain) NSString *requestURL;
@property(nonatomic) HttpConnMethod method;
@property(nonatomic, retain) NSDictionary *getParam;
@property(nonatomic, retain) NSDictionary *postParam;
@property(nonatomic) NSInteger tag;
@property (nonatomic, assign) id<HttpReqControllerDelegate> delegate;

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *receiveData;

@property (nonatomic) HttpConnStatus httpConnStatus;
@property (nonatomic, retain) NSTimer *timer;

- (id)initWithURL:(NSString *)theURL 
	   withMethod:(HttpConnMethod)theMethod
	 withGetParam:(NSDictionary *)theGetParam
	withPostParam:(NSDictionary *)thePostParam 
		  withTag:(NSInteger)theTag 
		 delegate:(id)theDelegate;

- (Boolean)startRequest;
- (void)stopRequest;

@end
