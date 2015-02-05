//
//  UserTmpParam.m
//  StoreClient
//
//  Created by viki on 14-7-18.
//  Copyright (c) 2014年 mishi. All rights reserved.
//

#import "UserTmpParam.h"

@implementation UserTmpParam

static NSString *userName;
static NSString *password;
static NSString *mobile;
static NSString *token;
static NSString *session;
static NSString *userId;
static NSString *userSex;
static NSString *companyName;
static NSString *portraitURL;
static NSString *authStatus;// 用户认证状态
static NSString *invitationPeople;// 邀请人手机号

static NSString *newVersionsTag;
static NSString *newVersions;
static NSString *newVersionsDesc;
static NSString *newVersionsURL;
static NSString *newVersionsForceUpdateTag;

static NetworkStatus currentStatus;

// User name
+ (void)setUserName:(NSString *)theUserName {
	
	if (nil != userName) {
		userName = nil;
	}
	
	userName = theUserName;
}

+ (NSString *)getUserName {
	
	return userName;
}

// Password
+ (void)setPassword:(NSString *)thePassword {
	
	if (nil != password) {
		password = nil;
	}
	
	password = thePassword;
}

+ (NSString *)getPassword {
	
	return password;
}

// Mobile
+ (void)setMobile:(NSString *)theMobile {
	
	if (nil != mobile) {
		mobile = nil;
	}
	
	mobile = theMobile;
}

+ (NSString *)getMobile {
	
	return mobile;
}

// Token
+ (void)setToken:(NSString *)theToken {
    
    if (nil != token) {
        token = nil;
    }
    token = theToken;
}

+ (NSString *)getToken {
    
    return token;
}

// Session
+ (void)setSession:(NSString *)theSession {
    
    if (session) {
        session = nil;
    }
    session = theSession;
}

+ (NSString *)getSession {
    
    return session;
}

// User ID
+ (void)setUserId:(NSString *)theUserId{
	
	if (nil != userId) {
		userId = nil;
	}
	userId = theUserId;
}

+ (NSString *)getUserId {
	
	return userId;
}

// User Sex
+ (void)setUserSex:(NSString *)theUserSex {
    
    if (nil != userSex) {
        userSex = nil;
    }
    userSex = theUserSex;
}

+ (NSString *)getUserSex {
    
    return userSex;
}

// Company Name
+ (void)setCompanyName:(NSString *)theCompanyName {
    
    if (nil != companyName) {
        companyName = nil;
    }
    companyName = theCompanyName;
}

+(NSString *)getCompanyName {
    
    return companyName;
}

// Portrait
+ (void)setPortraitUrl:(NSString *)thePortraitUrl {
    if (nil != portraitURL) {
        portraitURL = nil;
    }
    portraitURL = thePortraitUrl;
}

+ (NSString *)getPortraitUrl {
    
    return portraitURL;
}

// Authentication_status 用户认证状态（ 0未认证；1：认证中，3：已认证 ）
+ (void)setAuthenticationStatus:(NSString *)theAuthStatus {
    
    if (nil != authStatus) {
        authStatus = nil;
    }
    authStatus = theAuthStatus;
}

+ (NSString *)getAuthenticationStatus {
    return authStatus;
}

// Invitation People phone number
+ (void)setInvitationPeople:(NSString *)theInvitationPeople {
    if (nil != invitationPeople) {
        invitationPeople = nil;
    }
    invitationPeople = theInvitationPeople;
}

+ (NSString *)getInvitationPeople {
    return invitationPeople;
}

/*---------------------- New versions --------------------------*/
// New versions tag
+ (void)setNewVersionsTag:(NSString *)theNewVersionsTag {
    if (nil != newVersionsTag) {
        newVersionsTag = nil;
    }
    newVersionsTag = theNewVersionsTag;
}

+ (NSString *)getNewVersionsTag{
    return newVersionsTag;
}

// New versions force_update
+ (void)setNewVersionsForceUpdateTag:(NSString *)theNewVersionsForceUpdateTag {
    if (nil != newVersionsForceUpdateTag) {
        newVersionsForceUpdateTag = nil;
    }
    newVersionsForceUpdateTag = theNewVersionsForceUpdateTag;
}

+ (NSString *)getNewVersionsForceUpdateTag {
    return newVersionsForceUpdateTag;
}

// New versions
+ (void)setNewVersions:(NSString *)theNewVersions {
    if (nil != newVersions) {
        newVersions = nil;
    }
    newVersions = theNewVersions;
}

+ (NSString *)getNewVersions {
    return newVersions;
}

// New versions describe
+ (void)setNewVersionsDesc:(NSString *)theDescribe {
    if (nil != newVersionsDesc) {
        newVersionsDesc = nil;
    }
    newVersionsDesc = theDescribe;
}

+ (NSString *)getNewVersionsDesc {
    return newVersionsDesc;
}

// New versions URL
+ (void)setNewversionsURL:(NSString *)theURL {
    if (nil != newVersionsURL) {
        newVersionsURL = nil;
    }
    newVersionsURL = theURL;
}

+ (NSString *)getNewVersionsURL {
    return newVersionsURL;
}
/*--------------------------------------------------------------*/

// Clear login data
+ (void)clearLoginData {
	userName = nil;
	password = nil;
	mobile = nil;
    token = nil;
    
    session = nil;
    userId = nil;
    userSex = nil;
    companyName = nil;
    
    portraitURL = nil;
    authStatus = nil;
}

// Net Status
+ (void)updateNetStatus:(Reachability *)reach {
    
    currentStatus = [reach currentReachabilityStatus];
}

+ (NetworkStatus)currentNetWorkStatus {
    return currentStatus;
}

@end
