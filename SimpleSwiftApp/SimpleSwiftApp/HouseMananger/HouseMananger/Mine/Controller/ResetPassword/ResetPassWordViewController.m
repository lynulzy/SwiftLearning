//
//  ResetPassWordViewController.m
//  HouseMananger
//
//  Created by ZXH on 15/1/9.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "ResetPassWordViewController.h"

#import "VerifyPhoneViewController.h"

#import "Define.h"
#import "DataDefine.h"
#import "MessageShow.h"
#import "Utils.h"

#define TAG_NEXT_NAVBT                      102
#define TAG_BT_NEXT                         103
#define TAG_PHONENUM_TF                     1001
#define TAG_NEW_PSW_TF                      1002

#define TAG_ALERT_VERIFY_USERINFO_ERROR           3001
#define TAG_ALERT_VERIFY_USERINFO_OK              3002


#define HEIGHT_TF                           35.0f

@interface ResetPassWordViewController ()
<
UITextFieldDelegate,
UIAlertViewDelegate
>
{
    //View
    UITextField *_phoneNumTF;
    UITextField *_resetPSWTF;
    
    //ErrorCode
    NSInteger errMsgCode;
}
@end

@implementation ResetPassWordViewController

- (void)dealloc {
    DDLog(@"ForgerPSWViewController dealloc")
}

- (void)viewDidAppear:(BOOL)animated {
    [_phoneNumTF becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BACK_COLOR;
    
    if (IOS7Later) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.barTintColor = TAB_BAR_COLOR;
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"重置密码";
    
    [self buildNavBar];
    [self loadSubviews];
}

- (void)buildNavBar {
    // push到下一页 后 返回的按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"返回";
    self.navigationItem.backBarButtonItem = backBtn;
    
    // 右上角注册按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)loadSubviews {
    
    // 手机号TextField
    _phoneNumTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, size_width - 40, HEIGHT_TF)];
    _phoneNumTF.background = [UIImage imageNamed:@"textField_bg.png"];
    _phoneNumTF.tag = TAG_PHONENUM_TF;
    _phoneNumTF.delegate = self;
    _phoneNumTF.clearButtonMode = UITextFieldViewModeAlways;
    _phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumTF.returnKeyType = UIReturnKeyNext;
    _phoneNumTF.placeholder = @" 请输入用户的手机号码";
    _phoneNumTF.font = [UIFont systemFontOfSize:15.0F];
    [self.view addSubview:_phoneNumTF];
    
    // 重置密码
    _resetPSWTF = [[UITextField alloc] initWithFrame:CGRectMake(20, _phoneNumTF.frame.origin.y + _phoneNumTF.frame.size.height + 5, size_width - 40, HEIGHT_TF)];
    _resetPSWTF.background = [UIImage imageNamed:@"textField_bg.png"];
    _resetPSWTF.tag = TAG_NEW_PSW_TF;
    _resetPSWTF.delegate = self;
    _resetPSWTF.clearButtonMode = UITextFieldViewModeAlways;
    _resetPSWTF.keyboardType = UIKeyboardTypeURL;
    _resetPSWTF.returnKeyType = UIReturnKeyNext;
    _resetPSWTF.placeholder = @" 新密码";
    _resetPSWTF.font = [UIFont systemFontOfSize:15.0F];
    [self.view addSubview:_resetPSWTF];
    
    // 下一步Button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, _resetPSWTF.frame.origin.y + _resetPSWTF.frame.size.height + 15, size_width - 40, 35);
    btn.backgroundColor = TAB_BAR_COLOR;
    btn.tag = TAG_BT_NEXT;
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_phoneNumTF resignFirstResponder];
}

- (void)rightBarButtonClick{
   
    NSString *phoneNum = _phoneNumTF.text;
    NSString *newPSW = _resetPSWTF.text;
    
    [_phoneNumTF resignFirstResponder];
    
    [self verifyUserInfo:phoneNum andPassword:newPSW];
}

// 初步检查 用户名 密码 格式
- (void)verifyUserInfo:(NSString *)phoneNum andPassword:(NSString *)password {
    // Check, and Do login
    errMsgCode = -1;
    NSString *errMsg = nil;
    if (nil == password || [password isEqualToString:@""] || 6 > [password length] || 20 < [password length])
    {
        errMsgCode = MSG_CODE_LOGIN_ERR_1;
        errMsg = @"密码长度为6-20位";
    }
    
    if (nil == password || [password isEqualToString:@""]) {
        errMsgCode = MSG_CODE_LOGIN_ERR_2;
        errMsg = @"请输入新密码";
    }
    
    if (![phoneNum isEqualToString:@""] &&
        ![password isEqualToString:@""] &&
        ![Utils validatePhoneNumber:phoneNum])
    {
        errMsgCode = MSG_CODE_LOGIN_ERR_3;
        errMsg = @"手机号码格式不正确";
    }
    
    if (nil == phoneNum || [phoneNum isEqualToString:@""]) {
        errMsgCode = MSG_CODE_LOGIN_ERR_4;
        errMsg = @"请填写用户手机号";
    }
    
    if (-1 != errMsgCode) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:errMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新输入", nil];
        alert.tag = TAG_ALERT_VERIFY_USERINFO_ERROR;
        [alert show];
        return;
    }
    
    // 提示用户 将要发送短信验证码
    NSString *msg = [NSString stringWithFormat:@"将要向%@发送验证短信,请注意查收", phoneNum];
    UIAlertView *alertSendSMS = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
    alertSendSMS.tag = TAG_ALERT_VERIFY_USERINFO_OK;
    [alertSendSMS show];
}

// Push到 短信验证码页面
- (void)goToVerifyVCUsing:(NSString *)phoneNum and:(NSString *)newPSW {
    
    VerifyPhoneViewController *verifyVC = [[VerifyPhoneViewController alloc] init];
    verifyVC.phoneNumber = phoneNum;
    verifyVC.passWord = newPSW;
    verifyVC.fromFunc = @"2";
    [self.navigationController pushViewController:verifyVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex && TAG_ALERT_VERIFY_USERINFO_ERROR == alertView.tag) {
        
        if (MSG_CODE_LOGIN_ERR_1 == errMsgCode || MSG_CODE_LOGIN_ERR_2 == errMsgCode) {
            [_resetPSWTF becomeFirstResponder];
        }
        if (MSG_CODE_LOGIN_ERR_3 == errMsgCode || MSG_CODE_LOGIN_ERR_4 == errMsgCode) {
            [_phoneNumTF becomeFirstResponder];
        }
    }
    
    if (1 == buttonIndex && TAG_ALERT_VERIFY_USERINFO_OK == alertView.tag) {
        [self goToVerifyVCUsing:_phoneNumTF.text and:_resetPSWTF.text];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
//    [self rightBarButtonClick];
    return YES;
}

@end
