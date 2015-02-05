//
//  Utils.h
//  JiayuanIPad
//
//  Created by TONG YU on 11-9-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Define.h"

@interface Utils : NSObject {
	
}
@property (nonatomic,assign) BOOL isUserLogin;
+ (NSDictionary *)getUrlParams:(NSString *)theUrl;
+ (NSString *)signWithParam:(NSDictionary *)theParam;
+ (NSString *)signWithParam2:(NSDictionary *)theParam;
+ (NSString *)signWithParam3:(NSDictionary *)theParam;

+ (NSString *)getTradeStatusDesc:(TradeStatus)theTradeStatus;
+ (NSString *)formatPrice:(NSString *)theFormatPrice;
+ (NSString *)formatDistance:(NSString *)theDistance;
//计算年龄
+ (NSString *)calculateAgeFrom:(NSString *)birth;
//检查密码中的特殊字符
+ (BOOL)checkSpecialCharacter:(NSString *)str;

+ (BOOL)isLogin;

+ (NSArray *)getPropertyAlias:(NSString *)theProp;

+ (void)showNetworkIndicator;
+ (void)dismissNetworkIndicator;

+ (BOOL)validateEmail:(NSString *)candidate;
+ (BOOL)isAlphaNumeric:(NSString *)checkString;
+ (BOOL)validatePhoneNumber:(NSString *)checkString;
+ (BOOL)isNumber:(NSString *)checkString;

@end
