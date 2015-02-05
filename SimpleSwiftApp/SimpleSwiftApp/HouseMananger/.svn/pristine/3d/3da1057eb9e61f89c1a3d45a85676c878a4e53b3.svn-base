//
//  UserSuggestViewController.m
//  MiShiClient-Pro
//
//  Created by ZXH on 14/12/23.
//  Copyright (c) 2014年 ZSXJ. All rights reserved.
//

#import "UserSuggestViewController.h"

#import "UserSuggestDataController.h"
#import "Define.h"
#import "UserTmpParam.h"
#import "MessageShow.h"
#import "Param.h"

#define TAG_BG_SCROLLVIEW   8000
#define TAG_TEXT_VIEW_1     1000
#define TAG_TEXT_VIEW_2     1001

#define HEIGHT_TEXT_VIEW_1     (size_height < 500 ? 90 : 100)
#define HEIGHT_TEXT_VIEW_2     (size_height < 500 ? 50 : 60)

@interface UserSuggestViewController ()
<
UITextViewDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UIScrollViewDelegate,
UIAlertViewDelegate,
UserSuggestDataControllerDelegate
>
{
    UIActivityIndicatorView *_indicatorView;
}
@property(nonatomic, strong) UIScrollView *bgScrollView;
@property(nonatomic, strong) UIView *bgView;

@property(nonatomic, strong) UITextView *suggestTextView;
@property(nonatomic, strong) UILabel *placeLabel1;

@property(nonatomic, strong) UITextView *connectionTextView;
@property(nonatomic, strong) UILabel *placeLabel2;

@property(nonatomic, strong) UIAlertView *theAlert;

@property(nonatomic, strong) UserSuggestDataController *userSuggestDC;

@property(nonatomic, strong) UIAlertView *alertView;

@end

@implementation UserSuggestViewController

- (void)viewWillAppear:(BOOL)animated {

    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    if (IOS7Later) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.navigationController.navigationBar.barTintColor = TAB_BAR_COLOR;
    }
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.title = @"用户反馈";
    
    [self loadSubViews];
}

- (void)loadSubViews {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // scrollView窗口
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size_width, size_height - 44)];
    self.bgScrollView.contentSize = CGSizeMake(size_width, size_height - 44);
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView.delegate = self;
    self.bgScrollView.backgroundColor = BACK_COLOR;
    self.bgScrollView.userInteractionEnabled = YES;
    self.bgScrollView.tag = TAG_BG_SCROLLVIEW;
    [self.view addSubview:self.bgScrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHideKeyBoard)];
    [self.bgScrollView addGestureRecognizer:tap];
    
    // TextView1 用户意见
    self.suggestTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, size_width - 20, HEIGHT_TEXT_VIEW_1)];
    self.suggestTextView.delegate = self;
    self.suggestTextView.tag = TAG_TEXT_VIEW_1;
    self.suggestTextView.font = [UIFont systemFontOfSize:16.0F];
    self.suggestTextView.backgroundColor = [UIColor whiteColor];
    self.suggestTextView.layer.cornerRadius = 4;
    self.suggestTextView.layer.masksToBounds = YES;
    [self.view addSubview:self.suggestTextView];
    
    // PlaceHolder1
    self.placeLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.suggestTextView.frame.size.width - 30, 52)];
    self.placeLabel1.backgroundColor = [UIColor clearColor];
    self.placeLabel1.text = @"请留下您的宝贵意见和建议，我们将努力改进！";
    self.placeLabel1.font = [UIFont systemFontOfSize:16.0];
    self.placeLabel1.textColor = [UIColor lightGrayColor];
    self.placeLabel1.textAlignment = NSTextAlignmentLeft;
    self.placeLabel1.numberOfLines = 0;
    [self.suggestTextView addSubview:self.placeLabel1];
    
    // 联系方式
    self.connectionTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5 + HEIGHT_TEXT_VIEW_1 + 10, size_width - 20, HEIGHT_TEXT_VIEW_2)];
    self.connectionTextView.tag = TAG_TEXT_VIEW_2;
    self.connectionTextView.delegate = self;
    self.connectionTextView.font = [UIFont systemFontOfSize:16.0F];
    self.connectionTextView.backgroundColor = [UIColor whiteColor];
    self.connectionTextView.layer.cornerRadius = 4;
    self.connectionTextView.layer.masksToBounds = YES;
    [self.view addSubview:self.connectionTextView];
    
    // PlaceHolder1
    self.placeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.connectionTextView.frame.size.width - 30, 52)];
    self.placeLabel2.backgroundColor = [UIColor clearColor];
    self.placeLabel2.text = @"请留下您的联系方式(手机号/邮箱地址)，以便我们回复您！";
    self.placeLabel2.font = [UIFont systemFontOfSize:16.0];
    self.placeLabel2.textColor = [UIColor colorWithRed:198/255.0F green:198/255.0F blue:198/255.0F alpha:1];
    self.placeLabel2.textAlignment = NSTextAlignmentLeft;
    self.placeLabel2.numberOfLines = 0;
    [self.connectionTextView addSubview:self.placeLabel2];
    
    // Alert
    self.theAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
}

