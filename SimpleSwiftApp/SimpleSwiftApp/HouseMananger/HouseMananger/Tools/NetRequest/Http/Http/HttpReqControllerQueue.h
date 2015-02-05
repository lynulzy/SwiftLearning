//
//  HttpReqControllerQueue.h
//  TaobaoShow
//
//  Created by TONG YU on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Define.h"

#import "HttpReqController.h"

@interface HttpReqControllerQueue : NSObject {
	
}

// Init 
+ (void)initialize;

// Add 
+ (Boolean)addHttpReq:(HttpReqController *)theHttpReq;

// Remove
+ (Boolean)removeHttpReq:(NSInteger)theTag;

@end
