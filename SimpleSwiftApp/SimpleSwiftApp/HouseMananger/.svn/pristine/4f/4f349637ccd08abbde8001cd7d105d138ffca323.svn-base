//
//  VerifyPhoneViewController.m
//  MiShiClient-Pro
//
//  Created by ZXH on 14-12-31.
//  Copyright (c) 2014年 ZSXJ. All rights reserved.
//

#import "VerifyPhoneViewController.h"

#import "VerifyPhoneDataController.h"

#import "RegistDataController.h"
#import "ResetPasswordDataController.h"

#import "MessageShow.h"
#import "Define.h"
#import "UserTmpParam.h"
#import "Param.h"
#import "Base64.h"
#import "RC4.h"

#define TAG_SMSCODE_TF        1000

#define HEIGHT_TF             30.0f

@interface VerifyPhoneViewController ()
<
UITextFieldDelegate,
UIAlertViewDelegate,
VerifyPhoneDataControllerDelegate,
RegistDataControllerDelegate,
ResetPasswordDataControllerDelegate
>
{
    //View
    UITextField *_smsCodeTF;
    UIButton *_reSendBtn;
    
    //Data
    VerifyPhoneDataController *_verDC;
    RegistDataController *_registDC;
    ResetPasswordDataController *_resetPasswordDC;
}
@end

@implementation VerifyPhoneViewController

- (void)viewDidAppear:(BOOL)animated {
    [_smsCodeTF becomeFirstResponder];
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
    self.navigationItem.title = @"短信验证";
    
    [self buildNavBar];
    [self loadSubviews];
}

- (void)buildNavBar {
    // push到下一页后 的返回按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"返回";
    self.navigationItem.backBarButtonItem = backBtn;
    
    // 右上角注册按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarBtnClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)loadSubviews {
    // 提示Label
    UILabel *phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width -60, 40)];
    phoneNumberLabel.backgroundColor = [UIColor clearColor];
    phoneNumberLabel.font = [UIFont systemFontOfSize:13];
    phoneNumberLabel.text = [NSString stringWithFormat:@"已向手机号: %@ 发送短信验证码，请注意查收",self.phoneNumber];
    phoneNumberLabel.numberOfLines = 2;
    [self.view addSubview:phoneNumberLabel];
    
    // 短信验证码TextField
    _smsCodeTF = [[UITextField alloc] initWithFrame:CGRectMake(20, phoneNumberLabel.frame.size.height + phoneNumberLabel.frame.origin.y + 5, size_width - 40 - 110, HEIGHT_TF)];
    _smsCodeTF.background = [UIImage imageNamed:@"textField_bg.png"];
    _smsCodeTF.tag = TAG_SMSCODE_TF;
    _smsCodeTF.delegate = self;
    _smsCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    _smsCodeTF.returnKeyType = UIReturnKeyJoin;
    _smsCodeTF.placeholder = @" 请输入验证码";
    [self.view addSubview:_smsCodeTF];
    
    // 重新发送按钮
    _reSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _reSendBtn.frame = CGRectMake(size_width - 20 - 100, phoneNumberLabel.frame.size.height + phoneNumberLabel.frame.origin.y + 5, 100, HEIGHT_TF);
    _reSendBtn.backgroundColor = TAB_BAR_COLOR;
    _reSendBtn.layer.cornerRadius = 3;
    _reSendBtn.layer.masksToBounds = YES;
    _reSendBtn.userInteractionEnabled = NO;
    [_reSendBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    [_reSendBtn addTarget:self action:@selector(startTime) forControlEvents:UIControlEventTouchUpInside];
    [self startTime];
    [self.view addSubview:_reSendBtn];
    
    // 完成按钮
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(20, _smsCodeTF.frame.origin.y + _smsCodeTF.frame.size.height + 15, size_width - 40, 35);
    finishBtn.backgroundColor = TAB_BAR_COLOR;
    finishBtn.layer.cornerRadius = 3;
    finishBtn.layer.masksToBounds = YES;
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(rightBarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBtn];
}

// 倒计时
- (void)startTime {
    [self sendResendSMSCodeRequest];
    __block int timeout = 10;// 倒计时总时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);// 每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout == 0) {
            dispatch_source_cancel(_timer);//倒计时结束，关闭
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置界面的按钮显示
                [_reSendBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                _reSendBtn.backgroundColor = TAB_BAR_COLOR;
                _reSendBtn.userInteractionEnabled = YES;
                _reSendBtn.titleLabel.font = [UIFont systemFontOfSize:16.0F];
            });
        } else {

            int second = timeout % 60;
            NSString *timeString = [NSString stringWithFormat:@"%.2d",second];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置界面的按钮显示
                [_reSendBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",timeString]
                        forState:UIControlStateNormal];
                _reSendBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                _reSendBtn.userInteractionEnabled = NO;
                _reSendBtn.backgroundColor = [UIColor lightGrayColor];
            });
        }
        timeout--;
    });
    dispatch_resume(_timer);
}