#pragma mark - 提交反馈
- (void)rightItemClick {
    DDLog(@"提交反馈！ 提交反馈！")
    [self tapHideKeyBoard];
    if ([self.suggestTextView.text isEqualToString:@""]) {
        [self.theAlert setMessage:@"留下您的宝贵建议呗~"];
        [self.theAlert show];
        return;
    }
    if (self.suggestTextView.text.length > 350) {
        [self.theAlert setMessage:@"最多输入350个字"];
        [self.theAlert show];
        return;
    }
    
    if (self.connectionTextView.text.length > 60) {
        [self.theAlert setMessage:@"请检查您的联系方式是否正确！"];
        [self.theAlert show];
        return;
    }
    
    // 手机型号
    NSString *mobileModelStr = [[UIDevice currentDevice] model];
    NSDictionary *params =
    [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                         [Param getVersion],
                                         [Param getSysVersion],
                                         @"2",
                                         [NSString stringWithFormat:@"%f", size_width],
                                         [NSString stringWithFormat:@"%f", size_height + 20],
                                         mobileModelStr,
                                         self.suggestTextView.text,
                                         self.connectionTextView.text, nil]
                                forKeys:[NSArray arrayWithObjects:
                                         @"currentVersion",
                                         @"systemVersion",
                                         @"opeSystemType",
                                         @"screenWidth",
                                         @"screenHight",
                                         @"mobileModel",
                                         @"error_msg",
                                         @"relation_way", nil]];
    // Send request
    if (nil == self.userSuggestDC) {
        self.userSuggestDC = [[UserSuggestDataController alloc] init];
        self.userSuggestDC.delegate = self;
    }
    
    UIView *loadingView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    loadingView.tag = 1111;
    loadingView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.3];
    [self.view addSubview:loadingView];
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
        _indicatorView.frame = CGRectMake(loadingView.frame.size.width/3, loadingView.frame.size.height/11, loadingView.frame.size.width/3, loadingView.frame.size.width/3);
        _indicatorView.hidesWhenStopped = YES;
    }
    [loadingView addSubview:_indicatorView];
    [_indicatorView startAnimating];
    
    [self.userSuggestDC mrUserSuggest:params];
}

// 点击背景隐藏 键盘
- (void)tapHideKeyBoard {
    [self.suggestTextView resignFirstResponder];
    [self.connectionTextView resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (TAG_BG_SCROLLVIEW == scrollView.tag) {
        [self tapHideKeyBoard];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (TAG_TEXT_VIEW_1 == textView.tag && ![self.suggestTextView.text isEqualToString:@""]) {
        [self.placeLabel1 removeFromSuperview];
    } else if (TAG_TEXT_VIEW_1 == textView.tag && [self.suggestTextView.text isEqualToString:@""]) {
        [self.suggestTextView addSubview:self.placeLabel1];
    }
    
    if (TAG_TEXT_VIEW_2 == textView.tag && ![self.connectionTextView.text isEqualToString:@""]) {
        [self.placeLabel2 removeFromSuperview];
    } else if (TAG_TEXT_VIEW_2 == textView.tag && [self.connectionTextView.text isEqualToString:@""]) {
        [self.connectionTextView addSubview:self.placeLabel2];
    }
}

#pragma mark - PublishDataControllerDelegate
- (void)onSendUserSuggestData:(NSInteger)tag receiveData:(NSMutableDictionary *)data {
    DDLog(@"%@",data);

    [_indicatorView stopAnimating];
    UIView *view = [self.view viewWithTag:1111];
    [view removeFromSuperview];
    view = nil;
    [MessageShow showMessageView:0 code:0 msg:@"提交成功" autoClose:1 time:1];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSendUserSuggestRequestError:(NSInteger)tag error:(NSError *)error {
    [MessageShow closeMsgAlertView];
    [MessageShow showMessageView:MESSAGE_TYPE_ERROR
                            code:error.code
                             msg:nil
                       autoClose:1
                            time:1.0F];
    [_indicatorView stopAnimating];
    UIView *view = [self.view viewWithTag:1111];
    [view removeFromSuperview];
    view = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DDLog(@"mmmm");
}

@end
