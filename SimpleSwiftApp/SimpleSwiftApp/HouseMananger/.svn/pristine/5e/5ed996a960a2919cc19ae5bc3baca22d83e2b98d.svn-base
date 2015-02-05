//
//  HttpReqController.m
//  TaobaoShow
//
//  Created by TONG YU on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HttpReqController.h"

#define DATA(X)	[X dataUsingEncoding:NSUTF8StringEncoding]

// Posting constants 
#define IMAGE_CONTENT @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"
#define STRING_CONTENT @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define MULTIPART @"multipart/form-data; boundary=------------0x0x0x0x0x0x0x0x"

@implementation HttpReqController
@synthesize requestURL;
@synthesize method;
@synthesize getParam;
@synthesize postParam;
@synthesize tag;
@synthesize delegate;
@synthesize connection;
@synthesize receiveData;
@synthesize httpConnStatus;
@synthesize timer;

- (id)initWithURL:(NSString *)theURL 
	   withMethod:(HttpConnMethod)theMethod
	 withGetParam:(NSDictionary *)theGetParam
	withPostParam:(NSDictionary *)thePostParam 
		  withTag:(NSInteger)theTag 
		 delegate:(id)theDelegate {
    
	if ((self = [super init])) {
		
		requestURL = [theURL retain];
		method = theMethod;
		getParam = [theGetParam retain];
		postParam = [thePostParam retain];
		tag = theTag;
		delegate = theDelegate;
		
		// connection = ;
		receiveData = [[NSMutableData alloc] init];
		
		// Status 
		httpConnStatus = HttpConnStatus_WAITING;
		// Timer 
		if (nil != timer) {
			[timer release];
			timer = nil;
		}
	}
	
	return self;
}

- (void)formatGetParam {
	
	NSString *url = [NSString stringWithString:requestURL];
	
	// Add Get Param to request url
	if (HttpConnMethod_GET == method && nil != getParam) {
		
		url = [url stringByAppendingFormat:@"?"];
		
		for (NSString *_key in [getParam allKeys]) {
			url = [url stringByAppendingFormat:@"%@=%@&", _key, [getParam objectForKey:_key]];
		}
		
		url = [url substringToIndex:([url length] - 1)];

		if (nil != requestURL) {
			[requestURL release];
		}
		requestURL = [[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] retain];
	}
}

- (Boolean)startRequest {
	
	[self formatGetParam];
	
	NSURL *url = [NSURL URLWithString:requestURL];
	
	if (nil == url) {
		return NO;
	}
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	if (nil == request) {
		return NO;
	}
	
	DDLog(@"request=%@", request);
	
	// Not work for "POST" 
	[request setTimeoutInterval:TIMEINTERVAL_HTTP_URL_REQUEST];
	
	if (HttpConnMethod_GET == method) {
        
		[request setHTTPMethod:@"GET"];
	} else {
        
		NSData *postData = [self generateFormDataFromPostDictionary];
		[request setHTTPMethod:@"POST"];
		[request setValue:MULTIPART forHTTPHeaderField:@"Content-Type"];
		[request setHTTPBody:postData];
    }
	
	DLOG(@"request.timeoutInterval=%f", request.timeoutInterval);
	
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    httpConnStatus = HttpConnStatus_LOADING;

	// Timer
	timer = [[NSTimer scheduledTimerWithTimeInterval:TIMEINTERVAL_HTTP_URL_REQUEST
											  target:self 
											selector:@selector(requestTimeOut:) 
											userInfo:nil 
											 repeats:NO] retain];
	
	return YES;
}

- (void)requestTimeOut:(NSTimer*)theTimer {
	
	DLOG(@"requestTimeOut requestTimeOut requestTimeOut requestTimeOut");
	
	if (nil != _connection && HttpConnStatus_LOADING == httpConnStatus) {
		
		[_connection cancel];
		
		if (nil != delegate) {
			DLOG(@"requestTimeOut requestTimeOut requestTimeOut requestTimeOut Do Do Do");
			// Post request timeout
			NSError *err = [NSError errorWithDomain:ErrDom_Network
											   code:MSG_CODE_NETWORK_TIMEOUT
										   userInfo:[NSDictionary dictionaryWithObject:ErrInfo_ServerInternal forKey:@"msg"]];
			[delegate httpReqFailed:tag error:err];
		}
	}
}

- (NSData*)generateFormDataFromPostDictionary {

    id boundary = @"------------0x0x0x0x0x0x0x0x";
    NSArray* keys = [postParam allKeys];
    NSMutableData* result = [NSMutableData data];
	
    for (int i = 0; i < [keys count]; i++) {
		
        id value = [postParam valueForKey: [keys objectAtIndex:i]];
        [result appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
		if ([value isKindOfClass:[NSData class]]) {
            NSMutableArray *imageDataArr = [NSKeyedUnarchiver unarchiveObjectWithData:value];
			// handle image data
			DLOG(@"image");
            for (NSInteger j = 0; j < imageDataArr.count; j++) {
                NSString *dateStr = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
                NSString *nameStr = [MD5 md5:dateStr];
                NSString *formstring = [NSString stringWithFormat:IMAGE_CONTENT, [keys objectAtIndex:i], nameStr];
                [result appendData:DATA(formstring)];
                [result appendData:[imageDataArr objectAtIndex:j]];
                if (imageDataArr.count - 1 != j) {
                    NSString *hehe = @"\r\n";
                    [result appendData:DATA(hehe)];
                    [result appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                }
            }
		} else {
			
			// all non-image fields assumed to be strings
			DLOG(@"data");
			NSString *formstring = [NSString stringWithFormat:STRING_CONTENT, [keys objectAtIndex:i]];
			[result appendData: DATA(formstring)];
			NSString *strValue = [NSString stringWithFormat:@"%@", value];
			[result appendData:DATA(strValue)];
		}
		
		NSString *formstring = @"\r\n";
        [result appendData:DATA(formstring)];
    }
	NSString *formstring =[NSString stringWithFormat:@"--%@--\r\n", boundary];
    [result appendData:DATA(formstring)];
    DLOG(@"%@",[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);
    NSLog(@"%@",[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);
    return result;
}

- (void)stopRequest {
	
	if (nil == _connection) {
		
		return;
	} else {
		
        [_connection cancel];
		[_connection release];
		_connection = nil;
		delegate = nil;
		
		// Status
        httpConnStatus = HttpConnStatus_STOPED;

		// Timer
		[timer invalidate];
        [Utils dismissNetworkIndicator];
	}
}

- (void)dealloc {
	
    [requestURL release];
	[getParam release];
	[postParam release];
    	
	[_connection release];
	[receiveData release];
	
	[timer release];
	
	[super dealloc];
}

#pragma mark NSURLConnection
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    DDLog(@"response %@",response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	DLOG(@"HttpReqController didReceiveData");
	[receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

	// Status
    httpConnStatus = HttpConnStatus_FINISHED;

	// Timer
	[timer invalidate];
	
    NSString *strJSON = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    DDLog(@"%@",strJSON);
    

    
	if (nil != delegate) {
        
		[delegate httpReqFinished:tag receiveData:receiveData];
	}
	
	[strJSON release];
    [_connection release];
    _connection=nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	DLOG(@"HttpReqController didFailWithError %@",connection.request.url);
	
	// Status
    httpConnStatus = HttpConnStatus_FAILED;

	// Timer
	[timer invalidate];
	
	if (nil != delegate) {
		[delegate httpReqFailed:tag error:error];
	}
    
    [_connection release];
    _connection=nil;
}

@end
