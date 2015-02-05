//
//  RegistViewController.m
//  MiShiClient-Pro
//
//  Created by ZXH on 14-10-16.
//  Copyright (c) 2014年 ZSXJ. All rights reserved.
//

#import "RegistViewController.h"

#import "VerifyPhoneViewController.h"
#import "PrivacyPolicyViewController.h"

#import "MessageShow.h"
#import "DataDefine.h"
#import "Define.h"
#import "Utils.h"
#import "Base64.h"
#import "RC4.h"
#import "Param.h"

#define TAG_TRUE_NAME_TF        1000
#define TAG_PHONENUMBER_TF      1001
#define TAG_PASSWORD_TF         1002
#define TAG_INVITE_PHONE_TF     1003

#define TAG_REGIST_BT           2000
#define TAG_BT_POLICY           2001
#define TAG_AV_CODE_ERROR       2002
#define TAG_CONFIRM_ALERT       2003

#define HEIGHT_TF               30.0f
#define TF_BACK_VIEW_ORIGIN_Y   10.0F

@interface RegistViewController ()
<
UITextFieldDelegate,
UIAlertViewDelegate
>
{
    //View
    UIView *_tfBackView;
    UITextField *_trueNameTF;
    UITextField *_phoneNumberTF;
    UITextField *_passWordTF;
    UITextField *_invitePhoneTF;
    
    NSString *_trueName;// 真实姓名
    NSString *_phoneNumber;// 手机号
    NSString *_passWord;// 密码
    NSString *_invitePhoneNum;// 邀请人的手机号
    
    //ErrorCode
    NSInteger errMsgCode;
}
@end


@implementation RegistViewController

- (void)dealloc {
    DDLog(@"RegistViewController dealloc")
}

