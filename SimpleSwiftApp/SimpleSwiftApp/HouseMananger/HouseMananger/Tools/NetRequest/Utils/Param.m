//
//  Param.m
//  JiayuanNew
//
//  Created by viki on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Param.h"

#import "Utils.h"

@implementation Param

// Network indicator
static NSInteger networkIndicatorCount = 0;

//
+ (NSString *)getDefaultCompanyName {
	
	NSBundle* mainBundle = [NSBundle mainBundle];
	NSDictionary* info =  [mainBundle infoDictionary];
	
	// DLOG(@"info=%@", info);
	
	return [info objectForKey:@"CompanyName"];
}

+ (NSString *)getDefaultCompanyID {
	
	NSBundle* mainBundle = [NSBundle mainBundle];
	NSDictionary* info =  [mainBundle infoDictionary];
	
	// DLOG(@"info=%@", info);
	
	return [info objectForKey:@"CompanyID"];
}

// ---------------------- ---------------------- 
+ (NSString *)getDeviceId {
//	return [info objectForKey:@"Deviceid"];
    //iOS7以后官方推荐的UDID获取方法
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString *)getChannelid {
	
	NSBundle* mainBundle = [NSBundle mainBundle];
	NSDictionary* info =  [mainBundle infoDictionary];
	
	return [info objectForKey:@"Channelid"];
}

+ (NSString *)getVersion {
	
	NSBundle* mainBundle = [NSBundle mainBundle];
	NSDictionary* info =  [mainBundle infoDictionary];
	
	return [info objectForKey:@"CFBundleVersion"];
}

+ (NSString *)getSysVersion {
	
	return [[UIDevice currentDevice] systemVersion];
}

// ---------------------- ----------------------
+ (NSString *)getSellerNick {
	
	NSBundle* mainBundle = [NSBundle mainBundle];
	NSDictionary* info =  [mainBundle infoDictionary];
	
	return [info objectForKey:@"Seller_Nick"];
}

+ (NSString *)getAppKey {
	
	NSBundle* mainBundle = [NSBundle mainBundle];
	NSDictionary* info =  [mainBundle infoDictionary];
	
	return [info objectForKey:@"Buyer_AppKey"];
}

+ (NSString *)getAppSecret {
	
	NSBundle* mainBundle = [NSBundle mainBundle];
	NSDictionary* info =  [mainBundle infoDictionary];
	
	return [info objectForKey:@"Buyer_AppSecret"];
}

+ (NSString *)getRedirectUri {
	
	NSBundle* mainBundle = [NSBundle mainBundle];
	NSDictionary* info =  [mainBundle infoDictionary];
	
	return [info objectForKey:@"Buyer_RequestRedirectUri"];
}

+ (NSString *)getSignSecret {
	
	NSBundle* mainBundle = [NSBundle mainBundle];
	NSDictionary* info =  [mainBundle infoDictionary];
	
	return [info objectForKey:@"SignSecret"];
}

// ---------------------- ----------------------
+ (void)setNetworkIndicatorCount:(NSInteger)theCount {
	
	networkIndicatorCount = theCount;
}

+ (NSInteger)getNetworkIndicatorCount {
	
	return networkIndicatorCount;
}

@end
