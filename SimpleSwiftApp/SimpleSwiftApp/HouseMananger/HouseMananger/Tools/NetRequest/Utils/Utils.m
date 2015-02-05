//
//  Utils.m
//  JiayuanIPad
//
//  Created by TONG YU on 11-9-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import "Param.h"
#import "UserTmpParam.h"
#import "MD5.h"

@implementation Utils
+ (NSDictionary *)getUrlParams:(NSString *)theUrl {
	
	if (nil == theUrl)
		return nil;
	
	if (![theUrl isKindOfClass:[NSString class]])
		return nil;
	
	if ( ![theUrl hasPrefix:@"http://"] 
		&& ![theUrl hasPrefix:@"https://"])
		return nil;
	
	NSRange qmRange = [theUrl rangeOfString:@"#"];
	if (NSNotFound != qmRange.location) {
		
		NSString *sParams = [theUrl substringFromIndex:(qmRange.location + 1)];
		NSString *sTmp;
		NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
		for (;;) {
			NSRange range = [sParams rangeOfString:@"&"];
			
			if (NSNotFound != range.location) {
				sTmp = [sParams substringToIndex:range.location];
				sParams = [sParams substringFromIndex:(range.location + 1)];
			} else {
				sTmp = sParams;
				sParams = nil;
			}
			DLOG(@"sTmp=%@", sTmp);
			DLOG(@"sParams=%@", sParams);
			
			NSRange eRange = [sTmp rangeOfString:@"="];
			[dic setValue:[sTmp substringFromIndex:(eRange.location + 1)] 
				   forKey:[sTmp substringToIndex:eRange.location]];
			
			if ( nil == sParams 
				|| 0 == [sParams length] ) {
				break;
			}
		}
		
		return dic;
		
	}
	return nil;
	
}
+ (NSString *)calculateAgeFrom:(NSString *)birth
{
    NSDate *now = [NSDate date];
    NSTimeZone *localTimeZone = [NSTimeZone systemTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:localTimeZone];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //将当前日期转化成响与birth一直格式的日期
    NSDate *now_F = [formatter dateFromString:[formatter stringFromDate:now]];
    NSDate *birth_F = [formatter dateFromString:birth];
    NSInteger now_timeStamp = [now_F timeIntervalSince1970];
    NSInteger birth_timeStamp = [birth_F timeIntervalSince1970];
    NSInteger timeDiff = now_timeStamp - birth_timeStamp;
    NSString *age;
    if (timeDiff/(24*3600)> 30) {
        //月
        if(12 < timeDiff/(24*3600*30))
        {
            //年
            age =[NSString stringWithFormat:@"%d岁",timeDiff/(24*3600*30*12)];
            return age;
        }
        else
        {
            age = [NSString stringWithFormat:@"%d个月",timeDiff/(24*3600*30)];
            return age;
        }
    }
    else
    {
        age = [NSString stringWithFormat:@"%d天",timeDiff/(24*3600)];
        return age;
    }
}

+ (NSString *)signWithParam:(NSDictionary *)theParam {
	
	DLOG(@"theParam=%@", theParam);
	
	// Sort the keys 
	NSMutableArray *keys = [NSMutableArray arrayWithArray:[theParam allKeys]];
	[keys sortUsingSelector:@selector(caseInsensitiveCompare:)];
	
	NSString *strBeforeSign = @"";
	
	// Get string before sign 
	strBeforeSign = [strBeforeSign stringByAppendingString:[[Param getAppSecret] lowercaseString]];
	for (NSString *_key in keys) {
		strBeforeSign = [strBeforeSign stringByAppendingFormat:@"%@", _key];
		strBeforeSign = [strBeforeSign stringByAppendingFormat:@"%@", [theParam objectForKey:_key]];
	}
	strBeforeSign = [strBeforeSign stringByAppendingString:[[Param getAppSecret] lowercaseString]];
	DLOG(@"strBeforeSign=%@", strBeforeSign);
	
	return [[MD5 md5:strBeforeSign] uppercaseString];
}

+ (NSString *)signWithParam2:(NSDictionary *)theParam {
	
	DLOG(@"theParam=%@", theParam);
	
	// Sort the keys 
	NSMutableArray *keys = [NSMutableArray arrayWithArray:[theParam allKeys]];
	[keys sortUsingSelector:@selector(caseInsensitiveCompare:)];
	
	NSString *strBeforeSign = @"";
	
	// Get string before sign 
	for (NSString *_key in keys) {
		strBeforeSign = [strBeforeSign stringByAppendingFormat:@"%@", _key];
		strBeforeSign = [strBeforeSign stringByAppendingFormat:@"%@", [theParam objectForKey:_key]];
	}
	strBeforeSign = [strBeforeSign stringByAppendingString:[[Param getSignSecret] lowercaseString]];
	DLOG(@"strBeforeSign=%@", strBeforeSign);
	
	return [[MD5 md5:strBeforeSign] lowercaseString];
}

