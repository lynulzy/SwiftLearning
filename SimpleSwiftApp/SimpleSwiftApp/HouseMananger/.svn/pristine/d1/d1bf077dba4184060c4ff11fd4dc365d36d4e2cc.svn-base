//
//  Define.h
//  ELong
//
//  Created by TONG YU on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#ifndef ELong_Define_h
#define ELong_Define_h

// 买家应用 
// @"12444486";
// @"504240880eb50853add08b5b58ec0821";

// 在线订购应用 
// @"12027926";
// @"27723890b93e24b5255e49f8eda37cd9";

// onlyforlin 
// @"12592234";
// @"ad2df91a527aeb7b92c31d80d1382ac4";

// @"21026692"
// @"22ba0317f6c7318349e7803b5dc071b8"

// vikiunique - 12592234 
// AccessToken:
// 61027258eebca5feb1d583a586b2933611840f2789694aa143289568

// onlyforlin - 12592234
// onlyforlin / kylkyl00
// AccessToken:
// 6102315d5ec6bf016d87de215ac9dff3106cfc41969fb4a90258759

//#define _DEBUG_
#ifdef _DEBUG_
#define DLOG(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define DLOG(format, ...)
#endif
#define APPSTORE_ID    @"917630333"//当前设置的是米氏商家中心的ID

//#define _USE_TEST_ACCESS
#define ACCESS_TOKEN @"6101f0198192d8cafc68dcffb1eca8d357af65c56d88b3e143289568"
#define REFRESH_TOKEN @"6102a293051115240f0bfa4c215272f3e4ab914ec178dca143289568"

// Device or sumulator
#if TARGET_IPHONE_SIMULATOR
#elif TARGET_OS_IPHONE
#define DEVICE_COMPILER
#endif

//#define READ_PIC_FROM_CACHE 

//#define TEST_NEW_REQUEST 
//#define WANG_WANG_TO_USER 
//#define AppKey2

// Trade status
typedef enum {
												//		订单状态：		订单状态选项：		操作名称：
    TradeStatus_WAIT_SNATCH = 1,				//1  -- 待抢单			待抢单
    TradeStatus_WAIT_SNATCH_CANCEL = 2,			//2  -- 待抢单放弃		待抢单放弃		放弃
    TradeStatus_WAIT_SNATCH_TIMEOUT = 3,		//3  -- 待抢单超时		待抢单超时
    TradeStatus_SNATCHED = 4,					//4  -- 已抢单			已抢单			抢单
    TradeStatus_SNATCHED_CANCEL = 5,			//5  -- 已抢单取消		已抢单取消		取消
    TradeStatus_GOOD_PREPARE = 6,				//6  -- 已配货			已配货			配货
    TradeStatus_GOOD_DELIVERY = 8,				//8  -- 已配送			已配送			配送
    TradeStatus_GOOD_SIGNED = 9,				//9  -- 已签收[已发货]		已签收			签收
    TradeStatus_GOOD_SIGN_REJECT = 10,			//10 -- 已拒收[已取消]		已拒收			拒收
    TradeStatus_RECYCLE = 11,					//11 -- 无抢单回收		无抢单回收
    TradeStatus_SNATCHED_NO_OK_TIMEOUT = 12,	//12 -- 门店处理超时回收	门店处理超时回收
    TradeStatus_SNATCHED_NO_OK_RECYCLE = 13,	//13 -- 超时强制回收		超时强制回收
    TradeStatus_UNKNOWN = 0,					//0  -- 未知状态
    TradeStatus_ALL_STATUS = 100,				//100--	所有状态
} TradeStatus;
#define IOS7      ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] <= 8.0 ? YES : NO)
#define IOS7Later ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define IOS8Later ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)
//#define TAB_BAR_COLOR       [UIColor colorWithRed:2/255.0 green:153/255.0 blue:255/255.0 alpha:1.0F]
#define TAB_BAR_COLOR       [UIColor colorWithRed:4/255.0 green:169/255.0 blue:148/255.0 alpha:1.0F]

#define BACK_COLOR          [UIColor colorWithRed:249/255.0F green:249/255.0F blue:249/255.0F alpha:1.0F]
#define BACK_COLOR_DARK     [UIColor colorWithRed:244/255.0F green:244/255.0F blue:244/255.0F alpha:1.0F]
CGFloat origin_x;
CGFloat origin_y;
CGFloat size_width;
CGFloat size_height;

#define API_SIGN_KEY	@"*)8.~1`@X=^7!%#K;_$-"
#define RC4_SIGN_KEY	@"*)8.~1`@X=^7!%#K;_$-"
#define APP_ID          @"666669"
#define APP_SECRET      @"a5537b0f0b0438dbedf7eaa8372d4f85"
#define SESSION_KEY     @"u2fsdgvkX18"