- (void)viewWillDisappear:(BOOL)animated {
    //清除textField里面内容
    if (_passWordTF) {
        _passWordTF.text = @"";
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [_trueNameTF becomeFirstResponder];
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
    self.navigationItem.title = @"注册";
    
    [self buildNavBar];
    [self loadSubviews];
}

- (void)buildNavBar {
    // push到下一页 后 返回的按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"返回";
    self.navigationItem.backBarButtonItem = backBtn;
    
    // 右上角注册按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarBtnClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)loadSubviews {
    
    _tfBackView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           TF_BACK_VIEW_ORIGIN_Y,
                                                           size_width,
                                                           230)];
    _tfBackView.backgroundColor = BACK_COLOR;
    [self.view addSubview:_tfBackView];
    
    // 这 3个 Label 不能用同一个  必须创建 3个
    UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    leftLab.text = @"*";
    leftLab.textAlignment = NSTextAlignmentCenter;
    leftLab.textColor = [UIColor redColor];
    
    UILabel *leftLab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    leftLab1.text = @"*";
    leftLab1.textAlignment = NSTextAlignmentCenter;
    leftLab1.textColor = [UIColor redColor];
    
    UILabel *leftLab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    leftLab2.text = @"*";
    leftLab2.textAlignment = NSTextAlignmentCenter;
    leftLab2.textColor = [UIColor redColor];
    
    // 用户条款
    UILabel *policyLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 85, 30)];
    policyLab.font = [UIFont systemFontOfSize:14.0f];
    policyLab.text = @"注册前请阅读";
    [_tfBackView addSubview:policyLab];
    
    UIButton *policyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    policyBtn.frame = CGRectMake(20 + 85, 0, 60, 30);
    policyBtn.tag = TAG_BT_POLICY;
    [policyBtn setBackgroundColor:[UIColor clearColor]];
    [policyBtn setTitleColor:[UIColor colorWithRed:0.07f green:0.39f blue:0.55f alpha:1.00f]
                    forState:UIControlStateNormal];
    [policyBtn setTitle:@"用户条款" forState:UIControlStateNormal];
    policyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0F];
    [policyBtn addTarget:self action:@selector(policyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_tfBackView addSubview:policyBtn];
    
    // 真实姓名
    _trueNameTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 30, size_width - 40, HEIGHT_TF)];
    _trueNameTF.background = [UIImage imageNamed:@"textField_bg.png"];
    _trueNameTF.tag = TAG_TRUE_NAME_TF;
    _trueNameTF.clearButtonMode = UITextFieldViewModeAlways;
    _trueNameTF.placeholder = @" 请填写您的真实姓名";
    _trueNameTF.delegate = self;
    _trueNameTF.leftView = leftLab;
    _trueNameTF.leftViewMode = UITextFieldViewModeAlways;
    [_tfBackView addSubview:_trueNameTF];
    
    // 手机号
    _phoneNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(20, _trueNameTF.frame.origin.y + _trueNameTF.frame.size.height + 5, size_width - 40, HEIGHT_TF)];
    _phoneNumberTF.background = [UIImage imageNamed:@"textField_bg.png"];
    _phoneNumberTF.tag = TAG_PHONENUMBER_TF;
    _phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumberTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneNumberTF.placeholder = @" 请输入您的手机号";
    _phoneNumberTF.delegate = self;
    _phoneNumberTF.leftView = leftLab1;
    _phoneNumberTF.leftViewMode = UITextFieldViewModeAlways;

    if (self.thePhoneNumber.length > 0) {
        _phoneNumberTF.text = self.thePhoneNumber;
    }
    [_tfBackView addSubview:_phoneNumberTF];
    
    // 密码
    _passWordTF = [[UITextField alloc]
                   initWithFrame:CGRectMake(20,
                                            _phoneNumberTF.frame.origin.y + _phoneNumberTF.frame.size.height + 5,
                                            size_width - 40,
                                            HEIGHT_TF)];
    _passWordTF.background = [UIImage imageNamed:@"textField_bg.png"];
    _passWordTF.tag = TAG_PASSWORD_TF;
    _passWordTF.secureTextEntry = YES;
    _passWordTF.returnKeyType = UIReturnKeyNext;
    _passWordTF.keyboardType = UIKeyboardTypeURL;
    _passWordTF.clearButtonMode = UITextFieldViewModeAlways;
    _passWordTF.delegate = self;
    _passWordTF.placeholder = @" 请输入6~20位密码";
    _passWordTF.leftView = leftLab2;
    _passWordTF.leftViewMode = UITextFieldViewModeAlways;
    [_tfBackView addSubview:_passWordTF];
    
    // 邀请人手机号
    _invitePhoneTF = [[UITextField alloc]
                  initWithFrame:CGRectMake(20,
                                           _passWordTF.frame.origin.y + _passWordTF.frame.size.height + 15,
                                           size_width - 40,
                                           HEIGHT_TF)];
    _invitePhoneTF.background = [UIImage imageNamed:@"textField_bg.png"];
    _invitePhoneTF.tag = TAG_INVITE_PHONE_TF;
    _invitePhoneTF.secureTextEntry = YES;
    _invitePhoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _invitePhoneTF.returnKeyType = UIReturnKeySend;
    _invitePhoneTF.clearButtonMode = UITextFieldViewModeAlways;
    _invitePhoneTF.delegate = self;
    _invitePhoneTF.placeholder = @" 邀请人手机号";
    [_tfBackView addSubview:_invitePhoneTF];
    
    // 注册按钮
    UIButton *registButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registButton.frame = CGRectMake(20,
                                    _invitePhoneTF.frame.origin.y + _invitePhoneTF.frame.size.height + 15,
                                    _tfBackView.frame.size.width - 40,
                                    40);
    registButton.tag = TAG_REGIST_BT;
    registButton.layer.masksToBounds = YES;
    registButton.backgroundColor = TAB_BAR_COLOR;
    registButton.layer.cornerRadius = 3;
    [registButton setTitle:@"下一步" forState:UIControlStateNormal];
    [registButton addTarget:self action:@selector(rightBarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_tfBackView addSubview:registButton];
}
#pragma mark - 点击用户条款
- (void)policyBtnClick {
    
    PrivacyPolicyViewController *policyVC = [[PrivacyPolicyViewController alloc] init];
    [self.navigationController pushViewController:policyVC animated:YES];
}
#pragma mark - 点击注册按钮
- (void)rightBarBtnClick {
    
    _trueName = _trueNameTF.text;
    _phoneNumber = _phoneNumberTF.text;
    _passWord = _passWordTF.text;
    _invitePhoneNum = _invitePhoneTF.text;
    [self allKeyboardResign];
    [self verifyUserInfo:_trueName
          andPhoneNumber:_phoneNumber
             andPassword:_passWord
              andConfirm:_invitePhoneNum];
}
#pragma mark - 检查:姓名、手机号、密码
- (void)verifyUserInfo:(NSString *)theTrueName
        andPhoneNumber:(NSString *)thePhoneNumber
           andPassword:(NSString *)password
            andConfirm:(NSString *)confirm {
    // Check, and do login
    errMsgCode = -1;
    NSString *errMsg = nil;
    if (nil == password || [password isEqualToString:@""] ||
        6 > [password length] || 20 < [password length]) {
        errMsgCode = MSG_CODE_LOGIN_ERR_1;
        errMsg = @"密码长度为6-20位";
    }
    
    if (nil == password || [password isEqualToString:@""]) {
        errMsgCode = MSG_CODE_LOGIN_ERR_2;
        errMsg = @"密码不能为空";
    }

    if (nil == thePhoneNumber || [thePhoneNumber isEqualToString:@""]) {
        errMsgCode = MSG_CODE_LOGIN_ERR_3;
        errMsg = @"手机号不能为空";
    }
    
    if (![Utils validatePhoneNumber:thePhoneNumber]) {
        errMsgCode = MSG_CODE_LOGIN_ERR_4;
        errMsg = @"请填写正确的手机号";
    }
    
    if ((nil == theTrueName || [theTrueName isEqualToString:@""]) || (4 < theTrueName.length && 2 >= theTrueName.length)) {
        errMsgCode = MSG_CODE_LOGIN_ERR_5;
        errMsg = @"为提高服务质量，请填写真实姓名";
    }

    if (-1 != errMsgCode) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:errMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新输入", nil];
        [alert show];
        return;
    }
    [self jumpToVerityVC];
}

