//
//  Common.h
//  Vpubao
//
//  Created by 王晗 on 14-11-6.
//  Copyright (c) 2014年 王晗. All rights reserved.
//

#ifndef WXMovie_Common_h
#define WXMovie_Common_h

//屏幕的宽、高
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define ios7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
//通知名字
#define UPLOAD_IMAGE_NOTIFI @"upload_image_notifi"
#define REQDATA_ERROR_NOTIFI @"reqdata_error_notifi"

#define OPENTIMER @"open_timer_notifi"

//BASE URL
#define BASE_URL @"http://121.199.38.85/houseclient/api.php"
//新浪微博的key
#define kAppKey             @"2182570578"
#define kAppSecret          @"19fbaaf0171c75f727da7fcd40726866"



//////////////////////////////url接口//////////////////////////


#define FontSize_Weibo(isDetail) isDetail?16:15
#define FontSize_ReWeibo(isDetail) isDetail?15:14

#endif