#define NOTI_NAME_BACKGROUND                        @"noti_name_enter_background"//程序后台运行
#define NOTI_NAME_LOGIN_SUCC						@"noti_name_login_succ"     //登录成功12.10
#define NOTI_NAME_SMSCODE_CORRECT                   @"noti_name_smsCode_correct"//验证过程成功
#define NOTI_NAME_REGIST_SUCC                       @"noti_name_regist_succ"    //注册成功
#define NOTI_NAME_LOGOUT_SUCC						@"noti_name_logout_succ"    //登出成功12.10
#define NOTI_NAME_RESETPW_SUCC                      @"noti_name_resetPW_secc"   //重置密码成功

#define NOTI_NAME_TRADE_LIST_LOAD_DATA				@"noti_name_trade_list_load_data"
#define NOTI_NAME_TRADE_STATUS_LIST_UPDATE			@"noti_name_trade_status_list_update"
#define NOTI_NAME_APPEAR_NAV_MENU					@"noti_name_appear_nav_menu"
#define NOTI_NAME_DISAPPEAR_NAV_MENU				@"noti_name_disappear_nav_menu"

#define NOTI_NAME_DISAPPEAR_QUESTION_MENU           @"noti_name_disappear_question_menu"

#define NOTI_NAME_APPEAR_FULL_SCREEN_MSG_VIEW		@"noti_name_appear_full_screen_msg_view"
#define NOTI_NAME_DISAPPEAR_FULL_SCREEN_MSG_VIEW	@"noti_name_disappear_full_screen_msg_view"

typedef enum {
	
    CalendarType_In_time = 0,	// 0 -- In time 
    CalendarType_Out_time,		// 1 -- Out time 
	
}CalendarType;

typedef enum {
	
    ASRangeSliderType_Star = 0, 	//0 -- Star 
    ASRangeSliderType_Price,		//1 -- Price 
    ASRangeSliderType_Distance,		//2 -- Distance 
	
}ASRangeSliderType;

typedef enum {
	
    SearchShowMode_List = 0, 	// 0 -- List 
    SearchShowMode_Map,			// 1 -- Map 
	
}SearchShowMode;

typedef enum {
	
    SearchType_basic = 0, 	// 0 -- Basic 
    SearchType_advance,		// 1 -- Advance 
    SearchType_distance		// 2 -- Distance 
	
}SearchType;

typedef enum {
	
    SearchRankingType_default = 0, 	// 0 -- Basic 
	SearchRankingType_price,		// 1 -- Advance 
    SearchRankingType_distance		// 2 -- Distance 
	
}SearchRankingType;


typedef enum {
	
    Hotel_Detail_Function_XML = 0,	// 0 -- xml 
    Hotel_Detail_Function_JSON,		// 1 -- json 
    Hotel_Detail_Function_JSON2		// 2 -- json2 
	
}Hotel_Detail_Function;
#define USE_HOTEL_DETAIL_FUNCTION Hotel_Detail_Function_JSON2 

typedef enum {
	
    Hotel_CITY_FILE_0 = 0,	// 0 -- citydict.plist 
    Hotel_CITY_FILE_1		// 1 -- hotelcity.plist 
	
}Hotel_CITY_FILE;
#define USE_Hotel_CITY_FILE Hotel_CITY_FILE_1 

// Login 
typedef enum {
	
    Login_Type_Mobile = 0,		// 0 -- mobile 
    Login_Type_Weibo_Sina,		// 1 -- weibo_sina 
    Login_Type_Weibo_QQ			// 2 -- weibo_sina 
	
} Login_Type;

// LoginManager 
typedef enum {
    JYLoginSourceSina,		//0 -- sina微博
    JYLoginSourceQQ			//1 -- 腾讯微博
} JYLoginSource;

// ShareManager 
typedef enum {
    JYShareSourceSMS = 0,	//0 -- 短信
    JYShareSourceMail,		//1 -- 邮件
    JYShareSourceSina,		//2 -- sina微博
    JYShareSourceQQ			//3 -- 腾讯微博
} JYShareSource;

// SinaWeiBo 
typedef enum {
	
    SinaWeibo_method_Share = 0,	// 0 -- Do share 
    SinaWeibo_method_Login,		// 1 -- Do login 
	
} SinaWeibo_method;

// QQWeiBo 
typedef enum {
	
    QQWeibo_method_Share = 0,	// 0 -- Do share 
    QQWeibo_method_Login,		// 1 -- Do login 
	
} QQWeibo_method;

#define DEFAULT_LOWEST_PRICE	[NSNumber numberWithInt:880]
#define DEFAULT_STAR_CODE		@"4"

// The third part 
// Sina weibo 
#define SinaWeiBo_APPKey     @"1531867093"
#define SinaWeiBo_APPSecret  @"aa368b864a7c53c6705942eb0c2b1873"
// QQ weibo 
//#define QQWeiBo_APPKey     @"cfca46a9dc754e5c815b2afb6d407e6f"
//#define QQWeiBo_APPSecret  @"9ab82d507b173decb737ffdca7f49c67"
#define QQWeiBo_APPKey     @"801086521"
#define QQWeiBo_APPSecret  @"2390ecbf5d6fb0a07cc15cd4e8560e82"

//#define IMEI @"aaaaaaaaaaaaaaaaaa123456"

#define kReloginSessionIdUpdated @"sessionId have Updated after relgoin"

#endif
