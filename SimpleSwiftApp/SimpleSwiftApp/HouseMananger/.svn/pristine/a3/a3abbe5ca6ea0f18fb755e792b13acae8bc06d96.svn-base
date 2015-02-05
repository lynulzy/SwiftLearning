//
//  TalkingDetailViewController.m
//  HouseMananger
//
//  Created by ZXH on 15/1/16.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "TalkingDetailViewController.h"

#import "TalkingDetailDataController.h"
#import "TalkingDetailCell.h"

#import "ReplyDataController.h"
#import "LoginViewController.h"

#import "PicScanViewController.h"

#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

#import "UIImageView+WebCache.h"
#import "UserTmpParam.h"
#import "MessageShow.h"

#define TAG_LOGIN_ALERT     1001

#define kBackViewWidth      (size_width)
#define kTopGapHeight       10.0F                                           // Top留白
#define kIconWidth          ((size_width - 30) - 30) * 0.16                 // 头像宽度
#define kUserNameHeight     ((size_width - 30) - 30) * 0.16/2               // 姓名Lab   头像宽度的一半
#define kQuestionWidth      ((size_width - 30) - 30) * 0.84                 // 问题Label宽度
#define kImageWidth         (((size_width - 30) - 30) * 0.84 - 40) / 3      // 图片宽度
#define kTimeLabHeight      20.0F                                           // 时间高度
#define kReplyBtnWidth      80.0F                                           // 回复按钮宽度
#define kReplyFieldBgView   48.0F
#define VIEW_BOUNDS_HIGHT   (size_height - 44)
#define BUILD_NAME_COLOR    [UIColor colorWithRed:0/255.0F green:119/255.0F blue:80/255.0F alpha:1]

@interface TalkingDetailViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
TalkingDetailDataControllerDelegate,
ReplyDataControllerDelegate,
EGORefreshTableDelegate,
UITextViewDelegate,
UIAlertViewDelegate
>
{
    TalkingDetailDataController *_talkingDetailDC;
    ReplyDataController *_replyDC;
    NSInteger currentPage;
    
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
//    UIAlertView *_loginAlert;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *replyListArr;

@property(nonatomic, strong) UIView *replyFieldBgView;
@property(nonatomic, strong) UITextView *replyField;
@property(nonatomic, copy) NSString *theUser_id_2;
@property(nonatomic, strong) UILabel *replyLab;

@end

@implementation TalkingDetailViewController

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
    
    self.navigationItem.title = @"动态详情";
    [self loadData];
    [self loadSubviews];
    [self createHeaderView];
}

- (void)createHeaderView {
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    [self.tableView addSubview:_refreshHeaderView];
    [MessageShow showMessageView:MESSAGE_TYPE_WAITING code:0 msg:@"正在加载..." autoClose:1 time:15];
    // 首次进入 自动下拉刷新
//    self.tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -100);
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.tableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)testFinishedLoadData {
    
    [self finishReloadingData];
}

#pragma mark - Method that should be called when the refreshing is finished
- (void)finishReloadingData {
    // Model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
}

- (void)setFooterView {
    // If the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.tableView.contentSize.height, self.tableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f, height,
                                              self.tableView.frame.size.width, self.view.bounds.size.height);
    } else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.tableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.tableView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        
        [_refreshFooterView refreshLastUpdatedDate];
    }
    DDLog(@"\n\r view = %f  \n\r table = %f", self.view.bounds.size.height, self.tableView.frame.size.height)
}

