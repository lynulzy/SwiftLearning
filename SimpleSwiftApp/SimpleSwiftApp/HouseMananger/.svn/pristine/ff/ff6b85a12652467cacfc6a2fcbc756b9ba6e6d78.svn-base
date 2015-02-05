//
//  ResetCodeViewController.m
//  MiShiClient-Pro
//
//  Created by ZSXJ on 14-10-20.
//  Copyright (c) 2014年 zsxj. All rights reserved.
//

#import "ResetCodeViewController.h"
#import "Define.h"
#import "MessageShow.h"
#import "UserTmpParam.h"
#define TAG_BACK_NAVBT        101

#define TAG_PASSWORD_TF        1001
#define TAG_CONFIRM_TF         1002
#define TAG_ALERT              2001
#define HEIGHT_TF         35.0f
@interface ResetCodeViewController ()

@end

@implementation ResetCodeViewController

{
    //View
    UITextField *passWordTF_;
    UITextField *confirmTF_;
    
    //Data
    ResetCodeDataController *resetDC_;
    NSString *passWord;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildNavBar];
}

- (void)buildNavBar
{
    /*
    if (!self.navigationController)
    {
        float or_y = IOS7Later?20.0f:0;
        UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0, or_y, self.view.frame.size.width, 44.0f)];
        navBar.backgroundColor = [UIColor colorWithRed:0.31f green:0.51f blue:0.56f alpha:1.00f];
        [self.view addSubview:navBar];
        if (!self.navigationController)
        {
            //title
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(navBar.frame.size.width/2-45, navBar.frame.size.height/2-20, 90, 40)];
            titleLabel.text = @"重置密码";
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont boldSystemFontOfSize:22];
            [navBar addSubview:titleLabel];
        }
        
        //build a back Button
        UIButton *navBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        navBackBtn.frame = CGRectMake(10, 10, 60, 28);
        navBackBtn.backgroundColor = [UIColor orangeColor];
        [navBackBtn setTitle:@"返回" forState:UIControlStateNormal];
        navBackBtn.tag = TAG_BACK_NAVBT;
        [navBackBtn addTarget:self action:@selector(navBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [navBar addSubview:navBackBtn];
    }*/
//    else
//    {
        self.title = @"重置密码";
    UIBarButtonItem *finishReset = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(confirmBtnClick:)];
    self.navigationItem.rightBarButtonItem = finishReset;
//    }
    [self loadSubviews];
}
- (void)loadSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *tfBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height *0.12, self.view.frame.size.width, self.view.frame.size.height*0.5)];
    tfBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tfBackView];
    passWordTF_ = [[UITextField alloc] initWithFrame:CGRectMake(20, 50, self.view.frame.size.width-40, HEIGHT_TF)];
    passWordTF_.background = [UIImage imageNamed:@"loginTF_bg.png"];
    passWordTF_.tag = TAG_PASSWORD_TF;
    passWordTF_.secureTextEntry = YES;
    passWordTF_.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    passWordTF_.delegate = self;
    passWordTF_.placeholder = @"请输入密码";
    [tfBackView addSubview:passWordTF_];
    
    confirmTF_ = [[UITextField alloc] initWithFrame:CGRectMake(20, passWordTF_.frame.size.height+passWordTF_.frame.origin.y +25, self.view.frame.size.width-40, HEIGHT_TF)];
    confirmTF_.background = [UIImage imageNamed:@"loginTF_bg.png"];
    confirmTF_.tag = TAG_CONFIRM_TF;
    confirmTF_.secureTextEntry = YES;
    confirmTF_.returnKeyType = UIReturnKeySend;
    confirmTF_.delegate = self;
    confirmTF_.placeholder = @"请再次输入密码";
    [tfBackView addSubview:confirmTF_];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(20, confirmTF_.frame.origin.y + confirmTF_.frame.size.height +25, self.view.frame.size.width -40, HEIGHT_TF);
    confirmBtn.backgroundColor = [UIColor colorWithRed:0.99f green:0.72f blue:0.15f alpha:1.00f];
    [confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tfBackView addSubview:confirmBtn];
    
}
//!!!!有一个明文显示
- (void)navBarButtonClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
- (void)confirmBtnClick:(UIButton *)button
{
    [self.view endEditing:YES];
    [self sendRequest];
    //发送完请求接收到结果之后dismiss
}

- (void)sendRequest
{
    if ([passWordTF_ isFirstResponder]) {
        [passWordTF_ resignFirstResponder];
    }
    if ([confirmTF_ isFirstResponder]) {
        [confirmTF_ resignFirstResponder];
    }
    if (resetDC_ == nil)
    {
        resetDC_ = [[ResetCodeDataController alloc] init];
        resetDC_.delegate = self;
    }
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
//    [userDict setObject:[UserTmpParam getToken] forKey:@"token"];//1128弃
    [userDict setObject:self.phoneNumber forKey:@"mobile"];
    [userDict setObject:passWord forKey:@"password"];
    [userDict setObject:_smsCode forKey:@"smsCode"];
    [resetDC_ makeResetCodeRequest:userDict];
    
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        passWordTF_.text = @"";
        confirmTF_.text = @"";
        [passWordTF_ becomeFirstResponder];
    }
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == TAG_CONFIRM_TF )
    {
        if ([textField.text isEqualToString:passWordTF_.text])
        {
            passWord = textField.text;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告!" message:@"您两次输入的密码不一致,请重新输入" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            alert.tag = TAG_ALERT;
            [alert show];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder])
    {
        [textField resignFirstResponder];
    }
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([confirmTF_ isFirstResponder])
    {
        [confirmTF_ resignFirstResponder];
    }
    
    if ([passWordTF_ isFirstResponder])
    {
        [passWordTF_ resignFirstResponder];
    }
    
}

#pragma mark ResetDataControllerDelegate  ---Data
- (void)onGetResetRequest:(NSDictionary *)receiveData andTag:(NSInteger)tag
{
    //输入新密码之后用户免登陆,用户可直接使用,
    /*
     1.保存session,user_id
     2.发送消失注册和登录界面的通知
     */
    DDLog(@"%@",receiveData);
    //1
    NSString *session;
    NSString *user_id;
    //1128重置密码之后不能获得session需要跳转至登录页面让用户自行登录
//    session = [[receiveData objectForKey:@"content"] objectForKey:@"session"];
//    user_id = [[receiveData objectForKey:@"content"] objectForKey:@"user_id"];
    if (session.length > 0 && user_id.length > 0)
    {
        [UserTmpParam setSessionId:session];
        
    }
    //2
    [MessageShow showMessageView:MESSAGE_TYPE_OK code:101 msg:@"修改成功" autoClose:1 time:3];
//    if (self.navigationController)
//    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//    }
//    else
//    {
//        [self dismissViewControllerAnimated:NO completion:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_NAME_RESETPW_SUCC object:nil];
//    }
}

- (void)failedResetRequest:(NSError *)error andTag:(NSInteger)tag
{
    DDLog(@"%@",error);
    //错误码  12
    [MessageShow showMessageView:MESSAGE_TYPE_ERROR
                            code:error.code
                             msg:@"手机验证码错误"
                       autoClose:1
                            time:1.5f];
    passWordTF_.text = @"";
    confirmTF_.text = @"";
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DDLog(@"mmmm");
}
@end
