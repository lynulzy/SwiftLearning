//
//  Define.h
//  BasketballTV
//
//  Created by viki on 11/26/09.
//  Copyright 2009 asfd. All rights reserved.
//

#ifndef MY_HTTP_DEFINE_CLASS
#define MY_HTTP_DEFINE_CLASS

// Request timeout
#define TIMEINTERVAL_HTTP_URL_REQUEST		(30.0F) 
#define TIMEINTERVAL_PIC_URL_REQUEST		(60.0F) 

#define TIMEINTERVAL_HTTP_EXPIRE			(60*60*24) //(60*60*24) //(1)
//#define TIMEINTERVAL_PIC_EXPIRE			(1) //(60*60*24) //(1)

// Base
#define URL_BASE							@""
#define URL_BASE_TEST                       @"http://121.199.38.85/houseclient/api.php"

// URL
// 版本升级
#define URL_UPGRADE                         @"soft_upgrade"

// 登录
#define URL_LOGIN							@"submit_user_login"

// 退出登录
#define URL_SIGN_OUT						@"submit_user_logout"

// 注册
#define URL_REGITST                         @"submit_user_register"

// 发送短信验证码
#define URL_SEND_SMS_CODE                   @"submit_user_send_mobile_code"

// 重置密码
#define URL_RESET_PSW                       @"submit_user_reset_pw"

// 我的消息
#define URL_MYNEWS_LIST                     @"get_msg_list"

// 用户反馈
#define URL_USER_FEEDBACK                   @"user_feedback"

// 佣金列表
#define URL_COMMISSION_LIST                 @"get_commission_list"

// 佣金详情
#define URL_COMMISSION_DETAIL               @"get_commission"

// 已报备的客户
#define URL_CUSTOMER_AF                     @"get_report_customer_list"

// 经纪人经验值排行
#define URL_ANGET_RANK                      @"agent_rank_list"

// 楼盘报备排行
#define URL_BUILD_RANK                      @"build_rank_list"

// 修改头像
#define URL_EDIT_PORTRAIT                   @"edit_portrait"

// 修改用户信息
#define URL_EDIT_USER                       @"edit_user"

// 论坛列表
#define URL_TALKING_LIST                    @"get_say_list"

// 论坛详情
#define URL_TALKING_DETAIL                  @"get_say"

// 论坛回复
#define URL_TALKING_REPLY                   @"reply_say"


#define URL_GET_SERVER_TIME					@"get_server_time"

// 用户条款
#define URL_PRIVACY_POLICY                  @"http://121.199.38.85/mishiclient/Agreement/xieyi.html"

//
#define HTTP_CONTROLLER_TEST						(999)

// URL Control Tag
// 版本升级
#define HTTP_CONTROLLER_UPGRADE						(1)

// 登录
#define HTTP_CONTROLLER_LOGIN						(2)

// 我的消息
#define HTTP_CONTROLLER_MYNEWS_LIST					(3)

// 经纪人排行
#define HTTP_CONTROLLER_AGENT_RANK_LIST             (4)

#define HTTP_CONTROLLER_BUILD_RANK_LIST             (5)

// 佣金列表
#define HTTP_CONTROLLER_COMMISSION_LIST             (6) //待结佣金
#define HTTP_CONTROLLER_COMMISSION_FINISH_LIST      (7) //已结佣金

// 佣金详情
#define HTTP_CONTROLLER_COMMISSION_DETAIL			(8)

// 重置密码
#define HTTP_CONTROLLER_RESET_PSW                   (9)

// 用户反馈
#define HTTP_CONTROLLER_USER_FEEDBACK               (10)

// 修改头像
#define HTTP_CONTROLLER_EDIT_PORTRAIT               (11)

// 修改用户信息
#define HTTP_CONTROLLER_EDIT_USER                   (12)

// 论坛
#define HTTP_CONTROLLER_TALKING_LIST                (13) // 论坛列表
#define HTTP_CONTROLLER_TALKING_DETAIL              (14) // 动态详情
#define HTTP_CONTROLLER_REPLY                       (15) // 回复

// Logout
#define HTTP_CONTROLLER_LOGOUT						(16)

// Re login
#define HTTP_CONTROLLER_RELOGIN                     (17)

// Regist
#define HTTP_CONTROLLER_SMSCODE                     (18)//获取验证码
#define HTTP_CONTROLLER_CHECKVARIFYCODE             (19)//检查验证码
#define HTTP_CONTROLLER_REGIST                      (20)//发送注册信息
#define HTTP_CONTROLLER_CHANGE_PW                   (21)//修改密码

#define HTTP_CONTROLLER_CUSTOMER_AF                 (22)

#define HTTP_CONTROLLER_PER_PAGE_BASE               (23)

//修改个人信息
#define HTTP_CONTROLLER_MODIFY_MYINFO               (24)//个人信息

#define HTTP_CONTROLLER_UPLOAD_PORTRAIT             (25)//上传头像

#define HTTP_CONTROLLER_PAGENUM1                      (1)
#define HTTP_CONTROLLER_PAGENUM2                      (2)
#define HTTP_CONTROLLER_PAGENUM3                      (3)
#define HTTP_CONTROLLER_PAGENUM4                      (4)
#define HTTP_CONTROLLER_PAGENUM5                      (5)
#define HTTP_CONTROLLER_PAGENUM6                      (6)
#define HTTP_CONTROLLER_PAGENUM7                      (7)

/*
 每个HttpController的tag的计算规则
 (页码*每页最大个数)+种类代码
 
 eg:首页(PAGENUM1)的登录请求(LOGIN)的tag = HTTP_CONTROLLER_PAGENUM1*HTTP_CONTROLLER_PER_PAGE_BASE+HTTPCONTROLLER_LOGIN
 
 
 */

// X,00,000,00 + YY * 1,000,00 + i * 1,00 + jj
// INFO_QUERY_GET_CONTROLLER_BASE + theFromTag * CONTROLLER_BASE + theIndex * I_BASE + 0
//#define MULTI_URL_BASE							(10000000)
//#define CONTROLLER_BASE							(  100000)
//#define I_BASE									(     100)
#define MULTI_URL_BASE								(100000000)
#define CONTROLLER_BASE								(  1000000)
#define I_BASE										(      100)

#define PIC_LIST_GET_CONTROLLER_BASE				(1 * MULTI_URL_BASE)
#define PIC_GET_CONTROLLER_BASE						(2 * MULTI_URL_BASE)
#define ITEM_LIST_GET_CONTROLLER_BASE				(3 * MULTI_URL_BASE)
#define ITEM_GET_CONTROLLER_BASE					(4 * MULTI_URL_BASE)
#define ITEM_TRADE_GET_CONTROLLER_BASE				(5 * MULTI_URL_BASE)

#endif
