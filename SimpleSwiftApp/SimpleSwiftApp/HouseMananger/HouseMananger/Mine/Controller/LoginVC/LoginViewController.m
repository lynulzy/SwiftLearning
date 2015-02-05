//
//  LoginViewController.m
//  HouseMananger
//
//  Created by ZXH on 15/1/5.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "LoginViewController.h"

#import "LoginDataController.h"
#import "RegistViewController.h"
#import "ResetPassWordViewController.h"

#import "UserDefaults.h"
#import "UserTmpParam.h"
#import "MessageShow.h"
#import "Utils.h"

#import "CustomerViewController.h"
#define TAG_USERNAME_TF         1001
#define TAG_PASSWORD_TF         1002

#define TAG_LOGIN_BT            1003
#define TAG_ALERT_CODE_ERROR    1004

#define WIDTH_TF                (size_width - 40)
#define HEIGHT_TF               35.0F
#define TF_BACK_VIEW_ORIGIN_Y   10.0F
#define TF_BACK_VIEW_HEIGHT     200.0F

@interface LoginViewController ()
<
UITextFieldDelegate,
UIAlertViewDelegate,
LoginDataControllerDelegate
>
{
    //View
    UIView *_tfBackView;
    UITextField *_userNameTF;
    UITextField *_passWordTF;
    NSString *_userName;
    NSString *_passWord;
    
    //Data
    LoginDataController *_loginDC;
    
    //ErrorCode
    NSInteger errMsgCode;
}
@end


@implementation LoginViewController

- (void)dealloc {
    DDLog(@"LoginViewController dealloc")
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    if ([UserDefaults getUsername].length > 0) {
        _userNameTF.text = [UserDefaults getUsername];
    }
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
    
    self.navigationItem.title = @"登录";
    [self buildNavBar];
    [self loadSubviews];
}

- (void)buildNavBar {
    // push到下一页后 的返回按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"返回";
    self.navigationItem.backBarButtonItem = backBtn;
    
    // 右上角 注册 按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@" 注册 " style:UIBarButtonItemStyleDone target:self action:@selector(rightBarBtnClick:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)loadSubviews {
    
    // 背景托盘
    _tfBackView = [[UIView alloc]
                   initWithFrame:CGRectMake(0,
                                            TF_BACK_VIEW_ORIGIN_Y,
                                            size_width,
                                            TF_BACK_VIEW_HEIGHT)];
    _tfBackView.backgroundColor = BACK_COLOR;
    [self.view addSubview:_tfBackView];
    
    // 用户名
    _userNameTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, WIDTH_TF, HEIGHT_TF)];
    _userNameTF.background = [UIImage imageNamed:@"textField_bg.png"];
    _userNameTF.tag = TAG_USERNAME_TF;
    _userNameTF.keyboardType = UIKeyboardTypeNumberPad;
    _userNameTF.delegate = self;
    _userNameTF.clearButtonMode = UITextFieldViewModeAlways;
    _userNameTF.placeholder = @" 请输入您的手机号";
    [_tfBackView addSubview:_userNameTF];
    
    // 密码
    _passWordTF = [[UITextField alloc] initWithFrame:CGRectMake(20,
                                                                _userNameTF.frame.origin.y + HEIGHT_TF + 5,
                                                                WIDTH_TF,
                                                                HEIGHT_TF)];
    _passWordTF.tag = TAG_PASSWORD_TF;
    _passWordTF.secureTextEntry = YES;
    _passWordTF.returnKeyType = UIReturnKeyGo;
    _passWordTF.background = [UIImage imageNamed:@"textField_bg.png"];
    _passWordTF.delegate = self;
    _passWordTF.clearButtonMode = UITextFieldViewModeAlways;
    _passWordTF.placeholder = @" 请输入密码";
    [_tfBackView addSubview:_passWordTF];
    
    // 登录按钮
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(20, _passWordTF.frame.origin.y + HEIGHT_TF + 15, WIDTH_TF, HEIGHT_TF);
    loginButton.backgroundColor = TAB_BAR_COLOR;
    loginButton.tag = TAG_LOGIN_BT;
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 3;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_tfBackView addSubview:loginButton];
    
    // 忘记密码按钮
    UILabel *forgetPSWLab = [[UILabel alloc] initWithFrame:CGRectMake(20, loginButton.frame.origin.y + HEIGHT_TF + 10, 100, 25)];
    forgetPSWLab.text = @"重置密码?>>";
    forgetPSWLab.userInteractionEnabled = YES;
    forgetPSWLab.font = [UIFont systemFontOfSize:15.0F];
    forgetPSWLab.textColor = [UIColor darkGrayColor];
    [_tfBackView addSubview:forgetPSWLab];
    
    UIButton *forgetPSWBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPSWBtn.frame = forgetPSWLab.bounds;
    [forgetPSWBtn addTarget:self action:@selector(forgetPassWordClick:) forControlEvents:UIControlEventTouchUpInside];
    [forgetPSWLab addSubview:forgetPSWBtn];
}

