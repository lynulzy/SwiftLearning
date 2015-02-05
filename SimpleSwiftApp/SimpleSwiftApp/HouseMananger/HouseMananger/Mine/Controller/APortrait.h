//
//  APortrait.h
//  HouseMananger
//
//  Created by ZXH on 15/1/21.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APortrait : NSObject

+ (BOOL)isExist;
+ (UIImage *)getThePortrait;
+ (BOOL)saveThePortrait:(NSData *)imageData;

@end
