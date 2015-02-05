//
//  CacheReqController.m
//  TaobaoShow
//
//  Created by TONG YU on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CacheReqController.h"

#import "HTTPDefine.h"
#import "MD5.h"

@implementation CacheReqController

+ (NSDictionary *)getDataFromCache:(NSDictionary *)theParams 
					useExpireCache:(Boolean)theUseExpireCache 
					withIdentifier:(NSString *)theIdentifier 
						  fromPath:(NSString *)thePath 
					  withFileName:(NSString *)theFileName 
					 hasExpireData:(Boolean *)theHasExpireData {
	
	DLOG(@"CacheReqController getDataFromCache");
	
	NSError *theError = nil;
	NSDictionary *theData = nil;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex:0];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *array = [fileManager contentsOfDirectoryAtPath:path error:&theError];
	
	//Check whether has "cache" dir in doc path 
	//If not, create it. 
	if (NSNotFound == [array indexOfObject:[NSString stringWithFormat:@"cache"]]) {
		
		DLOG(@"Do not has cache dir");
		NSString *directory = [path stringByAppendingPathComponent:@"cache"];
		[fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&theError];
	}
	
	path = [path stringByAppendingPathComponent:@"cache"];
	array = [fileManager contentsOfDirectoryAtPath:path error:&theError];
	//Check whether has "thePath" dir in "cache" path 
	//If not, create it. 
	if (NSNotFound == [array indexOfObject:thePath]) {
		
		DLOG(@"Do not has thePath dir");
		NSString *directory = [path stringByAppendingPathComponent:thePath];
		[fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&theError];
	}
	
	path = [path stringByAppendingPathComponent:thePath];
	array = [fileManager contentsOfDirectoryAtPath:path error:&theError];
	path = [path stringByAppendingPathComponent:[MD5 md5:theIdentifier]];
	//Check whether has cache file in "cache" dir
	//If not, get list from web, and write it to cache
	if (NSNotFound == [array indexOfObject:[NSString stringWithFormat:@"%@", [MD5 md5:theIdentifier]]]) {
		
		DLOG(@"Do not has cache file");
		//Do not has cache file
		return nil;
		
	} else {
		
		DLOG(@"Do has cache file");
		//Do has cache file
		//Check the time stamp
		NSDictionary *cacheFileData = [NSDictionary dictionaryWithContentsOfFile:path];
		NSDate *timeStamp = [cacheFileData objectForKey:@"timeStamp"];
		NSDictionary *cacheDic = [cacheFileData objectForKey:@"cacheDic"];
		
		NSDate *currentDate = [NSDate date];
		NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeStamp];	//Seconds
		
		if (timeInterval < TIMEINTERVAL_HTTP_EXPIRE) {
			//Because time interval is not long enough, do not need refresh from net
			DLOG(@"Do not need refresh from net");
			theData = [[cacheDic retain] autorelease];
		} else {
			//Because time interval is so long, need to refresh from net
			DLOG(@"Need to refresh from net");
			if (theUseExpireCache) {
				DLOG(@"Net work error, use cache");
				theData = [cacheDic retain];
				return [theData autorelease];
			} else {
				DLOG(@"Refresh from net");
				if (nil != theHasExpireData) {
					*theHasExpireData = YES;
				}
				return nil;
			}
		}
		
		return theData;
	}
}

+ (Boolean)setDataToCache:(NSDictionary *)theParams 
		   withIdentifier:(NSString *)theIdentifier 
				   toPath:(NSString *)thePath 
			 withFileName:(NSString *)theFileName 
				 withData:(NSDictionary *)theData {
	
	DLOG(@"writeToCache");
	
	//Write the videoList to cache with time stamp
	NSArray *keys = [NSArray arrayWithObjects:@"timeStamp", @"cacheDic", @"pageCount", nil];
	NSArray *objects = [NSArray arrayWithObjects:[NSDate date], theData, @"1", nil];
	NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	
	NSError *theError = nil;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex:0];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *array = [fileManager contentsOfDirectoryAtPath:path error:&theError];
	
	//Check whether has "cache" dir in doc path 
	//If not, create it. 
	if (NSNotFound == [array indexOfObject:[NSString stringWithFormat:@"cache"]]) {
		
		DLOG(@"Do not has cache dir");
		NSString *directory = [path stringByAppendingPathComponent:@"cache"];
		[fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&theError];
	}
	
	path = [path stringByAppendingPathComponent:@"cache"];
	array = [fileManager contentsOfDirectoryAtPath:path error:&theError];
	//Check whether has "thePath" dir in "cache" path 
	//If not, create it. 
	if (NSNotFound == [array indexOfObject:thePath]) {
		
		DLOG(@"Do not has thePath dir");
		NSString *directory = [path stringByAppendingPathComponent:thePath];
		[fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&theError];
	}
	
	path = [path stringByAppendingPathComponent:thePath];
	path = [path stringByAppendingPathComponent:[MD5 md5:theIdentifier]];
	
	return [dict writeToFile:path atomically:YES];
}

@end
