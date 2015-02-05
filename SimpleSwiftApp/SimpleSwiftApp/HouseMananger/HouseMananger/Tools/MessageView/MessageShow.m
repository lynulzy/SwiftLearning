//
//  MessageShow.m
//  JiayuanIPad
//
//  Created by TONG YU on 11-9-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MessageShow.h"

#import "DataDefine.h"

@implementation MessageShow

// theTime 表示自动关闭时间
+ (void)showMessageView:(NSInteger)type 
				   code:(NSInteger)code
					msg:(NSString *)msg 
			  autoClose:(NSInteger)autoClose 
                   time:(CGFloat)theTime {
    
    if (MSG_CODE_NET_NOT_REACHABLITY == code) {
        msg = @"网络连接不可用";
    }
	// Error code
	if (MSG_CODE_NETWORK_TIMEOUT == code) {
		msg = @"网络链接超时,请重试";
	} else if (MSG_CODE_NETWORK_NOT_CONN_1 == code) {
		msg = @"无法链接网络";
	} else if (MSG_CODE_NETWORK_NOT_CONN_2 == code) {
		msg = @"无法链接网络";
	} else if (MSG_CODE_NETWORK_NOT_CONN_3 == code) {
		msg = @"无法链接网络";
	}
	if (MSG_CODE_SERVER_INTERNAL == code) {
		msg = @"服务器内部错误";
	} else if (MSG_CODE_DATA_WRITE_CACHE_FAILED == code) {
		msg = @"写入缓存错误";
	} else if (MSG_CODE_CLIENT_UNCATCHED == code) {
		msg = @"未知错误";
	} else if (MSG_CODE_UNKNOWN == code) {
		msg = @"未知错误";
	}
    //regist
    if (MSG_CODE_REGIST == code)
    {
        msg = @"该用户已经注册";
    }
	
	// Login 
	if (MSG_CODE_LOGIN == code) {
		msg = @"正在登录,请稍后...";
	}
    if (code == MSG_CODE_LOGIN_SUCCESS)
    {
        msg = @"登录成功";
    }
	// Trade list
	if (MSG_CODE_TRADE_LIST == code) {
		msg = @"正在查询订单...";
	}
	// Trade info
	if (MSG_CODE_TRADE_INFO == code) {
		msg = @"正在查询订单详情...";
	} else if (MSG_CODE_TRADE_STATUS_UPDATE == code) {
		msg = @"正在提交订单状态...";
	}
	// Logout
	if (MSG_CODE_LOGOUT == code) {
		msg = @"正在登出...";
	}
    // Server define
    switch (code)
    {
        case MSG_CODE_SERVER_ERR_1001:
            msg = @"数据请求错误";
            break;
        case MSG_CODE_SERVER_ERR_1002:
            msg = @"服务器错误";
            break;
        case MSG_CODE_SERVER_ERR_1003:
            msg = @"注册失败,验证码错误";
            break;
        case MSG_CODE_SERVER_ERR_1004:
            msg = @"用户名不存在";
            break;
        case MSG_CODE_SERVER_ERR_1005:
            msg = @"登录失败";
            break;
        case MSG_CODE_SERVER_ERR_1006:
            msg = @"会话超时,请重新登录";
            break;
        case MSG_CODE_WRONGPHONE:
            msg = @"请填写正确的手机号";
            break;
        case ERR_CODE_USER_LOGIN_PW_ERR:
            msg = @"用户名或密码错误";
            break;
        case ERR_CODE_USER_CODE_MOBILE_EXIST:
            msg = @"手机号已注册";
            break;
        case ERR_CODE_USER_CODE_MOBILE_NOT_EXIST:
            msg = @"手机号不存在";
            break;
        case ERR_CODE_USER_CODE_API_FAILED:
            msg = @"第三方接口错误";
            break;
        case ERR_CODE_USER_CODE_CHECK_CODE_NOT_EXIST:
            msg = @"验证码不存在";
            break;
        case ERR_CODE_USER_CODE_CHECK_MOBILE_NOT_EXIST:
            msg = @"手机号不存在";
            break;
        case ERR_CODE_USER_REG_CODE_INVALID:
            msg = @"验证码错误";
            break;
//        case ERR_CODE_USER_REG_MOBILE_EXIST:
//            msg = @"手机号已存在";
//            break;
        case ERR_CODE_USER_CHANGE_PW_MOBILE_NOT_EXIST:
            msg = @"用户不存在";
            break;
        case ERR_CODE_USER_CHANGE_PW_OLD_PW_ERROR:
            msg = @"原密码错误";
            break;
        case ERR_CODE_USER_RESET_PW_TOKEN_INVALID:
            msg = @"token失效";
            break;
        case ERR_CODE_USER_RESET_PW_MOBILE_NOT_EXIST:
            msg = @"重设密码的手机号不存在";
            break;
        case ERR_CODE_USER_LOGIN_CHECK_USER_NOT_EXIST:
            msg = @"用户不存在";
            break;
        case ERR_CODE_USER_LOGIN_CHECK_SESSION_INVALID:
            msg = @"会话超时,将为您重新登录";
            break;
        case ERR_CODE_UNKNOWN_ERROR:
            msg = @"未知错误";
            break;
            
        default:
            break;
    }
	
	if (nil == msg) {
		msg = [NSString stringWithFormat:@"%ld", (long)code];
	}
	DDLog(@"msg=%@", msg);
	
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                                  [NSNumber numberWithLong:type],
                                                                  [NSNumber numberWithLong:code],
                                                                  msg,
                                                                  [NSNumber numberWithLong:autoClose],
                                                                  [NSNumber numberWithFloat:theTime], nil]
														 forKeys:[NSArray arrayWithObjects:
                                                                  @"type",
                                                                  @"code",
                                                                  @"message",
                                                                  @"auto_close",
                                                                  @"time", nil]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTI_NAME_APPEAR_FULL_SCREEN_MSG_VIEW
														object:nil 
													  userInfo:userInfo];
}

+ (void)closeMsgAlertView {
	
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTI_NAME_DISAPPEAR_FULL_SCREEN_MSG_VIEW
														object:nil 
													  userInfo:nil];
}

@end
