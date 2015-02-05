//
//  UserDefaults.h
//  ELong
//
//  Created by TONG YU on 11-12-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USER_DEFAULTS_SAVE_PASSWORD		@"save_password"
#define USER_DEFAULTS_AUTO_LOGIN		@"auto_login"

#define USER_DEFAULTS_USERNAME			@"username"
#define USER_DEFAULTS_PASSWORD			@"password"
#define USER_DEFAULTS_MOBILE			@"mobile"

#define USER_DEFAULTS_LOGINSHOPDATA		@"login_shop_data"

#define USER_DEFAULTS_TRADESTATUSLIST	@"trade_status_list"
#define USER_DEFAULTS_CURRENTTRADESTATUS	@"current_trade_status"




#define USER_DEFAULTS_HAVE_BARCODE		@"have_barcode"

#define USER_DEFAULTS_ACCESS_TOKEN		@"access_token"
#define USER_DEFAULTS_REFRESH_TOKEN		@"refresh_token"
#define USER_DEFAULTS_TAOBAO_USER_ID	@"taobao_user_id"
#define USER_DEFAULTS_TAOBAO_USER_NICK	@"taobao_user_nick"

@interface UserDefaults : NSObject {
    
}

// 
+ (void)initUserDefaults;
// Save password
+ (void)setSavePassword:(NSString *)theSavePassword;
+ (NSString *)getSavePassword;

// Auto login
+ (void)setAutoLogin:(NSString *)theAutoLogin;
+ (NSString *)getAutoLogin;

// User name
+ (void)setUsername:(NSString *)theUsername;
+ (NSString *)getUsername;

// Password
+ (void)setPassword:(NSString *)thePassword;
+ (NSString *)getPassword;

// Mobile
+ (void)setMobile:(NSString *)theMobile;
+ (NSString *)getMobile;

// ---------------------- ----------------------
// Login success, shop data
+ (void)setLoginShopData:(NSDictionary *)theLoginShopData;
+ (NSDictionary *)getLoginShopData;

// ---------------------- ----------------------
// Trade status list
+ (void)setTradeStatusList:(NSArray *)theTradeStatusList;
+ (NSArray *)getTradeStatusList;
// Current trade status
+ (void)setCurTradeStatus:(NSDictionary *)theCurTradeStatus;
+ (NSDictionary *)getCurTradeStatus;

// ---------------------- ----------------------
// Clear login data
+ (void)clearLoginData:(NSDictionary *)theParam keepUsername:(Boolean)theKeepUsername;




// ---------------------- ----------------------
// Last check update date
+ (void)setLastCheckUpdateDate:(NSString *)theDate;
+ (NSString *)getLastCheckUpdateDate;

// ---------------------- ----------------------
// Have barcode
+ (void)setHaveBarcode:(NSDictionary *)theHaveBarcode;
+ (NSDictionary *)getHaveBarcode;

// ---------------------- ----------------------
// Access token
+ (void)setAccessToken:(NSString *)theAccessToken;
+ (NSString *)getAccessToken;

// Refresh token
+ (void)setRefreshToken:(NSString *)theRefreshToken;
+ (NSString *)getRefreshToken;

// Taobao user id
+ (void)setTaobaoUserId:(NSString *)theTaobaoUserId;
+ (NSString *)getTaobaoUserId;

// Taobao user nick
+ (void)setTaobaoUserNick:(NSString *)theTaobaoUserNick;
+ (NSString *)getTaobaoUserNick;

@end
