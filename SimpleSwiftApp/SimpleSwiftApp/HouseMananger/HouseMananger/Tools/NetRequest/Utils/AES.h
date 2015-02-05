//
//  AES.h
//  ELong
//
//  Created by TONG YU on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AES : NSObject

+ (NSData *)AES256EncryptWithKey:(NSString *)key withData:(NSData *)theData;
+ (NSData *)AES256DecryptWithKey:(NSString *)key withData:(NSData *)theData;

@end
