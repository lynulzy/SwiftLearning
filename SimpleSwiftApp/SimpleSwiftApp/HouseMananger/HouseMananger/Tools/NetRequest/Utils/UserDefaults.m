//
//  UserDefaults.m
//  ELong
//
//  Created by TONG YU on 11-12-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserDefaults.h"

#import "Param.h"

@interface UserDefaults ()

@end

@implementation UserDefaults

// Init user defaults
+ (void)initUserDefaults {
	
	// User name
	if (nil == [UserDefaults getUsername]) {
		NSDictionary *resourceDict = [NSDictionary dictionaryWithObject:@"" forKey:USER_DEFAULTS_USERNAME];
		[[NSUserDefaults standardUserDefaults] registerDefaults:resourceDict];
	}
	
	// Password
	if (nil == [UserDefaults getPassword]) {
		NSDictionary *resourceDict = [NSDictionary dictionaryWithObject:@"" forKey:USER_DEFAULTS_PASSWORD];
		[[NSUserDefaults standardUserDefaults] registerDefaults:resourceDict];
	}

	// Save password
	if (nil == [UserDefaults getSavePassword]) {
		NSDictionary *resourceDict = [NSDictionary dictionaryWithObject:@"1" forKey:USER_DEFAULTS_SAVE_PASSWORD];
		[[NSUserDefaults standardUserDefaults] registerDefaults:resourceDict];
	}
    
    // Mobile
    if (nil == [UserDefaults getMobile]) {
        NSDictionary *resourceDict = [NSDictionary dictionaryWithObject:@"" forKey:USER_DEFAULTS_MOBILE];
        [[NSUserDefaults standardUserDefaults] registerDefaults:resourceDict];
    }
	
	// Auto login
	if (nil == [UserDefaults getAutoLogin]) {
		NSDictionary *resourceDict = [NSDictionary dictionaryWithObject:@"1" forKey:USER_DEFAULTS_AUTO_LOGIN];
		[[NSUserDefaults standardUserDefaults] registerDefaults:resourceDict];
	}
	
	
	
	// ---------------------- ----------------------
	// Have barcode
	if (nil == [UserDefaults getHaveBarcode]) {
		NSDictionary *resourceDict = [NSDictionary dictionaryWithObject:[[[NSDictionary alloc] init] autorelease] forKey:USER_DEFAULTS_HAVE_BARCODE];
		[[NSUserDefaults standardUserDefaults] registerDefaults:resourceDict];
	}
	
	// ---------------------- ----------------------
	// Access token
	if (nil == [UserDefaults getAccessToken]) {
		NSDictionary *resourceDict = [NSDictionary dictionaryWithObject:@"" forKey:USER_DEFAULTS_ACCESS_TOKEN];
		[[NSUserDefaults standardUserDefaults] registerDefaults:resourceDict];
	}
	// Refresh token
	if (nil == [UserDefaults getRefreshToken]) {
		NSDictionary *resourceDict = [NSDictionary dictionaryWithObject:@"" forKey:USER_DEFAULTS_REFRESH_TOKEN];
		[[NSUserDefaults standardUserDefaults] registerDefaults:resourceDict];
	}
	// Taobao user id
	if (nil == [UserDefaults getTaobaoUserId]) {
		NSDictionary *resourceDict = [NSDictionary dictionaryWithObject:@"" forKey:USER_DEFAULTS_TAOBAO_USER_ID];
		[[NSUserDefaults standardUserDefaults] registerDefaults:resourceDict];
	}
	// Taobao user nick
	if (nil == [UserDefaults getTaobaoUserNick]) {
		NSDictionary *resourceDict = [NSDictionary dictionaryWithObject:@"" forKey:USER_DEFAULTS_TAOBAO_USER_NICK];
		[[NSUserDefaults standardUserDefaults] registerDefaults:resourceDict];
	}
}
//Save UserInfo


// Save password
+ (void)setSavePassword:(NSString *)theSavePassword {
	
	[[NSUserDefaults standardUserDefaults] setObject:theSavePassword forKey:USER_DEFAULTS_SAVE_PASSWORD];
}

+ (NSString *)getSavePassword {
	
	return [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_SAVE_PASSWORD];
}

// Auto login
+ (void)setAutoLogin:(NSString *)theAutoLogin {
	
	[[NSUserDefaults standardUserDefaults] setObject:theAutoLogin forKey:USER_DEFAULTS_AUTO_LOGIN];
}

+ (NSString *)getAutoLogin {
	
	return [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_AUTO_LOGIN];
}

// User name  使用
+ (void)setUsername:(NSString *)theUsername {
	
	[[NSUserDefaults standardUserDefaults] setObject:theUsername forKey:USER_DEFAULTS_USERNAME];
}

+ (NSString *)getUsername {
	
	return [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_USERNAME];
}

