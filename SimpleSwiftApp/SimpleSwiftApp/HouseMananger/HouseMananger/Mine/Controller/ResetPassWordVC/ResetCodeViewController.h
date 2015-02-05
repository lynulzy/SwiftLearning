//
//  ResetCodeViewController.h
//  MiShiClient-Pro
//
//  Created by ZSXJ on 14-10-20.
//  Copyright (c) 2014年 zsxj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResetCodeDataController.h"
@interface ResetCodeViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,ResetCodeDataControllerDelegate>
@property(nonatomic,strong)  NSString *phoneNumber;
@property (nonatomic,strong) NSString *smsCode;
@end