- (void)removeFooterView {
    
    if (_refreshFooterView && [_refreshFooterView superview]) {
        
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

// 刷新
#pragma mark - Data reloading methods that must be overide by the subclass
- (void)beginToReloadData:(EGORefreshPos)aRefreshPos {
    
    // should be calling your tableviews data source model to reload
    _reloading = YES;
    if (aRefreshPos == EGORefreshHeader) {
        // Pull down to refresh data
        currentPage = 1;
        [self performSelector:@selector(loadReplayListData) withObject:nil afterDelay:2.0];
        
    } else if(aRefreshPos == EGORefreshFooter) {
        // Pull up to load more data
        currentPage++;
        [self performSelector:@selector(loadReplayListData) withObject:nil afterDelay:2.0];
    }
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_refreshHeaderView) {
        
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    if (_refreshFooterView) {
        
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (_refreshHeaderView) {
        
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
    if (_refreshFooterView) {
        
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark - EGORefreshTableDelegate Methods
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos scrollView:(UIScrollView *)scrollView {
    // 开始网络请求
    [self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view {
    
    return _reloading;
}

// 记录最后操作的时间
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view {
    
    return [NSDate date];
}

- (void)loadReplayListData {
    
    NSString *theBuildID;
    if (![self.dataDic[@"build_id"] isEqual:[NSNull null]]) {
        theBuildID = self.dataDic[@"build_id"];
    } else {
        theBuildID = @"";
    }
    
    NSString *thePage = [NSString stringWithFormat:@"%ld", (long)currentPage];
    NSDictionary *params = @{@"say_id"    : self.dataDic[@"say_id"],
                             @"build_id"  : theBuildID,
                             @"page"      : thePage,
                             @"page_size" : @"10"};
    
    
    if (nil == _talkingDetailDC) {
        _talkingDetailDC = [[TalkingDetailDataController alloc] init];
        _talkingDetailDC.delegate = self;
    }
    
    [_talkingDetailDC mrTalkingDetail:params];
}

- (void)loadData {
    self.replyListArr = [[NSMutableArray alloc] initWithCapacity:0];
    currentPage = 1;
    _reloading = NO;
}

- (void)loadSubviews {

    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size_width, size_height - 44) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BACK_COLOR;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[TalkingDetailCell class] forCellReuseIdentifier:@"TalkingDetailCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = [self loadTableHeaderView];
    
    [self loadTextView];
}

- (void)loadTextView {
    
    self.replyFieldBgView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_BOUNDS_HIGHT, size_width, kReplyFieldBgView)];
    self.replyFieldBgView.backgroundColor = [UIColor colorWithRed:240/255.0
                                                            green:240/255.0
                                                             blue:240/255.0 alpha:1];
    [self.view addSubview:self.replyFieldBgView];

    // TextField
    self.replyField = [[UITextView alloc] initWithFrame:CGRectMake(20, 6, size_width - 20 - 70, kReplyFieldBgView - 12)];
    self.replyField.layer.cornerRadius = 4;
    self.replyField.layer.masksToBounds = YES;
    self.replyField.returnKeyType = UIReturnKeyDefault;
    self.replyField.delegate = self;
    self.replyField.layer.borderColor = [[UIColor colorWithWhite:0.4 alpha:1] CGColor];
    self.replyField.layer.borderWidth = 0.5;
    self.replyField.backgroundColor = [UIColor whiteColor];
    self.replyField.font = [UIFont systemFontOfSize:16.0F];
    [self.replyFieldBgView addSubview:self.replyField];
//    self.replyField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    self.replyLab = [[UILabel alloc] init];
    self.replyLab.frame = CGRectMake(10, 3, size_width - 20 - 70 - 10, 30);
    self.replyLab.textColor = [UIColor lightGrayColor];
    self.replyLab.font = [UIFont systemFontOfSize:16.0F];
    [self.replyField addSubview:self.replyLab];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendBtn.frame = CGRectMake(size_width - 65, 5, 60, kReplyFieldBgView - 10);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0F];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.replyFieldBgView addSubview:sendBtn];
    
    
    // 键盘通知
    // 出现监听 UIKeyboardWillShownotifification
    // 调用 self keyboardWillShow
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 隐藏监听 UIKeyboardWillHidenotifification
    // 调用 self keyboardWillHidden:
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 监听键盘的两个方法
- (void)keyboardWillShow:(NSNotification*)notifi {
    
    //keyboardSize
    CGSize keyboardSize = [[notifi.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.15 animations:^{
        self.replyFieldBgView.frame = CGRectMake(0, VIEW_BOUNDS_HIGHT - keyboardSize.height - kReplyFieldBgView, size_width, kReplyFieldBgView);
    }];
}

- (void)keyboardWillHidden:(NSNotification*)notifi {
    
    [UIView animateWithDuration:0.15 animations:^{
        
        self.replyFieldBgView.frame = CGRectMake(0, VIEW_BOUNDS_HIGHT, size_width, kReplyFieldBgView);
    }];
}

// 判断是否已经登录
- (BOOL)isLogin {
    
    if ([UserTmpParam getUserId].length == 0 || [UserTmpParam getSession].length == 0) {
        return NO;
    } else {
        return YES;
    }
}
// 去登录
- (void)goToLogin {

    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (UIView *)loadTableHeaderView {
    
    UIView *backView = [[UIView alloc] init];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = BACK_COLOR;
    
    // 头像
    UIImageView *headIconIV = [[UIImageView alloc] init];
    headIconIV.frame = CGRectMake(10, kTopGapHeight, kIconWidth, kIconWidth);
    headIconIV.backgroundColor = [UIColor clearColor];
    headIconIV.layer.masksToBounds = YES;
    headIconIV.layer.cornerRadius = kIconWidth/2;
    headIconIV.layer.borderColor = [[UIColor colorWithWhite:0.2 alpha:0.8] CGColor];
    headIconIV.layer.borderWidth = 0.2;
    [headIconIV sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"portrait"]] placeholderImage:[UIImage imageNamed:@"headIcon.png"]];
    [backView addSubview:headIconIV];
    
    // 昵称(用户名)
    UILabel *userNameLab = [[UILabel alloc] init];
    userNameLab.text = self.dataDic[@"username"];
    userNameLab.frame = CGRectMake(kIconWidth + 20, kTopGapHeight, 150, kIconWidth/2);
    userNameLab.font = [UIFont boldSystemFontOfSize:15.0F];
    userNameLab.textColor = [UIColor colorWithRed:51.0/255.0
                                                 green:85.0/255.0
                                                  blue:139.0/255.0
                                                 alpha:1.0F];
    [backView addSubview:userNameLab];
    
    // 楼盘名称
    UILabel *buildNameLab = [[UILabel alloc] init];
    buildNameLab.font = [UIFont systemFontOfSize:13.5F];
    buildNameLab.textColor = [UIColor darkGrayColor];
    if ([self.dataDic[@"name"] isEqual:[NSNull null]]) {
        buildNameLab.frame = CGRectMake(kIconWidth + 20,
                                        userNameLab.frame.origin.y + userNameLab.frame.size.height,
                                        0,
                                        0);
        buildNameLab.text = @"";
    } else {
        buildNameLab.frame = CGRectMake(kIconWidth + 20,
                                        userNameLab.frame.origin.y + userNameLab.frame.size.height,
                                        200,
                                        kIconWidth/2);
        NSString *completeStr = [NSString stringWithFormat:@"来自「%@」",self.dataDic[@"name"]];
        NSMutableAttributedString* aStr = [[NSMutableAttributedString alloc] initWithString:completeStr];
        
        [aStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIFont boldSystemFontOfSize:13.5F], NSFontAttributeName,
                             BUILD_NAME_COLOR, NSForegroundColorAttributeName, nil]
                      range:[completeStr rangeOfString:self.dataDic[@"name"]]];
        buildNameLab.attributedText = aStr;
    }
    [backView addSubview:buildNameLab];
    
    // 内容Label
    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.font = [UIFont systemFontOfSize:15.0F];
    contentLab.numberOfLines = 0;
    CGSize qLabelSize = CGSizeMake(0, 0);
    if (IOS7Later) {
        // 计算Label高度
        qLabelSize = [self.dataDic[@"content"] boundingRectWithSize:CGSizeMake(kQuestionWidth, 1000)
                                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0F]} context:nil].size;
    } else {
        qLabelSize = [self.dataDic[@"content"] sizeWithFont:[UIFont systemFontOfSize:15.0F] constrainedToSize:CGSizeMake(kQuestionWidth, 1000)];
    }
    contentLab.frame = CGRectMake(kIconWidth + 20,
                                  buildNameLab.frame.origin.y + buildNameLab.frame.size.height,
                                  kQuestionWidth,
                                  qLabelSize.height);
    contentLab.text = self.dataDic[@"content"];
    [backView addSubview:contentLab];
    
    // 图片
    NSArray *picArr = self.dataDic[@"pic"];
    NSInteger imageCount = picArr.count;
    for (NSInteger i = 0; i < imageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake((kIconWidth + 20) + i % 3 * (kImageWidth + 5),
                                     contentLab.frame.origin.y + contentLab.frame.size.height + 5 + i/3*(kImageWidth + 5),
                                     kImageWidth,
                                     kImageWidth);
        imageView.tag = (i + 1) * 10000;
        [imageView sd_setImageWithURL:[NSURL URLWithString:picArr[i]] placeholderImage:[UIImage imageNamed:@"placeholderPic.png"]];
        imageView.backgroundColor = BACK_COLOR;
        [backView addSubview:imageView];
        
        // 点击放大查看
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *enlargeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchEnlarge:)];
        [imageView addGestureRecognizer:enlargeTap];
    }
    
    // 发表时间
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.textColor = [UIColor grayColor];
    timeLab.backgroundColor = [UIColor clearColor];
    timeLab.font = [UIFont systemFontOfSize:13.5F];
    
    // 图片行数
    NSInteger imageLineCount = (0 != imageCount %3 ? imageCount / 3 + 1 : imageCount / 3);
    if (0 != imageCount) {
        timeLab.frame = CGRectMake(kIconWidth + 20,
                                   contentLab.frame.origin.y + contentLab.frame.size.height + 5 + imageLineCount * (kImageWidth + 5),
                                   kQuestionWidth,
                                   kTimeLabHeight);
        
    } else {
        timeLab.frame = CGRectMake(kIconWidth + 20,
                                   contentLab.frame.origin.y + contentLab.frame.size.height + 5,
                                   kQuestionWidth - kReplyBtnWidth,
                                   kTimeLabHeight);
    }
    timeLab.text = self.dataDic[@"create_time"];
    [backView addSubview:timeLab];
    
    // 评论按钮
    UIButton *replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    replyBtn.backgroundColor = TAB_BAR_COLOR;
    replyBtn.frame = CGRectMake(kIconWidth + 20 + kQuestionWidth - kReplyBtnWidth,
                                timeLab.frame.origin.y,
                                kReplyBtnWidth,
                                kTimeLabHeight);
    replyBtn.titleLabel.font = [UIFont systemFontOfSize:13.5F];
    [replyBtn setTitle:@"评论" forState:UIControlStateNormal];
    [replyBtn addTarget:self action:@selector(replyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:replyBtn];

    // 底部 横线
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(10,
                                timeLab.frame.origin.y + timeLab.frame.size.height + 9,
                                size_width - 10,
                                1);
    lineView.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:lineView];
    
    // Back view frame
    CGFloat backViewHight = kTopGapHeight + kUserNameHeight + buildNameLab.frame.size.height + qLabelSize.height + imageLineCount * (kImageWidth + 5) + 5 + kTimeLabHeight + 10;
    backView.frame = CGRectMake(0, 0, kBackViewWidth, backViewHight);
    
    return backView;
}

