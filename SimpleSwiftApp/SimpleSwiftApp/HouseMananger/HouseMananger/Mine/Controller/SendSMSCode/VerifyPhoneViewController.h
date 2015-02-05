//
//  VerifyPhoneViewController.h
//  MiShiClient-Pro
//
//  Created by ZXH on 14-10-16.
//  Copyright (c) 2014年 ZSXJ. All rights reserved.
//

/****
 *
 *  短信验证 界面
 *
 ****/

#import <UIKit/UIKit.h>

@interface VerifyPhoneViewController : UIViewController

@property(nonatomic, copy) NSString *trueName;
@property(nonatomic, copy) NSString *phoneNumber;
@property(nonatomic, copy) NSString *passWord;
@property(nonatomic, copy) NSString *invitPhone;

@property(nonatomic, copy) NSString *fromFunc;//1 是注册时候使用的 2 是重置密码的时候使用的

@end
