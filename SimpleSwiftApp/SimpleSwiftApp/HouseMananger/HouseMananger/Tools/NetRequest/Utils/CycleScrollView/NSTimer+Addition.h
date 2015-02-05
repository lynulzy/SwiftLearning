//
//  NSTimer+Addition.h
//  MiShiClient-Pro
//
//  Created by ZXH on 14/10/20.
//  Copyright (c) 2014年 zsxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