#pragma mark - 注册按钮
- (void)rightBarBtnClick:(UIView *)btn {
    
    RegistViewController *registVC = [[RegistViewController alloc] init];
    
    if (0 < _userNameTF.text.length) {
        registVC.thePhoneNumber = _userNameTF.text;
    }
    
    if ([btn isKindOfClass:[UIBarButtonItem class]]) {
        [self.navigationController pushViewController:registVC animated:YES];
    }
}

#pragma mark - 登录按钮
- (void)loginButtonClick {
    
    [self.view endEditing:YES];
    [self allKeyboardResign];
    _userName = _userNameTF.text;
    _passWord = _passWordTF.text;
    [self verifyUserInfo:_userName andPassword:_passWord];
}

#pragma mark - 重置密码按钮
- (void)forgetPassWordClick:(UIButton *)btn {
    
     ResetPassWordViewController *resetPSWVC = [[ResetPassWordViewController alloc] init];
    [self.navigationController pushViewController:resetPSWVC animated:YES];
}

#pragma mark - 初步检查 用户名 密码 格式
- (void)verifyUserInfo:(NSString *)userName andPassword:(NSString *)password {
    
    errMsgCode = -1;
    NSString *errMsg = nil;
    if (nil == password || [password isEqualToString:@""] || 6 > [password length] || 20 < [password length])
    {
        errMsgCode = MSG_CODE_LOGIN_ERR_1;
        errMsg = @"密码长度为6-20位";
    }
    
    if (nil == password || [password isEqualToString:@""]) {
        errMsgCode = MSG_CODE_LOGIN_ERR_2;
        errMsg = @"密码不能为空";
    }
    
    if (nil == userName || [userName isEqualToString:@""]) {
        errMsgCode = MSG_CODE_LOGIN_ERR_3;
        errMsg = @"用户名不能为空";
    }
    
    if (![userName isEqualToString:@""] &&
        ![password isEqualToString:@""] &&
        ![Utils validatePhoneNumber:userName])
    {
        errMsgCode = MSG_CODE_LOGIN_ERR_4;
        errMsg = @"手机号码格式不正确";
    }
    
    if (-1 != errMsgCode) {
        UIAlertView *verifyInfoAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:errMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新输入", nil];
        [verifyInfoAlert show];
        return;
    }
    
    [self loadDataWith:_userName and:_passWord];
}

#pragma mark - 登录请求
- (void)loadDataWith:(NSString *)theUserName and:(NSString *)thePassWord {
    
    NSDictionary *params = @{@"mobile"      : theUserName,
                             @"password"    : thePassWord};
    
    if (nil == _loginDC) {
        
        _loginDC = [[LoginDataController alloc] init];
        _loginDC.delegate = self;
    }
    
    [_loginDC makeLoginRequest:params];
}

#pragma mark - 全部键盘 收起
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self allKeyboardResign];
}