// 完成按钮
- (void)rightBarBtnClick {
    [_smsCodeTF resignFirstResponder];
    
    // 重置密码
    if ([@"2" isEqualToString:self.fromFunc]) {
        
        if (0 == _smsCodeTF.text.length) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } else {
            [self sendResetPasswordRequest];
        }
    }
    
    // 注册
    if ([@"1" isEqualToString:self.fromFunc]) {
        if (0 == _smsCodeTF.text.length) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } else {
            [self sendRegistRequest];
        }
    }
}

#pragma mark - 发送短信验证码请求
- (void)sendResendSMSCodeRequest {
    
    NSDictionary *params = @{@"mobile" : self.phoneNumber,
                             @"from_func" : self.fromFunc};
    if (nil == _verDC) {
        _verDC = [[VerifyPhoneDataController alloc] init];
        _verDC.delegate = self;
    }
    [_verDC makeReSendSMSCodeRequest:params];
}

#pragma mark - 发送重置密码请求
- (void)sendResetPasswordRequest {
    NSString *smsCode = _smsCodeTF.text;
    NSDictionary *params = @{@"mobile" : self.phoneNumber,
                             @"password" : [Base64 base64EncodeData:[RC4 rc4:[[self.passWord dataUsingEncoding:NSUTF8StringEncoding] mutableCopy] key:RC4_SIGN_KEY]],
                             @"sms_code" : smsCode};
    if (nil == _resetPasswordDC) {
        _resetPasswordDC = [[ResetPasswordDataController alloc] init];
        _resetPasswordDC.delegate = self;
    }
    [_resetPasswordDC mrResetPassword:params];
}

#pragma mark - 发送注册请求
- (void)sendRegistRequest {

    NSString *smsCode = _smsCodeTF.text;
    NSString *mobileModelStr = [[UIDevice currentDevice] model];
    NSDictionary *params = @{@"mobile" : self.phoneNumber,
                             @"password" : [Base64 base64EncodeData:[RC4 rc4:[[self.passWord dataUsingEncoding:NSUTF8StringEncoding] mutableCopy] key:RC4_SIGN_KEY]],
                             @"sms_code" : smsCode,
                             @"deviceid" : [Param getDeviceId],
                             @"pingtai" : @"2",
                             @"ext" : mobileModelStr,
                             @"utm" : @"AppStore",
                             @"ver" : @"1.0",
                             @"username" : self.trueName,
                             @"invitation_people" : self.invitPhone};
    if (nil == _registDC) {
        _registDC = [[RegistDataController alloc] init];
        _registDC.delegate = self;
    }
    [_registDC makeRegistRequest:params];
}

#pragma mark - 收起所有键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_smsCodeTF resignFirstResponder];
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

#pragma mark - AlerViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (1 == buttonIndex) {
        [_smsCodeTF becomeFirstResponder];
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
//    [self sendRegistRequest];
    return YES;
}


#pragma mark - VerifyPhoneDataDelegate 短信验证码
- (void)onGetReSendSMSData:(NSDictionary *)receiveData withRequestTag:(NSInteger)tag {
    DDLog(@"request - resendSmsCode %@",receiveData)
    [MessageShow showMessageView:MESSAGE_TYPE_OK code:0 msg:@"验证码已发送" autoClose:1 time:1.5];
}

- (void)failedGetResendSMSData:(NSError *)error withRequestTag:(NSInteger)tag {
    DDLog(@"reuqest - resendSmsCode failed %@",error);
}

#pragma mark - RegistDataControllerDelegate 注册
- (void)onGetRegistData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag {

    DDLog(@"requset - regist  %@  nav %@",receiveDict,self.navigationController.viewControllers);

    [MessageShow showMessageView:MESSAGE_TYPE_OK code:0 msg:@"注册成功,快来登陆吧！" autoClose:1 time:1.50f];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)onFailedGetRegistData:(NSError *)error witReqTag:(NSInteger)tag {
    DDLog(@"request -regist failed %@",error);
    
    [MessageShow showMessageView:MESSAGE_TYPE_ERROR
                            code:error.code
                             msg:[error.userInfo objectForKey:@"msg"]
                       autoClose:1
                            time:1.5F];
}

#pragma mark - ResetPasswordDataControllerDelegate 重置密码
- (void)onGetResetPSWRequest:(NSDictionary *)receiveData withTag:(NSInteger)tag {

}

- (void)failedGetResetPSWRequest:(NSError *)error withTag:(NSInteger)tag {

}

@end