- (void)touchEnlarge:(UITapGestureRecognizer*)tap {
    NSInteger tag = tap.view.tag;
    NSInteger currPage = tag / 10000;
    
    NSMutableArray *picArr = [[NSMutableArray alloc] initWithArray:self.dataDic[@"pic"]];
    
    PicScanViewController *picScanVC = [[PicScanViewController alloc] init];
    picScanVC.currentPage = currPage;
    picScanVC.imageUrlArray = picArr;
//    [picScanVC.imageUrlArray addObject:dic[imageUrl]];
    
    picScanVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:picScanVC animated:YES];
    
    DDLog(@"currPage = %ld", (long)currPage)
}

// 评论
- (void)replyBtnClick:(UIButton *)btn {
    DDLog(@"评论 评论")
    if ([self isLogin]) {
        self.theUser_id_2 = nil;
        self.theUser_id_2 = self.dataDic[@"user_id"];
        [self.replyField becomeFirstResponder];
        self.replyLab.text = [NSString stringWithFormat:@"回复%@：", self.dataDic[@"username"]];
    } else {
        [self showLoginAlert];
    }
}

// 发送 send
- (void)sendBtnClick {
    [self makeReplyRequest:self.theUser_id_2];
    [self.replyField resignFirstResponder];
    self.replyField.text = @"";
}