#pragma mark - 跳转到短信验证码页面
- (void)jumpToVerityVC {
    
    [self allKeyboardResign];
    
    VerifyPhoneViewController *verifyVC = [[VerifyPhoneViewController alloc] init];
    verifyVC.trueName = _trueNameTF.text;
    verifyVC.phoneNumber = _phoneNumberTF.text;
    verifyVC.passWord = _passWordTF.text;
    verifyVC.invitPhone = _invitePhoneTF.text;
    verifyVC.fromFunc = @"1";// 标识 来自注册页面
    [self.navigationController pushViewController:verifyVC animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (TAG_TRUE_NAME_TF == textField.tag) {
        [_trueNameTF resignFirstResponder];
        [_phoneNumberTF becomeFirstResponder];
    }
    
    if (TAG_PHONENUMBER_TF == textField.tag) {
        [_phoneNumberTF resignFirstResponder];
        [_passWordTF becomeFirstResponder];
    }
    if (TAG_PASSWORD_TF == textField.tag) {
        [_passWordTF resignFirstResponder];
        [_invitePhoneTF becomeFirstResponder];
    }
    
    if (TAG_INVITE_PHONE_TF == textField.tag) {
        [self rightBarBtnClick];
    }
    return  YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (TAG_PASSWORD_TF == textField.tag && 0 < textField.text.length) {
        if ([Utils checkSpecialCharacter:textField.text]) {
            //包含特殊字符
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"密码不能设置特殊字符，如『~￥#&*』等" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
            alert.tag = TAG_AV_CODE_ERROR;
            [alert show];
        }
    }
}

#pragma mark - AlerViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (1 == buttonIndex) {
        
        if (MSG_CODE_LOGIN_ERR_1 == errMsgCode || MSG_CODE_LOGIN_ERR_2 == errMsgCode) {
            [_passWordTF becomeFirstResponder];
        }
        
        if (MSG_CODE_LOGIN_ERR_3 == errMsgCode || MSG_CODE_LOGIN_ERR_4 == errMsgCode) {
            [_phoneNumberTF becomeFirstResponder];
        }
        
        if (MSG_CODE_LOGIN_ERR_5 == errMsgCode) {
            [_trueNameTF becomeFirstResponder];
        }
    }
    
    if (TAG_AV_CODE_ERROR == alertView.tag) {
        _passWordTF.text = @"";
        [_passWordTF becomeFirstResponder];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self allKeyboardResign];
}
// 所有键盘Resign
- (void)allKeyboardResign {
    
    if ([_phoneNumberTF isFirstResponder]) {
        [_phoneNumberTF resignFirstResponder];
    }
    
    if ([_passWordTF isFirstResponder]) {
        [_passWordTF resignFirstResponder];
    }
    
    if ([_invitePhoneTF isFirstResponder]) {
        [_invitePhoneTF resignFirstResponder];
    }
}

#pragma mark RegistDataController
- (void)onFetchAuthCodeRequestData:(NSDictionary *)receiveData withReqTag:(NSInteger)tag {
    DDLog(@"1128 发送验证码%@",receiveData);
}

- (void)onFailedFetchAuthCodeRequest:(NSError *)error withTag:(NSInteger)tag {
    DDLog(@"1128 发送验证码失败");
}

- (void)onFailedGetRegistData:(NSError *)error witReqTag:(NSInteger)tag {
    
    [MessageShow showMessageView:MESSAGE_TYPE_ERROR
                            code:error.code
                             msg:nil
                       autoClose:1
                            time:1.5F];
    _passWordTF.text = @"";
    _invitePhoneTF.text = @"";
}

- (void)onGetRegistData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
