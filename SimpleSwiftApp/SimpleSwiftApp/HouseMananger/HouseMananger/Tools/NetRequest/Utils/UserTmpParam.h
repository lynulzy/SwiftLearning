//
//  UserTmpParam.h
//  StoreClient
//
//  Created by viki on 14-7-18.
//  Copyright (c) 2014年 _MyCompany_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"

@interface UserTmpParam : NSObject

// User name
+ (void)setUserName:(NSString *)theUserName;
+ (NSString *)getUserName;

// Password
+ (void)setPassword:(NSString *)thePassword;
+ (NSString *)getPassword;

// Mobile
+ (void)setMobile:(NSString *)theMobile;
+ (NSString *)getMobile;

// Token
+ (void)setToken:(NSString *)theToken;
+ (NSString *)getToken;

// Session
+ (void)setSession:(NSString *)theSession;
+ (NSString *)getSession;

// User ID
+ (void)setUserId:(NSString *)theUserId;
+ (NSString *)getUserId;

// User Sex
+ (void)setUserSex:(NSString *)theUserSex;
+ (NSString *)getUserSex;

// Company Name
+ (void)setCompanyName:(NSString *)theCompanyName;
+ (NSString *)getCompanyName;

// Portrait
+ (void)setPortraitUrl:(NSString *)thePortraitUrl;
+ (NSString *)getPortraitUrl;

// Authentication Status
+ (void)setAuthenticationStatus:(NSString *)theAuthStatus;
+ (NSString *)getAuthenticationStatus;

// Invitation people
+ (void)setInvitationPeople:(NSString *)theInvitationPeople;
+ (NSString *)getInvitationPeople;

/*---------------------- New versions --------------------------*/
// New versions tag
+ (void)setNewVersionsTag:(NSString *)theNewVersionsTag;
+ (NSString *)getNewVersionsTag;

// New versions force_update
+ (void)setNewVersionsForceUpdateTag:(NSString *)theNewVersionsForceUpdateTag;
+ (NSString *)getNewVersionsForceUpdateTag;

// New versions
+ (void)setNewVersions:(NSString *)theNewVersions;
+ (NSString *)getNewVersions;

// New versions describe
+ (void)setNewVersionsDesc:(NSString *)theDescribe;
+ (NSString *)getNewVersionsDesc;

// New versions URL
+ (void)setNewversionsURL:(NSString *)theURL;
+ (NSString *)getNewVersionsURL;
/*--------------------------------------------------------------*/



// Update NetWork Status
+ (void)updateNetStatus:(Reachability *)reach;
+ (NetworkStatus)currentNetWorkStatus;

+ (void)clearLoginData;

@end