+ (NSString *)signWithParam3:(NSDictionary *)theParam {
	
	DLOG(@"theParam=%@", theParam);
	
	return [[MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [theParam objectForKey:@"act"], APP_ID, APP_SECRET, SESSION_KEY ,[theParam objectForKey:@"timestamp"], [theParam objectForKey:@"data"], API_SIGN_KEY]] lowercaseString];
}

// ---------------------- ----------------------
+ (NSString *)getTradeStatusDesc:(TradeStatus)theTradeStatus {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"tradestatus" ofType:@"plist"];
	NSDictionary *status = [[NSDictionary alloc] initWithContentsOfFile:path];
	
	return [status objectForKey:[NSString stringWithFormat:@"%d", theTradeStatus]];
}

+ (NSString *)formatPrice:(NSString *)theFormatPrice {
	
	NSInteger dotIdx = [theFormatPrice rangeOfString:@"."].location;
	if (NSNotFound == dotIdx) {
		return theFormatPrice;
	}
	
	NSInteger toIdx = [theFormatPrice length] - 1;
	for (; toIdx > dotIdx; toIdx--) {
		if (48 != (NSInteger)[theFormatPrice characterAtIndex:toIdx])	// 48 = 0
			break;
	}
	
	return [theFormatPrice substringToIndex:(toIdx + 1)];
}

+ (NSString *)formatDistance:(NSString *)theDistance {
	
	NSInteger iDist = [theDistance integerValue];
	if (iDist / 1000 > 0) {
		return [NSString stringWithFormat:@"%.2f公里", (iDist / 1000.0F)];
	}
	
	if (iDist / 500 > 0) {
		return [NSString stringWithFormat:@"%ld米", (long)iDist];
	}
	
	return @"小于500米";
}

// ---------------------- ----------------------
+ (BOOL)isLogin {
	//目前使用到的参数UserTmpParam UserId SessionId
	if (nil == [UserTmpParam getUserName]
		/*|| nil == [UserTmpParam getPassword]
		|| nil == [UserTmpParam getMobile]*/
		|| nil == [UserTmpParam getUserId]
		/*|| nil == [UserTmpParam getShopId]
		|| nil == [UserTmpParam getEmployeeId]*/
		|| nil == [UserTmpParam getSessionId]) {
		
		return NO;
	}
	
	return YES;
}

// ---------------------- ----------------------
+ (NSArray *)getPropertyAlias:(NSString *)theProp {
	
	NSMutableArray *props = [NSMutableArray arrayWithArray:[theProp componentsSeparatedByString:@";"]];
	for (int i = 0; i < [props count]; i++) {
		
		NSString *prop = [props objectAtIndex:i];
		// Find first ":"
		NSRange range = [prop rangeOfString:@":"];
		prop = [prop substringFromIndex:(range.location + range.length)];
		// Find second ":"
		range = [prop rangeOfString:@":"];
		prop = [prop substringFromIndex:(range.location + range.length)];
		//
		[props removeObjectAtIndex:i];
		[props insertObject:prop atIndex:i];
	}
	
	return [NSArray arrayWithArray:props];
}

// ---------------------- ----------------------
+ (void)showNetworkIndicator {
	
	NSInteger count = [Param getNetworkIndicatorCount];
	
	if (0 == count) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}
	
	++count;
	
	[Param setNetworkIndicatorCount:count];
}

+ (void)dismissNetworkIndicator {
	
	NSInteger count = [Param getNetworkIndicatorCount];
    if (count>0) {
        --count;
    }
	if (0 == count) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
	
	[Param setNetworkIndicatorCount:count];
}

// ---------------------- ----------------------
// Valid email 
+ (BOOL)validateEmail:(NSString *)candidate {
	
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	
	return [emailTest evaluateWithObject:candidate];
}

// Valid password 
+ (BOOL)isAlphaNumeric:(NSString *)checkString {
	
	NSCharacterSet *alphaSet = [NSCharacterSet alphanumericCharacterSet];
	return [[checkString stringByTrimmingCharactersInSet:alphaSet] isEqualToString:@""];
}

// Valid phoneNumber 
+ (BOOL)validatePhoneNumber:(NSString *)checkString{
	
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0235-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[156])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:checkString] == YES)
        || ([regextestcm evaluateWithObject:checkString] == YES)
        || ([regextestct evaluateWithObject:checkString] == YES)
        || ([regextestcu evaluateWithObject:checkString] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

// Valid number 
+ (BOOL)isNumber:(NSString *)checkString {
	
	int length = (int)[checkString length];
    
    for (int index = 0; index < length; index++) {
		
        unichar endCharacter = [checkString characterAtIndex:index];
        if (endCharacter >= '0' && endCharacter <= '9') 
            continue;
        else
            return NO;
    }
    
    return YES;
	
	//NSCharacterSet *alphaSet = [checkString componentsSeparatedByCharactersInSet:[NSCharacterSet letterCharacterSet] ];
	//return [[checkString stringByTrimmingCharactersInSet:alphaSet] isEqualToString:@""];
}
//检查密码中的特殊字符
+ (BOOL)checkSpecialCharacter:(NSString *)str
{
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange specialCharacterRange = [str rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (NSNotFound == specialCharacterRange.location) {
        return NO;
    }
    return YES;
}

@end
