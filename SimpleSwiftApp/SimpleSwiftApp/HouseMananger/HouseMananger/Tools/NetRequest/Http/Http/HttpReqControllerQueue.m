//
//  HttpReqControllerQueue.m
//  TaobaoShow
//
//  Created by TONG YU on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HttpReqControllerQueue.h"

#define HTTP_REQ_LOADING_COUNT	(5)

@implementation HttpReqControllerQueue

static NSMutableArray *httpReqs;

+ (void)initialize {
    
    if(nil == httpReqs) {
        httpReqs = [[NSMutableArray alloc] init];
    }
}

#pragma mark HTTP REQUEST UPDATE
+ (void)updateReqQueue {
    
    // Test -- --
    //DLOG(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    //for (HttpReqController *_httpReq in httpReqs) {
    //	DLOG(@"_httpReq.httpConnStatus=%d", _httpReq.httpConnStatus);
    //}
    // End -- --
    
    NSInteger reqLoadingCount = 0;
    
    // Found "loading" request
    for (HttpReqController *_httpReq in httpReqs) {
        if (HttpConnStatus_LOADING == _httpReq.httpConnStatus) {
            reqLoadingCount++;
        }
    }
    DLOG(@"reqLoadingCount=%d", reqLoadingCount);
    
    // Start "waiting" request
    if (HTTP_REQ_LOADING_COUNT > reqLoadingCount) {
        
        for (HttpReqController *_httpReq in httpReqs) {
            
            if (HttpConnStatus_WAITING == _httpReq.httpConnStatus) {
                
                // Start this "waiting" request -> "loading" request
                [_httpReq startRequest];
                reqLoadingCount++;
                
                if (HTTP_REQ_LOADING_COUNT <= reqLoadingCount) {
                    break;
                }
            }
            
        }
    }
    
    // Test -- --
    //DLOG(@"----------------------------------------");
    //for (HttpReqController *_httpReq in httpReqs) {
    //	DLOG(@"_httpReq.httpConnStatus=%d", _httpReq.httpConnStatus);
    //}
    // End -- --
    
}

#pragma mark HTTP REQUEST ADD
+ (Boolean)addHttpReq:(HttpReqController *)theHttpReq {
    
    DLOG(@"addHTTPCtrl theHttpReq = %@", theHttpReq);
    
    Boolean inTheQueue = NO;
    
    // Check if the request is in the queue already
    for (HttpReqController *_httpReq in httpReqs) {
        
        if (_httpReq.tag == theHttpReq.tag) {
            inTheQueue = YES;
        }
    }
    
    // Return NO, if the request already in the queue
    if (inTheQueue) {
        return NO;
    }
    
    // Add the request to the queue
    [httpReqs addObject:theHttpReq];
    
    // [theHttpReq startRequest];
    //
    // Update http request queue
    [HttpReqControllerQueue updateReqQueue];
    
    return YES;
}

#pragma mark HTTP REQUEST STOP
+ (void)stopAllHttpReqs {
    
    for (HttpReqController *_httpReq in httpReqs) {
        [_httpReq stopRequest];
    }
}

#pragma mark HTTP REQUEST REMOVE
// Delete http request with tag, Stop then remove
+ (Boolean)removeHttpReq:(NSInteger)theTag {
    
    for (HttpReqController *_httpReq in httpReqs) {
        
        if (_httpReq.tag == theTag) {
            
            [_httpReq stopRequest];
            [httpReqs removeObject:_httpReq];
            
            // Update http request queue 
            [HttpReqControllerQueue updateReqQueue];
            
            return YES;
        }
    }
    
    return NO;
}

// Delete all http request 
+ (void)removeAllHttpReq {
    
    for (HttpReqController *_httpReq in httpReqs) {
        
        [_httpReq stopRequest];
        [httpReqs removeObject:_httpReq];
    }
}

@end