// 登录提示 Alert
- (void)showLoginAlert {
    // Login alert
    UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"登录后才能参与评论，现在登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
    loginAlert.tag = TAG_LOGIN_ALERT;
    [loginAlert show];
}

- (void)makeReplyRequest:(NSString*)toUserID {

    NSString *theBuildID;
    if (![self.dataDic[@"build_id"] isEqual:[NSNull null]]) {
        theBuildID = self.dataDic[@"build_id"];
    } else {
        theBuildID = @"";
    }
    
    NSDictionary *params = @{@"user_id"    : [UserTmpParam getUserId],
                             @"user_id_2"  : toUserID,
                             @"content"    : self.replyField.text,
                             @"flag"       : self.dataDic[@"flag"],
                             @"session"    : [UserTmpParam getSession],
                             @"build_id"   : theBuildID};
    
    if (nil == _replyDC) {
        _replyDC = [[ReplyDataController alloc] init];
        _replyDC.delegate = self;
    }
    
    [_replyDC mrReply:params];
}

// 字符串高度计算
- (CGSize)calculateLabelSizeWith:(NSString *)theStr andTheSize:(CGSize)theSize andTheFont:(UIFont*)theFont {
    
    CGSize size;
    
    size = [theStr boundingRectWithSize:theSize
                                options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                             attributes:@{NSFontAttributeName:theFont} context:nil].size;
    return size;
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

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
//    CGRect frame1 = textView.frame;
//    frame1.size.height = textView.contentSize.height;
//    textView.frame = frame1;
    
    if ([self.replyField.text isEqualToString:@""]) {
        
        [self.replyField addSubview:self.replyLab];
    } else {
        
        [self.replyLab removeFromSuperview];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (TAG_LOGIN_ALERT == alertView.tag) {
        if (1 == buttonIndex) {
            [self goToLogin];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.replyListArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    TalkingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TalkingDetailCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = BACK_COLOR;
    NSDictionary *dic = [self.replyListArr objectAtIndex:row];
    [cell reloadCellSubViewsWithData:dic forRow:row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSDictionary *dataDic = [self.replyListArr objectAtIndex:row];
    
    // Top留白
    CGFloat topGap = 10.0F;
    
    // 文字Label宽度
    CGFloat questionWidth = (size_width - 50) * 0.86;
    
    // Username and Content Label
    NSString *completeStr;
    NSString *usernameStr = dataDic[@"username"];
    NSString *replaynameStr = dataDic[@"reply_name"];
    NSString *contentStr = dataDic[@"content"];
    
    if ([usernameStr isEqualToString:replaynameStr]) {
        completeStr = [NSString stringWithFormat:@"%@：%@", usernameStr, contentStr];
    } else {
        completeStr = [NSString stringWithFormat:@"%@回复%@：%@", usernameStr, replaynameStr, contentStr];
    }
    
    CGSize qLabelSize = [self calculateLabelSizeWith:completeStr andTheSize:CGSizeMake(questionWidth, 1000) andTheFont:[UIFont systemFontOfSize:14.0F]];
    
    // 时间Label高度
    NSInteger timeHight = 20;
    DDLog(@"%f", topGap + qLabelSize.height + 5 + timeHight +5);
    return (topGap + qLabelSize.height + 5 + timeHight + 5);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self isLogin]) {
        self.theUser_id_2 = nil;
        self.theUser_id_2 = self.replyListArr[row][@"user_id"];
        if ([self.replyField isFirstResponder]) {
            [self.replyField resignFirstResponder];
        } else {
            [self.replyField becomeFirstResponder];
            self.replyLab.text = [NSString stringWithFormat:@"回复%@：", self.replyListArr[row][@"username"]];
        }
        
    } else {
        [self showLoginAlert];
    }
}

#pragma mark - TalkingDetailDataControllerDelegate
- (void)onGetTalkingDetailReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag {
    [MessageShow closeMsgAlertView];
    [self removeFooterView];
    
    NSMutableDictionary *talkingListDic = [[NSMutableDictionary alloc] initWithDictionary:receiveDict];
    
    if (1 == currentPage) {
        [self.replyListArr removeAllObjects];
    }
    
    [self.replyListArr addObjectsFromArray:talkingListDic[@"content"][@"say_list"]];
    [self.tableView reloadData];
    
    [self testFinishedLoadData];
    if ([talkingListDic[@"content"][@"page_count"] integerValue] > currentPage) {
        [self setFooterView];
    }
}

- (void)onGetTalkingDetailFailedWithError:(NSError *)error withReqTag:(NSInteger)tag {
    [MessageShow closeMsgAlertView];
    [self testFinishedLoadData];
    [self setFooterView];
}

#pragma mark - ReplyDataControllerDelegate
- (void)onGetReplyReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag {
    [MessageShow showMessageView:MESSAGE_TYPE_OK code:0 msg:@"评论成功" autoClose:1 time:1.0];
    currentPage = 1;
    [self loadReplayListData];
    DDLog(@"回复成功！")
}

- (void)onGetReplyFailedWithError:(NSError *)error withReqTag:(NSInteger)tag {
    [MessageShow showMessageView:MESSAGE_TYPE_ERROR code:0 msg:@"评论失败" autoClose:1 time:1.0];
    DDLog(@"回复失败！")
}

@end