- (void)allKeyboardResign {
    
    if ([_userNameTF isFirstResponder]) {
        [_userNameTF resignFirstResponder];
    }
    
    if ([_passWordTF isFirstResponder]) {
        [_passWordTF resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - (登录成功后)保存用户信息
- (void)parseAndSaveUserInfo:(NSDictionary *)contentDict {
    
    // 用于自动登录
    [UserDefaults setUsername:_userName];
    [UserDefaults setPassword:_passWord];
    
    if ([contentDict objectForKey:@"content"]) {
        NSDictionary *content = [contentDict objectForKey:@"content"];
        // 必须保存 的用户信息
        if ([content objectForKey:@"session"]&&
            [content objectForKey:@"user_id"]&&
            [content objectForKey:@"mobile"]) {
            [UserTmpParam setUserId:[content objectForKey:@"user_id"]];
            [UserTmpParam setMobile:[content objectForKey:@"mobile"]];
            [UserTmpParam setSession:[content objectForKey:@"session"]];
            [UserTmpParam setUserName:[content objectForKey:@"username"]];
            
            // 选择保存 的用户信息
            // 性别
            NSString *sex = [content objectForKey:@"sex"];
            if (0 < sex.length) {
                [UserTmpParam setUserSex:sex];
            }
            
            // 公司
            NSString *company = [content objectForKey:@"company"];
            if (0 < company.length) {
                [UserTmpParam setPortraitUrl:company];
            }
            
            // 头像
            NSString *portrait = [content objectForKey:@"portrait"];
            if (0 < portrait.length) {
                [UserTmpParam setPortraitUrl:portrait];
            }
            
            // 用户认证状态
            NSString *authStatus = [content objectForKey:@"authentication_status"];
            if (0 < authStatus.length) {
                [UserTmpParam setAuthenticationStatus:authStatus];
            }
            
            // 邀请人手机号
            NSString *invitation_people = [content objectForKey:@"invitation_people"];
            if (0 < invitation_people.length) {
                [UserTmpParam setInvitationPeople:invitation_people];
            }
        }
    } else {
        DDLog(@"保存登录信息失败!");
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (1 == buttonIndex) {
        
        if (MSG_CODE_LOGIN_ERR_1 == errMsgCode || MSG_CODE_LOGIN_ERR_2 == errMsgCode) {
            [_passWordTF becomeFirstResponder];
        }
        if (MSG_CODE_LOGIN_ERR_3 == errMsgCode || MSG_CODE_LOGIN_ERR_4 == errMsgCode) {
            [_userNameTF becomeFirstResponder];
        }
    }
    
    if (alertView.tag == 1111) {
        if (buttonIndex == 1) {
            
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
    if (TAG_ALERT_CODE_ERROR == alertView.tag) {
        UITextField *codeTF = (UITextField *)[self.view viewWithTag:TAG_PASSWORD_TF];
        codeTF.text = @"";
        [codeTF becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //    [self allKeyboardResign];
    [self.view endEditing:YES];
    [self loginButtonClick];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (TAG_PASSWORD_TF == textField.tag && 0 < textField.text.length) {
        if ([Utils checkSpecialCharacter:textField.text]) {
            //包含特殊字符
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"密码不能使用特殊字符，如『~￥#&*』等" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
            alert.tag = TAG_ALERT_CODE_ERROR;
            [alert show];
        }
    }
}

#pragma mark - LoginDataControllerDelegate
- (void)onGetLoginReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag {
    
    if (0 == receiveDict.count) {
        return;
    }
    
    // 保存用户信息
    [self parseAndSaveUserInfo:receiveDict];
    
    [MessageShow showMessageView:MESSAGE_TYPE_OK
                            code:0
                             msg:@"登录成功"
                       autoClose:1
                            time:1.3F];
    if ([self.navigationController.viewControllers[0] isKindOfClass:[CustomerViewController class]]) {
        CustomerViewController * cus = self.navigationController.viewControllers[0];
        cus.isReload = YES;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onGetLoginFailedWithError:(NSError *)error withReqTag:(NSInteger)tag {
    
    [MessageShow showMessageView:MESSAGE_TYPE_ERROR
                            code:error.code
                             msg:nil
                       autoClose:1
                            time:1.3F];
}

@end