// Password   使用
+ (void)setPassword:(NSString *)thePassword {
	
	[[NSUserDefaults standardUserDefaults] setObject:thePassword forKey:USER_DEFAULTS_PASSWORD];
}

+ (NSString *)getPassword {
	
	return [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_PASSWORD];
}

// Mobile
+ (void)setMobile:(NSString *)theMobile {
	
	[[NSUserDefaults standardUserDefaults] setObject:theMobile forKey:USER_DEFAULTS_MOBILE];
}

+ (NSString *)getMobile {
	
	return [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_MOBILE];
}

// ---------------------- ----------------------
// Login success, shop data
+ (void)setLoginShopData:(NSDictionary *)theLoginShopData {
	
	[[NSUserDefaults standardUserDefaults] setObject:theLoginShopData forKey:USER_DEFAULTS_LOGINSHOPDATA];
}

+ (NSDictionary *)getLoginShopData {
	
	return [[NSUserDefaults standardUserDefaults] dictionaryForKey:USER_DEFAULTS_LOGINSHOPDATA];
}

// ---------------------- ----------------------
// Trade status list
+ (void)setTradeStatusList:(NSArray *)theTradeStatusList {
	
	[[NSUserDefaults standardUserDefaults] setObject:theTradeStatusList forKey:USER_DEFAULTS_TRADESTATUSLIST];
}

+ (NSArray *)getTradeStatusList {
	
	return [[NSUserDefaults standardUserDefaults] arrayForKey:USER_DEFAULTS_TRADESTATUSLIST];
}

// Current trade status
+ (void)setCurTradeStatus:(NSDictionary *)theCurTradeStatus {
	
	[[NSUserDefaults standardUserDefaults] setObject:theCurTradeStatus forKey:USER_DEFAULTS_CURRENTTRADESTATUS];
}

+ (NSDictionary *)getCurTradeStatus {
	
	return [[NSUserDefaults standardUserDefaults] dictionaryForKey:USER_DEFAULTS_CURRENTTRADESTATUS];
}

// ---------------------- ----------------------
// Clear login data
+ (void)clearLoginData:(NSDictionary *)theParam keepUsername:(Boolean)theKeepUsername {
	
	// Clear password
	[[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:USER_DEFAULTS_SAVE_PASSWORD];
	
	// Clear auto login
	[[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:USER_DEFAULTS_AUTO_LOGIN];
	
	// Clear user name
	if (!theKeepUsername) {
		[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USER_DEFAULTS_USERNAME];
	}
	
	// Clear password
	[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USER_DEFAULTS_PASSWORD];
	
	// Clear login shop data
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_DEFAULTS_LOGINSHOPDATA];
}




// ---------------------- ----------------------
// Last check update date
+ (void)setLastCheckUpdateDate:(NSString *)theDate {
	
	[[NSUserDefaults standardUserDefaults] setObject:theDate forKey:@"LastCheckUpdateDate"];
}

+ (NSString *)getLastCheckUpdateDate {
	
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"LastCheckUpdateDate"];
}

// ---------------------- ----------------------
// Have barcode 
+ (void)setHaveBarcode:(NSDictionary *)theHaveBarcode {
	
	[[NSUserDefaults standardUserDefaults] setObject:theHaveBarcode forKey:USER_DEFAULTS_HAVE_BARCODE];
}

+ (NSDictionary *)getHaveBarcode {
	
	return [[NSUserDefaults standardUserDefaults] dictionaryForKey:USER_DEFAULTS_HAVE_BARCODE];
}

// ---------------------- ----------------------
// Access token
+ (void)setAccessToken:(NSString *)theAccessToken {
	
	[[NSUserDefaults standardUserDefaults] setObject:theAccessToken forKey:USER_DEFAULTS_ACCESS_TOKEN];
}

+ (NSString *)getAccessToken {
	
	return [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_ACCESS_TOKEN];
}

// Refresh token
+ (void)setRefreshToken:(NSString *)theRefreshToken {
	
	[[NSUserDefaults standardUserDefaults] setObject:theRefreshToken forKey:USER_DEFAULTS_REFRESH_TOKEN];
}

+ (NSString *)getRefreshToken {
	
	return [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_REFRESH_TOKEN];
}

// Taobao user id
+ (void)setTaobaoUserId:(NSString *)theTaobaoUserId {
	
	[[NSUserDefaults standardUserDefaults] setObject:theTaobaoUserId forKey:USER_DEFAULTS_TAOBAO_USER_ID];
}

+ (NSString *)getTaobaoUserId {
	
	return [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_TAOBAO_USER_ID];
}

// Taobao user nick
+ (void)setTaobaoUserNick:(NSString *)theTaobaoUserNick {
	
	[[NSUserDefaults standardUserDefaults] setObject:theTaobaoUserNick forKey:USER_DEFAULTS_TAOBAO_USER_NICK];
}

+ (NSString *)getTaobaoUserNick {
	
	return [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_TAOBAO_USER_NICK];
}

@end
